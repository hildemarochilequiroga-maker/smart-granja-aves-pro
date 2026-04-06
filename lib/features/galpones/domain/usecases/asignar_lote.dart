import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para asignar un lote a un galpón.
///
/// Valida que el galpón esté disponible y pueda recibir el lote.
class AsignarLoteUseCase implements UseCase<Galpon, AsignarLoteParams> {
  AsignarLoteUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(AsignarLoteParams params) async {
    try {
      // Obtener el galpón
      final galponResult = await repository.obtenerPorId(params.galponId);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Validar que el galpón esté activo
        if (galpon.estado != EstadoGalpon.activo) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.format('GALPON_ACTIVO_PARA_LOTE', {'estado': galpon.estado.displayName}),
              code: 'GALPON_NO_ACTIVO',
            ),
          );
        }

        // Validar que no tenga ya un lote asignado
        if (galpon.loteActualId != null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_LOTE_YA_ASIGNADO'),
              code: 'GALPON_OCUPADO',
            ),
          );
        }

        // Validar que esté disponible
        if (!galpon.estaDisponible) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_NO_DISPONIBLE'),
              code: 'GALPON_NO_DISPONIBLE',
            ),
          );
        }

        return repository.asignarLote(params.galponId, params.loteId);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_ASIGNAR_LOTE')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para asignar un lote a un galpón.
class AsignarLoteParams extends Equatable {
  const AsignarLoteParams({required this.galponId, required this.loteId});

  final String galponId;
  final String loteId;

  @override
  List<Object?> get props => [galponId, loteId];
}
