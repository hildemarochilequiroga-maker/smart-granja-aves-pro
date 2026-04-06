library;

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/granja_usuario.dart';
import '../../domain/entities/invitacion_granja.dart';
import '../../domain/enums/rol_granja_enum.dart';
import '../../domain/repositories/granja_colaboradores_repository.dart';
import '../datasources/granja_usuarios_firebase_datasource.dart';

/// Implementación del repositorio de usuarios de granjas
class GranjaUsuariosRepositoryImpl implements GranjaUsuariosRepository {
  GranjaUsuariosRepositoryImpl({
    required GranjaUsuariosFirebaseDatasource datasource,
    NetworkInfo? networkInfo,
  }) : _datasource = datasource,
       _networkInfo = networkInfo ?? NetworkInfo();

  final GranjaUsuariosFirebaseDatasource _datasource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<GranjaUsuario>>> obtenerUsuariosPorGranja({
    required String granjaId,
    bool soloActivos = true,
  }) async {
    debugPrint('📚 [GranjaUsuariosRepo] obtenerUsuariosPorGranja');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ soloActivos: $soloActivos');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [GranjaUsuariosRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuarios = await _datasource.obtenerUsuariosPorGranja(
        granjaId: granjaId,
        soloActivos: soloActivos,
      );
      debugPrint(
        '✅ [GranjaUsuariosRepo] ${usuarios.length} usuarios obtenidos',
      );
      return Right(usuarios);
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RolGranja?>> obtenerRolUsuarioEnGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final rol = await _datasource.obtenerRolUsuarioEnGranja(
        granjaId: granjaId,
        usuarioId: usuarioId,
      );
      return Right(rol);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GranjaUsuario>> asignarUsuarioAGranja({
    required String granjaId,
    required String usuarioId,
    required RolGranja rol,
    String? notas,
    String? nombreCompleto,
    String? email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _datasource.asignarUsuarioAGranja(
        granjaId: granjaId,
        usuarioId: usuarioId,
        rol: rol,
        notas: notas,
        nombreCompleto: nombreCompleto,
        email: email,
      );
      return Right(usuario);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GranjaUsuario>> cambiarRolUsuario({
    required String granjaId,
    required String usuarioId,
    required RolGranja nuevoRol,
  }) async {
    debugPrint('🔄 [GranjaUsuariosRepo] cambiarRolUsuario');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   ├─ usuarioId: ${usuarioId.substring(0, 8)}...');
    debugPrint('   └─ nuevoRol: ${nuevoRol.name}');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [GranjaUsuariosRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final usuario = await _datasource.cambiarRolUsuario(
        granjaId: granjaId,
        usuarioId: usuarioId,
        nuevoRol: nuevoRol,
      );
      debugPrint('✅ [GranjaUsuariosRepo] Rol cambiado exitosamente');
      return Right(usuario);
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removerUsuarioDeLaGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    debugPrint('🗑️ [GranjaUsuariosRepo] removerUsuarioDeLaGranja');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ usuarioId: ${usuarioId.substring(0, 8)}...');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [GranjaUsuariosRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _datasource.removerUsuarioDeLaGranja(
        granjaId: granjaId,
        usuarioId: usuarioId,
      );
      debugPrint('✅ [GranjaUsuariosRepo] Usuario removido exitosamente');
      return const Right(null);
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> abandonarGranja({
    required String granjaId,
    required String usuarioId,
  }) async {
    debugPrint('🚪 [GranjaUsuariosRepo] abandonarGranja');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   └─ usuarioId: ${usuarioId.substring(0, 8)}...');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [GranjaUsuariosRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _datasource.abandonarGranja(
        granjaId: granjaId,
        usuarioId: usuarioId,
      );
      debugPrint('✅ [GranjaUsuariosRepo] Usuario abandonó la granja');
      return const Right(null);
    } on Exception catch (e) {
      debugPrint('❌ [GranjaUsuariosRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> obtenerGranjasPorUsuario({
    required String usuarioId,
    bool soloActivas = true,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final granjas = await _datasource.obtenerGranjasPorUsuario(
        usuarioId: usuarioId,
        soloActivas: soloActivas,
      );
      return Right(granjas);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}

/// Implementación del repositorio de invitaciones
class InvitacionesGranjaRepositoryImpl implements InvitacionesGranjaRepository {
  InvitacionesGranjaRepositoryImpl({
    required GranjaUsuariosFirebaseDatasource datasource,
    NetworkInfo? networkInfo,
  }) : _datasource = datasource,
       _networkInfo = networkInfo ?? NetworkInfo();

  final GranjaUsuariosFirebaseDatasource _datasource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, InvitacionGranja>> crearInvitacion({
    required String granjaId,
    required String granjaNombre,
    required RolGranja rol,
    required String creadoPorId,
    required String creadoPorNombre,
    String? emailDestino,
  }) async {
    debugPrint('📨 [InvitacionesRepo] crearInvitacion');
    debugPrint('   ├─ granjaId: $granjaId');
    debugPrint('   ├─ granjaNombre: $granjaNombre');
    debugPrint('   ├─ rol: ${rol.name}');
    debugPrint('   ├─ creadoPorId: ${creadoPorId.substring(0, 8)}...');
    debugPrint('   └─ emailDestino: ${emailDestino ?? "ninguno"}');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [InvitacionesRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    // No se puede invitar con rol owner
    if (rol == RolGranja.owner) {
      debugPrint('❌ [InvitacionesRepo] No se puede invitar con rol owner');
      return Left(
        ServerFailure(message: ErrorMessages.get('ERR_CANNOT_INVITE_OWNER')),
      );
    }

    try {
      // Verificar que el creador tiene permiso para invitar
      debugPrint('   ├─ Verificando permisos del creador...');
      final rolCreador = await _datasource.obtenerRolUsuarioEnGranja(
        granjaId: granjaId,
        usuarioId: creadoPorId,
      );

      if (rolCreador == null || !rolCreador.canInviteUsers) {
        debugPrint('❌ [InvitacionesRepo] Usuario sin permisos para invitar');
        return Left(
          ServerFailure(
            message: ErrorMessages.get('ERR_NO_INVITE_PERMISSION'),
          ),
        );
      }
      debugPrint('   ├─ Permisos verificados: ${rolCreador.name}');

      final invitacion = await _datasource.crearInvitacion(
        granjaId: granjaId,
        granjaNombre: granjaNombre,
        rol: rol,
        creadoPorId: creadoPorId,
        creadoPorNombre: creadoPorNombre,
        emailDestino: emailDestino,
      );
      debugPrint(
        '✅ [InvitacionesRepo] Invitación creada: ${invitacion.codigo}',
      );
      return Right(invitacion);
    } on Exception catch (e) {
      debugPrint('❌ [InvitacionesRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, InvitacionGranja?>> obtenerInvitacionPorCodigo({
    required String codigo,
  }) async {
    debugPrint('🔍 [InvitacionesRepo] obtenerInvitacionPorCodigo');
    debugPrint('   └─ codigo: $codigo');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [InvitacionesRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final invitacion = await _datasource.obtenerInvitacionPorCodigo(
        codigo: codigo,
      );
      if (invitacion != null) {
        debugPrint('✅ [InvitacionesRepo] Invitación encontrada');
        debugPrint('   ├─ granjaNombre: ${invitacion.granjaNombre}');
        debugPrint('   ├─ rol: ${invitacion.rol.name}');
        debugPrint('   └─ esValida: ${invitacion.esValida}');
      } else {
        debugPrint('⚠️ [InvitacionesRepo] Invitación no encontrada');
      }
      return Right(invitacion);
    } on Exception catch (e) {
      debugPrint('❌ [InvitacionesRepo] Error: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> marcarInvitacionComoUsada({
    required String invitacionId,
    required String usuarioId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      await _datasource.marcarInvitacionComoUsada(
        invitacionId: invitacionId,
        usuarioId: usuarioId,
      );
      return const Right(null);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<InvitacionGranja>>> obtenerInvitacionesPorGranja({
    required String granjaId,
    bool soloValidas = true,
  }) async {
    if (!await _networkInfo.isConnected) {
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      final invitaciones = await _datasource.obtenerInvitacionesPorGranja(
        granjaId: granjaId,
        soloValidas: soloValidas,
      );
      return Right(invitaciones);
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GranjaUsuario>> aceptarInvitacion({
    required String codigo,
    required String usuarioId,
    String? nombreCompleto,
    String? email,
  }) async {
    debugPrint('✅ [InvitacionesRepo] aceptarInvitacion');
    debugPrint('   ├─ codigo: $codigo');
    debugPrint('   └─ usuarioId: ${usuarioId.substring(0, 8)}...');

    if (!await _networkInfo.isConnected) {
      debugPrint('❌ [InvitacionesRepo] Sin conexión a internet');
      return Left(NetworkFailure(message: ErrorMessages.get('ERR_NO_CONNECTION')));
    }

    try {
      // Obtener invitación
      debugPrint('   ├─ Buscando invitación...');
      final invitacionResult = await obtenerInvitacionPorCodigo(codigo: codigo);

      return await invitacionResult.fold(
        (failure) {
          debugPrint(
            '❌ [InvitacionesRepo] Error obteniendo invitación: ${failure.message}',
          );
          return Left(failure);
        },
        (invitacion) async {
          if (invitacion == null) {
            debugPrint('❌ [InvitacionesRepo] Invitación no encontrada');
            return Left(
              ServerFailure(message: ErrorMessages.get('ERR_INVITATION_NOT_FOUND')),
            );
          }

          debugPrint('   ├─ Invitación encontrada:');
          debugPrint('   │  ├─ granjaNombre: ${invitacion.granjaNombre}');
          debugPrint('   │  ├─ rol: ${invitacion.rol.name}');
          debugPrint('   │  └─ esValida: ${invitacion.esValida}');

          if (!invitacion.esValida) {
            debugPrint('❌ [InvitacionesRepo] Invitación no válida o expirada');
            return Left(
              ServerFailure(message: ErrorMessages.get('ERR_INVITATION_INVALID')),
            );
          }

          // Verificar si el usuario ya es miembro de la granja
          debugPrint('   ├─ Verificando si usuario ya es miembro...');
          final rolExistente = await _datasource.obtenerRolUsuarioEnGranja(
            granjaId: invitacion.granjaId,
            usuarioId: usuarioId,
          );

          if (rolExistente != null) {
            debugPrint(
              '❌ [InvitacionesRepo] Usuario ya es miembro (rol: ${rolExistente.name})',
            );
            return Left(
              ServerFailure(message: ErrorMessages.get('ERR_ALREADY_MEMBER')),
            );
          }
          debugPrint('   ├─ Usuario no es miembro aún');

          // Verificar que no sea el propietario intentando unirse
          if (invitacion.creadoPorId == usuarioId) {
            debugPrint(
              '❌ [InvitacionesRepo] Usuario intentó aceptar su propia invitación',
            );
            return Left(
              ServerFailure(message: ErrorMessages.get('ERR_CANNOT_ACCEPT_OWN')),
            );
          }

          // Asignar usuario a granja
          try {
            debugPrint('   ├─ Asignando usuario a granja...');
            final usuario = await _datasource.asignarUsuarioAGranja(
              granjaId: invitacion.granjaId,
              usuarioId: usuarioId,
              rol: invitacion.rol,
              nombreCompleto: nombreCompleto,
              email: email,
            );
            debugPrint('   ├─ Usuario asignado exitosamente');

            // Marcar invitación como usada
            debugPrint('   ├─ Marcando invitación como usada...');
            await _datasource.marcarInvitacionComoUsada(
              invitacionId: invitacion.id,
              usuarioId: usuarioId,
            );
            debugPrint('   ├─ Invitación marcada como usada');

            // Convertir modelo a entidad
            final usuarioEntidad = GranjaUsuario(
              id: usuario.id,
              granjaId: usuario.granjaId,
              usuarioId: usuario.usuarioId,
              rol: usuario.rol,
              fechaAsignacion: usuario.fechaAsignacion,
              fechaExpiracion: usuario.fechaExpiracion,
              activo: usuario.activo,
              notas: usuario.notas,
              nombreCompleto: usuario.nombreCompleto,
              email: usuario.email,
            );

            debugPrint(
              '✅ [InvitacionesRepo] Usuario unido exitosamente a ${invitacion.granjaNombre}',
            );
            return Right(usuarioEntidad);
          } on Exception catch (e) {
            debugPrint('❌ [InvitacionesRepo] Error asignando usuario: $e');
            return Left(ServerFailure(message: ErrorMessages.format('ERR_GENERIC_PREFIX', {'e': '$e'})));
          }
        },
      );
    } on Exception catch (e) {
      debugPrint('❌ [InvitacionesRepo] Error general: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
