library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión con email y contraseña
class LoginConEmailUseCase implements UseCase<Usuario, LoginConEmailParams> {
  const LoginConEmailUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Usuario>> call(LoginConEmailParams params) async {
    return _repository.loginConEmail(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parámetros para el login con email
class LoginConEmailParams extends Equatable {
  const LoginConEmailParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
