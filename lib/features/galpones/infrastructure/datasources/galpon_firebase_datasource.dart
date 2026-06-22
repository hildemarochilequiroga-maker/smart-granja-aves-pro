import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/enums/estado_galpon.dart';
import '../models/galpon_model.dart';
import '../models/galpon_evento_model.dart';

/// Datasource remoto para operaciones de galpones en Firebase.
class GalponFirebaseDatasource {
  GalponFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de galpones.
  CollectionReference<Map<String, dynamic>> get _galponesCollection =>
      _firestore.collection('galpones');

  /// Colección de eventos de galpones.
  CollectionReference<Map<String, dynamic>> get _eventosCollection =>
      _firestore.collection('galpon_eventos');

  // ==================== CRUD GALPONES ====================

  /// Crea un nuevo galpón.
  Future<GalponModel> crear(GalponModel galpon) async {
    try {
      final docRef = _galponesCollection.doc();
      final galponConId = galpon.copyWith(id: docRef.id);
      await docRef.set(galponConId.toFirestore());
      return galponConId;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_CREATE_SHED'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene un galpón por ID.
  Future<GalponModel?> obtenerPorId(String id) async {
    try {
      final doc = await _galponesCollection.doc(id).get();
      if (!doc.exists) return null;
      return GalponModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_GET_SHED'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene todos los galpones de una granja.
  Future<List<GalponModel>> obtenerPorGranja(String granjaId) async {
    try {
      final snapshot = await _galponesCollection
          .where('granjaId', isEqualTo: granjaId)
          .orderBy('codigo')
          .get();

      return snapshot.docs
          .map((doc) => GalponModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_GET_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Actualiza un galpón.
  ///
  /// Re-lee el documento después de actualizar para reflejar
  /// el valor real de `FieldValue.serverTimestamp()`.
  Future<GalponModel> actualizar(GalponModel galpon) async {
    try {
      await _galponesCollection.doc(galpon.id).update(galpon.toFirestore());
      // Re-leer para obtener el serverTimestamp real
      final updated = await _galponesCollection.doc(galpon.id).get();
      if (!updated.exists) return galpon;
      return GalponModel.fromFirestore(updated);
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_UPDATE_SHED'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Elimina un galpón y todos sus datos relacionados.
  ///
  /// Incluye: lotes con sus subcollections, costos, ventas y eventos.
  Future<bool> eliminar(String id) async {
    try {
      // 1. Obtener todos los lotes de este galpón
      final lotesSnapshot = await _firestore
          .collection('lotes')
          .where('galponId', isEqualTo: id)
          .get();

      // 2. Para cada lote, eliminar subcollections y datos relacionados
      for (final loteDoc in lotesSnapshot.docs) {
        await _eliminarDatosLote(loteDoc.id);
      }

      // 3. Eliminar los documentos de lotes
      await _eliminarDocumentos(lotesSnapshot.docs);

      // 4. Eliminar eventos del galpón
      await _limpiarColeccion('galpon_eventos', 'galponId', id);

      // 5. Eliminar el galpón
      await _galponesCollection.doc(id).delete();

      debugPrint('✅ Galpón $id eliminado con todos sus datos relacionados');
      return true;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_DELETE_SHED'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Elimina subcollections y datos relacionados de un lote.
  Future<void> _eliminarDatosLote(String loteId) async {
    final lotesCol = _firestore.collection('lotes');
    for (final sub in ['pesos', 'produccion', 'mortalidad', 'consumos']) {
      await _eliminarSubcoleccionDeLote(lotesCol, loteId, sub);
    }
    await _limpiarColeccion('costos_gastos', 'loteId', loteId);
    await _limpiarColeccion('ventas_productos', 'loteId', loteId);
  }

  /// Elimina todos los documentos de una subcollection de un lote.
  Future<void> _eliminarSubcoleccionDeLote(
    CollectionReference<Map<String, dynamic>> lotesCol,
    String loteId,
    String nombre,
  ) async {
    try {
      final snapshot = await lotesCol.doc(loteId).collection(nombre).get();
      if (snapshot.docs.isEmpty) return;
      await _eliminarDocumentos(snapshot.docs);
    } on Exception catch (e) {
      debugPrint('  ⚠️ Error eliminando $nombre del lote $loteId: $e');
    }
  }

  /// Elimina documentos de una colección filtrados por un campo.
  Future<void> _limpiarColeccion(
    String coleccion,
    String campo,
    String valor,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(coleccion)
          .where(campo, isEqualTo: valor)
          .get();
      if (snapshot.docs.isEmpty) return;
      await _eliminarDocumentos(snapshot.docs);
    } on Exception catch (e) {
      debugPrint('  ⚠️ Error limpiando $coleccion: $e');
    }
  }

  /// Elimina una lista de documentos usando WriteBatch.
  Future<void> _eliminarDocumentos(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) async {
    if (docs.isEmpty) return;
    var batch = _firestore.batch();
    var ops = 0;
    for (final doc in docs) {
      batch.delete(doc.reference);
      ops++;
      if (ops >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        ops = 0;
      }
    }
    if (ops > 0) await batch.commit();
  }

  // ==================== CONSULTAS ====================

  /// Obtiene galpones disponibles de una granja (activos sin lote).
  Future<List<GalponModel>> obtenerDisponibles(String granjaId) async {
    try {
      final snapshot = await _galponesCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('estado', isEqualTo: EstadoGalpon.activo.toJson())
          .where('loteActualId', isNull: true)
          .orderBy('codigo')
          .get();

      return snapshot.docs
          .map((doc) => GalponModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      // Solo hacer fallback si falla por índice compuesto faltante
      if (e.code == 'failed-precondition' || e.code == 'unimplemented') {
        final todos = await obtenerPorGranja(granjaId);
        return todos
            .where(
              (g) => g.estado == EstadoGalpon.activo && g.loteActualId == null,
            )
            .toList();
      }
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_GET_AVAILABLE_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene galpones por estado.
  Future<List<GalponModel>> obtenerPorEstado(
    String granjaId,
    EstadoGalpon estado,
  ) async {
    try {
      final snapshot = await _galponesCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('estado', isEqualTo: estado.toJson())
          .orderBy('codigo')
          .get();

      return snapshot.docs
          .map((doc) => GalponModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_GET_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Busca galpones por nombre o código.
  Future<List<GalponModel>> buscar(String granjaId, String query) async {
    try {
      // Firestore no tiene búsqueda de texto completo
      // Buscamos todos y filtramos localmente
      final todos = await obtenerPorGranja(granjaId);
      final queryLower = query.toLowerCase();
      return todos
          .where(
            (g) =>
                g.nombre.toLowerCase().contains(queryLower) ||
                g.codigo.toLowerCase().contains(queryLower),
          )
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_SEARCH_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  // ==================== STREAMS ====================

  /// Stream de galpones de una granja.
  Stream<List<GalponModel>> watchPorGranja(String granjaId) {
    return _galponesCollection
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('codigo')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GalponModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Stream de un galpón específico.
  Stream<GalponModel?> watchPorId(String id) {
    return _galponesCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GalponModel.fromFirestore(doc);
    });
  }

  // ==================== EVENTOS ====================

  /// Registra un evento para un galpón.
  Future<GalponEventoModel> registrarEvento(GalponEventoModel evento) async {
    try {
      final docRef = _eventosCollection.doc();
      final eventoConId = evento.copyWith(id: docRef.id);
      await docRef.set(eventoConId.toFirestore());
      return eventoConId;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_REGISTER_EVENT'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene eventos de un galpón.
  Future<List<GalponEventoModel>> obtenerEventos(
    String galponId, {
    int? limite,
  }) async {
    try {
      var query = _eventosCollection
          .where('galponId', isEqualTo: galponId)
          .orderBy('fecha', descending: true);

      if (limite != null) {
        query = query.limit(limite);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => GalponEventoModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_GET_EVENTS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Stream de eventos de un galpón.
  Stream<List<GalponEventoModel>> watchEventos(String galponId, {int? limite}) {
    var query = _eventosCollection
        .where('galponId', isEqualTo: galponId)
        .orderBy('fecha', descending: true);

    if (limite != null) {
      query = query.limit(limite);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => GalponEventoModel.fromFirestore(doc))
          .toList();
    });
  }

  // ==================== ESTADÍSTICAS ====================

  /// Cuenta galpones por estado.
  Future<int> contarPorEstado(String granjaId, EstadoGalpon estado) async {
    try {
      final snapshot = await _galponesCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('estado', isEqualTo: estado.toJson())
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_COUNT_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Cuenta total de galpones de una granja.
  Future<int> contarPorGranja(String granjaId) async {
    try {
      final snapshot = await _galponesCollection
          .where('granjaId', isEqualTo: granjaId)
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? ErrorMessages.get('ERR_COUNT_SHEDS'),
      );
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }
}
