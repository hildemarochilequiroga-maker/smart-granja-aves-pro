import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../enums/estado_galpon.dart';
import '../repositories/galpon_repository.dart';

/// Use Case para obtener estadísticas de galpones.
///
/// Calcula y retorna estadísticas agregadas de los galpones.
class ObtenerEstadisticasUseCase
    implements UseCase<GalponEstadisticas, ObtenerEstadisticasParams> {
  ObtenerEstadisticasUseCase({required this.repository});

  final GalponRepository repository;

  @override
  Future<Either<Failure, GalponEstadisticas>> call(
    ObtenerEstadisticasParams params,
  ) async {
    try {
      // Obtener todos los galpones de la granja
      final galponesResult = await repository.obtenerPorGranja(params.granjaId);

      return galponesResult.fold((failure) => Left(failure), (galpones) {
        if (galpones.isEmpty) {
          return Right(GalponEstadisticas.vacio());
        }

        // Calcular estadísticas
        final total = galpones.length;

        // Conteo por estado
        final porEstado = <EstadoGalpon, int>{};
        for (final estado in EstadoGalpon.values) {
          porEstado[estado] = galpones.where((g) => g.estado == estado).length;
        }

        // Disponibles (activos sin lote)
        final disponibles = galpones.where((g) => g.estaDisponible).length;

        // Ocupados (con lote)
        final ocupados = galpones.where((g) => g.loteActualId != null).length;

        // Capacidad
        final capacidadTotal = galpones.fold<int>(
          0,
          (sum, g) => sum + g.capacidadMaxima,
        );

        final avesActuales = galpones.fold<int>(
          0,
          (sum, g) => sum + g.avesActuales,
        );

        // Área
        final areaTotal = galpones.fold<double>(
          0,
          (sum, g) => sum + (g.areaM2 ?? 0),
        );

        // Sensores
        final conSensorTemperatura = galpones
            .where((g) => g.sensorTemperatura)
            .length;
        final conSensorHumedad = galpones.where((g) => g.sensorHumedad).length;
        final conSensorCO2 = galpones.where((g) => g.sensorCO2).length;
        final conSensorAmoniaco = galpones
            .where((g) => g.sensorAmoniaco)
            .length;

        // Requieren atención
        final requierenAtencion = galpones
            .where((g) => g.requiereAtencion)
            .length;

        // Últimas desinfecciones
        final sinDesinfeccionReciente = galpones.where((g) {
          if (g.ultimaDesinfeccion == null) return true;
          final diasDesdeDesinfeccion = DateTime.now()
              .difference(g.ultimaDesinfeccion!)
              .inDays;
          return diasDesdeDesinfeccion > 30; // Más de 30 días
        }).length;

        return Right(
          GalponEstadisticas(
            total: total,
            porEstado: porEstado,
            disponibles: disponibles,
            ocupados: ocupados,
            capacidadTotal: capacidadTotal,
            avesActuales: avesActuales,
            areaTotal: areaTotal,
            porcentajeOcupacion: capacidadTotal > 0
                ? (avesActuales / capacidadTotal * 100)
                : 0,
            conSensorTemperatura: conSensorTemperatura,
            conSensorHumedad: conSensorHumedad,
            conSensorCO2: conSensorCO2,
            conSensorAmoniaco: conSensorAmoniaco,
            requierenAtencion: requierenAtencion,
            sinDesinfeccionReciente: sinDesinfeccionReciente,
          ),
        );
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERROR_OBTENER_ESTADISTICAS', {
            'detail': e.toString(),
          }),
        ),
      );
    }
  }
}

/// Parámetros para obtener estadísticas.
class ObtenerEstadisticasParams extends Equatable {
  const ObtenerEstadisticasParams({required this.granjaId});

  final String granjaId;

  @override
  List<Object?> get props => [granjaId];
}

/// Clase que contiene las estadísticas de galpones.
class GalponEstadisticas extends Equatable {
  const GalponEstadisticas({
    required this.total,
    required this.porEstado,
    required this.disponibles,
    required this.ocupados,
    required this.capacidadTotal,
    required this.avesActuales,
    required this.areaTotal,
    required this.porcentajeOcupacion,
    required this.conSensorTemperatura,
    required this.conSensorHumedad,
    required this.conSensorCO2,
    required this.conSensorAmoniaco,
    required this.requierenAtencion,
    required this.sinDesinfeccionReciente,
  });

  /// Crea estadísticas vacías.
  factory GalponEstadisticas.vacio() => GalponEstadisticas(
    total: 0,
    porEstado: {for (var e in EstadoGalpon.values) e: 0},
    disponibles: 0,
    ocupados: 0,
    capacidadTotal: 0,
    avesActuales: 0,
    areaTotal: 0,
    porcentajeOcupacion: 0,
    conSensorTemperatura: 0,
    conSensorHumedad: 0,
    conSensorCO2: 0,
    conSensorAmoniaco: 0,
    requierenAtencion: 0,
    sinDesinfeccionReciente: 0,
  );

  final int total;
  final Map<EstadoGalpon, int> porEstado;
  final int disponibles;
  final int ocupados;
  final int capacidadTotal;
  final int avesActuales;
  final double areaTotal;
  final double porcentajeOcupacion;
  final int conSensorTemperatura;
  final int conSensorHumedad;
  final int conSensorCO2;
  final int conSensorAmoniaco;
  final int requierenAtencion;
  final int sinDesinfeccionReciente;

  /// Cantidad de galpones activos.
  int get activos => porEstado[EstadoGalpon.activo] ?? 0;

  /// Cantidad de galpones en mantenimiento.
  int get enMantenimiento => porEstado[EstadoGalpon.mantenimiento] ?? 0;

  /// Cantidad de galpones inactivos.
  int get inactivos => porEstado[EstadoGalpon.inactivo] ?? 0;

  /// Cantidad de galpones en desinfección.
  int get enDesinfeccion => porEstado[EstadoGalpon.desinfeccion] ?? 0;

  /// Cantidad de galpones en cuarentena.
  int get enCuarentena => porEstado[EstadoGalpon.cuarentena] ?? 0;

  /// Capacidad disponible.
  int get capacidadDisponible => capacidadTotal - avesActuales;

  /// Porcentaje de galpones disponibles.
  double get porcentajeDisponibles =>
      total > 0 ? (disponibles / total * 100) : 0;

  /// Convierte a Map para serialización.
  Map<String, dynamic> toJson() => {
    'total': total,
    'porEstado': porEstado.map((k, v) => MapEntry(k.name, v)),
    'disponibles': disponibles,
    'ocupados': ocupados,
    'capacidadTotal': capacidadTotal,
    'avesActuales': avesActuales,
    'areaTotal': areaTotal,
    'porcentajeOcupacion': porcentajeOcupacion,
    'conSensorTemperatura': conSensorTemperatura,
    'conSensorHumedad': conSensorHumedad,
    'conSensorCO2': conSensorCO2,
    'conSensorAmoniaco': conSensorAmoniaco,
    'requierenAtencion': requierenAtencion,
    'sinDesinfeccionReciente': sinDesinfeccionReciente,
  };

  @override
  List<Object?> get props => [
    total,
    porEstado,
    disponibles,
    ocupados,
    capacidadTotal,
    avesActuales,
    areaTotal,
    porcentajeOcupacion,
    conSensorTemperatura,
    conSensorHumedad,
    conSensorCO2,
    conSensorAmoniaco,
    requierenAtencion,
    sinDesinfeccionReciente,
  ];
}
