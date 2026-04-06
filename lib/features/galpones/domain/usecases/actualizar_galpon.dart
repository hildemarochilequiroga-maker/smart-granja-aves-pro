import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../granjas/domain/value_objects/value_objects.dart';
import '../entities/galpon.dart';
import '../enums/tipo_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para actualizar un galpón existente.
///
/// Actualiza los datos de un galpón validando las restricciones.
class ActualizarGalponUseCase
    implements UseCase<Galpon, ActualizarGalponParams> {
  ActualizarGalponUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(ActualizarGalponParams params) async {
    try {
      // Obtener el galpón actual
      final galponActualResult = await repository.obtenerPorId(params.id);

      return await galponActualResult.fold((failure) => Left(failure), (
        galponActual,
      ) async {
        // Si se cambió el código o nombre, verificar duplicados
        if (params.codigo != null && params.codigo != galponActual.codigo ||
            params.nombre != null && params.nombre != galponActual.nombre) {
          final galponesResult = await repository.obtenerPorGranja(
            galponActual.granjaId,
          );

          final duplicadoCheck = galponesResult.fold((failure) => failure, (
            galpones,
          ) {
            if (params.codigo != null) {
              final existeCodigo = galpones.any(
                (g) =>
                    g.id != params.id &&
                    g.codigo.toLowerCase() == params.codigo!.toLowerCase(),
              );
              if (existeCodigo) {
                return ValidationFailure(
                  message: ErrorMessages.get(
                    'GALPON_CODIGO_DUPLICADO_ACTUALIZAR',
                  ),
                  code: 'CODIGO_DUPLICADO',
                );
              }
            }

            if (params.nombre != null) {
              final existeNombre = galpones.any(
                (g) =>
                    g.id != params.id &&
                    g.nombre.toLowerCase() == params.nombre!.toLowerCase(),
              );
              if (existeNombre) {
                return ValidationFailure(
                  message: ErrorMessages.get(
                    'GALPON_NOMBRE_DUPLICADO_ACTUALIZAR',
                  ),
                  code: 'NOMBRE_DUPLICADO',
                );
              }
            }
            return null;
          });

          if (duplicadoCheck is Failure) {
            return Left(duplicadoCheck);
          }
        }

        // Actualizar el galpón
        var galponActualizado = galponActual;

        if (params.nombre != null) {
          galponActualizado = galponActualizado.copyWith(nombre: params.nombre);
        }

        if (params.codigo != null) {
          galponActualizado = galponActualizado.copyWith(codigo: params.codigo);
        }

        if (params.tipo != null) {
          galponActualizado = galponActualizado.copyWith(tipo: params.tipo);
        }

        if (params.capacidadMaxima != null) {
          galponActualizado = galponActualizado.copyWith(
            capacidadMaxima: params.capacidadMaxima,
          );
        }

        if (params.areaM2 != null) {
          galponActualizado = galponActualizado.copyWith(areaM2: params.areaM2);
        }

        if (params.umbralesAmbientales != null) {
          galponActualizado = galponActualizado.actualizarUmbrales(
            params.umbralesAmbientales!,
          );
        }

        if (params.descripcion != null) {
          galponActualizado = galponActualizado.copyWith(
            descripcion: params.descripcion,
          );
        }

        if (params.ubicacion != null) {
          galponActualizado = galponActualizado.copyWith(
            ubicacion: params.ubicacion,
          );
        }

        if (params.numeroCorrales != null) {
          galponActualizado = galponActualizado.copyWith(
            numeroCorrales: params.numeroCorrales,
          );
        }

        if (params.sistemaBebederos != null) {
          galponActualizado = galponActualizado.copyWith(
            sistemaBebederos: params.sistemaBebederos,
          );
        }

        if (params.sistemaComederos != null) {
          galponActualizado = galponActualizado.copyWith(
            sistemaComederos: params.sistemaComederos,
          );
        }

        if (params.sistemaVentilacion != null) {
          galponActualizado = galponActualizado.copyWith(
            sistemaVentilacion: params.sistemaVentilacion,
          );
        }

        if (params.sistemaCalefaccion != null) {
          galponActualizado = galponActualizado.copyWith(
            sistemaCalefaccion: params.sistemaCalefaccion,
          );
        }

        if (params.sistemaIluminacion != null) {
          galponActualizado = galponActualizado.copyWith(
            sistemaIluminacion: params.sistemaIluminacion,
          );
        }

        if (params.tieneBalanza != null) {
          galponActualizado = galponActualizado.copyWith(
            tieneBalanza: params.tieneBalanza,
          );
        }

        if (params.sensorTemperatura != null) {
          galponActualizado = galponActualizado.copyWith(
            sensorTemperatura: params.sensorTemperatura,
          );
        }

        if (params.sensorHumedad != null) {
          galponActualizado = galponActualizado.copyWith(
            sensorHumedad: params.sensorHumedad,
          );
        }

        if (params.sensorCO2 != null) {
          galponActualizado = galponActualizado.copyWith(
            sensorCO2: params.sensorCO2,
          );
        }

        if (params.sensorAmoniaco != null) {
          galponActualizado = galponActualizado.copyWith(
            sensorAmoniaco: params.sensorAmoniaco,
          );
        }

        if (params.metadatos != null) {
          galponActualizado = galponActualizado.copyWith(
            metadatos: {...galponActualizado.metadatos, ...params.metadatos!},
          );
        }

        // Validar el galpón actualizado
        final errorValidacion = galponActualizado.validar();
        if (errorValidacion != null) {
          return Left(
            ValidationFailure(
              message: errorValidacion,
              code: 'VALIDACION_FALLIDA',
            ),
          );
        }

        return repository.actualizar(galponActualizado);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_ACTUALIZAR_GALPON')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para actualizar un galpón.
class ActualizarGalponParams extends Equatable {
  const ActualizarGalponParams({
    required this.id,
    this.codigo,
    this.nombre,
    this.tipo,
    this.capacidadMaxima,
    this.areaM2,
    this.umbralesAmbientales,
    this.descripcion,
    this.ubicacion,
    this.numeroCorrales,
    this.sistemaBebederos,
    this.sistemaComederos,
    this.sistemaVentilacion,
    this.sistemaCalefaccion,
    this.sistemaIluminacion,
    this.tieneBalanza,
    this.sensorTemperatura,
    this.sensorHumedad,
    this.sensorCO2,
    this.sensorAmoniaco,
    this.metadatos,
  });

  final String id;
  final String? codigo;
  final String? nombre;
  final TipoGalpon? tipo;
  final int? capacidadMaxima;
  final double? areaM2;
  final UmbralesAmbientales? umbralesAmbientales;
  final String? descripcion;
  final String? ubicacion;
  final int? numeroCorrales;
  final String? sistemaBebederos;
  final String? sistemaComederos;
  final String? sistemaVentilacion;
  final String? sistemaCalefaccion;
  final String? sistemaIluminacion;
  final bool? tieneBalanza;
  final bool? sensorTemperatura;
  final bool? sensorHumedad;
  final bool? sensorCO2;
  final bool? sensorAmoniaco;
  final Map<String, dynamic>? metadatos;

  @override
  List<Object?> get props => [
    id,
    codigo,
    nombre,
    tipo,
    capacidadMaxima,
    areaM2,
    umbralesAmbientales,
    descripcion,
    ubicacion,
    numeroCorrales,
    sistemaBebederos,
    sistemaComederos,
    sistemaVentilacion,
    sistemaCalefaccion,
    sistemaIluminacion,
    tieneBalanza,
    sensorTemperatura,
    sensorHumedad,
    sensorCO2,
    sensorAmoniaco,
    metadatos,
  ];
}
