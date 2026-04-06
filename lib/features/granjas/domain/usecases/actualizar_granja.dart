library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';
import '../value_objects/value_objects.dart';

/// Use Case para actualizar una granja existente
class ActualizarGranjaUseCase
    implements UseCase<Granja, ActualizarGranjaParams> {
  ActualizarGranjaUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, Granja>> call(ActualizarGranjaParams params) async {
    try {
      // Validar que la granja existe
      final existeResult = await repository.obtenerPorId(params.id);

      return await existeResult.fold((failure) => Left(failure), (
        granjaExistente,
      ) async {
        if (granjaExistente == null) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_NO_ENCONTRADA'),
              code: 'GRANJA_NO_ENCONTRADA',
            ),
          );
        }

        // Validar datos actualizados
        final granjaActualizada = granjaExistente.copyWith(
          nombre: params.nombre ?? granjaExistente.nombre,
          propietarioNombre:
              params.propietarioNombre ?? granjaExistente.propietarioNombre,
          direccion: params.direccion ?? granjaExistente.direccion,
          coordenadas: params.coordenadas ?? granjaExistente.coordenadas,
          telefono: params.telefono ?? granjaExistente.telefono,
          correo: params.correo ?? granjaExistente.correo,
          ruc: params.ruc ?? granjaExistente.ruc,
          capacidadTotalAves:
              params.capacidadTotalAves ?? granjaExistente.capacidadTotalAves,
          areaTotalM2: params.areaTotalM2 ?? granjaExistente.areaTotalM2,
          numeroTotalGalpones:
              params.numeroTotalGalpones ?? granjaExistente.numeroTotalGalpones,
          notas: params.notas ?? granjaExistente.notas,
          umbralesAmbientales:
              params.umbralesAmbientales ?? granjaExistente.umbralesAmbientales,
          ultimaActualizacion: DateTime.now(),
        );

        // Validar la granja actualizada
        final errorValidacion = granjaActualizada.validar();
        if (errorValidacion != null) {
          return Left(
            ValidationFailure(
              message: errorValidacion,
              code: 'VALIDACION_FALLIDA',
            ),
          );
        }

        // Si cambió el nombre, validar que no existe otra con ese nombre
        if (params.nombre != null && params.nombre != granjaExistente.nombre) {
          final validacionResult = await _validarNombreUnico(
            params.nombre!,
            params.id,
            granjaExistente.propietarioId,
          );

          return await validacionResult.fold((failure) => Left(failure), (
            esUnico,
          ) async {
            if (!esUnico) {
              return Left(
                ValidationFailure(
                  message: ErrorMessages.get('GRANJA_NOMBRE_DUPLICADO'),
                  code: 'NOMBRE_DUPLICADO',
                ),
              );
            }
            return repository.actualizar(granjaActualizada);
          });
        }

        return repository.actualizar(granjaActualizada);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: '${ErrorMessages.get('ERROR_ACTUALIZAR_GRANJA')}: ${e.toString()}',
        ),
      );
    }
  }

  /// Valida que el nombre sea único (excluyendo la granja actual)
  Future<Either<Failure, bool>> _validarNombreUnico(
    String nombre,
    String granjaId,
    String usuarioId,
  ) async {
    final result = await repository.obtenerPorUsuario(usuarioId);

    return result.fold((failure) => Left(failure), (granjas) {
      final existe = granjas.any(
        (g) =>
            g.id != granjaId && g.nombre.toLowerCase() == nombre.toLowerCase(),
      );
      return Right(!existe);
    });
  }
}

/// Parámetros para actualizar una granja
class ActualizarGranjaParams extends Equatable {
  const ActualizarGranjaParams({
    required this.id,
    this.nombre,
    this.propietarioNombre,
    this.direccion,
    this.coordenadas,
    this.umbralesAmbientales,
    this.telefono,
    this.correo,
    this.ruc,
    this.capacidadTotalAves,
    this.areaTotalM2,
    this.numeroTotalGalpones,
    this.notas,
  });

  final String id;
  final String? nombre;
  final String? propietarioNombre;
  final Direccion? direccion;
  final Coordenadas? coordenadas;
  final UmbralesAmbientales? umbralesAmbientales;
  final String? telefono;
  final String? correo;
  final String? ruc;
  final int? capacidadTotalAves;
  final double? areaTotalM2;
  final int? numeroTotalGalpones;
  final String? notas;

  @override
  List<Object?> get props => [
    id,
    nombre,
    propietarioNombre,
    direccion,
    coordenadas,
    umbralesAmbientales,
    telefono,
    correo,
    ruc,
    capacidadTotalAves,
    areaTotalM2,
    numeroTotalGalpones,
    notas,
  ];
}
