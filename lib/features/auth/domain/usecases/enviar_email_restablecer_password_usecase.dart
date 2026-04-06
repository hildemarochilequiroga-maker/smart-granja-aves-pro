library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Caso de uso para enviar email de restablecimiento de contraseña
class EnviarEmailRestablecerPasswordUseCase
    implements UseCase<void, EnviarEmailRestablecerPasswordParams> {
  const EnviarEmailRestablecerPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(
    EnviarEmailRestablecerPasswordParams params,
  ) async {
    return _repository.enviarEmailRestablecerPassword(email: params.email);
  }
}

/// Parámetros para enviar email de restablecimiento
class EnviarEmailRestablecerPasswordParams extends Equatable {
  const EnviarEmailRestablecerPasswordParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
