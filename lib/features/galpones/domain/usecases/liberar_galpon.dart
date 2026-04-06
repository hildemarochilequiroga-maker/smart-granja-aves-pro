import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para liberar un galpón de su lote asignado.
///
/// Desasocia el lote actual del galpón.
class LiberarGalponUseCase implements UseCase<Galpon, LiberarGalponParams> {
  LiberarGalponUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(LiberarGalponParams params) async {
    try {
      // Obtener el galpón
      final galponResult = await repository.obtenerPorId(params.galponId);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Validar que tenga un lote asignado
        if (galpon.loteActualId == null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_SIN_LOTE'),
              code: 'GALPON_SIN_LOTE',
            ),
          );
        }

        // Si requiere desinfección, programarla
        if (params.requiereDesinfeccion) {
          // Primero liberar, luego programar desinfección
          final resultadoLiberar = await repository.liberar(params.galponId);

          return await resultadoLiberar.fold((failure) => Left(failure), (
            galponLiberado,
          ) async {
            // Programar desinfección automática
            return repository.registrarDesinfeccion(
              params.galponId,
              DateTime.now(),
              params.productosDesinfeccion ?? ['Desinfectante estándar'],
              observaciones:
                  'Desinfección programada tras liberar lote ${galpon.loteActualId}',
            );
          });
        }

        return repository.liberar(params.galponId);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_LIBERAR_GALPON')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para liberar un galpón.
class LiberarGalponParams extends Equatable {
  const LiberarGalponParams({
    required this.galponId,
    this.requiereDesinfeccion = true,
    this.productosDesinfeccion,
  });

  final String galponId;
  final bool requiereDesinfeccion;
  final List<String>? productosDesinfeccion;

  @override
  List<Object?> get props => [
    galponId,
    requiereDesinfeccion,
    productosDesinfeccion,
  ];
}
