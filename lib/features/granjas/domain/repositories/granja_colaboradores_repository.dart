library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/granja_usuario.dart';
import '../entities/invitacion_granja.dart';
import '../enums/rol_granja_enum.dart';

/// Repositorio para gestionar usuarios de granjas
abstract class GranjaUsuariosRepository {
  /// Obtiene todos los usuarios de una granja
  Future<Either<Failure, List<GranjaUsuario>>> obtenerUsuariosPorGranja({
    required String granjaId,
    bool soloActivos = true,
  });

  /// Obtiene el rol de un usuario en una granja específica
  Future<Either<Failure, RolGranja?>> obtenerRolUsuarioEnGranja({
    required String granjaId,
    required String usuarioId,
  });

  /// Asigna un usuario a una granja con un rol
  Future<Either<Failure, GranjaUsuario>> asignarUsuarioAGranja({
    required String granjaId,
    required String usuarioId,
    required RolGranja rol,
    String? notas,
    String? nombreCompleto,
    String? email,
  });

  /// Cambia el rol de un usuario en una granja
  Future<Either<Failure, GranjaUsuario>> cambiarRolUsuario({
    required String granjaId,
    required String usuarioId,
    required RolGranja nuevoRol,
  });

  /// Remueve un usuario de una granja (soft delete)
  Future<Either<Failure, void>> removerUsuarioDeLaGranja({
    required String granjaId,
    required String usuarioId,
  });

  /// Permite a un usuario abandonar voluntariamente una granja
  /// El propietario no puede abandonar su propia granja
  Future<Either<Failure, void>> abandonarGranja({
    required String granjaId,
    required String usuarioId,
  });

  /// Obtiene todas las granjas donde un usuario tiene acceso
  Future<Either<Failure, List<String>>> obtenerGranjasPorUsuario({
    required String usuarioId,
    bool soloActivas = true,
  });
}

/// Repositorio para invitaciones de granjas
abstract class InvitacionesGranjaRepository {
  /// Crea una nueva invitación
  Future<Either<Failure, InvitacionGranja>> crearInvitacion({
    required String granjaId,
    required String granjaNombre,
    required RolGranja rol,
    required String creadoPorId,
    required String creadoPorNombre,
    String? emailDestino,
  });

  /// Obtiene una invitación por código
  Future<Either<Failure, InvitacionGranja?>> obtenerInvitacionPorCodigo({
    required String codigo,
  });

  /// Marca una invitación como usada
  Future<Either<Failure, void>> marcarInvitacionComoUsada({
    required String invitacionId,
    required String usuarioId,
  });

  /// Obtiene invitaciones válidas de una granja
  Future<Either<Failure, List<InvitacionGranja>>> obtenerInvitacionesPorGranja({
    required String granjaId,
    bool soloValidas = true,
  });

  /// Aceptar una invitación
  Future<Either<Failure, GranjaUsuario>> aceptarInvitacion({
    required String codigo,
    required String usuarioId,
    String? nombreCompleto,
    String? email,
  });
}
