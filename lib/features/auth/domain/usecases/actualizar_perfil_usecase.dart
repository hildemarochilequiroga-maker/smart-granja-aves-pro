library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para actualizar el perfil del usuario
class ActualizarPerfilUseCase
    implements UseCase<Usuario, ActualizarPerfilParams> {
  const ActualizarPerfilUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Usuario>> call(ActualizarPerfilParams params) async {
    return _repository.actualizarPerfil(
      nombre: params.nombre,
      apellido: params.apellido,
      telefono: params.telefono,
      fotoUrl: params.fotoUrl,
    );
  }
}

/// Parámetros para actualizar perfil
class ActualizarPerfilParams extends Equatable {
  const ActualizarPerfilParams({
    this.nombre,
    this.apellido,
    this.telefono,
    this.fotoUrl,
  });

  final String? nombre;
  final String? apellido;
  final String? telefono;
  final String? fotoUrl;

  @override
  List<Object?> get props => [nombre, apellido, telefono, fotoUrl];
}
