import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../models/lote_model.dart';

/// Datasource de Firebase para la gestión de lotes.
///
/// Implementa las operaciones CRUD contra Firestore.
class LoteFirebaseDatasource {
  LoteFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de lotes en Firestore.
  CollectionReference<Map<String, dynamic>> get _lotesCollection =>
      _firestore.collection('lotes');

  // ============================================================
  // OPERACIONES CRUD
  // ============================================================

  /// Crea un nuevo lote y, atómicamente, actualiza
  /// `galpones/{galponId}.loteActualId` para mantener la integridad
  /// referencial galpón ↔ lote en una única transacción.
  Future<Lote> crear(Lote lote) async {
    final model = LoteModel.fromEntity(lote);
    final loteRef = _lotesCollection.doc();

    await _firestore.runTransaction((transaction) async {
      transaction.set(loteRef, model.toFirestore());

      if (lote.galponId.isNotEmpty) {
        final galponRef = _firestore.collection('galpones').doc(lote.galponId);
        transaction.update(galponRef, {
          'loteActualId': loteRef.id,
          'ultimaActualizacion': FieldValue.serverTimestamp(),
        });
      }
    });

    return lote.copyWith(
      id: loteRef.id,
      fechaCreacion: DateTime.now(),
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza un lote existente.
  ///
  /// Si el lote pasa a un estado terminal (cerrado o vendido) y el galpón que
  /// lo referencia aún lo tiene como `loteActualId`, libera el galpón en la
  /// misma transacción. Así un lote cerrado/vendido no deja el galpón ocupado
  /// apuntando a un ciclo ya terminado (integridad referencial galpón ↔ lote).
  Future<Lote> actualizar(Lote lote) async {
    final model = LoteModel.fromEntity(lote);
    final esTerminal =
        lote.estado == EstadoLote.cerrado ||
        lote.estado == EstadoLote.vendido;

    if (esTerminal && lote.galponId.isNotEmpty) {
      final galponRef = _firestore.collection('galpones').doc(lote.galponId);
      await _firestore.runTransaction((transaction) async {
        final galponSnap = await transaction.get(galponRef);
        transaction.update(
          _lotesCollection.doc(lote.id),
          model.toFirestore(),
        );
        // Solo liberar si el galpón apuntaba precisamente a este lote.
        // Replica la lógica de Galpon.liberarLote(): limpia loteActualId,
        // resetea avesActuales y archiva el lote en lotesHistoricos.
        if (galponSnap.exists &&
            galponSnap.data()?['loteActualId'] == lote.id) {
          transaction.update(galponRef, {
            'loteActualId': null,
            'avesActuales': 0,
            'lotesHistoricos': FieldValue.arrayUnion([lote.id]),
            'ultimaActualizacion': FieldValue.serverTimestamp(),
          });
        }
      });
    } else {
      await _lotesCollection.doc(lote.id).update(model.toFirestore());
    }

    return lote.copyWith(ultimaActualizacion: DateTime.now());
  }

  /// Elimina un lote y todos sus datos relacionados.
  ///
  /// Incluye: subcollections (pesos, produccion, mortalidad, consumos),
  /// costos_gastos y ventas_productos referenciados. Además libera el
  /// `galpon.loteActualId` si este lote era el lote activo del galpón,
  /// para no dejar el galpón apuntando a un documento inexistente.
  Future<void> eliminar(String id) async {
    // 0. Leer el lote antes de borrarlo para conocer su galpón.
    final loteDoc = await _lotesCollection.doc(id).get();
    final galponId = loteDoc.data()?['galponId'] as String?;

    // 1. Eliminar subcollections del lote
    await _eliminarSubcoleccion(id, 'pesos');
    await _eliminarSubcoleccion(id, 'produccion');
    await _eliminarSubcoleccion(id, 'mortalidad');
    await _eliminarSubcoleccion(id, 'consumos');

    // 2. Eliminar costos y ventas que referencian este lote
    await _limpiarColeccionPorLote('costos_gastos', id);
    await _limpiarColeccionPorLote('ventas_productos', id);

    // 3. Eliminar el lote y liberar el galpón si lo referenciaba.
    if (galponId != null && galponId.isNotEmpty) {
      final galponRef = _firestore.collection('galpones').doc(galponId);
      await _firestore.runTransaction((transaction) async {
        final galponSnap = await transaction.get(galponRef);
        transaction.delete(_lotesCollection.doc(id));
        // Solo liberar si el galpón apuntaba precisamente a este lote.
        if (galponSnap.exists &&
            galponSnap.data()?['loteActualId'] == id) {
          transaction.update(galponRef, {
            'loteActualId': null,
            'ultimaActualizacion': FieldValue.serverTimestamp(),
          });
        }
      });
    } else {
      await _lotesCollection.doc(id).delete();
    }

    debugPrint('✅ Lote $id eliminado con todos sus datos relacionados');
  }

  /// Elimina todos los documentos de una subcollection de un lote.
  Future<void> _eliminarSubcoleccion(String loteId, String nombre) async {
    try {
      final snapshot = await _lotesCollection
          .doc(loteId)
          .collection(nombre)
          .get();
      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      var ops = 0;
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
        ops++;
        if (ops >= 500) {
          await batch.commit();
          ops = 0;
        }
      }
      if (ops > 0) await batch.commit();

      debugPrint('  ✅ Eliminados ${snapshot.docs.length} docs de $nombre');
    } on Exception catch (e) {
      debugPrint('  ⚠️ Error eliminando subcollection $nombre: $e');
    }
  }

  /// Elimina documentos de una colección top-level que referencian un lote.
  Future<void> _limpiarColeccionPorLote(String coleccion, String loteId) async {
    try {
      final snapshot = await _firestore
          .collection(coleccion)
          .where('loteId', isEqualTo: loteId)
          .get();
      if (snapshot.docs.isEmpty) return;

      final batch = _firestore.batch();
      var ops = 0;
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
        ops++;
        if (ops >= 500) {
          await batch.commit();
          ops = 0;
        }
      }
      if (ops > 0) await batch.commit();

      debugPrint('  ✅ Eliminados ${snapshot.docs.length} docs de $coleccion');
    } on Exception catch (e) {
      debugPrint('  ⚠️ Error limpiando $coleccion: $e');
    }
  }

