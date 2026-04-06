library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';
import '../value_objects/value_objects.dart';

/// Use Case para crear una nueva granja
///
/// Valida y crea una nueva granja en el sistema.
class CrearGranjaUseCase implements UseCase<Granja, CrearGranjaParams> {
  CrearGranjaUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, Granja>> call(CrearGranjaParams params) async {
    try {
      // Validar que no exista otra granja con el mismo nombre
      final granjasResult = await repository.obtenerPorUsuario(
        params.usuarioId,
      );

      return await granjasResult.fold((failure) => Left(failure), (
        granjas,
      ) async {
        final existeNombre = granjas.any(
          (g) => g.nombre.toLowerCase() == params.nombre.toLowerCase(),
        );

        if (existeNombre) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GRANJA_NOMBRE_DUPLICADO'),
              code: 'NOMBRE_DUPLICADO',
            ),
          );
        }

        // Crear la granja
        final granja =
            Granja.nueva(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              nombre: params.nombre,
              direccion: params.direccion,
              propietarioId: params.usuarioId,
              propietarioNombre: params.propietarioNombre,
              coordenadas: params.coordenadas,
              telefono: params.telefono,
              correo: params.correo,
              ruc: params.ruc,
            ).actualizarEstadisticas(
              capacidadTotalAves: params.capacidadMaximaAves,
              areaTotalM2: params.areaTotal,
            );

        // Validar la granja
        final errorValidacion = granja.validar();
        if (errorValidacion != null) {
          return Left(
            ValidationFailure(
              message: errorValidacion,
              code: 'VALIDACION_FALLIDA',
            ),
          );
        }

        return repository.crear(granja);
      });
    } on GranjaException catch (e) {
      return Left(
        ValidationFailure(message: e.mensaje, code: 'GRANJA_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_CREAR_GRANJA')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para crear una nueva granja
class CrearGranjaParams extends Equatable {
  const CrearGranjaParams({
    required this.usuarioId,
    required this.nombre,
    required this.propietarioNombre,
    required this.direccion,
    this.coordenadas,
    this.capacidadMaximaAves,
    this.areaTotal,
    this.telefono,
    this.correo,
    this.ruc,
    this.umbralesAmbientales,
  });

  final String usuarioId;
  final String nombre;
  final String propietarioNombre;
  final Direccion direccion;
  final Coordenadas? coordenadas;
  final int? capacidadMaximaAves;
  final double? areaTotal;
  final String? telefono;
  final String? correo;
  final String? ruc;
  final UmbralesAmbientales? umbralesAmbientales;

  @override
  List<Object?> get props => [
    usuarioId,
    nombre,
    propietarioNombre,
    direccion,
    coordenadas,
    capacidadMaximaAves,
    areaTotal,
    telefono,
    correo,
    ruc,
    umbralesAmbientales,
  ];
}
