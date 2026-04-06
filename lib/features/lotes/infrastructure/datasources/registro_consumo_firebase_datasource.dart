/// Datasource Firebase para registros de consumo.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_consumo.dart';
import '../models/registro_consumo_model.dart';

/// Datasource para operaciones de registro de consumo en Firebase.
class RegistroConsumoFirebaseDatasource {
  RegistroConsumoFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de registros de consumo.
  CollectionReference<Map<String, dynamic>> _collection(String loteId) {
    return _firestore.collection('lotes').doc(loteId).collection('consumos');
  }

  /// Crea un nuevo registro.
  Future<RegistroConsumo> crear(RegistroConsumo registro) async {
    final model = RegistroConsumoModel.fromEntity(registro);
    final docRef = await _collection(registro.loteId).add(model.toFirestore());

    return registro.copyWith(id: docRef.id);
  }

  /// Actualiza un registro existente.
  Future<RegistroConsumo> actualizar(RegistroConsumo registro) async {
    final model = RegistroConsumoModel.fromEntity(
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
  Future<RegistroConsumo?> obtenerPorId(
    String loteId,
    String registroId,
  ) async {
    final doc = await _collection(loteId).doc(registroId).get();

    if (!doc.exists) return null;

    return RegistroConsumoModel.fromFirestore(doc).toEntity();
  }

  /// Obtiene todos los registros de un lote.
  Future<List<RegistroConsumo>> obtenerPorLote(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(500).get();

    return snapshot.docs
        .map((doc) => RegistroConsumoModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene registros por rango de fechas.
  Future<List<RegistroConsumo>> obtenerPorFechas(
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
        .map((doc) => RegistroConsumoModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene el último registro de un lote.
  Future<RegistroConsumo?> obtenerUltimo(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return RegistroConsumoModel.fromFirestore(snapshot.docs.first).toEntity();
  }

  /// Stream de registros de un lote.
  Stream<List<RegistroConsumo>> watchPorLote(String loteId) {
    return _collection(loteId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => RegistroConsumoModel.fromFirestore(doc).toEntity())
              .toList(),
        );
  }

  /// Obtiene el consumo total de un lote.
  Future<double> obtenerConsumoTotal(String loteId) async {
    final registros = await obtenerPorLote(loteId);
    return registros.fold<double>(0, (total, r) => total + r.cantidadKg);
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
