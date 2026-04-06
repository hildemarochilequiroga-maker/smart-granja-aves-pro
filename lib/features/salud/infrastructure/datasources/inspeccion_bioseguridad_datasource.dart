/// Datasource remoto para inspecciones de bioseguridad.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';

/// Datasource de Firestore para inspecciones de bioseguridad.
class InspeccionBioseguridadDatasource {
  final FirebaseFirestore _firestore;

  InspeccionBioseguridadDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String granjaId) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('inspecciones_bioseguridad');
  }

  /// Obtiene todas las inspecciones de una granja.
  Future<List<InspeccionBioseguridad>> obtenerInspecciones(
    String granjaId,
  ) async {
    final snapshot = await _collection(
      granjaId,
    ).orderBy('fecha', descending: true).limit(500).get();
    return snapshot.docs
        .map(
          (doc) =>
              InspeccionBioseguridad.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Obtiene una inspección por su ID.
  Future<InspeccionBioseguridad?> obtenerInspeccionPorId(
    String granjaId,
    String id,
  ) async {
    final doc = await _collection(granjaId).doc(id).get();
    if (!doc.exists || doc.data() == null) return null;
    return InspeccionBioseguridad.fromJson({'id': doc.id, ...doc.data()!});
  }

  /// Obtiene inspecciones por rango de fechas.
  Future<List<InspeccionBioseguridad>> obtenerInspeccionesPorFecha({
    required String granjaId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final snapshot = await _collection(granjaId)
        .where('fecha', isGreaterThanOrEqualTo: fechaInicio.toIso8601String())
        .where('fecha', isLessThanOrEqualTo: fechaFin.toIso8601String())
        .orderBy('fecha', descending: true)
        .limit(500)
        .get();
    return snapshot.docs
        .map(
          (doc) =>
              InspeccionBioseguridad.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Obtiene la última inspección de una granja o galpón.
  Future<InspeccionBioseguridad?> obtenerUltimaInspeccion({
    required String granjaId,
    String? galponId,
  }) async {
    Query<Map<String, dynamic>> query = _collection(granjaId);
    if (galponId != null) {
      query = query.where('galponId', isEqualTo: galponId);
    }
    final snapshot = await query
        .orderBy('fecha', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return InspeccionBioseguridad.fromJson({'id': doc.id, ...doc.data()});
  }

  /// Crea una nueva inspección.
  Future<String> crearInspeccion(InspeccionBioseguridad inspeccion) async {
    final json = inspeccion.toJson();
    json.remove('id'); // Firestore generará el ID
    final docRef = await _collection(inspeccion.granjaId).add(json);
    return docRef.id;
  }

  /// Actualiza una inspección existente.
  Future<void> actualizarInspeccion(InspeccionBioseguridad inspeccion) async {
    await _collection(
      inspeccion.granjaId,
    ).doc(inspeccion.id).update(inspeccion.toJson());
  }

  /// Elimina una inspección.
  Future<void> eliminarInspeccion(String granjaId, String id) async {
    await _collection(granjaId).doc(id).delete();
  }

  /// Obtiene inspecciones con incumplimientos críticos.
  Future<List<InspeccionBioseguridad>> obtenerConIncumplimientosCriticos(
    String granjaId,
  ) async {
    final snapshot = await _collection(granjaId)
        .where('tieneIncumplimientosCriticos', isEqualTo: true)
        .orderBy('fecha', descending: true)
        .limit(500)
        .get();
    return snapshot.docs
        .map(
          (doc) =>
              InspeccionBioseguridad.fromJson({'id': doc.id, ...doc.data()}),
        )
        .toList();
  }

  /// Escucha cambios en las inspecciones de una granja.
  Stream<List<InspeccionBioseguridad>> watchInspecciones(String granjaId) {
    return _collection(granjaId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => InspeccionBioseguridad.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }),
              )
              .toList(),
        );
  }
}
