/// Entidad para calendario y seguimiento de eventos de salud.
library;

import 'package:equatable/equatable.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Evento de salud en el calendario.
class EventoSalud extends Equatable {
  const EventoSalud({
    required this.id,
    required this.granjaId,
    this.galponId,
    this.loteId,
    required this.tipo,
    required this.titulo,
    this.descripcion,
    required this.fechaProgramada,
    this.fechaEjecucion,
    required this.estado,
    this.recordatorioHoras = 24,
    this.ejecutadoPor,
    this.observaciones,
    this.documentoAdjunto,
    required this.prioridad,
    required this.creadoPor,
    required this.fechaCreacion,
  });

  /// ID único del evento.
  final String id;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón (opcional).
  final String? galponId;

  /// ID del lote (opcional).
  final String? loteId;

  /// Tipo de evento de salud.
  final TipoEventoSalud tipo;

  /// Título del evento.
  final String titulo;

  /// Descripción detallada.
  final String? descripcion;

  /// Fecha programada.
  final DateTime fechaProgramada;

  /// Fecha de ejecución real.
  final DateTime? fechaEjecucion;

  /// Estado del evento.
  final EstadoEventoSalud estado;

  /// Horas antes para recordatorio.
  final int recordatorioHoras;

  /// Usuario que ejecutó el evento.
  final String? ejecutadoPor;

  /// Observaciones.
  final String? observaciones;

  /// URL de documento adjunto.
  final String? documentoAdjunto;

  /// Prioridad del evento.
  final PrioridadEvento prioridad;

  /// Usuario que creó el evento.
  final String creadoPor;

  /// Fecha de creación.
  final DateTime fechaCreacion;

  // ==================== MÉTODOS AUXILIARES ====================

  /// Indica si el evento está pendiente.
  bool get estaPendiente =>
      estado == EstadoEventoSalud.pendiente ||
      estado == EstadoEventoSalud.programado;

  /// Indica si está vencido.
  bool get estaVencido =>
      estaPendiente && fechaProgramada.isBefore(DateTime.now());

  /// Indica si debe mostrar recordatorio.
  bool get mostrarRecordatorio {
    if (!estaPendiente) return false;
    final ahora = DateTime.now();
    final tiempoRestante = fechaProgramada.difference(ahora);
    return tiempoRestante.inHours <= recordatorioHoras &&
        tiempoRestante.inHours >= 0;
  }

