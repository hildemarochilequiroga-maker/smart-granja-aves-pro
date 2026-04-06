library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/errors/exceptions.dart';
import '../../domain/enums/rol_granja_enum.dart';
import '../models/granja_usuario_model.dart';
import '../models/invitacion_granja_model.dart';

/// Datasource de Firebase para gestionar usuarios de granjas
class GranjaUsuariosFirebaseDatasource {
  GranjaUsuariosFirebaseDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _granjasUsariosCollection =>
      _firestore.collection('granja_usuarios');

  CollectionReference<Map<String, dynamic>> get _invitacionesCollection =>
      _firestore.collection('invitaciones_granja');

  CollectionReference<Map<String, dynamic>> get _granjasCollection =>
      _firestore.collection('granjas');

  // ===========================================================================
  // USUARIOS DE GRANJA
  // ===========================================================================

  /// Obtiene todos los usuarios de una granja
  Future<List<GranjaUsuarioModel>> obtenerUsuariosPorGranja({
    required String granjaId,
    bool soloActivos = true,
  }) async {
    debugPrint(
      '📋 [GranjaUsuariosDatasource] obtenerUsuariosPorGranja iniciado',
    );
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ soloActivos: $soloActivos');
    try {
      var query = _granjasUsariosCollection.where(
        'granjaId',
        isEqualTo: granjaId,
      );

      if (soloActivos) {
        query = query.where('activo', isEqualTo: true);
      }

      final snapshot = await query.get();
      final usuarios = snapshot.docs
          .map((doc) => GranjaUsuarioModel.fromFirestore(doc))
          .toList();

      debugPrint(
        '✅ [GranjaUsuariosDatasource] Usuarios obtenidos: ${usuarios.length}',
      );
      for (final u in usuarios) {
        debugPrint(
          '   ├─ Usuario: ${u.usuarioId.substring(0, 8)}... - Rol: ${u.rol.name}',
        );
      }
      return usuarios;
    } on Exception catch (e) {
      debugPrint(
        '❌ [GranjaUsuariosDatasource] Error obtenerUsuariosPorGranja: $e',
      );
      throw UnknownException(
        message: ErrorMessages.get('ERR_GET_FARM_USERS'),
        details: e.toString(),
      );
    }
  }

