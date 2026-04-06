import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para programar mantenimiento de un galpón.
///
/// Agenda un mantenimiento y cambia el estado del galpón.
class ProgramarMantenimientoUseCase
    implements UseCase<Galpon, ProgramarMantenimientoParams> {
  ProgramarMantenimientoUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(
    ProgramarMantenimientoParams params,
  ) async {
    try {
      // Obtener el galpón
      final galponResult = await repository.obtenerPorId(params.galponId);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Validar que pueda entrar en mantenimiento
        if (!galpon.estado.puedeTransicionarA(EstadoGalpon.mantenimiento)) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.format('GALPON_MANTENIMIENTO_TRANSICION', {'estado': galpon.estado.displayName}),
              code: 'TRANSICION_INVALIDA',
            ),
          );
        }

        // Advertir si tiene lote asignado
        if (galpon.loteActualId != null && !params.forzar) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_MANTENIMIENTO_CON_LOTE'),
              code: 'GALPON_CON_LOTE_ADVERTENCIA',
            ),
          );
        }

        // Validar fecha de inicio
        if (params.fechaInicio.isBefore(DateTime.now())) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_MANTENIMIENTO_FECHA_FUTURA'),
              code: 'FECHA_INVALIDA',
            ),
          );
        }

        // Validar descripción
        if (params.descripcion.isEmpty) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_MANTENIMIENTO_DESCRIPCION'),
              code: 'DESCRIPCION_REQUERIDA',
            ),
          );
        }

        return repository.programarMantenimiento(
          params.galponId,
          params.fechaInicio,
          params.descripcion,
        );
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: '${ErrorMessages.get('ERROR_PROGRAMAR_MANTENIMIENTO')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Parámetros para programar mantenimiento.
class ProgramarMantenimientoParams extends Equatable {
  const ProgramarMantenimientoParams({
    required this.galponId,
    required this.fechaInicio,
    required this.descripcion,
    this.fechaFin,
    this.tipoMantenimiento,
    this.forzar = false,
  });

  final String galponId;
  final DateTime fechaInicio;
  final String descripcion;
  final DateTime? fechaFin;
  final String? tipoMantenimiento;
  final bool forzar;

  @override
  List<Object?> get props => [
    galponId,
    fechaInicio,
    descripcion,
    fechaFin,
    tipoMantenimiento,
    forzar,
  ];
}
