/// Datasource remoto para alertas sanitarias.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entities.dart';

/// Datasource de Firestore para alertas sanitarias.
class AlertaSanitariaDatasource {
  final FirebaseFirestore _firestore;

  AlertaSanitariaDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _collection(String granjaId) {
    return _firestore
        .collection('granjas')
        .doc(granjaId)
        .collection('alertas_sanitarias');
  }

  /// Obtiene todas las alertas de una granja.
  Future<List<AlertaSanitaria>> obtenerAlertas(String granjaId) async {
    final snapshot = await _collection(
      granjaId,
    ).orderBy('fechaGeneracion', descending: true).limit(500).get();
    return snapshot.docs
        .map((doc) => AlertaSanitaria.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  /// Obtiene alertas activas (no resueltas).
  Future<List<AlertaSanitaria>> obtenerAlertasActivas(String granjaId) async {
    final snapshot = await _collection(granjaId)
        .where('estado', isEqualTo: 'activa')
        .orderBy('fechaGeneracion', descending: true)
        .limit(500)
        .get();
    return snapshot.docs
        .map((doc) => AlertaSanitaria.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  /// Obtiene alertas por nivel.
  Future<List<AlertaSanitaria>> obtenerAlertasPorNivel(
    String granjaId,
    String nivel,
  ) async {
    final snapshot = await _collection(granjaId)
        .where('nivel', isEqualTo: nivel)
        .orderBy('fechaGeneracion', descending: true)
        .limit(500)
        .get();
    return snapshot.docs
        .map((doc) => AlertaSanitaria.fromJson({'id': doc.id, ...doc.data()}))
        .toList();
  }

  /// Crea una nueva alerta.
  Future<String> crearAlerta(AlertaSanitaria alerta) async {
    final json = alerta.toJson();
    json.remove('id');
    final docRef = await _collection(alerta.granjaId).add(json);
    return docRef.id;
  }

  /// Actualiza una alerta.
  Future<void> actualizarAlerta(AlertaSanitaria alerta) async {
    await _collection(alerta.granjaId).doc(alerta.id).update(alerta.toJson());
  }

  /// Marca una alerta como resuelta o descartada.
  Future<void> resolverAlerta({
    required String granjaId,
    required String alertaId,
    required String resolvedPor,
    required String comentario,
    required EstadoAlerta nuevoEstado,
  }) async {
    await _collection(granjaId).doc(alertaId).update({
      'estado': nuevoEstado.toJson(),
      'fechaResolucion': DateTime.now().toIso8601String(),
      'resolvedPor': resolvedPor,
      'comentarioResolucion': comentario,
    });
  }

  /// Elimina una alerta.
  Future<void> eliminarAlerta(String granjaId, String alertaId) async {
    await _collection(granjaId).doc(alertaId).delete();
  }

  /// Escucha cambios en todas las alertas.
  Stream<List<AlertaSanitaria>> watchAlertas(String granjaId) {
    return _collection(granjaId)
        .orderBy('fechaGeneracion', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AlertaSanitaria.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  /// Escucha cambios en alertas activas.
  Stream<List<AlertaSanitaria>> watchAlertasActivas(String granjaId) {
    return _collection(granjaId)
        .where('estado', isEqualTo: 'activa')
        .orderBy('fechaGeneracion', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    AlertaSanitaria.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }
}
