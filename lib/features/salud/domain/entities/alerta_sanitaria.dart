/// Entidad para alertas sanitarias y sistema de monitoreo de salud.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Alerta sanitaria generada automáticamente o manualmente.
class AlertaSanitaria extends Equatable {
  const AlertaSanitaria({
    required this.id,
    required this.granjaId,
    this.galponId,
    this.loteId,
    required this.tipo,
    required this.nivel,
    required this.titulo,
    required this.descripcion,
    required this.fechaGeneracion,
    this.fechaDeteccion,
    this.enfermedadSospechada,
    required this.indicadores,
    this.recomendaciones,
    this.accionesTomadas,
    required this.estado,
    this.fechaResolucion,
    this.resolvedPor,
    this.comentarioResolucion,
    required this.generadoAutomaticamente,
    required this.fechaCreacion,
  });

  /// ID único de la alerta.
  final String id;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón (opcional).
  final String? galponId;

  /// ID del lote (opcional).
  final String? loteId;

  /// Tipo de alerta.
  final TipoAlertaSanitaria tipo;

  /// Nivel de urgencia.
  final NivelAlerta nivel;

  /// Título corto de la alerta.
  final String titulo;

  /// Descripción detallada.
  final String descripcion;

  /// Fecha de generación de la alerta.
  final DateTime fechaGeneracion;

  /// Fecha de detección del problema (puede ser antes de generar alerta).
  final DateTime? fechaDeteccion;

  /// Enfermedad sospechada (si aplica).
  final EnfermedadAvicola? enfermedadSospechada;

  /// Indicadores que dispararon la alerta.
  final List<IndicadorAlerta> indicadores;

  /// Recomendaciones de acción.
  final String? recomendaciones;

  /// Acciones tomadas en respuesta.
  final String? accionesTomadas;

  /// Estado actual de la alerta.
  final EstadoAlerta estado;

  /// Fecha de resolución.
  final DateTime? fechaResolucion;

  /// Usuario que resolvió la alerta.
  final String? resolvedPor;

  /// Comentario de resolución.
  final String? comentarioResolucion;

  /// Si fue generada automáticamente por el sistema.
  final bool generadoAutomaticamente;

  /// Fecha de creación del registro.
  final DateTime fechaCreacion;

  // ==================== MÉTODOS AUXILIARES ====================

  /// Indica si la alerta está activa.
  bool get estaActiva => estado == EstadoAlerta.activa;

  /// Indica si es una alerta crítica.
  bool get esCritica =>
      nivel == NivelAlerta.critico || nivel == NivelAlerta.emergencia;

  /// Tiempo transcurrido desde la generación.
  Duration get tiempoDesdeGeneracion =>
      DateTime.now().difference(fechaGeneracion);

