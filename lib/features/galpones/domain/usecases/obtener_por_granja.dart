import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para obtener galpones por granja.
///
/// Retorna todos los galpones de una granja específica.
class ObtenerPorGranjaUseCase
    implements UseCase<List<Galpon>, ObtenerPorGranjaParams> {
  ObtenerPorGranjaUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, List<Galpon>>> call(
    ObtenerPorGranjaParams params,
  ) async {
    try {
      return repository.obtenerPorGranja(params.granjaId);
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_OBTENER_GALPONES')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para obtener galpones por granja.
class ObtenerPorGranjaParams extends Equatable {
  const ObtenerPorGranjaParams({required this.granjaId});

  final String granjaId;

  @override
  List<Object?> get props => [granjaId];
}
