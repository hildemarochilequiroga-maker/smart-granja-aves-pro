import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para eliminar un galpón.
///
/// Valida que el galpón pueda ser eliminado antes de proceder.
class EliminarGalponUseCase implements UseCase<Unit, EliminarGalponParams> {
  EliminarGalponUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Unit>> call(EliminarGalponParams params) async {
    try {
      // Obtener el galpón para validar que pueda eliminarse
      final galponResult = await repository.obtenerPorId(params.id);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // No se puede eliminar si tiene lote asignado
        if (galpon.loteActualId != null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_CON_LOTE_NO_ELIMINAR'),
              code: 'GALPON_CON_LOTE',
            ),
          );
        }

        // No se puede eliminar si está en cuarentena
        if (galpon.estado == EstadoGalpon.cuarentena) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_EN_CUARENTENA_NO_ELIMINAR'),
              code: 'GALPON_EN_CUARENTENA',
            ),
          );
        }

        // Validación adicional si se fuerza la eliminación
        if (!params.forzar) {
          // Si está en mantenimiento o desinfección, advertir
          if (galpon.estado == EstadoGalpon.mantenimiento ||
              galpon.estado == EstadoGalpon.desinfeccion) {
            return Left(
              ValidationFailure(
                message:
                    ErrorMessages.format('GALPON_EN_PROCESO_CONFIRMAR', {'estado': galpon.estado.displayName}),
                code: 'GALPON_EN_PROCESO',
              ),
            );
          }
        }

        return repository.eliminar(params.id);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_ELIMINAR_GALPON')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para eliminar un galpón.
class EliminarGalponParams extends Equatable {
  const EliminarGalponParams({required this.id, this.forzar = false});

  final String id;
  final bool forzar;

  @override
  List<Object?> get props => [id, forzar];
}
