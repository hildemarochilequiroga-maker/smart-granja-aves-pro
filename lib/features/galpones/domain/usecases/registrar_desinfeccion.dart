import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/galpon.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para registrar desinfección de un galpón.
///
/// Registra una desinfección realizada o programada.
class RegistrarDesinfeccionUseCase
    implements UseCase<Galpon, RegistrarDesinfeccionParams> {
  RegistrarDesinfeccionUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(
    RegistrarDesinfeccionParams params,
  ) async {
    try {
      // Obtener el galpón
      final galponResult = await repository.obtenerPorId(params.galponId);

      return await galponResult.fold((failure) => Left(failure), (
        galpon,
      ) async {
        // Validar que pueda entrar en desinfección
        if (!galpon.estado.puedeTransicionarA(EstadoGalpon.desinfeccion)) {
          return Left(
            ValidationFailure(
              message:
                  ErrorMessages.format('GALPON_DESINFECCION_TRANSICION', {'estado': galpon.estado.displayName}),
              code: 'TRANSICION_INVALIDA',
            ),
          );
        }

        // Advertir si tiene lote asignado
        if (galpon.loteActualId != null && !params.forzar) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_DESINFECCION_CON_LOTE'),
              code: 'GALPON_CON_LOTE_ADVERTENCIA',
            ),
          );
        }

        // Validar que se especifiquen productos
        if (params.productos.isEmpty) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_DESINFECCION_PRODUCTOS'),
              code: 'PRODUCTOS_REQUERIDOS',
            ),
          );
        }

        return repository.registrarDesinfeccion(
          params.galponId,
          params.fechaDesinfeccion,
          params.productos,
          observaciones: params.observaciones,
        );
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: '${ErrorMessages.get('ERROR_REGISTRAR_DESINFECCION')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Parámetros para registrar desinfección.
class RegistrarDesinfeccionParams extends Equatable {
  const RegistrarDesinfeccionParams({
    required this.galponId,
    required this.fechaDesinfeccion,
    required this.productos,
    this.observaciones,
    this.responsable,
    this.duracionHoras,
    this.forzar = false,
  });

  final String galponId;
  final DateTime fechaDesinfeccion;
  final List<String> productos;
  final String? observaciones;
  final String? responsable;
  final int? duracionHoras;
  final bool forzar;

  @override
  List<Object?> get props => [
    galponId,
    fechaDesinfeccion,
    productos,
    observaciones,
    responsable,
    duracionHoras,
    forzar,
  ];
}
