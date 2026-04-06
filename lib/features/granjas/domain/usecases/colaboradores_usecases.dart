library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/granja_usuario.dart';
import '../entities/invitacion_granja.dart';
import '../enums/rol_granja_enum.dart';
import '../repositories/granja_colaboradores_repository.dart';

// =============================================================================
// USE CASE: INVITAR USUARIO A GRANJA
// =============================================================================

class InvitarUsuarioAGranjaUseCase
    implements UseCase<InvitacionGranja, InvitarUsuarioAGranjaParams> {
  const InvitarUsuarioAGranjaUseCase(this._repository);

  final InvitacionesGranjaRepository _repository;

  @override
  Future<Either<Failure, InvitacionGranja>> call(
    InvitarUsuarioAGranjaParams params,
  ) {
    return _repository.crearInvitacion(
      granjaId: params.granjaId,
      granjaNombre: params.granjaNombre,
      rol: params.rol,
      creadoPorId: params.creadoPorId,
      creadoPorNombre: params.creadoPorNombre,
      emailDestino: params.emailDestino,
    );
  }
}

class InvitarUsuarioAGranjaParams {
  const InvitarUsuarioAGranjaParams({
    required this.granjaId,
    required this.granjaNombre,
    required this.rol,
    required this.creadoPorId,
    required this.creadoPorNombre,
    this.emailDestino,
  });

  final String granjaId;
  final String granjaNombre;
  final RolGranja rol;
  final String creadoPorId;
  final String creadoPorNombre;
  final String? emailDestino;
}

// =============================================================================
// USE CASE: ACEPTAR INVITACIÓN
// =============================================================================

class AceptarInvitacionGranjaUseCase
    implements UseCase<GranjaUsuario, AceptarInvitacionParams> {
  const AceptarInvitacionGranjaUseCase(this._repository);

  final InvitacionesGranjaRepository _repository;

  @override
  Future<Either<Failure, GranjaUsuario>> call(AceptarInvitacionParams params) {
    return _repository.aceptarInvitacion(
      codigo: params.codigo,
      usuarioId: params.usuarioId,
      nombreCompleto: params.nombreCompleto,
      email: params.email,
    );
  }
}

class AceptarInvitacionParams {
  const AceptarInvitacionParams({
    required this.codigo,
    required this.usuarioId,
    this.nombreCompleto,
    this.email,
  });

  final String codigo;
  final String usuarioId;
  final String? nombreCompleto;
  final String? email;
}

// =============================================================================
// USE CASE: LISTAR COLABORADORES
// =============================================================================

class ListarColaboradoresGranjaUseCase
    implements UseCase<List<GranjaUsuario>, ListarColaboradoresParams> {
  const ListarColaboradoresGranjaUseCase(this._repository);

  final GranjaUsuariosRepository _repository;

  @override
  Future<Either<Failure, List<GranjaUsuario>>> call(
    ListarColaboradoresParams params,
  ) {
    return _repository.obtenerUsuariosPorGranja(
      granjaId: params.granjaId,
      soloActivos: params.soloActivos,
    );
  }
}

class ListarColaboradoresParams {
  const ListarColaboradoresParams({
    required this.granjaId,
    this.soloActivos = true,
  });

  final String granjaId;
  final bool soloActivos;
}

// =============================================================================
// USE CASE: CAMBIAR ROL DE COLABORADOR
// =============================================================================

class CambiarRolColaboradorUseCase
    implements UseCase<GranjaUsuario, CambiarRolColaboradorParams> {
  const CambiarRolColaboradorUseCase(this._repository);

  final GranjaUsuariosRepository _repository;

  @override
  Future<Either<Failure, GranjaUsuario>> call(
    CambiarRolColaboradorParams params,
  ) {
    return _repository.cambiarRolUsuario(
      granjaId: params.granjaId,
      usuarioId: params.usuarioId,
      nuevoRol: params.nuevoRol,
    );
  }
}

class CambiarRolColaboradorParams {
  const CambiarRolColaboradorParams({
    required this.granjaId,
    required this.usuarioId,
    required this.nuevoRol,
  });

  final String granjaId;
  final String usuarioId;
  final RolGranja nuevoRol;
}

// =============================================================================
// USE CASE: REMOVER COLABORADOR
// =============================================================================

class RemoverColaboradorGranjaUseCase
    implements UseCase<void, RemoverColaboradorParams> {
  const RemoverColaboradorGranjaUseCase(this._repository);

  final GranjaUsuariosRepository _repository;

  @override
  Future<Either<Failure, void>> call(RemoverColaboradorParams params) {
    return _repository.removerUsuarioDeLaGranja(
      granjaId: params.granjaId,
      usuarioId: params.usuarioId,
    );
  }
}

class RemoverColaboradorParams {
  const RemoverColaboradorParams({
    required this.granjaId,
    required this.usuarioId,
  });

  final String granjaId;
  final String usuarioId;
}

// =============================================================================
// USE CASE: OBTENER ROL DE USUARIO EN GRANJA
// =============================================================================

class ObtenerRolUsuarioEnGranjaUseCase
    implements UseCase<RolGranja?, ObtenerRolUsuarioParams> {
  const ObtenerRolUsuarioEnGranjaUseCase(this._repository);

  final GranjaUsuariosRepository _repository;

  @override
  Future<Either<Failure, RolGranja?>> call(ObtenerRolUsuarioParams params) {
    return _repository.obtenerRolUsuarioEnGranja(
      granjaId: params.granjaId,
      usuarioId: params.usuarioId,
    );
  }
}

class ObtenerRolUsuarioParams {
  const ObtenerRolUsuarioParams({
    required this.granjaId,
    required this.usuarioId,
  });

  final String granjaId;
  final String usuarioId;
}

// =============================================================================
// USE CASE: OBTENER GRANJAS DEL USUARIO
// =============================================================================

class ObtenerGranjaIdsDelUsuarioUseCase
    implements UseCase<List<String>, ObtenerGranjaIdsDelUsuarioParams> {
  const ObtenerGranjaIdsDelUsuarioUseCase(this._repository);

  final GranjaUsuariosRepository _repository;

  @override
  Future<Either<Failure, List<String>>> call(
    ObtenerGranjaIdsDelUsuarioParams params,
  ) {
    return _repository.obtenerGranjasPorUsuario(
      usuarioId: params.usuarioId,
      soloActivas: params.soloActivas,
    );
  }
}

class ObtenerGranjaIdsDelUsuarioParams {
  const ObtenerGranjaIdsDelUsuarioParams({
    required this.usuarioId,
    this.soloActivas = true,
  });

  final String usuarioId;
  final bool soloActivas;
}
