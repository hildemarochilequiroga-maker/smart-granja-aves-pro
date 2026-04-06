/// Repositorio de notificaciones.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/notificacion.dart';

/// Repositorio para operaciones CRUD de notificaciones.
class NotificacionesRepository {
  NotificacionesRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección base de usuarios.
  CollectionReference<Map<String, dynamic>> get _usuarios =>
      _firestore.collection('usuarios');

  /// Obtiene la colección de notificaciones de un usuario.
  CollectionReference<Map<String, dynamic>> _notificacionesRef(
    String usuarioId,
  ) => _usuarios.doc(usuarioId).collection('notificaciones');

  /// Stream de notificaciones de un usuario.
  Stream<List<Notificacion>> streamNotificaciones(String usuarioId) {
    return _notificacionesRef(usuarioId)
        .orderBy('fechaCreacion', descending: true)
        .limit(50)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Notificacion.fromFirestore(doc))
              .toList(),
        );
  }

  /// Stream de notificaciones no leídas.
  Stream<List<Notificacion>> streamNotificacionesNoLeidas(String usuarioId) {
    return _notificacionesRef(usuarioId)
        .where('leida', isEqualTo: false)
        .orderBy('fechaCreacion', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Notificacion.fromFirestore(doc))
              .toList(),
        );
  }

  /// Stream del conteo de no leídas.
  ///
  /// Firestore no soporta streams de aggregation queries,
  /// se limita a 999 docs para acotar la descarga.
  Stream<int> streamConteoNoLeidas(String usuarioId) {
    return _notificacionesRef(usuarioId)
        .where('leida', isEqualTo: false)
        .limit(999)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  /// Obtiene notificaciones paginadas.
  Future<List<Notificacion>> getNotificaciones(
    String usuarioId, {
    int limite = 20,
    DocumentSnapshot? ultimoDoc,
  }) async {
    var query = _notificacionesRef(
      usuarioId,
    ).orderBy('fechaCreacion', descending: true).limit(limite);

    if (ultimoDoc != null) {
      query = query.startAfterDocument(ultimoDoc);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => Notificacion.fromFirestore(doc)).toList();
  }

  /// Marca una notificación como leída.
  Future<void> marcarComoLeida(String usuarioId, String notificacionId) async {
    await _notificacionesRef(usuarioId).doc(notificacionId).update({
      'leida': true,
      'fechaLeida': FieldValue.serverTimestamp(),
    });
  }

  /// Marca todas las notificaciones como leídas.
  Future<void> marcarTodasComoLeidas(String usuarioId) async {
    final batch = _firestore.batch();
    final snapshot = await _notificacionesRef(
      usuarioId,
    ).where('leida', isEqualTo: false).limit(500).get();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {
        'leida': true,
        'fechaLeida': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// Elimina una notificación.
  Future<void> eliminar(String usuarioId, String notificacionId) async {
    await _notificacionesRef(usuarioId).doc(notificacionId).delete();
  }

  /// Elimina todas las notificaciones leídas.
  Future<void> eliminarLeidas(String usuarioId) async {
    final batch = _firestore.batch();
    final snapshot = await _notificacionesRef(
      usuarioId,
    ).where('leida', isEqualTo: true).limit(500).get();

    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Crea una notificación.
  Future<String> crear(Notificacion notificacion) async {
    final docRef = await _notificacionesRef(
      notificacion.usuarioId,
    ).add(notificacion.toFirestore());
    return docRef.id;
  }

  /// Crea notificaciones para múltiples usuarios.
  Future<void> crearParaMultiplesUsuarios({
    required List<String> usuarioIds,
    required Notificacion notificacionBase,
  }) async {
    final batch = _firestore.batch();

    for (final usuarioId in usuarioIds) {
      final notificacion = notificacionBase.copyWith(usuarioId: usuarioId);
      final docRef = _notificacionesRef(usuarioId).doc();
      batch.set(docRef, notificacion.toFirestore());
    }

    await batch.commit();
  }
}
