library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/enums/enums.dart';
import '../models/granja_model.dart';

/// Datasource remoto para operaciones de granjas en Firebase
class GranjaFirebaseDatasource {
  GranjaFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  /// Colección de granjas
  CollectionReference<Map<String, dynamic>> get _granjasCollection =>
      _firestore.collection('granjas');

  // ==================== CRUD ====================

  /// Crea una nueva granja y registra al propietario como owner
  Future<GranjaModel> crear(GranjaModel granja) async {
    try {
      final docRef = _granjasCollection.doc();
      final granjaConId = granja.copyWith(id: docRef.id);

      // Usar batch para crear granja y registro de usuario atómicamente
      final batch = _firestore.batch();

      // 1. Crear la granja
      batch.set(docRef, granjaConId.toFirestore());

      // 2. Registrar al propietario como owner en granja_usuarios
      final granjaUsuarioDocId = '${docRef.id}_${granja.propietarioId}';
      final granjaUsuarioRef = _firestore
          .collection('granja_usuarios')
          .doc(granjaUsuarioDocId);

      batch.set(granjaUsuarioRef, {
        'granjaId': docRef.id,
        'usuarioId': granja.propietarioId,
        'rol': 'owner',
        'fechaAsignacion': FieldValue.serverTimestamp(),
        'activo': true,
        'notas': 'Propietario original de la granja',
        'nombreCompleto': granja.propietarioNombre,
        'email': granja.correo,
      });

      await batch.commit();

      return granjaConId;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_CREATE_FARM'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene una granja por ID
  Future<GranjaModel?> obtenerPorId(String id) async {
    try {
      final doc = await _granjasCollection.doc(id).get();
      if (!doc.exists) return null;
      return GranjaModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_GET_FARM'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene todas las granjas de un usuario (propias + colaborativas)
  Future<List<GranjaModel>> obtenerPorUsuario(String usuarioId) async {
    try {
      // Obtener granjas propias
      final snapshotPropias = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .get();

      // Obtener granjas colaborativas
      final snapshotColaborativas = await _granjasCollection
          .where('usuariosAccesoIds', arrayContains: usuarioId)
          .get();

      // Combinar evitando duplicados
      final granjasMap = <String, GranjaModel>{};

      for (final doc in snapshotPropias.docs) {
        final granja = GranjaModel.fromFirestore(doc);
        granjasMap[granja.id] = granja;

        // Asegurar que el propietario esté registrado en granja_usuarios
        await _asegurarPropietarioRegistrado(granja);
      }

      for (final doc in snapshotColaborativas.docs) {
        final granja = GranjaModel.fromFirestore(doc);
        if (!granjasMap.containsKey(granja.id)) {
          granjasMap[granja.id] = granja;
        }
      }

      // Ordenar por fecha de creación descendente
      final granjasList = granjasMap.values.toList();
      granjasList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      return granjasList;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_GET_FARMS'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Asegura que el propietario de una granja esté registrado en granja_usuarios
  /// Esto es una migración automática para granjas creadas antes del sistema multi-usuario
  Future<void> _asegurarPropietarioRegistrado(GranjaModel granja) async {
    try {
      final docId = '${granja.id}_${granja.propietarioId}';
      final docRef = _firestore.collection('granja_usuarios').doc(docId);
      final doc = await docRef.get();

      if (!doc.exists) {
        // El propietario no está registrado, crear el registro
        await docRef.set({
          'granjaId': granja.id,
          'usuarioId': granja.propietarioId,
          'rol': 'owner',
          'fechaAsignacion': FieldValue.serverTimestamp(),
          'activo': true,
          'notas': 'Propietario migrado automáticamente',
          'nombreCompleto': granja.propietarioNombre,
          'email': granja.correo,
        });
        debugPrint(
          '[GranjaFirebaseDatasource] Propietario registrado para granja ${granja.id}',
        );
      }
    } on Exception catch (e) {
      // No fallar si hay error en la migración, solo log
      debugPrint(
        '[GranjaFirebaseDatasource] Error al asegurar propietario: $e',
      );
    }
  }

  /// Actualiza una granja
  Future<GranjaModel> actualizar(GranjaModel granja) async {
    try {
      await _granjasCollection.doc(granja.id).update(granja.toFirestore());
      return granja;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_UPDATE_FARM'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Elimina una granja y todos sus datos relacionados
  /// Incluye: granja_usuarios, invitaciones_granja
  Future<bool> eliminar(String id) async {
    try {
      // 1. Eliminar todos los registros de granja_usuarios para esta granja
      await _limpiarColeccionPorGranja('granja_usuarios', id);

      // 2. Eliminar todas las invitaciones de esta granja
      await _limpiarColeccionPorGranja('invitaciones_granja', id);

      // 3. Eliminar la granja
      await _granjasCollection.doc(id).delete();

      debugPrint('✅ Granja $id eliminada con todos sus datos relacionados');
      return true;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_DELETE_FARM'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Limpia todos los documentos de una colección que pertenecen a una granja
  Future<void> _limpiarColeccionPorGranja(
    String coleccion,
    String granjaId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(coleccion)
          .where('granjaId', isEqualTo: granjaId)
          .get();

      if (snapshot.docs.isEmpty) return;

      // Eliminar en lotes de 500 (límite de Firestore)
      final batches = <WriteBatch>[];
      var currentBatch = _firestore.batch();
      var operationsInBatch = 0;

      for (final doc in snapshot.docs) {
        currentBatch.delete(doc.reference);
        operationsInBatch++;

        if (operationsInBatch >= 500) {
          batches.add(currentBatch);
          currentBatch = _firestore.batch();
          operationsInBatch = 0;
        }
      }

      if (operationsInBatch > 0) {
        batches.add(currentBatch);
      }

      for (final batch in batches) {
        await batch.commit();
      }

      debugPrint(
        '✅ Limpiados ${snapshot.docs.length} documentos de $coleccion',
      );
    } on Exception catch (e) {
      debugPrint('⚠️ Error limpiando $coleccion: $e');
      // No propagamos el error para no interrumpir la eliminación de la granja
    }
  }

  // ==================== CONSULTAS ====================

  /// Obtiene granjas activas de un usuario (propias + colaborativas)
  Future<List<GranjaModel>> obtenerActivas(String usuarioId) async {
    try {
      // Obtener granjas activas propias
      final snapshotPropias = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .where('estado', isEqualTo: EstadoGranja.activo.toJson())
          .get();

      // Obtener granjas activas colaborativas
      final snapshotColaborativas = await _granjasCollection
          .where('usuariosAccesoIds', arrayContains: usuarioId)
          .where('estado', isEqualTo: EstadoGranja.activo.toJson())
          .get();

      // Combinar evitando duplicados
      final granjasMap = <String, GranjaModel>{};

      for (final doc in snapshotPropias.docs) {
        final granja = GranjaModel.fromFirestore(doc);
        granjasMap[granja.id] = granja;
      }

      for (final doc in snapshotColaborativas.docs) {
        final granja = GranjaModel.fromFirestore(doc);
        if (!granjasMap.containsKey(granja.id)) {
          granjasMap[granja.id] = granja;
        }
      }

      // Ordenar por nombre
      final granjasList = granjasMap.values.toList();
      granjasList.sort((a, b) => a.nombre.compareTo(b.nombre));
      return granjasList;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_GET_FARMS'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene granjas por estado
  Future<List<GranjaModel>> obtenerPorEstado(
    String usuarioId,
    EstadoGranja estado,
  ) async {
    try {
      final snapshot = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .where('estado', isEqualTo: estado.toJson())
          .orderBy('nombre')
          .get();

      return snapshot.docs
          .map((doc) => GranjaModel.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_GET_FARMS'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Busca granjas por nombre
  Future<List<GranjaModel>> buscarPorNombre(
    String usuarioId,
    String nombre,
  ) async {
    try {
      // Firestore no tiene búsqueda de texto completo nativa
      // Usamos startAt/endAt para búsqueda por prefijo
      final nombreLower = nombre.toLowerCase();
      final snapshot = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .orderBy('nombre')
          .startAt([nombreLower])
          .endAt(['$nombreLower\uf8ff'])
          .get();

      return snapshot.docs
          .map((doc) => GranjaModel.fromFirestore(doc))
          .toList();
    } on FirebaseException {
      // Si falla por índice, hacer búsqueda local
      final todas = await obtenerPorUsuario(usuarioId);
      return todas
          .where((g) => g.nombre.toLowerCase().contains(nombre.toLowerCase()))
          .toList();
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Verifica si existe una granja con el RUC
  Future<bool> existeConRuc(String ruc) async {
    try {
      final snapshot = await _granjasCollection
          .where('ruc', isEqualTo: ruc)
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_VERIFY_RUC'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene una granja por RUC
  Future<GranjaModel?> obtenerPorRuc(String ruc) async {
    try {
      final snapshot = await _granjasCollection
          .where('ruc', isEqualTo: ruc)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return GranjaModel.fromFirestore(snapshot.docs.first);
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_GET_FARM'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  // ==================== STREAMS ====================

  /// Stream de una granja específica
  Stream<GranjaModel?> observarGranja(String id) {
    return _granjasCollection.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return GranjaModel.fromFirestore(doc);
    });
  }

  /// Stream de granjas del usuario (propias + colaborativas)
  /// Combina granjas donde es propietario + granjas donde tiene acceso
  Stream<List<GranjaModel>> observarGranjasDelUsuario(String usuarioId) {
    // Stream de granjas donde es propietario
    final granjasPropiasStream = _granjasCollection
        .where('propietarioId', isEqualTo: usuarioId)
        .snapshots();

    // Stream de granjas donde tiene acceso como colaborador
    final granjasColaborativasStream = _granjasCollection
        .where('usuariosAccesoIds', arrayContains: usuarioId)
        .snapshots();

    // Variables para almacenar los últimos valores de cada stream
    QuerySnapshot<Map<String, dynamic>>? lastPropias;
    QuerySnapshot<Map<String, dynamic>>? lastColaborativas;

    // Función para combinar los resultados
    List<GranjaModel> combineResults() {
      final granjasMap = <String, GranjaModel>{};

      // Agregar granjas propias
      if (lastPropias != null) {
        for (final doc in lastPropias!.docs) {
          final granja = GranjaModel.fromFirestore(doc);
          granjasMap[granja.id] = granja;
        }
      }

      // Agregar granjas colaborativas (no duplicar si ya existe)
      if (lastColaborativas != null) {
        for (final doc in lastColaborativas!.docs) {
          final granja = GranjaModel.fromFirestore(doc);
          if (!granjasMap.containsKey(granja.id)) {
            granjasMap[granja.id] = granja;
          }
        }
      }

      // Ordenar por fecha de creación descendente
      final granjasList = granjasMap.values.toList();
      granjasList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      return granjasList;
    }

    // Usar StreamGroup para combinar ambos streams reactivamente
    return Stream.multi((controller) {
      // Suscribirse a granjas propias
      final subPropias = granjasPropiasStream.listen((snapshot) {
        lastPropias = snapshot;
        if (lastPropias != null) {
          controller.add(combineResults());
        }
      });

      // Suscribirse a granjas colaborativas
      final subColaborativas = granjasColaborativasStream.listen((snapshot) {
        lastColaborativas = snapshot;
        if (lastPropias != null) {
          controller.add(combineResults());
        }
      });

      // Cancelar suscripciones cuando se cierre el stream
      controller.onCancel = () {
        subPropias.cancel();
        subColaborativas.cancel();
      };
    });
  }

  /// Stream de granjas activas del usuario (propias + colaborativas)
  Stream<List<GranjaModel>> observarGranjasActivas(String usuarioId) {
    // Stream de granjas activas propias
    final granjasPropiasStream = _granjasCollection
        .where('propietarioId', isEqualTo: usuarioId)
        .where('estado', isEqualTo: EstadoGranja.activo.toJson())
        .snapshots();

    // Stream de granjas activas donde tiene acceso como colaborador
    final granjasColaborativasStream = _granjasCollection
        .where('usuariosAccesoIds', arrayContains: usuarioId)
        .where('estado', isEqualTo: EstadoGranja.activo.toJson())
        .snapshots();

    // Variables para almacenar los últimos valores de cada stream
    QuerySnapshot<Map<String, dynamic>>? lastPropias;
    QuerySnapshot<Map<String, dynamic>>? lastColaborativas;

    // Función para combinar los resultados
    List<GranjaModel> combineResults() {
      final granjasMap = <String, GranjaModel>{};

      if (lastPropias != null) {
        for (final doc in lastPropias!.docs) {
          final granja = GranjaModel.fromFirestore(doc);
          granjasMap[granja.id] = granja;
        }
      }

      if (lastColaborativas != null) {
        for (final doc in lastColaborativas!.docs) {
          final granja = GranjaModel.fromFirestore(doc);
          if (!granjasMap.containsKey(granja.id)) {
            granjasMap[granja.id] = granja;
          }
        }
      }

      final granjasList = granjasMap.values.toList();
      granjasList.sort((a, b) => a.nombre.compareTo(b.nombre));
      return granjasList;
    }

    // Usar Stream.multi para combinar ambos streams reactivamente
    return Stream.multi((controller) {
      final subPropias = granjasPropiasStream.listen((snapshot) {
        lastPropias = snapshot;
        if (lastPropias != null) {
          controller.add(combineResults());
        }
      });

      final subColaborativas = granjasColaborativasStream.listen((snapshot) {
        lastColaborativas = snapshot;
        if (lastPropias != null) {
          controller.add(combineResults());
        }
      });

      controller.onCancel = () {
        subPropias.cancel();
        subColaborativas.cancel();
      };
    });
  }

  // ==================== ESTADÍSTICAS ====================

  /// Cuenta granjas del usuario
  Future<int> contarPorUsuario(String usuarioId) async {
    try {
      final snapshot = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_COUNT_FARMS'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Cuenta granjas por estado
  Future<int> contarPorEstado(String usuarioId, EstadoGranja estado) async {
    try {
      final snapshot = await _granjasCollection
          .where('propietarioId', isEqualTo: usuarioId)
          .where('estado', isEqualTo: estado.toJson())
          .count()
          .get();
      return snapshot.count ?? 0;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? ErrorMessages.get('ERR_COUNT_FARMS'));
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }
}
