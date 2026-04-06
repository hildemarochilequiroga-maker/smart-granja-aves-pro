library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';

/// Use Case para suspender una granja
class SuspenderGranjaUseCase implements UseCase<Granja, SuspenderGranjaParams> {
  SuspenderGranjaUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, Granja>> call(SuspenderGranjaParams params) async {
    try {
      final result = await repository.obtenerPorId(params.granjaId);

      return await result.fold((failure) => Left(failure), (granja) async {
        if (granja == null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_NO_ENCONTRADA'),
              code: 'GRANJA_NO_ENCONTRADA',
            ),
          );
        }

        final granjaSuspendida = granja.suspender(razon: params.razon);
        return repository.actualizar(granjaSuspendida);
      });
    } on GranjaException catch (e) {
      return Left(
        ValidationFailure(message: e.mensaje, code: 'GRANJA_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_SUSPENDER_GRANJA')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para suspender una granja
class SuspenderGranjaParams extends Equatable {
  const SuspenderGranjaParams({required this.granjaId, this.razon});

  final String granjaId;
  final String? razon;

  @override
  List<Object?> get props => [granjaId, razon];
}
