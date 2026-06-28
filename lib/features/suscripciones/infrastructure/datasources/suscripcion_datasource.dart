/// Datasource de solo lectura de suscripciones (colección `suscripciones`,
/// 1 documento por usuario propietario con id == uid).
///
/// El cliente NUNCA escribe aquí: las reglas de Firestore lo prohíben. La
/// escritura ocurre en el servidor tras validar la compra de Google Play.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/suscripcion_model.dart';

class SuscripcionDatasource {
  SuscripcionDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'suscripciones';

  DocumentReference<Map<String, dynamic>> _doc(String usuarioId) =>
      _firestore.collection(_collection).doc(usuarioId);

  /// Stream del documento de suscripción. Si no existe, emite gratis.
  Stream<SuscripcionModel> observar(String usuarioId) {
    return _doc(usuarioId).snapshots().map((snap) {
      if (!snap.exists) return SuscripcionModel.gratis(usuarioId);
      return SuscripcionModel.fromFirestore(snap);
    });
  }

  /// Lectura puntual. Si no existe, devuelve gratis.
  Future<SuscripcionModel> obtener(String usuarioId) async {
    final snap = await _doc(usuarioId).get();
    if (!snap.exists) return SuscripcionModel.gratis(usuarioId);
    return SuscripcionModel.fromFirestore(snap);
  }
}
