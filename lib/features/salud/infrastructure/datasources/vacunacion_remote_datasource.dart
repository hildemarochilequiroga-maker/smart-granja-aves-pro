import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/vacunacion.dart';
import '../models/vacunacion_model.dart';

/// Datasource remoto para Vacunacion usando Firestore.
abstract class VacunacionRemoteDatasource {
  Future<Vacunacion> crear(Vacunacion vacunacion);
  Future<Vacunacion?> obtenerPorId(String id);
  Future<List<Vacunacion>> obtenerTodos();
  Future<Vacunacion> actualizar(Vacunacion vacunacion);
  Future<void> eliminar(String id);
  Future<List<Vacunacion>> obtenerPorLote(String loteId);
  Future<List<Vacunacion>> obtenerPorGranja(String granjaId);
  Future<List<Vacunacion>> obtenerProximas({int diasUmbral = 7});
  Stream<List<Vacunacion>> observarPorLote(String loteId);
  Stream<List<Vacunacion>> observarPorGranja(String granjaId);
}

class VacunacionRemoteDatasourceImpl implements VacunacionRemoteDatasource {
  final FirebaseFirestore _firestore;
  final String _collection = 'vacunaciones';

  VacunacionRemoteDatasourceImpl(this._firestore);

  @override
  Future<Vacunacion> crear(Vacunacion vacunacion) async {
    try {
      debugPrint(
        '💾 VacunacionDatasource.crear: granjaId=${vacunacion.granjaId}, loteId=${vacunacion.loteId}, nombre=${vacunacion.nombreVacuna}',
      );
      final model = VacunacionModel.fromEntity(vacunacion);
      final firestoreData = model.toFirestore();
      debugPrint(
        '💾 VacunacionDatasource.crear - Datos Firestore: granjaId=${firestoreData['granjaId']}, loteId=${firestoreData['loteId']}',
      );
      final docRef = await _firestore
          .collection(_collection)
          .add(firestoreData);

      debugPrint(
        '✅ VacunacionDatasource.crear: Documento creado con ID: ${docRef.id}',
      );
      final doc = await docRef.get();
      return VacunacionModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      debugPrint('❌ VacunacionDatasource.crear ERROR: $e');
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<Vacunacion?> obtenerPorId(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return VacunacionModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<Vacunacion>> obtenerTodos() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fechaProgramada', descending: false)
          .get();

      return snapshot.docs
          .map(
            (doc) => VacunacionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<Vacunacion> actualizar(Vacunacion vacunacion) async {
    try {
      final model = VacunacionModel.fromEntity(vacunacion);
      final docRef = _firestore.collection(_collection).doc(vacunacion.id);

      // Actualizar con timestamp del servidor
      await docRef.update({
        ...model.toFirestore(),
        'ultimaActualizacion': FieldValue.serverTimestamp(),
      });

      // Obtener el documento actualizado desde Firestore
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception(
          ErrorMessages.get('ERR_VACCINATION_NOT_FOUND_AFTER_UPDATE'),
        );
      }
      return VacunacionModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<void> eliminar(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<Vacunacion>> obtenerPorLote(String loteId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('loteId', isEqualTo: loteId)
          .orderBy('fechaProgramada', descending: false)
          .get();

      return snapshot.docs
          .map(
            (doc) => VacunacionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<Vacunacion>> obtenerPorGranja(String granjaId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('granjaId', isEqualTo: granjaId)
          .orderBy('fechaProgramada', descending: false)
          .get();

      return snapshot.docs
          .map(
            (doc) => VacunacionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<Vacunacion>> obtenerProximas({int diasUmbral = 7}) async {
    try {
      final now = DateTime.now();
      final limite = now.add(Duration(days: diasUmbral));

      final snapshot = await _firestore
          .collection(_collection)
          .where('aplicada', isEqualTo: false)
          .where(
            'fechaProgramada',
            isGreaterThanOrEqualTo: Timestamp.fromDate(now),
          )
          .where(
            'fechaProgramada',
            isLessThanOrEqualTo: Timestamp.fromDate(limite),
          )
          .get();

      return snapshot.docs
          .map(
            (doc) => VacunacionModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Stream<List<Vacunacion>> observarPorLote(String loteId) {
    return _firestore
        .collection(_collection)
        .where('loteId', isEqualTo: loteId)
        .orderBy('fechaProgramada', descending: false)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return VacunacionModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ).toEntity();
                } on Exception catch (e) {
                  debugPrint('Error parsing vacunacion doc ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<Vacunacion>()
              .toList(),
        )
        .handleError((error, stackTrace) {
          debugPrint('Error en stream observarPorLote vacunacion: $error');
          throw error;
        });
  }

  @override
  Stream<List<Vacunacion>> observarPorGranja(String granjaId) {
    debugPrint(
      '🔍 VacunacionDatasource: Buscando vacunaciones para granjaId: $granjaId',
    );
    return _firestore
        .collection(_collection)
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fechaProgramada', descending: true)
        .limit(200)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            '📊 VacunacionDatasource: Encontradas ${snapshot.docs.length} vacunaciones',
          );
          return snapshot.docs
              .map((doc) {
                try {
                  return VacunacionModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ).toEntity();
                } on Exception catch (e) {
                  debugPrint('Error parsing vacunacion doc ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<Vacunacion>()
              .toList();
        })
        .handleError((error, stackTrace) {
          debugPrint('Error en stream observarPorGranja vacunacion: $error');
          throw error;
        });
  }
}
