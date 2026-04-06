import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para obtener galpones disponibles.
///
/// Retorna los galpones que no tienen lote asignado
/// y están en estado activo.
class ObtenerDisponiblesUseCase
    implements UseCase<List<Galpon>, ObtenerDisponiblesParams> {
  ObtenerDisponiblesUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, List<Galpon>>> call(
    ObtenerDisponiblesParams params,
  ) async {
    try {
      return repository.obtenerDisponibles(params.granjaId);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERROR_OBTENER_DISPONIBLES', {
            'detail': e.toString(),
          }),
        ),
      );
    }
  }
}

/// Parámetros para obtener galpones disponibles.
class ObtenerDisponiblesParams extends Equatable {
  const ObtenerDisponiblesParams({required this.granjaId});

  final String granjaId;

  @override
  List<Object?> get props => [granjaId];
}
