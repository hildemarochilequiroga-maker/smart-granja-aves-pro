import 'package:cloud_firestore/cloud_firestore.dart';

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

  /// Crea un nuevo lote.
  Future<Lote> crear(Lote lote) async {
    final model = LoteModel.fromEntity(lote);
    final docRef = await _lotesCollection.add(model.toFirestore());

    return lote.copyWith(
      id: docRef.id,
      fechaCreacion: DateTime.now(),
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza un lote existente.
  Future<Lote> actualizar(Lote lote) async {
    final model = LoteModel.fromEntity(lote);
    await _lotesCollection.doc(lote.id).update(model.toFirestore());

    return lote.copyWith(ultimaActualizacion: DateTime.now());
  }

  /// Elimina un lote.
  Future<void> eliminar(String id) async {
    await _lotesCollection.doc(id).delete();
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
