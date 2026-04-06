/// Datasource Firebase para registros de producción.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_produccion.dart';
import '../models/registro_produccion_model.dart';

/// Datasource para operaciones de registro de producción en Firebase.
class RegistroProduccionFirebaseDatasource {
  RegistroProduccionFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de registros de producción.
  CollectionReference<Map<String, dynamic>> _collection(String loteId) {
    return _firestore.collection('lotes').doc(loteId).collection('produccion');
  }

  /// Crea un nuevo registro.
  Future<RegistroProduccion> crear(RegistroProduccion registro) async {
    final model = RegistroProduccionModel.fromEntity(registro);
    final docRef = await _collection(registro.loteId).add(model.toFirestore());

    return registro.copyWith(id: docRef.id);
  }

  /// Actualiza un registro existente.
  Future<RegistroProduccion> actualizar(RegistroProduccion registro) async {
    final model = RegistroProduccionModel.fromEntity(
      registro.copyWith(updatedAt: DateTime.now()),
    );

    await _collection(
      registro.loteId,
    ).doc(registro.id).update(model.toFirestore());

    return registro.copyWith(updatedAt: DateTime.now());
  }

  /// Elimina un registro.
  Future<void> eliminar(String loteId, String registroId) async {
    await _collection(loteId).doc(registroId).delete();
  }

  /// Obtiene un registro por ID.
  Future<RegistroProduccion?> obtenerPorId(
    String loteId,
    String registroId,
  ) async {
    final doc = await _collection(loteId).doc(registroId).get();

    if (!doc.exists) return null;

    return RegistroProduccionModel.fromFirestore(doc).toEntity();
  }

  /// Obtiene todos los registros de un lote.
  Future<List<RegistroProduccion>> obtenerPorLote(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(500).get();

    return snapshot.docs
        .map((doc) => RegistroProduccionModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene registros por rango de fechas.
  Future<List<RegistroProduccion>> obtenerPorFechas(
    String loteId,
    DateTime inicio,
    DateTime fin,
  ) async {
    final snapshot = await _collection(loteId)
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
        .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fin))
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RegistroProduccionModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene el último registro de un lote.
  Future<RegistroProduccion?> obtenerUltimo(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return RegistroProduccionModel.fromFirestore(
      snapshot.docs.first,
    ).toEntity();
  }

  /// Stream de registros de un lote.
  Stream<List<RegistroProduccion>> watchPorLote(String loteId) {
    return _collection(loteId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => RegistroProduccionModel.fromFirestore(doc).toEntity(),
              )
              .toList(),
        );
  }

  /// Obtiene el total de huevos producidos.
  Future<int> obtenerTotalHuevos(String loteId) async {
    final registros = await obtenerPorLote(loteId);
    return registros.fold<int>(0, (total, r) => total + r.huevosRecolectados);
  }

  /// Obtiene el porcentaje de postura promedio.
  Future<double> obtenerPosturaPromedio(String loteId) async {
    final registros = await obtenerPorLote(loteId);
    if (registros.isEmpty) return 0;

    final sumaPostura = registros.fold<double>(
      0,
      (total, r) => total + r.porcentajePostura,
    );

    return sumaPostura / registros.length;
  }

  /// Obtiene la evolución de producción (para gráficos).
  Future<List<({DateTime fecha, int huevos, double postura})>>
  obtenerEvolucionProduccion(String loteId) async {
    final registros = await obtenerPorLote(loteId);

    return registros
        .map(
          (r) => (
            fecha: r.fecha,
            huevos: r.huevosRecolectados,
            postura: r.porcentajePostura,
          ),
        )
        .toList()
        .reversed
        .toList();
  }

  /// Verifica si existe un registro para la fecha dada.
  Future<bool> existeRegistroParaFecha(String loteId, DateTime fecha) async {
    final inicioDia = DateTime(fecha.year, fecha.month, fecha.day);
    final finDia = inicioDia.add(const Duration(days: 1));

    final snapshot = await _collection(loteId)
        .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(inicioDia))
        .where('fecha', isLessThan: Timestamp.fromDate(finDia))
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
