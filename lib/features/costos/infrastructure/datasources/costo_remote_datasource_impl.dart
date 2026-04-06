import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';
import '../models/costo_gasto_model.dart';
import 'costo_remote_datasource.dart';

final costoRemoteDatasourceProvider = Provider<CostoRemoteDatasource>((ref) {
  return CostoRemoteDatasourceImpl(FirebaseFirestore.instance);
});

class CostoRemoteDatasourceImpl implements CostoRemoteDatasource {
  final FirebaseFirestore firestore;
  static const String _collection = 'costos_gastos';

  CostoRemoteDatasourceImpl(this.firestore);

  CollectionReference<Map<String, dynamic>> get _costosCollection =>
      firestore.collection(_collection);

  @override
  Future<CostoGasto> crear(CostoGasto costo) async {
    try {
      final model = CostoGastoModel.fromEntity(costo);
      if (costo.id.isEmpty) {
        final docRef = await _costosCollection.add(model.toFirestore());
        return costo.copyWith(id: docRef.id);
      } else {
        await _costosCollection.doc(costo.id).set(model.toFirestore());
        return costo;
      }
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_CREATE_COST', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<CostoGasto?> obtenerPorId(String id) async {
    try {
      final doc = await _costosCollection.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return CostoGastoModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COST', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerTodos() async {
    try {
      final snapshot = await _costosCollection
          .orderBy('fechaRegistro', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COSTS', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> actualizar(CostoGasto costo) async {
    try {
      final model = CostoGastoModel.fromEntity(costo);
      await _costosCollection.doc(costo.id).update(model.toFirestore());
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_UPDATE_COST', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<void> eliminar(String id) async {
    try {
      await _costosCollection.doc(id).delete();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_DELETE_COST', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerPorGranja(String granjaId) async {
    try {
      final snapshot = await _costosCollection
          .where('granjaId', isEqualTo: granjaId)
          .orderBy('fecha', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COSTS_BY_FARM', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerPorLote(String loteId) async {
    try {
      final snapshot = await _costosCollection
          .where('loteId', isEqualTo: loteId)
          .orderBy('fecha', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COSTS_BY_BATCH', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerPorTipo(
    TipoGasto tipo,
    String granjaId,
  ) async {
    try {
      final snapshot = await _costosCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('tipo', isEqualTo: tipo.name)
          .orderBy('fecha', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COSTS_BY_TYPE', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerPendientesAprobacion(String granjaId) async {
    try {
      final snapshot = await _costosCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('requiereAprobacion', isEqualTo: true)
          .where('aprobado', isEqualTo: false)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_PENDING_COSTS', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Future<List<CostoGasto>> obtenerPorPeriodo({
    required String granjaId,
    required DateTime desde,
    required DateTime hasta,
  }) async {
    try {
      final snapshot = await _costosCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(desde))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(hasta))
          .orderBy('fecha', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => CostoGastoModel.fromFirestore(doc).toEntity())
          .toList();
    } on Exception catch (e) {
      throw ServerException(
        message: ErrorMessages.format('ERR_GET_COSTS_BY_PERIOD', {'e': '$e'}),
        code: 'FIRESTORE_ERROR',
      );
    }
  }

  @override
  Stream<List<CostoGasto>> observarTodos() {
    return _costosCollection
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          final costos = <CostoGasto>[];
          for (final doc in snapshot.docs) {
            try {
              costos.add(CostoGastoModel.fromFirestore(doc).toEntity());
            } on Exception catch (e) {
              debugPrint('Error parseando costo ${doc.id}: $e');
            }
          }
          return costos;
        })
        .handleError((error) {
          debugPrint('Error en stream observarTodos: $error');
          throw error;
        });
  }

  @override
  Stream<List<CostoGasto>> observarPorGranja(String granjaId) {
    return _costosCollection
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          final costos = <CostoGasto>[];
          for (final doc in snapshot.docs) {
            try {
              costos.add(CostoGastoModel.fromFirestore(doc).toEntity());
            } on Exception catch (e) {
              debugPrint('Error parseando costo ${doc.id}: $e');
            }
          }
          return costos;
        })
        .handleError((error) {
          debugPrint('Error en stream observarPorGranja: $error');
          throw error;
        });
  }

  @override
  Stream<List<CostoGasto>> observarPorLote(String loteId) {
    return _costosCollection
        .where('loteId', isEqualTo: loteId)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          final costos = <CostoGasto>[];
          for (final doc in snapshot.docs) {
            try {
              costos.add(CostoGastoModel.fromFirestore(doc).toEntity());
            } on Exception catch (e) {
              debugPrint('Error parseando costo ${doc.id}: $e');
            }
          }
          return costos;
        })
        .handleError((error) {
          debugPrint('Error en stream observarPorLote: $error');
          throw error;
        });
  }
}
