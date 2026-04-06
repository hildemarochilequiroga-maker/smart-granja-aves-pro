/// Datasource Firebase para registros de peso.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_peso.dart';
import '../models/registro_peso_model.dart';

/// Datasource para operaciones de registro de peso en Firebase.
class RegistroPesoFirebaseDatasource {
  RegistroPesoFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de registros de peso.
  CollectionReference<Map<String, dynamic>> _collection(String loteId) {
    return _firestore.collection('lotes').doc(loteId).collection('pesos');
  }

  /// Crea un nuevo registro.
  Future<RegistroPeso> crear(RegistroPeso registro) async {
    final model = RegistroPesoModel.fromEntity(registro);
    final docRef = await _collection(registro.loteId).add(model.toFirestore());

    return registro.copyWith(id: docRef.id);
  }

  /// Actualiza un registro existente.
  Future<RegistroPeso> actualizar(RegistroPeso registro) async {
    final model = RegistroPesoModel.fromEntity(
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
  Future<RegistroPeso?> obtenerPorId(String loteId, String registroId) async {
    final doc = await _collection(loteId).doc(registroId).get();

    if (!doc.exists) return null;

    return RegistroPesoModel.fromFirestore(doc).toEntity();
  }

  /// Obtiene todos los registros de un lote.
  Future<List<RegistroPeso>> obtenerPorLote(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(500).get();

    return snapshot.docs
        .map((doc) => RegistroPesoModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene registros por rango de fechas.
  Future<List<RegistroPeso>> obtenerPorFechas(
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
        .map((doc) => RegistroPesoModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene el último registro de un lote.
  Future<RegistroPeso?> obtenerUltimo(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return RegistroPesoModel.fromFirestore(snapshot.docs.first).toEntity();
  }

  /// Stream de registros de un lote.
  Stream<List<RegistroPeso>> watchPorLote(String loteId) {
    return _collection(loteId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RegistroPesoModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  /// Obtiene el último peso promedio de un lote.
  Future<double?> obtenerUltimoPesoPromedio(String loteId) async {
    final ultimo = await obtenerUltimo(loteId);
    return ultimo?.pesoPromedio;
  }

  /// Obtiene la evolución de peso (para gráficos).
  Future<List<({DateTime fecha, double peso})>> obtenerEvolucionPeso(
    String loteId,
  ) async {
    final registros = await obtenerPorLote(loteId);

    return registros
        .map((r) => (fecha: r.fecha, peso: r.pesoPromedio))
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
