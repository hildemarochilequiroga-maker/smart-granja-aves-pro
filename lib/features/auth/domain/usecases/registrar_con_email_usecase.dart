library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para registrar un nuevo usuario con email
class RegistrarConEmailUseCase
    implements UseCase<Usuario, RegistrarConEmailParams> {
  const RegistrarConEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Usuario>> call(RegistrarConEmailParams params) async {
    return _repository.registrarConEmail(
      email: params.email,
      password: params.password,
      nombre: params.nombre,
      apellido: params.apellido,
    );
  }
}

/// Parámetros para el registro con email
class RegistrarConEmailParams extends Equatable {
  const RegistrarConEmailParams({
    required this.email,
    required this.password,
    this.nombre,
    this.apellido,
  });

  final String email;
  final String password;
  final String? nombre;
  final String? apellido;

  @override
  List<Object?> get props => [email, password, nombre, apellido];
}
