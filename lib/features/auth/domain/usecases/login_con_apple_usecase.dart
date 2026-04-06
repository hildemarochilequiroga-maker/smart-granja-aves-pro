library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión con Apple
class LoginConAppleUseCase implements UseCaseNoParams<Usuario> {
  const LoginConAppleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Usuario>> call() async {
    return _repository.loginConApple();
  }
}