  /// Obtiene un lote por ID.
  Future<Lote?> obtenerPorId(String id) async {
    final doc = await _lotesCollection.doc(id).get();
    if (!doc.exists) return null;
    return LoteModel.fromFirestore(doc).toEntity();
  }

  // ============================================================
  // CONSULTAS
  // ============================================================

  /// Obtiene todos los lotes de una granja.
  Future<List<Lote>> obtenerPorGranja(String granjaId) async {
    final snapshot = await _lotesCollection
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fechaIngreso', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => LoteModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene todos los lotes de un galpón.
  Future<List<Lote>> obtenerPorGalpon(String galponId) async {
    final snapshot = await _lotesCollection
        .where('galponId', isEqualTo: galponId)
        .orderBy('fechaIngreso', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => LoteModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene el lote activo de un galpón.
  Future<Lote?> obtenerLoteActivoDeGalpon(String galponId) async {
    final snapshot = await _lotesCollection
        .where('galponId', isEqualTo: galponId)
        .where('estado', isEqualTo: EstadoLote.activo.toJson())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return LoteModel.fromFirestore(snapshot.docs.first).toEntity();
  }

  /// Obtiene todos los lotes activos de una granja.
  Future<List<Lote>> obtenerActivos(String granjaId) async {
    final snapshot = await _lotesCollection
        .where('granjaId', isEqualTo: granjaId)
        .where('estado', isEqualTo: EstadoLote.activo.toJson())
        .orderBy('fechaIngreso', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => LoteModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene lotes por estado.
  Future<List<Lote>> obtenerPorEstado(
    String granjaId,
    EstadoLote estado,
  ) async {
    final snapshot = await _lotesCollection
        .where('granjaId', isEqualTo: granjaId)
        .where('estado', isEqualTo: estado.toJson())
        .orderBy('fechaIngreso', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => LoteModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Busca lotes por código o nombre.
  Future<List<Lote>> buscar(String granjaId, String query) async {
    // Firestore no soporta búsqueda de texto completo,
    // así que obtenemos todos y filtramos localmente
    final lotes = await obtenerPorGranja(granjaId);
    final queryLower = query.toLowerCase();

    return lotes.where((lote) {
      final codigo = lote.codigo.toLowerCase();
      final nombre = lote.nombre?.toLowerCase() ?? '';
      return codigo.contains(queryLower) || nombre.contains(queryLower);
    }).toList();
  }

  // ============================================================
  // STREAMS EN TIEMPO REAL
  // ============================================================

  /// Stream de lotes de una granja.
  Stream<List<Lote>> watchPorGranja(String granjaId) {
    return _lotesCollection
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fechaIngreso', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LoteModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  /// Stream de lotes de un galpón.
  Stream<List<Lote>> watchPorGalpon(String galponId) {
    return _lotesCollection
        .where('galponId', isEqualTo: galponId)
        .orderBy('fechaIngreso', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LoteModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  /// Stream de un lote específico.
  Stream<Lote?> watchPorId(String id) {
    return _lotesCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return LoteModel.fromFirestore(doc).toEntity();
    });
  }

  // ============================================================
  // OPERACIONES DE NEGOCIO
  // ============================================================

  /// Actualiza campos específicos de un lote.
  Future<void> actualizarCampos(String id, Map<String, dynamic> campos) async {
    campos['ultimaActualizacion'] = FieldValue.serverTimestamp();
    await _lotesCollection.doc(id).update(campos);
  }

  /// Incrementa contadores (mortalidad, descartes, ventas).
  Future<void> incrementarContador(
    String id,
    String campo,
    int cantidad,
  ) async {
    await _lotesCollection.doc(id).update({
      campo: FieldValue.increment(cantidad),
      'ultimaActualizacion': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // ESTADÍSTICAS
  // ============================================================

  /// Obtiene estadísticas de lotes de una granja.
  Future<Map<String, dynamic>> obtenerEstadisticas(String granjaId) async {
    final lotes = await obtenerPorGranja(granjaId);

    if (lotes.isEmpty) {
      return {
        'totalLotes': 0,
        'lotesActivos': 0,
        'lotesCerrados': 0,
        'totalAves': 0,
        'mortalidadPromedio': 0.0,
      };
    }

    final activos = lotes.where((l) => l.estaActivo).toList();
    final cerrados = lotes.where((l) => l.estaFinalizado).toList();
    final totalAves = activos.fold<int>(
      0,
      (total, l) => total + l.avesActuales,
    );
    final mortalidadPromedio = lotes.isNotEmpty
        ? lotes.fold<double>(0, (total, l) => total + l.porcentajeMortalidad) /
              lotes.length
        : 0.0;

    return {
      'totalLotes': lotes.length,
      'lotesActivos': activos.length,
      'lotesCerrados': cerrados.length,
      'totalAves': totalAves,
      'mortalidadPromedio': mortalidadPromedio,
    };
  }

  /// Cuenta lotes por estado.
  Future<Map<EstadoLote, int>> contarPorEstado(String granjaId) async {
    final lotes = await obtenerPorGranja(granjaId);

    final conteo = <EstadoLote, int>{};
    for (final estado in EstadoLote.values) {
      conteo[estado] = lotes.where((l) => l.estado == estado).length;
    }

    return conteo;
  }
}