  /// Tiempo hasta resolución (si está resuelta).
  Duration? get tiempoResolucion =>
      fechaResolucion?.difference(fechaGeneracion);

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    loteId,
    tipo,
    nivel,
    titulo,
    descripcion,
    fechaGeneracion,
    fechaDeteccion,
    enfermedadSospechada,
    indicadores,
    recomendaciones,
    accionesTomadas,
    estado,
    fechaResolucion,
    resolvedPor,
    comentarioResolucion,
    generadoAutomaticamente,
    fechaCreacion,
  ];

  AlertaSanitaria copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    String? loteId,
    TipoAlertaSanitaria? tipo,
    NivelAlerta? nivel,
    String? titulo,
    String? descripcion,
    DateTime? fechaGeneracion,
    DateTime? fechaDeteccion,
    EnfermedadAvicola? enfermedadSospechada,
    List<IndicadorAlerta>? indicadores,
    String? recomendaciones,
    String? accionesTomadas,
    EstadoAlerta? estado,
    DateTime? fechaResolucion,
    String? resolvedPor,
    String? comentarioResolucion,
    bool? generadoAutomaticamente,
    DateTime? fechaCreacion,
  }) {
    return AlertaSanitaria(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      loteId: loteId ?? this.loteId,
      tipo: tipo ?? this.tipo,
      nivel: nivel ?? this.nivel,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaGeneracion: fechaGeneracion ?? this.fechaGeneracion,
      fechaDeteccion: fechaDeteccion ?? this.fechaDeteccion,
      enfermedadSospechada: enfermedadSospechada ?? this.enfermedadSospechada,
      indicadores: indicadores ?? this.indicadores,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      accionesTomadas: accionesTomadas ?? this.accionesTomadas,
      estado: estado ?? this.estado,
      fechaResolucion: fechaResolucion ?? this.fechaResolucion,
      resolvedPor: resolvedPor ?? this.resolvedPor,
      comentarioResolucion: comentarioResolucion ?? this.comentarioResolucion,
      generadoAutomaticamente:
          generadoAutomaticamente ?? this.generadoAutomaticamente,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'granjaId': granjaId,
    'galponId': galponId,
    'loteId': loteId,
    'tipo': tipo.toJson(),
    'nivel': nivel.toJson(),
    'titulo': titulo,
    'descripcion': descripcion,
    'fechaGeneracion': fechaGeneracion.toIso8601String(),
    'fechaDeteccion': fechaDeteccion?.toIso8601String(),
    'enfermedadSospechada': enfermedadSospechada?.toJson(),
    'indicadores': indicadores.map((i) => i.toJson()).toList(),
    'recomendaciones': recomendaciones,
    'accionesTomadas': accionesTomadas,
    'estado': estado.toJson(),
    'fechaResolucion': fechaResolucion?.toIso8601String(),
    'resolvedPor': resolvedPor,
    'comentarioResolucion': comentarioResolucion,
    'generadoAutomaticamente': generadoAutomaticamente,
    'fechaCreacion': fechaCreacion.toIso8601String(),
  };

  factory AlertaSanitaria.fromJson(Map<String, dynamic> json) {
    return AlertaSanitaria(
      id: json['id'] as String,
      granjaId: json['granjaId'] as String,
      galponId: json['galponId'] as String?,
      loteId: json['loteId'] as String?,
      tipo: TipoAlertaSanitaria.fromJson(json['tipo'] as String),
      nivel: NivelAlerta.fromJson(json['nivel'] as String),
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String,
      fechaGeneracion: DateTime.parse(json['fechaGeneracion'] as String),
      fechaDeteccion: json['fechaDeteccion'] != null
          ? DateTime.parse(json['fechaDeteccion'] as String)
          : null,
      enfermedadSospechada: json['enfermedadSospechada'] != null
          ? EnfermedadAvicola.fromJson(json['enfermedadSospechada'] as String)
          : null,
      indicadores: (json['indicadores'] as List<dynamic>)
          .map((i) => IndicadorAlerta.fromJson(i as Map<String, dynamic>))
          .toList(),
      recomendaciones: json['recomendaciones'] as String?,
      accionesTomadas: json['accionesTomadas'] as String?,
      estado: EstadoAlerta.fromJson(json['estado'] as String),
      fechaResolucion: json['fechaResolucion'] != null
          ? DateTime.parse(json['fechaResolucion'] as String)
          : null,
      resolvedPor: json['resolvedPor'] as String?,
      comentarioResolucion: json['comentarioResolucion'] as String?,
      generadoAutomaticamente: json['generadoAutomaticamente'] as bool,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }
}

/// Indicador que disparó una alerta.
class IndicadorAlerta extends Equatable {
  const IndicadorAlerta({
    required this.nombre,
    required this.valorActual,
    required this.valorEsperado,
    required this.umbral,
    this.unidad,
    required this.tipoDesviacion,
  });

  /// Nombre del indicador.
  final String nombre;

  /// Valor actual observado.
  final double valorActual;

  /// Valor esperado/normal.
  final double valorEsperado;

  /// Umbral que fue superado.
  final double umbral;

  /// Unidad de medida.
  final String? unidad;

  /// Tipo de desviación.
  final TipoDesviacion tipoDesviacion;

  /// Porcentaje de desviación del valor esperado.
  double get porcentajeDesviacion {
    if (valorEsperado == 0) return 0;
    return ((valorActual - valorEsperado) / valorEsperado).abs() * 100;
  }

  @override
  List<Object?> get props => [
    nombre,
    valorActual,
    valorEsperado,
    umbral,
    unidad,
    tipoDesviacion,
  ];

  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'valorActual': valorActual,
    'valorEsperado': valorEsperado,
    'umbral': umbral,
    'unidad': unidad,
    'tipoDesviacion': tipoDesviacion.toJson(),
  };

  factory IndicadorAlerta.fromJson(Map<String, dynamic> json) {
    return IndicadorAlerta(
      nombre: json['nombre'] as String,
      valorActual: (json['valorActual'] as num).toDouble(),
      valorEsperado: (json['valorEsperado'] as num).toDouble(),
      umbral: (json['umbral'] as num).toDouble(),
      unidad: json['unidad'] as String?,
      tipoDesviacion: TipoDesviacion.fromJson(json['tipoDesviacion'] as String),
    );
  }
}

/// Tipos de alertas sanitarias.
enum TipoAlertaSanitaria {
  mortalidadElevada('Mortalidad Elevada', 'Mortalidad por encima del umbral'),
  sintomasRespiratorios(
    'Síntomas Respiratorios',
    'Signos de enfermedad respiratoria',
  ),
  bajaProduccion('Baja Producción', 'Producción por debajo de lo esperado'),
  consumoAnormal('Consumo Anormal', 'Consumo de agua o alimento anormal'),
  temperaturaAnormal('Temperatura Anormal', 'Temperatura fuera de rango'),
  humedadAnormal('Humedad Anormal', 'Humedad fuera de rango'),
  vacunacionPendiente('Vacunación Pendiente', 'Vacuna programada vencida'),
  bioseguridadFallida('Bioseguridad Fallida', 'Incumplimiento de bioseguridad'),
  enfermedadConfirmada(
    'Enfermedad Confirmada',
    'Diagnóstico positivo de laboratorio',
  ),
  retiroActivo('Retiro Activo', 'Lote en período de retiro de medicamento'),
  otro('Otro', 'Otro tipo de alerta');

