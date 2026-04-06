library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para verificar si hay una sesión activa
class VerificarSesionActivaUseCase implements UseCaseNoParams<bool> {
  const VerificarSesionActivaUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call() async {
    return _repository.verificarSesionActiva();
  }
}
