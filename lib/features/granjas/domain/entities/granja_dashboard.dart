library;

import 'package:equatable/equatable.dart';

/// **Dashboard tipado de una granja.**
///
/// Agrega datos de granja, lotes y galpones en una estructura inmutable
/// y fuertemente tipada, reemplazando el antiguo `Map<String, dynamic>`
/// que obligaba a la UI a castear cada campo manualmente.
class GranjaDashboard extends Equatable {
  const GranjaDashboard({
    required this.resumen,
    required this.capacidad,
    required this.lotes,
    required this.galpones,
    required this.alertas,
  });

  final GranjaDashboardResumen resumen;
  final GranjaDashboardCapacidad capacidad;
  final GranjaDashboardLotes lotes;
  final GranjaDashboardGalpones galpones;
  final GranjaDashboardAlertas alertas;

  @override
  List<Object?> get props => [resumen, capacidad, lotes, galpones, alertas];
}

/// Datos básicos de la granja mostrados en la cabecera del dashboard.
class GranjaDashboardResumen extends Equatable {
  const GranjaDashboardResumen({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.propietario,
  });

  final String id;
  final String nombre;
  final String estado;
  final String propietario;

  @override
  List<Object?> get props => [id, nombre, estado, propietario];
}

/// Capacidad y ocupación agregada de la granja.
class GranjaDashboardCapacidad extends Equatable {
  const GranjaDashboardCapacidad({
    required this.totalAves,
    required this.capacidadMaxima,
    required this.porcentajeOcupacion,
    this.densidadPromedio,
  });

  final int totalAves;
  final int capacidadMaxima;
  final double porcentajeOcupacion;
  final double? densidadPromedio;

  @override
  List<Object?> get props => [
    totalAves,
    capacidadMaxima,
    porcentajeOcupacion,
    densidadPromedio,
  ];
}

/// Resumen de lotes activos.
class GranjaDashboardLotes extends Equatable {
  const GranjaDashboardLotes({
    required this.activos,
    required this.totalAves,
  });

  final int activos;
  final int totalAves;

  @override
  List<Object?> get props => [activos, totalAves];
}

/// Resumen del estado de los galpones.
class GranjaDashboardGalpones extends Equatable {
  const GranjaDashboardGalpones({
    required this.total,
    required this.activos,
    required this.enMantenimiento,
  });

  final int total;
  final int activos;
  final int enMantenimiento;

  @override
  List<Object?> get props => [total, activos, enMantenimiento];
}

/// Alertas calculadas para la granja.
class GranjaDashboardAlertas extends Equatable {
  const GranjaDashboardAlertas({
    required this.sobrepoblacion,
    required this.datosDesactualizados,
    required this.sinLotes,
  });

  final bool sobrepoblacion;
  final bool datosDesactualizados;
  final bool sinLotes;

  /// `true` si existe al menos una alerta activa.
  bool get tieneAlertas =>
      sobrepoblacion || datosDesactualizados || sinLotes;

  @override
  List<Object?> get props => [sobrepoblacion, datosDesactualizados, sinLotes];
}
