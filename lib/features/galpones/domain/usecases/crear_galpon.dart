import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../granjas/domain/value_objects/value_objects.dart';
import '../entities/galpon.dart';
import '../enums/tipo_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para crear un nuevo galpón.
///
/// Valida y crea un nuevo galpón en el sistema.
class CrearGalponUseCase implements UseCase<Galpon, CrearGalponParams> {
  CrearGalponUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, Galpon>> call(CrearGalponParams params) async {
    try {
      // Validar que no exista otro galpón con el mismo código en la granja
      final galponesResult = await repository.obtenerPorGranja(params.granjaId);

      return await galponesResult.fold((failure) => Left(failure), (
        galpones,
      ) async {
        // Verificar código duplicado
        final existeCodigo = galpones.any(
          (g) => g.codigo.toLowerCase() == params.codigo.toLowerCase(),
        );

        if (existeCodigo) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_CODIGO_DUPLICADO'),
              code: 'CODIGO_DUPLICADO',
            ),
          );
        }

        // Verificar nombre duplicado
        final existeNombre = galpones.any(
          (g) => g.nombre.toLowerCase() == params.nombre.toLowerCase(),
        );

        if (existeNombre) {
          return Left(
            ValidationFailure(
              message: ErrorMessages.get('GALPON_NOMBRE_DUPLICADO'),
              code: 'NOMBRE_DUPLICADO',
            ),
          );
        }

        // Crear el galpón usando el factory Galpon.nuevo
        final galpon = Galpon.nuevo(
          granjaId: params.granjaId,
          codigo: params.codigo,
          nombre: params.nombre,
          tipo: params.tipo,
          capacidadMaxima: params.capacidadMaxima,
          areaM2: params.areaM2,
          umbralesAmbientales: params.umbralesAmbientales,
          descripcion: params.descripcion,
          ubicacion: params.ubicacion,
          numeroCorrales: params.numeroCorrales,
          sistemaBebederos: params.sistemaBebederos,
          sistemaComederos: params.sistemaComederos,
          sistemaVentilacion: params.sistemaVentilacion,
          sistemaCalefaccion: params.sistemaCalefaccion,
          sistemaIluminacion: params.sistemaIluminacion,
          tieneBalanza: params.tieneBalanza ?? false,
          sensorTemperatura: params.sensorTemperatura ?? false,
          sensorHumedad: params.sensorHumedad ?? false,
          sensorCO2: params.sensorCO2 ?? false,
          sensorAmoniaco: params.sensorAmoniaco ?? false,
          metadatos: params.metadatos ?? const {},
        );

        // Validar el galpón
        final errorValidacion = galpon.validar();
        if (errorValidacion != null) {
          return Left(
            ValidationFailure(
              message: errorValidacion,
              code: 'VALIDACION_FALLIDA',
            ),
          );
        }

        return repository.crear(galpon);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_CREAR_GALPON')}: ${e.toString()}'),
      );
    }
  }
}

/// Parámetros para crear un nuevo galpón.
class CrearGalponParams extends Equatable {
  const CrearGalponParams({
    required this.granjaId,
    required this.codigo,
    required this.nombre,
    required this.tipo,
    required this.capacidadMaxima,
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

  final String granjaId;
  final String codigo;
  final String nombre;
  final TipoGalpon tipo;
  final int capacidadMaxima;
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
    granjaId,
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