  /// Obtiene el rol de un usuario en una granja
  /// Retorna null si el usuario no es miembro o si no tiene acceso para leer
  Future<RolGranja?> obtenerRolUsuarioEnGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    debugPrint('🔍 [GranjaUsuariosDatasource] obtenerRolUsuarioEnGranja');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ usuarioId: ${usuarioId.substring(0, 8)}...');
    try {
      final docId = '${granjaId}_$usuarioId';
      debugPrint('   ├─ Buscando documento: $docId');
      final doc = await _granjasUsariosCollection.doc(docId).get();

      if (!doc.exists) {
        debugPrint('⚠️ [GranjaUsuariosDatasource] Documento no existe');
        return null;
      }

      final data = doc.data()!;

      // Verificar que esté activo
      final activo = data['activo'] as bool? ?? false;
      if (!activo) {
        debugPrint('⚠️ [GranjaUsuariosDatasource] Usuario inactivo en granja');
        return null;
      }

      final rol = RolGranja.fromString(data['rol'] as String? ?? 'viewer');
      debugPrint('✅ [GranjaUsuariosDatasource] Rol encontrado: ${rol.name}');
      return rol;
    } on Exception catch (e) {
      // Si hay error de permisos (usuario no es miembro), retornar null
      // Esto es esperado cuando se verifica membresía antes de aceptar invitación
      debugPrint(
        '⚠️ [GranjaUsuariosDatasource] obtenerRolUsuarioEnGranja error: $e',
      );
      return null;
    }
  }

  /// Asigna un usuario a una granja con un rol
  Future<GranjaUsuarioModel> asignarUsuarioAGranja({
    required String granjaId,
    required String usuarioId,
    required RolGranja rol,
    String? notas,
    String? nombreCompleto,
    String? email,
  }) async {
    debugPrint('➕ [GranjaUsuariosDatasource] asignarUsuarioAGranja iniciado');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   ├─ usuarioId: ${usuarioId.substring(0, 8)}...');
    debugPrint('   ├─ rol: ${rol.name}');
    debugPrint('   └─ notas: ${notas ?? "sin notas"}');
    try {
      final docId = '${granjaId}_$usuarioId';
      final model = GranjaUsuarioModel(
        id: docId,
        granjaId: granjaId,
        usuarioId: usuarioId,
        rol: rol,
        fechaAsignacion: DateTime.now(),
        activo: true,
        notas: notas,
        nombreCompleto: nombreCompleto,
        email: email,
      );

      debugPrint('   ├─ Guardando documento: $docId');
      await _granjasUsariosCollection.doc(docId).set(model.toFirestore());
      debugPrint('   ├─ Documento guardado correctamente');

      // Actualizar usuariosAccesoIds en granja
      await _agregarUsuarioAGranjaAcceso(granjaId, usuarioId);
      debugPrint('✅ [GranjaUsuariosDatasource] Usuario asignado exitosamente');

      return model;
    } on Exception catch (e) {
      debugPrint(
        '❌ [GranjaUsuariosDatasource] Error asignarUsuarioAGranja: $e',
      );
      throw UnknownException(
        message: ErrorMessages.get('ERR_ASSIGN_USER'),
        details: e.toString(),
      );
    }
  }

  /// Cambia el rol de un usuario en una granja
  Future<GranjaUsuarioModel> cambiarRolUsuario({
    required String granjaId,
    required String usuarioId,
    required RolGranja nuevoRol,
  }) async {
    debugPrint('🔄 [GranjaUsuariosDatasource] cambiarRolUsuario iniciado');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   ├─ usuarioId: ${usuarioId.substring(0, 8)}...');
    debugPrint('   └─ nuevoRol: ${nuevoRol.name}');
    try {
      final docId = '${granjaId}_$usuarioId';
      final doc = await _granjasUsariosCollection.doc(docId).get();

      if (!doc.exists) {
        debugPrint(
          '❌ [GranjaUsuariosDatasource] Usuario no encontrado en granja',
        );
        throw UnknownException(
          message: ErrorMessages.get('ERR_USER_NOT_FOUND_IN_FARM'),
          details: ErrorMessages.get('ERR_USER_NOT_FOUND_IN_FARM'),
        );
      }

      final model = GranjaUsuarioModel.fromFirestore(doc);
      debugPrint('   ├─ Rol anterior: ${model.rol.name}');

      await _granjasUsariosCollection.doc(docId).update({'rol': nuevoRol.name});
      debugPrint(
        '✅ [GranjaUsuariosDatasource] Rol actualizado: ${model.rol.name} → ${nuevoRol.name}',
      );

      final actualizado = GranjaUsuarioModel.fromEntity(
        model.copyWith(rol: nuevoRol),
      );
      return actualizado;
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosDatasource] Error cambiarRolUsuario: $e');
      throw UnknownException(
        message: ErrorMessages.get('ERR_CHANGE_ROLE'),
        details: e.toString(),
      );
    }
  }

  /// Remueve un usuario de una granja (soft delete)
  /// Realiza limpieza completa: desactiva acceso, remueve de array de accesos,
  /// e invalida invitaciones pendientes creadas por este usuario.
  Future<void> removerUsuarioDeLaGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    try {
      final docId = '${granjaId}_$usuarioId';
      final batch = _firestore.batch();

      // 1. Marcar como inactivo en granja_usuarios
      final usuarioRef = _granjasUsariosCollection.doc(docId);
      batch.update(usuarioRef, {
        'activo': false,
        'fechaRemovido': FieldValue.serverTimestamp(),
      });

      // 2. Remover de usuariosAccesoIds en la granja
      final granjaRef = _granjasCollection.doc(granjaId);
      batch.update(granjaRef, {
        'usuariosAccesoIds': FieldValue.arrayRemove([usuarioId]),
      });

      // Ejecutar batch
      await batch.commit();

      // 3. Invalidar invitaciones pendientes creadas por este usuario
      // (se hace fuera del batch porque requiere query)
      await _invalidarInvitacionesPendientes(granjaId, usuarioId);

      debugPrint(
        '✅ Usuario $usuarioId removido de granja $granjaId correctamente',
      );
    } on Exception catch (e) {
      debugPrint('❌ Error al remover usuario: $e');
      throw UnknownException(
        message: ErrorMessages.get('ERR_REMOVE_USER'),
        details: e.toString(),
      );
    }
  }

  /// Invalida las invitaciones pendientes creadas por un usuario en una granja
  /// Simplificada para evitar queries compuestas complejas
  Future<void> _invalidarInvitacionesPendientes(
    String granjaId,
    String creadoPorId,
  ) async {
    try {
      final ahora = DateTime.now();

      // Query simplificada: solo granjaId y creadoPorId (2 campos igualdad)
      // El resto se filtra en código
      final invitacionesQuery = await _invitacionesCollection
          .where('granjaId', isEqualTo: granjaId)
          .where('creadoPorId', isEqualTo: creadoPorId)
          .get();

      if (invitacionesQuery.docs.isEmpty) return;

      // Filtrar localmente las que aún son válidas
      final invitacionesValidas = invitacionesQuery.docs.where((doc) {
        final data = doc.data();
        final usado = data['usado'] as bool? ?? true;
        final fechaExp = (data['fechaExpiracion'] as Timestamp?)?.toDate();
        return !usado && fechaExp != null && fechaExp.isAfter(ahora);
      }).toList();

      if (invitacionesValidas.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in invitacionesValidas) {
        // Marcar como expirada (fecha en el pasado)
        batch.update(doc.reference, {
          'fechaExpiracion': Timestamp.fromDate(
            ahora.subtract(const Duration(days: 1)),
          ),
        });
      }
      await batch.commit();

      debugPrint(
        '✅ Invalidadas ${invitacionesValidas.length} invitaciones pendientes',
      );
    } on Exception catch (e) {
      // No es crítico, solo log
      debugPrint('⚠️ No se pudieron invalidar invitaciones: $e');
    }
  }

  /// Permite a un usuario abandonar voluntariamente una granja
  /// El propietario no puede abandonar su propia granja.
  Future<void> abandonarGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    try {
      // Verificar que no sea el propietario
      final granjaDoc = await _granjasCollection.doc(granjaId).get();
      if (!granjaDoc.exists) {
        throw UnknownException(
          message: ErrorMessages.get('ERR_FARM_NOT_FOUND'),
          details: ErrorMessages.get('ERR_FARM_NOT_EXISTS'),
        );
      }

      final granjaData = granjaDoc.data()!;
      if (granjaData['propietarioId'] == usuarioId) {
        throw UnknownException(
          message: ErrorMessages.get('ERR_OWNER_CANNOT_LEAVE'),
          details: ErrorMessages.get('ERR_TRANSFER_OR_DELETE'),
        );
      }

      // Usar el método de remover que ya hace toda la limpieza
      await removerUsuarioDeLaGranja(granjaId: granjaId, usuarioId: usuarioId);

      debugPrint('✅ Usuario $usuarioId abandonó granja $granjaId');
    } on Exception catch (e) {
      if (e is UnknownException) rethrow;
      throw UnknownException(
        message: ErrorMessages.get('ERR_LEAVE_FARM'),
        details: e.toString(),
      );
    }
  }

  /// Obtiene todas las granjas donde un usuario tiene acceso
  Future<List<String>> obtenerGranjasPorUsuario({
    required String usuarioId,
    bool soloActivas = true,
  }) async {
    try {
      var query = _granjasUsariosCollection.where(
        'usuarioId',
        isEqualTo: usuarioId,
      );

      if (soloActivas) {
        query = query.where('activo', isEqualTo: true);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc['granjaId'] as String).toList();
    } on Exception catch (e) {
      throw UnknownException(
        message: ErrorMessages.get('ERR_GET_USER_FARMS'),
        details: e.toString(),
      );
    }
  }

  // ===========================================================================
  // INVITACIONES
  // ===========================================================================

  /// Crea una nueva invitación
  Future<InvitacionGranjaModel> crearInvitacion({
    required String granjaId,
    required String granjaNombre,
    required RolGranja rol,
    required String creadoPorId,
    required String creadoPorNombre,
    String? emailDestino,
  }) async {
    debugPrint('📨 [GranjaUsuariosDatasource] crearInvitacion iniciado');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   ├─ granjaNombre: $granjaNombre');
    debugPrint('   ├─ rol: ${rol.name}');
    debugPrint('   ├─ creadoPorId: ${creadoPorId.substring(0, 8)}...');
    debugPrint('   ├─ creadoPorNombre: $creadoPorNombre');
    debugPrint('   └─ emailDestino: ${emailDestino ?? "sin email"}');
    try {
      final codigo = _generarCodigoInvitacion();
      final ahora = DateTime.now();
      final expiracion = ahora.add(const Duration(days: 30));

      debugPrint('   ├─ Código generado: $codigo');
      debugPrint('   ├─ Expira: $expiracion');

      final model = InvitacionGranjaModel(
        id: const Uuid().v4(),
        codigo: codigo,
        granjaId: granjaId,
        granjaNombre: granjaNombre,
        creadoPorId: creadoPorId,
        creadoPorNombre: creadoPorNombre,
        rol: rol,
        fechaCreacion: ahora,
        fechaExpiracion: expiracion,
        emailDestino: emailDestino,
      );

      await _invitacionesCollection.doc(model.id).set(model.toFirestore());
      debugPrint('✅ [GranjaUsuariosDatasource] Invitación creada: ${model.id}');

      return model;
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosDatasource] Error crearInvitacion: $e');
      throw UnknownException(
        message: ErrorMessages.get('ERR_CREATE_INVITATION'),
        details: e.toString(),
      );
    }
  }

  /// Obtiene una invitación por código
  Future<InvitacionGranjaModel?> obtenerInvitacionPorCodigo({
    required String codigo,
  }) async {
    debugPrint('🔍 [GranjaUsuariosDatasource] obtenerInvitacionPorCodigo');
    debugPrint('   └─ código: $codigo');
    try {
      final query = await _invitacionesCollection
          .where('codigo', isEqualTo: codigo)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        debugPrint('⚠️ [GranjaUsuariosDatasource] Invitación no encontrada');
        return null;
      }

      final invitacion = InvitacionGranjaModel.fromFirestore(query.docs.first);
      debugPrint('✅ [GranjaUsuariosDatasource] Invitación encontrada:');
      debugPrint('   ├─ id: ${invitacion.id}');
      debugPrint('   ├─ granjaNombre: ${invitacion.granjaNombre}');
      debugPrint('   ├─ rol: ${invitacion.rol.name}');
      debugPrint('   ├─ esValida: ${invitacion.esValida}');
      debugPrint('   └─ usado: ${invitacion.usado}');
      return invitacion;
    } on Exception catch (e) {
      debugPrint(
        '❌ [GranjaUsuariosDatasource] Error obtenerInvitacionPorCodigo: $e',
      );
      throw UnknownException(details: e.toString());
    }
  }

  /// Marca una invitación como usada
  Future<void> marcarInvitacionComoUsada({
    required String invitacionId,
    required String usuarioId,
  }) async {
    debugPrint('✅ [GranjaUsuariosDatasource] marcarInvitacionComoUsada');
    debugPrint('   ├─ invitacionId: $invitacionId');
    debugPrint('   └─ usuarioId: ${usuarioId.substring(0, 8)}...');
    try {
      await _invitacionesCollection.doc(invitacionId).update({
        'usado': true,
        'usadoPorId': usuarioId,
        'usadoEn': FieldValue.serverTimestamp(),
      });
      debugPrint('✅ [GranjaUsuariosDatasource] Invitación marcada como usada');
    } on Exception catch (e) {
      debugPrint(
        '❌ [GranjaUsuariosDatasource] Error marcarInvitacionComoUsada: $e',
      );
      throw UnknownException(
        message: ErrorMessages.get('ERR_MARK_INVITATION_USED'),
        details: e.toString(),
      );
    }
  }

  /// Obtiene invitaciones válidas de una granja
  Future<List<InvitacionGranjaModel>> obtenerInvitacionesPorGranja({
    required String granjaId,
    bool soloValidas = true,
  }) async {
    try {
      final query = _invitacionesCollection.where(
        'granjaId',
        isEqualTo: granjaId,
      );

      final snapshot = await query.get();
      var invitaciones = snapshot.docs
          .map((doc) => InvitacionGranjaModel.fromFirestore(doc))
          .toList();

      if (soloValidas) {
        invitaciones = invitaciones.where((inv) => inv.esValida).toList();
      }

      return invitaciones;
    } on Exception catch (e) {
      throw UnknownException(
        message: ErrorMessages.get('ERR_GET_INVITATIONS'),
        details: e.toString(),
      );
    }
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS
  // ===========================================================================

  /// Genera un código único y aleatorio para la invitación
  String _generarCodigoInvitacion() {
    final uuid = const Uuid().v4().replaceAll('-', '').toUpperCase();

    // Usar parte del UUID para generar código más aleatorio
    final part1 = uuid.substring(0, 6);
    final part2 = uuid.substring(6, 12);

    return 'GRANJA-$part1-$part2';
  }

  /// Agrega usuario a la lista de acceso de granja
  Future<void> _agregarUsuarioAGranjaAcceso(
    String granjaId,
    String usuarioId,
  ) async {
    try {
      await _granjasCollection.doc(granjaId).update({
        'usuariosAccesoIds': FieldValue.arrayUnion([usuarioId]),
      });
    } on Exception catch (e) {
      // No es crítico, el acceso se verifica principalmente por granja_usuarios
      // El campo usuariosAccesoIds es para optimización de queries
      debugPrint('⚠️ No se pudo actualizar usuariosAccesoIds: $e');
    }
  }
}
