/// Datasource para la cola de integraciones de inventario pendientes de
/// reintento (colección `integraciones_pendientes`).
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/integracion_pendiente.dart';

/// Persiste y recupera integraciones de inventario que fallaron por un
/// problema transitorio, para que el reconciliador las reintente.
class IntegracionPendienteDatasource {
  IntegracionPendienteDatasource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'integraciones_pendientes';

  CollectionReference<Map<String, dynamic>> get _ref =>
      _firestore.collection(_collection);

  /// Encola una nueva integración pendiente y devuelve su ID.
  Future<String> encolar(IntegracionPendiente pendiente) async {
    final doc = _ref.doc();
    await doc.set(_toFirestore(pendiente));
    return doc.id;
  }

  /// Obtiene las integraciones pendientes reintentables de una granja
  /// (las que aún no agotaron sus intentos), ordenadas por antigüedad.
  Future<List<IntegracionPendiente>> obtenerReintentables(
    String granjaId,
  ) async {
    final snapshot = await _ref
        .where('granjaId', isEqualTo: granjaId)
        .where('intentos', isLessThan: IntegracionPendiente.maxIntentos)
        .orderBy('intentos')
        .orderBy('creadoEn')
        .limit(50)
        .get();
    return snapshot.docs.map(_fromFirestore).toList();
  }

  /// Marca un intento fallido: incrementa el contador y guarda el error.
  Future<void> registrarIntentoFallido(
    String id,
    String error,
  ) async {
    await _ref.doc(id).update({
      'intentos': FieldValue.increment(1),
      'ultimoError': error,
      'ultimoIntento': FieldValue.serverTimestamp(),
    });
  }

  /// Elimina una integración pendiente (tras reconciliarla con éxito).
  Future<void> eliminar(String id) => _ref.doc(id).delete();

  // ==================== Serialización ====================

  Map<String, dynamic> _toFirestore(IntegracionPendiente p) {
    return {
      'granjaId': p.granjaId,
      'tipo': p.tipo.toJson(),
      'parametros': p.parametros,
      'creadoEn': Timestamp.fromDate(p.creadoEn),
      'intentos': p.intentos,
      'ultimoError': p.ultimoError,
      'ultimoIntento': p.ultimoIntento != null
          ? Timestamp.fromDate(p.ultimoIntento!)
          : null,
    };
  }

  IntegracionPendiente _fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return IntegracionPendiente(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      tipo: TipoIntegracionPendiente.fromJson(data['tipo'] as String? ?? ''),
      parametros: Map<String, dynamic>.from(
        data['parametros'] as Map? ?? const {},
      ),
      creadoEn: (data['creadoEn'] as Timestamp?)?.toDate() ?? DateTime.now(),
      intentos: (data['intentos'] as num?)?.toInt() ?? 0,
      ultimoError: data['ultimoError'] as String?,
      ultimoIntento: (data['ultimoIntento'] as Timestamp?)?.toDate(),
    );
  }
}