  /// Días hasta el evento.
  int get diasHastaEvento => fechaProgramada.difference(DateTime.now()).inDays;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    loteId,
    tipo,
    titulo,
    descripcion,
    fechaProgramada,
    fechaEjecucion,
    estado,
    recordatorioHoras,
    ejecutadoPor,
    observaciones,
    documentoAdjunto,
    prioridad,
    creadoPor,
    fechaCreacion,
  ];

  EventoSalud copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    String? loteId,
    TipoEventoSalud? tipo,
    String? titulo,
    String? descripcion,
    DateTime? fechaProgramada,
    DateTime? fechaEjecucion,
    EstadoEventoSalud? estado,
    int? recordatorioHoras,
    String? ejecutadoPor,
    String? observaciones,
    String? documentoAdjunto,
    PrioridadEvento? prioridad,
    String? creadoPor,
    DateTime? fechaCreacion,
  }) {
    return EventoSalud(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      loteId: loteId ?? this.loteId,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaProgramada: fechaProgramada ?? this.fechaProgramada,
      fechaEjecucion: fechaEjecucion ?? this.fechaEjecucion,
      estado: estado ?? this.estado,
      recordatorioHoras: recordatorioHoras ?? this.recordatorioHoras,
      ejecutadoPor: ejecutadoPor ?? this.ejecutadoPor,
      observaciones: observaciones ?? this.observaciones,
      documentoAdjunto: documentoAdjunto ?? this.documentoAdjunto,
      prioridad: prioridad ?? this.prioridad,
      creadoPor: creadoPor ?? this.creadoPor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'granjaId': granjaId,
    'galponId': galponId,
    'loteId': loteId,
    'tipo': tipo.toJson(),
    'titulo': titulo,
    'descripcion': descripcion,
    'fechaProgramada': fechaProgramada.toIso8601String(),
    'fechaEjecucion': fechaEjecucion?.toIso8601String(),
    'estado': estado.toJson(),
    'recordatorioHoras': recordatorioHoras,
    'ejecutadoPor': ejecutadoPor,
    'observaciones': observaciones,
    'documentoAdjunto': documentoAdjunto,
    'prioridad': prioridad.toJson(),
    'creadoPor': creadoPor,
    'fechaCreacion': fechaCreacion.toIso8601String(),
  };

  factory EventoSalud.fromJson(Map<String, dynamic> json) {
    return EventoSalud(
      id: json['id'] as String,
      granjaId: json['granjaId'] as String,
      galponId: json['galponId'] as String?,
      loteId: json['loteId'] as String?,
      tipo: TipoEventoSalud.fromJson(json['tipo'] as String),
      titulo: json['titulo'] as String,
      descripcion: json['descripcion'] as String?,
      fechaProgramada: DateTime.parse(json['fechaProgramada'] as String),
      fechaEjecucion: json['fechaEjecucion'] != null
          ? DateTime.parse(json['fechaEjecucion'] as String)
          : null,
      estado: EstadoEventoSalud.fromJson(json['estado'] as String),
      recordatorioHoras: json['recordatorioHoras'] as int? ?? 24,
      ejecutadoPor: json['ejecutadoPor'] as String?,
      observaciones: json['observaciones'] as String?,
      documentoAdjunto: json['documentoAdjunto'] as String?,
      prioridad: PrioridadEvento.fromJson(json['prioridad'] as String),
      creadoPor: json['creadoPor'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }
}

/// Tipos de eventos de salud.
enum TipoEventoSalud {
  vacunacion('Vacunación', 'Aplicación de vacuna'),
  desparasitacion('Desparasitación', 'Tratamiento antiparasitario'),
  medicacion('Medicación', 'Tratamiento médico'),
  inspeccionBioseguridad(
    'Inspección Bioseguridad',
    'Auditoría de bioseguridad',
  ),
  muestreoLaboratorio('Muestreo Laboratorio', 'Toma de muestras'),
  visitaVeterinaria('Visita Veterinaria', 'Consulta veterinaria'),
  desinfeccion('Desinfección', 'Limpieza y desinfección'),
  controlPlagas('Control de Plagas', 'Aplicación de rodenticidas/insecticidas'),
  finRetiro('Fin de Retiro', 'Término de período de retiro'),
  revacunacion('Revacunación', 'Refuerzo de vacuna'),
  otro('Otro', 'Otro tipo de evento');

  const TipoEventoSalud(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static TipoEventoSalud fromJson(String json) {
    return TipoEventoSalud.values.firstWhere(
      (t) => t.name == json,
      orElse: () => TipoEventoSalud.otro,
    );
  }
}

/// Estado de un evento de salud.
enum EstadoEventoSalud {
  programado('Programado', 'Evento planificado'),
  pendiente('Pendiente', 'Próximo a realizar'),
  enProceso('En Proceso', 'Siendo ejecutado'),
  completado('Completado', 'Realizado exitosamente'),
  cancelado('Cancelado', 'Evento cancelado'),
  vencido('Vencido', 'No realizado a tiempo');

  const EstadoEventoSalud(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    return switch (this) {
      EstadoEventoSalud.programado => locale == 'pt' ? 'Programado' : 'Scheduled',
      EstadoEventoSalud.pendiente => locale == 'pt' ? 'Pendente' : 'Pending',
      EstadoEventoSalud.enProceso => locale == 'pt' ? 'Em Andamento' : 'In Progress',
      EstadoEventoSalud.completado => locale == 'pt' ? 'Concluído' : 'Completed',
      EstadoEventoSalud.cancelado => locale == 'pt' ? 'Cancelado' : 'Cancelled',
      EstadoEventoSalud.vencido => locale == 'pt' ? 'Vencido' : 'Overdue',
    };
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    return switch (this) {
      EstadoEventoSalud.programado => locale == 'pt' ? 'Evento planejado' : 'Planned event',
      EstadoEventoSalud.pendiente => locale == 'pt' ? 'Próximo' : 'Upcoming',
      EstadoEventoSalud.enProceso => locale == 'pt' ? 'Sendo executado' : 'Being executed',
      EstadoEventoSalud.completado => locale == 'pt' ? 'Concluído com sucesso' : 'Successfully done',
      EstadoEventoSalud.cancelado => locale == 'pt' ? 'Evento cancelado' : 'Event cancelled',
      EstadoEventoSalud.vencido => locale == 'pt' ? 'Não realizado a tempo' : 'Not done on time',
    };
  }

  String toJson() => name;

  static EstadoEventoSalud fromJson(String json) {
    return EstadoEventoSalud.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoEventoSalud.programado,
    );
  }
}

/// Prioridad de un evento.
enum PrioridadEvento {
  baja('Baja', 'Puede posponerse'),
  normal('Normal', 'Realizar según programa'),
  alta('Alta', 'Prioritario'),
  urgente('Urgente', 'Acción inmediata');

  const PrioridadEvento(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    return switch (this) {
      PrioridadEvento.baja => locale == 'pt' ? 'Baixa' : 'Low',
      PrioridadEvento.normal => 'Normal',
      PrioridadEvento.alta => locale == 'pt' ? 'Alta' : 'High',
      PrioridadEvento.urgente => locale == 'pt' ? 'Urgente' : 'Urgent',
    };
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    return switch (this) {
      PrioridadEvento.baja => locale == 'pt' ? 'Pode ser adiado' : 'Can be postponed',
      PrioridadEvento.normal => locale == 'pt' ? 'Seguir o cronograma' : 'Follow schedule',
      PrioridadEvento.alta => locale == 'pt' ? 'Prioritário' : 'Priority',
      PrioridadEvento.urgente => locale == 'pt' ? 'Ação imediata' : 'Immediate action',
    };
  }

  String toJson() => name;

  static PrioridadEvento fromJson(String json) {
    return PrioridadEvento.values.firstWhere(
      (p) => p.name == json,
      orElse: () => PrioridadEvento.normal,
    );
  }
}

/// Calendario de salud con eventos agrupados.
class CalendarioSalud extends Equatable {
  const CalendarioSalud({
    required this.granjaId,
    required this.eventos,
    required this.fechaInicio,
    required this.fechaFin,
  });

  final String granjaId;
  final List<EventoSalud> eventos;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  /// Eventos del día actual.
  List<EventoSalud> get eventosHoy {
    final hoy = DateTime.now();
    return eventos.where((e) {
      return e.fechaProgramada.year == hoy.year &&
          e.fechaProgramada.month == hoy.month &&
          e.fechaProgramada.day == hoy.day;
    }).toList();
  }

  /// Eventos de la semana actual.
  List<EventoSalud> get eventosSemana {
    final hoy = DateTime.now();
    final inicioSemana = hoy.subtract(Duration(days: hoy.weekday - 1));
    final finSemana = inicioSemana.add(const Duration(days: 7));
    return eventos.where((e) {
      return e.fechaProgramada.isAfter(inicioSemana) &&
          e.fechaProgramada.isBefore(finSemana);
    }).toList();
  }

  /// Eventos vencidos sin completar.
  List<EventoSalud> get eventosVencidos =>
      eventos.where((e) => e.estaVencido).toList();

  /// Eventos próximos (7 días).
  List<EventoSalud> get eventosProximos {
    final ahora = DateTime.now();
    final enUnaSemana = ahora.add(const Duration(days: 7));
    return eventos.where((e) {
      return e.estaPendiente &&
          e.fechaProgramada.isAfter(ahora) &&
          e.fechaProgramada.isBefore(enUnaSemana);
    }).toList();
  }

  /// Agrupa eventos por fecha.
  Map<DateTime, List<EventoSalud>> get eventosPorFecha {
    final Map<DateTime, List<EventoSalud>> agrupados = {};
    for (final evento in eventos) {
      final fecha = DateTime(
        evento.fechaProgramada.year,
        evento.fechaProgramada.month,
        evento.fechaProgramada.day,
      );
      agrupados.putIfAbsent(fecha, () => []).add(evento);
    }
    return agrupados;
  }

  /// Agrupa eventos por tipo.
  Map<TipoEventoSalud, List<EventoSalud>> get eventosPorTipo {
    final Map<TipoEventoSalud, List<EventoSalud>> agrupados = {};
    for (final evento in eventos) {
      agrupados.putIfAbsent(evento.tipo, () => []).add(evento);
    }
    return agrupados;
  }

  @override
  List<Object?> get props => [granjaId, eventos, fechaInicio, fechaFin];
}
