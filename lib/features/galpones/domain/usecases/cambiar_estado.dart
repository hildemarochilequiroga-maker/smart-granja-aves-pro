import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para cambiar el estado de un galpón.
///
/// Valida que la transición de estado sea válida antes de aplicarla.
class CambiarEstadoUseCase implements UseCase<Galpon, CambiarEstadoParams> {
  CambiarEstadoUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(CambiarEstadoParams params) async {
    try {
      // Obtener el galpón actual
      final galponResult = await repository.obtenerPorId(params.galponId);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Validar la transición de estado
        if (!galpon.estado.puedeTransicionarA(params.nuevoEstado)) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.format('GALPON_TRANSICION_INVALIDA', {'estadoActual': galpon.estado.displayName, 'estadoNuevo': params.nuevoEstado.displayName}),
              code: 'TRANSICION_INVALIDA',
            ),
          );
        }

        // Validaciones adicionales según el nuevo estado
        switch (params.nuevoEstado) {
          case EstadoGalpon.activo:
            // No se puede activar si está en cuarentena sin completarla
            if (galpon.estado == EstadoGalpon.cuarentena) {
              // Verificar que la cuarentena haya terminado
              // (lógica adicional si es necesario)
            }
            break;

          case EstadoGalpon.cuarentena:
            // Se requiere un motivo para cuarentena
            if (params.motivo == null || params.motivo!.isEmpty) {
              return Left(
                ValidationFailure(
                  message: ErrorMessages.get('GALPON_MOTIVO_CUARENTENA'),
                  code: 'MOTIVO_REQUERIDO',
                ),
              );
            }
            break;

          case EstadoGalpon.mantenimiento:
          case EstadoGalpon.desinfeccion:
            // Advertir si tiene lote asignado
            if (galpon.loteActualId != null && !params.forzar) {
              return Left(
                ValidationFailure(
                  message: ErrorMessages.get('GALPON_CON_LOTE_CONTINUAR'),
                  code: 'GALPON_CON_LOTE_ADVERTENCIA',
                ),
              );
            }
            break;

          case EstadoGalpon.inactivo:
            // No se puede inactivar con lote asignado
            if (galpon.loteActualId != null) {
              return Left(
                ValidationFailure(
                  message: ErrorMessages.get('GALPON_INACTIVAR_CON_LOTE'),
                  code: 'GALPON_CON_LOTE',
                ),
              );
            }
            break;
        }

        return repository.cambiarEstado(
          params.galponId,
          params.nuevoEstado,
          motivo: params.motivo,
        );
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_CAMBIAR_ESTADO')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para cambiar el estado de un galpón.
class CambiarEstadoParams extends Equatable {
  const CambiarEstadoParams({
    required this.galponId,
    required this.nuevoEstado,
    this.motivo,
    this.forzar = false,
  });

  final String galponId;
  final EstadoGalpon nuevoEstado;
  final String? motivo;
  final bool forzar;

  @override
  List<Object?> get props => [galponId, nuevoEstado, motivo, forzar];
}
