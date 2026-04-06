library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para obtener el usuario actual
class ObtenerUsuarioActualUseCase implements UseCaseNoParams<Usuario?> {
  const ObtenerUsuarioActualUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, Usuario?>> call() async {
    return _repository.obtenerUsuarioActual();
  }
}