  const TipoAlertaSanitaria(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static TipoAlertaSanitaria fromJson(String json) {
    return TipoAlertaSanitaria.values.firstWhere(
      (t) => t.name == json,
      orElse: () => TipoAlertaSanitaria.otro,
    );
  }
}

/// Nivel de urgencia de la alerta.
enum NivelAlerta {
  informativo('Informativo', 'Para conocimiento', '#2196F3'),
  precaucion('Precaución', 'Requiere monitoreo', '#FF9800'),
  alerta('Alerta', 'Requiere acción pronto', '#F44336'),
  critico('Crítico', 'Acción inmediata requerida', '#9C27B0'),
  emergencia('Emergencia', 'Emergencia sanitaria', '#D32F2F');

  const NivelAlerta(this.nombre, this.descripcion, this.colorHex);

  final String nombre;
  final String descripcion;
  final String colorHex;

  String toJson() => name;

  static NivelAlerta fromJson(String json) {
    return NivelAlerta.values.firstWhere(
      (n) => n.name == json,
      orElse: () => NivelAlerta.informativo,
    );
  }
}

/// Estado de la alerta.
enum EstadoAlerta {
  activa('Activa', 'Alerta sin resolver'),
  enRevision('En Revisión', 'Siendo evaluada'),
  resuelta('Resuelta', 'Problema solucionado'),
  descartada('Descartada', 'Falsa alarma');

  const EstadoAlerta(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static EstadoAlerta fromJson(String json) {
    return EstadoAlerta.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoAlerta.activa,
    );
  }
}

/// Tipo de desviación de un indicador.
enum TipoDesviacion {
  superior('Superior', 'Por encima del umbral'),
  inferior('Inferior', 'Por debajo del umbral'),
  cambioRepentino('Cambio Repentino', 'Cambio brusco');

  const TipoDesviacion(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static TipoDesviacion fromJson(String json) {
    return TipoDesviacion.values.firstWhere(
      (t) => t.name == json,
      orElse: () => TipoDesviacion.superior,
    );
  }
}

/// Umbrales de alerta configurables.
class UmbralesAlerta {
  const UmbralesAlerta({
    this.mortalidadDiariaMaxima = 0.5, // 0.5%
    this.mortalidadAcumuladaMaxima = 5.0, // 5%
    this.consumoAguaDesviacionMaxima = 20.0, // 20% desviación
    this.consumoAlimentoDesviacionMaxima = 15.0, // 15% desviación
    this.produccionMinimaEsperada = 80.0, // 80% de producción
    this.temperaturaMinima = 18.0, // °C
    this.temperaturaMaxima = 32.0, // °C
    this.humedadMinima = 40.0, // %
    this.humedadMaxima = 70.0, // %
  });

  final double mortalidadDiariaMaxima;
  final double mortalidadAcumuladaMaxima;
  final double consumoAguaDesviacionMaxima;
  final double consumoAlimentoDesviacionMaxima;
  final double produccionMinimaEsperada;
  final double temperaturaMinima;
  final double temperaturaMaxima;
  final double humedadMinima;
  final double humedadMaxima;

  Map<String, dynamic> toJson() => {
    'mortalidadDiariaMaxima': mortalidadDiariaMaxima,
    'mortalidadAcumuladaMaxima': mortalidadAcumuladaMaxima,
    'consumoAguaDesviacionMaxima': consumoAguaDesviacionMaxima,
    'consumoAlimentoDesviacionMaxima': consumoAlimentoDesviacionMaxima,
    'produccionMinimaEsperada': produccionMinimaEsperada,
    'temperaturaMinima': temperaturaMinima,
    'temperaturaMaxima': temperaturaMaxima,
    'humedadMinima': humedadMinima,
    'humedadMaxima': humedadMaxima,
  };

  factory UmbralesAlerta.fromJson(Map<String, dynamic> json) {
    return UmbralesAlerta(
      mortalidadDiariaMaxima:
          (json['mortalidadDiariaMaxima'] as num?)?.toDouble() ?? 0.5,
      mortalidadAcumuladaMaxima:
          (json['mortalidadAcumuladaMaxima'] as num?)?.toDouble() ?? 5.0,
      consumoAguaDesviacionMaxima:
          (json['consumoAguaDesviacionMaxima'] as num?)?.toDouble() ?? 20.0,
      consumoAlimentoDesviacionMaxima:
          (json['consumoAlimentoDesviacionMaxima'] as num?)?.toDouble() ?? 15.0,
      produccionMinimaEsperada:
          (json['produccionMinimaEsperada'] as num?)?.toDouble() ?? 80.0,
      temperaturaMinima:
          (json['temperaturaMinima'] as num?)?.toDouble() ?? 18.0,
      temperaturaMaxima:
          (json['temperaturaMaxima'] as num?)?.toDouble() ?? 32.0,
      humedadMinima: (json['humedadMinima'] as num?)?.toDouble() ?? 40.0,
      humedadMaxima: (json['humedadMaxima'] as num?)?.toDouble() ?? 70.0,
    );
  }
}
