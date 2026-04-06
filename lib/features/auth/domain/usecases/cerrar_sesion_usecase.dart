library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para cerrar sesión
class CerrarSesionUseCase implements UseCaseNoParams<void> {
  const CerrarSesionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call() async {
    return _repository.cerrarSesion();
  }
}
