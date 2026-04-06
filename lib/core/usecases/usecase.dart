library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';
import '../types/type_definitions.dart';

/// Clase base para casos de uso
abstract class UseCase<T, Params> {
  FutureResult<T> call(Params params);
}

/// Clase base para casos de uso sin parámetros
abstract class UseCaseNoParams<T> {
  FutureResult<T> call();
}

/// Clase para casos de uso sin parámetros
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Clase base para casos de uso con stream
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Clase base para casos de uso sync
abstract class SyncUseCase<T, Params> {
  Result<T> call(Params params);
}

/// Clase base para casos de uso sync sin parámetros
abstract class SyncUseCaseNoParams<T> {
  Result<T> call();
}
