library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';

/// Use Case para activar una granja
class ActivarGranjaUseCase implements UseCase<Granja, String> {
  ActivarGranjaUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, Granja>> call(String granjaId) async {
    try {
      final result = await repository.obtenerPorId(granjaId);

      return await result.fold((failure) => Left(failure), (granja) async {
        if (granja == null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_NO_ENCONTRADA'),
              code: 'GRANJA_NO_ENCONTRADA',
            ),
          );
        }

        final granjaActivada = granja.activar();
        return repository.actualizar(granjaActivada);
      });
    } on GranjaException catch (e) {
      return Left(
        ValidationFailure(message: e.mensaje, code: 'GRANJA_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('ERROR_ACTIVAR_GRANJA')}: ${e.toString()}',
        ),
      );
    }
  }
}
