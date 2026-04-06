library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para cambiar la contraseña del usuario
class CambiarPasswordUseCase implements UseCase<void, CambiarPasswordParams> {
  const CambiarPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(CambiarPasswordParams params) async {
    return _repository.cambiarPassword(
      passwordActual: params.passwordActual,
      passwordNuevo: params.passwordNuevo,
    );
  }
}

/// Parámetros para cambiar contraseña
class CambiarPasswordParams extends Equatable {
  const CambiarPasswordParams({
    required this.passwordActual,
    required this.passwordNuevo,
  });

  final String passwordActual;
  final String passwordNuevo;

  @override
  List<Object?> get props => [passwordActual, passwordNuevo];
}
