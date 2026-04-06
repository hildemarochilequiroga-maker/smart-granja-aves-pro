import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/salud_registro.dart';
import '../models/salud_registro_model.dart';

/// Datasource remoto para SaludRegistro usando Firestore.
abstract class SaludRemoteDatasource {
  Future<SaludRegistro> crear(SaludRegistro registro);
  Future<SaludRegistro?> obtenerPorId(String id);
  Future<List<SaludRegistro>> obtenerTodos();
  Future<SaludRegistro> actualizar(SaludRegistro registro);
  Future<void> eliminar(String id);
  Future<List<SaludRegistro>> obtenerPorLote(String loteId);
  Future<List<SaludRegistro>> obtenerPorGranja(String granjaId);
  Stream<List<SaludRegistro>> observarTodos();
  Stream<List<SaludRegistro>> observarPorLote(String loteId);
  Stream<List<SaludRegistro>> observarPorGranja(String granjaId);
}

class SaludRemoteDatasourceImpl implements SaludRemoteDatasource {
  final FirebaseFirestore _firestore;
  final String _collection = 'salud_registros';

  SaludRemoteDatasourceImpl(this._firestore);

  @override
  Future<SaludRegistro> crear(SaludRegistro registro) async {
    try {
      final model = SaludRegistroModel.fromEntity(registro);
      // Firestore genera el ID automáticamente
      final docRef = await _firestore
          .collection(_collection)
          .add(model.toFirestore());

      // Obtener el documento recién creado con su ID real
      final doc = await docRef.get();
      return SaludRegistroModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<SaludRegistro?> obtenerPorId(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;
      return SaludRegistroModel.fromFirestore(doc).toEntity();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<SaludRegistro>> obtenerTodos() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SaludRegistroModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<SaludRegistro> actualizar(SaludRegistro registro) async {
    try {
      final model = SaludRegistroModel.fromEntity(registro);
      final docRef = _firestore.collection(_collection).doc(registro.id);

      // Actualizar con timestamp del servidor
      await docRef.update({
        ...model.toFirestore(),
        'ultimaActualizacion': FieldValue.serverTimestamp(),
      });

      // Obtener el documento actualizado desde Firestore
      final doc = await docRef.get();
      if (!doc.exists) {
        throw Exception(ErrorMessages.get('ERR_RECORD_NOT_FOUND_AFTER_UPDATE'));
      }
      return SaludRegistroModel.fromFirestore(doc).toEntity();
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
  Future<List<SaludRegistro>> obtenerPorLote(String loteId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('loteId', isEqualTo: loteId)
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SaludRegistroModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Future<List<SaludRegistro>> obtenerPorGranja(String granjaId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('granjaId', isEqualTo: granjaId)
          .orderBy('fecha', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => SaludRegistroModel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>,
            ).toEntity(),
          )
          .toList();
    } on Exception catch (e) {
      throw ErrorHandler.toException(e);
    }
  }

  @override
  Stream<List<SaludRegistro>> observarTodos() {
    return _firestore
        .collection(_collection)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return SaludRegistroModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ).toEntity();
                } on Exception catch (e) {
                  debugPrint('Error parsing salud doc ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<SaludRegistro>()
              .toList(),
        )
        .handleError((error, stackTrace) {
          debugPrint('Error en stream observarTodos: $error');
          throw error;
        });
  }

  @override
  Stream<List<SaludRegistro>> observarPorLote(String loteId) {
    return _firestore
        .collection(_collection)
        .where('loteId', isEqualTo: loteId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return SaludRegistroModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ).toEntity();
                } on Exception catch (e) {
                  debugPrint('Error parsing salud doc ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<SaludRegistro>()
              .toList(),
        )
        .handleError((error, stackTrace) {
          debugPrint('Error en stream observarPorLote: $error');
          throw error;
        });
  }

  @override
  Stream<List<SaludRegistro>> observarPorGranja(String granjaId) {
    return _firestore
        .collection(_collection)
        .where('granjaId', isEqualTo: granjaId)
        .orderBy('fecha', descending: true)
        .limit(200)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                try {
                  return SaludRegistroModel.fromFirestore(
                    doc as DocumentSnapshot<Map<String, dynamic>>,
                  ).toEntity();
                } on Exception catch (e) {
                  debugPrint('Error parsing salud doc ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<SaludRegistro>()
              .toList(),
        )
        .handleError((error, stackTrace) {
          debugPrint('Error en stream observarPorGranja: $error');
          throw error;
        });
  }
}
