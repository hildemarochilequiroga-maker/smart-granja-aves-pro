/// Datasource Firebase para registros de mortalidad.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_mortalidad.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';
import '../models/lote_model.dart';
import '../models/registro_mortalidad_model.dart';

/// Datasource para operaciones de registro de mortalidad en Firebase.
class RegistroMortalidadFirebaseDatasource {
  RegistroMortalidadFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Coleccion de registros de mortalidad.
  CollectionReference<Map<String, dynamic>> _collection(String loteId) {
    return _firestore.collection('lotes').doc(loteId).collection('mortalidad');
  }

  /// Crea un nuevo registro.
  Future<RegistroMortalidad> crear(RegistroMortalidad registro) async {
    final model = RegistroMortalidadModel.fromEntity(registro);
    final docRef = await _collection(registro.loteId).add(model.toFirestore());

    return registro.copyWith(id: docRef.id);
  }

  /// Actualiza un registro existente.
  Future<RegistroMortalidad> actualizar(RegistroMortalidad registro) async {
    final model = RegistroMortalidadModel.fromEntity(
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
  Future<RegistroMortalidad?> obtenerPorId(
    String loteId,
    String registroId,
  ) async {
    final doc = await _collection(loteId).doc(registroId).get();

    if (!doc.exists) return null;

    return RegistroMortalidadModel.fromFirestore(doc).toEntity();
  }

  /// Obtiene todos los registros de un lote.
  Future<List<RegistroMortalidad>> obtenerPorLote(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(500).get();

    return snapshot.docs
        .map((doc) => RegistroMortalidadModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene registros por rango de fechas.
  Future<List<RegistroMortalidad>> obtenerPorFechas(
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
        .map((doc) => RegistroMortalidadModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene registros por causa.
  Future<List<RegistroMortalidad>> obtenerPorCausa(
    String loteId,
    CausaMortalidad causa,
  ) async {
    final snapshot = await _collection(loteId)
        .where('causa', isEqualTo: causa.toJson())
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => RegistroMortalidadModel.fromFirestore(doc).toEntity())
        .toList();
  }

  /// Obtiene el ultimo registro de un lote.
  Future<RegistroMortalidad?> obtenerUltimo(String loteId) async {
    final snapshot = await _collection(
      loteId,
    ).orderBy('fecha', descending: true).limit(1).get();

    if (snapshot.docs.isEmpty) return null;

    return RegistroMortalidadModel.fromFirestore(
      snapshot.docs.first,
    ).toEntity();
  }

  /// Stream de registros de un lote.
  Stream<List<RegistroMortalidad>> watchPorLote(String loteId) {
    return _collection(loteId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => RegistroMortalidadModel.fromFirestore(doc).toEntity(),
              )
              .toList(),
        );
  }

  /// Obtiene la mortalidad total de un lote.
  Future<int> obtenerMortalidadTotal(String loteId) async {
    final registros = await obtenerPorLote(loteId);
    return registros.fold<int>(0, (total, r) => total + r.cantidad);
  }

  /// Obtiene estadisticas por causa.
  Future<Map<CausaMortalidad, int>> obtenerEstadisticasPorCausa(
    String loteId,
  ) async {
    final registros = await obtenerPorLote(loteId);
    final stats = <CausaMortalidad, int>{};

    for (final registro in registros) {
      stats[registro.causa] = (stats[registro.causa] ?? 0) + registro.cantidad;
    }

    return stats;
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

  /// Crea un registro de mortalidad y actualiza el lote en una transacción atómica.
  ///
  /// Esto garantiza que si una operación falla, ninguna se aplica,
  /// evitando inconsistencias de datos.
  Future<RegistroMortalidad> crearConActualizacionLote({
    required RegistroMortalidad registro,
    required Lote loteActualizado,
  }) async {
    final registroModel = RegistroMortalidadModel.fromEntity(registro);
    final loteModel = LoteModel.fromEntity(loteActualizado);

    final loteRef = _firestore.collection('lotes').doc(registro.loteId);
    final registroRef = _collection(registro.loteId).doc();

    await _firestore.runTransaction((transaction) async {
      // Crear el registro de mortalidad
      transaction.set(registroRef, registroModel.toFirestore());

      // Actualizar el lote
      transaction.update(loteRef, loteModel.toFirestore());
    });

    return registro.copyWith(id: registroRef.id);
  }
}
