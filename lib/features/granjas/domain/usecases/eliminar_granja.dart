library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../galpones/domain/repositories/galpon_repository.dart';
import '../../../lotes/domain/repositories/lote_repository.dart';
import '../repositories/granja_repository.dart';

/// Use Case para eliminar una granja del sistema
class EliminarGranjaUseCase implements UseCase<bool, String> {
  EliminarGranjaUseCase({
    required this.repository,
    this.galponRepository,
    this.loteRepository,
  });

  final GranjaRepository repository;
  final GalponRepository? galponRepository;
  final LoteRepository? loteRepository;

  @override
  Future<Either<Failure, bool>> call(String granjaId) async {
    try {
      // Verificar que la granja existe
      final existeResult = await repository.obtenerPorId(granjaId);

      return await existeResult.fold((failure) => Left(failure), (
        granja,
      ) async {
        if (granja == null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_NO_ENCONTRADA'),
              code: 'GRANJA_NO_ENCONTRADA',
            ),
          );
        }

        // Validar que la granja pueda ser eliminada
        if (granja.estaActiva) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_ACTIVA_NO_ELIMINAR'),
              code: 'GRANJA_ACTIVA',
            ),
          );
        }

        // Verificar que no tenga galpones activos
        if (galponRepository != null) {
          final galponesResult = await galponRepository!.obtenerPorGranja(
            granjaId,
          );
          final tieneGalponesActivos = galponesResult.fold(
            (_) => false,
            (galpones) => galpones.any((g) => g.estaActivo),
          );

          if (tieneGalponesActivos) {
            return Left(
              ValidationFailure(
                message: ErrorMessages.get('GRANJA_CON_GALPONES_ACTIVOS'),
                code: 'GRANJA_CON_GALPONES_ACTIVOS',
              ),
            );
          }
        }

        // Verificar que no tenga lotes activos
        if (loteRepository != null) {
          final lotesResult = await loteRepository!.obtenerPorGranja(granjaId);
          final tieneLotesActivos = lotesResult.fold(
            (_) => false,
            (lotes) => lotes.any((l) => l.estaActivo),
          );

          if (tieneLotesActivos) {
            return Left(
              ValidationFailure(
                message: ErrorMessages.get('GRANJA_CON_LOTES_ACTIVOS'),
                code: 'GRANJA_CON_LOTES_ACTIVOS',
              ),
            );
          }
        }

        return repository.eliminar(granjaId);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: '${ErrorMessages.get('ERROR_ELIMINAR_GRANJA')}: ${e.toString()}',
        ),
      );
    }
  }
}
