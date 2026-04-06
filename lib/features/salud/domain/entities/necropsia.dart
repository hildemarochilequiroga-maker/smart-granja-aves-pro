/// Entidad para registro de necropsias/exámenes post-mortem.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Registro de necropsia o examen post-mortem de aves.
class Necropsia extends Equatable {
  const Necropsia({
    required this.id,
    required this.granjaId,
    required this.galponId,
    required this.loteId,
    required this.fecha,
    required this.numeroAvesExaminadas,
    required this.hallazgos,
    this.diagnosticoPresuntivo,
    this.diagnosticoConfirmado,
    this.enfermedadDetectada,
    this.fotografias = const [],
    this.muestrasLaboratorio = const [],
    this.recomendaciones,
    required this.realizadoPor,
    this.veterinarioId,
    this.veterinarioNombre,
    required this.fechaCreacion,
  });

  /// ID único del registro.
  final String id;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón.
  final String galponId;

  /// ID del lote.
  final String loteId;

  /// Fecha del examen.
  final DateTime fecha;

  /// Número de aves examinadas.
  final int numeroAvesExaminadas;

  /// Hallazgos anatómicos observados.
  final List<HallazgoNecropsia> hallazgos;

  /// Diagnóstico presuntivo inicial.
  final String? diagnosticoPresuntivo;

  /// Diagnóstico confirmado (después de laboratorio).
  final String? diagnosticoConfirmado;

  /// Enfermedad detectada (si aplica).
  final EnfermedadAvicola? enfermedadDetectada;

  /// URLs de fotografías de evidencia.
  final List<String> fotografias;

  /// Muestras enviadas a laboratorio.
  final List<MuestraLaboratorio> muestrasLaboratorio;

  /// Recomendaciones post-diagnóstico.
  final String? recomendaciones;

  /// Quién realizó la necropsia.
  final String realizadoPor;

  /// ID del veterinario (si aplica).
  final String? veterinarioId;

  /// Nombre del veterinario.
  final String? veterinarioNombre;

  /// Fecha de creación del registro.
  final DateTime fechaCreacion;

  /// Indica si tiene resultados de laboratorio pendientes.
  bool get tieneResultadosPendientes =>
      muestrasLaboratorio.any((m) => m.resultado == null);

  /// Indica si es un caso confirmado de enfermedad.
  bool get esCasoConfirmado =>
      diagnosticoConfirmado != null || enfermedadDetectada != null;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    loteId,
    fecha,
    numeroAvesExaminadas,
    hallazgos,
    diagnosticoPresuntivo,
    diagnosticoConfirmado,
    enfermedadDetectada,
    fotografias,
    muestrasLaboratorio,
    recomendaciones,
    realizadoPor,
    veterinarioId,
    veterinarioNombre,
    fechaCreacion,
  ];

  Necropsia copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    String? loteId,
    DateTime? fecha,
    int? numeroAvesExaminadas,
    List<HallazgoNecropsia>? hallazgos,
    String? diagnosticoPresuntivo,
    String? diagnosticoConfirmado,
    EnfermedadAvicola? enfermedadDetectada,
    List<String>? fotografias,
    List<MuestraLaboratorio>? muestrasLaboratorio,
    String? recomendaciones,
    String? realizadoPor,
    String? veterinarioId,
    String? veterinarioNombre,
    DateTime? fechaCreacion,
  }) {
    return Necropsia(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      loteId: loteId ?? this.loteId,
      fecha: fecha ?? this.fecha,
      numeroAvesExaminadas: numeroAvesExaminadas ?? this.numeroAvesExaminadas,
      hallazgos: hallazgos ?? this.hallazgos,
      diagnosticoPresuntivo:
          diagnosticoPresuntivo ?? this.diagnosticoPresuntivo,
      diagnosticoConfirmado:
          diagnosticoConfirmado ?? this.diagnosticoConfirmado,
      enfermedadDetectada: enfermedadDetectada ?? this.enfermedadDetectada,
      fotografias: fotografias ?? this.fotografias,
      muestrasLaboratorio: muestrasLaboratorio ?? this.muestrasLaboratorio,
      recomendaciones: recomendaciones ?? this.recomendaciones,
      realizadoPor: realizadoPor ?? this.realizadoPor,
      veterinarioId: veterinarioId ?? this.veterinarioId,
      veterinarioNombre: veterinarioNombre ?? this.veterinarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'granjaId': granjaId,
    'galponId': galponId,
    'loteId': loteId,
    'fecha': fecha.toIso8601String(),
    'numeroAvesExaminadas': numeroAvesExaminadas,
    'hallazgos': hallazgos.map((h) => h.toJson()).toList(),
    'diagnosticoPresuntivo': diagnosticoPresuntivo,
    'diagnosticoConfirmado': diagnosticoConfirmado,
    'enfermedadDetectada': enfermedadDetectada?.toJson(),
    'fotografias': fotografias,
    'muestrasLaboratorio': muestrasLaboratorio.map((m) => m.toJson()).toList(),
    'recomendaciones': recomendaciones,
    'realizadoPor': realizadoPor,
    'veterinarioId': veterinarioId,
    'veterinarioNombre': veterinarioNombre,
    'fechaCreacion': fechaCreacion.toIso8601String(),
  };

  factory Necropsia.fromJson(Map<String, dynamic> json) {
    return Necropsia(
      id: json['id'] as String,
      granjaId: json['granjaId'] as String,
      galponId: json['galponId'] as String,
      loteId: json['loteId'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      numeroAvesExaminadas: json['numeroAvesExaminadas'] as int,
      hallazgos: (json['hallazgos'] as List<dynamic>)
          .map((h) => HallazgoNecropsia.fromJson(h as Map<String, dynamic>))
          .toList(),
      diagnosticoPresuntivo: json['diagnosticoPresuntivo'] as String?,
      diagnosticoConfirmado: json['diagnosticoConfirmado'] as String?,
      enfermedadDetectada: json['enfermedadDetectada'] != null
          ? EnfermedadAvicola.fromJson(json['enfermedadDetectada'] as String)
          : null,
      fotografias:
          (json['fotografias'] as List<dynamic>?)
              ?.map((f) => f as String)
              .toList() ??
          [],
      muestrasLaboratorio:
          (json['muestrasLaboratorio'] as List<dynamic>?)
              ?.map(
                (m) => MuestraLaboratorio.fromJson(m as Map<String, dynamic>),
              )
              .toList() ??
          [],
      recomendaciones: json['recomendaciones'] as String?,
      realizadoPor: json['realizadoPor'] as String,
      veterinarioId: json['veterinarioId'] as String?,
      veterinarioNombre: json['veterinarioNombre'] as String?,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }
}

/// Hallazgo anatómico durante la necropsia.
class HallazgoNecropsia extends Equatable {
  const HallazgoNecropsia({
    required this.organo,
    required this.descripcion,
    this.severidad = SeveridadHallazgo.leve,
    this.fotografiaUrl,
  });

  /// Órgano o sistema afectado.
  final OrganoAfectado organo;

  /// Descripción del hallazgo.
  final String descripcion;

  /// Severidad del hallazgo.
  final SeveridadHallazgo severidad;

  /// URL de fotografía del hallazgo.
  final String? fotografiaUrl;

  @override
  List<Object?> get props => [organo, descripcion, severidad, fotografiaUrl];

  Map<String, dynamic> toJson() => {
    'organo': organo.toJson(),
    'descripcion': descripcion,
    'severidad': severidad.toJson(),
    'fotografiaUrl': fotografiaUrl,
  };

  factory HallazgoNecropsia.fromJson(Map<String, dynamic> json) {
    return HallazgoNecropsia(
      organo: OrganoAfectado.fromJson(json['organo'] as String),
      descripcion: json['descripcion'] as String,
      severidad: json['severidad'] != null
          ? SeveridadHallazgo.fromJson(json['severidad'] as String)
          : SeveridadHallazgo.leve,
      fotografiaUrl: json['fotografiaUrl'] as String?,
    );
  }
}

/// Órgano o sistema anatómico del ave.
enum OrganoAfectado {
  sistemaRespiratorio(
    'Sistema Respiratorio',
    'Tráquea, pulmones, sacos aéreos',
  ),
  sistemaDigestivo('Sistema Digestivo', 'Buche, intestinos, hígado, páncreas'),
  sistemaInmune(
    'Sistema Inmune',
    'Bolsa de Fabricio, timo, bazo, tonsilas cecales',
  ),
  sistemaReproductivo('Sistema Reproductivo', 'Ovarios, oviducto, testículos'),
  sistemaNervioso('Sistema Nervioso', 'Cerebro, médula espinal'),
  piel('Piel y Plumas', 'Tegumento, folículos, cresta'),
  patas('Patas', 'Articulaciones, almohadillas'),
  corazon('Corazón', 'Miocardio, pericardio'),
  rinones('Riñones', 'Tejido renal'),
  musculos('Músculos', 'Pectorales, muslos'),
  ojos('Ojos', 'Globo ocular, párpados'),
  articulaciones('Articulaciones', 'Corvejón, rodilla');

  const OrganoAfectado(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static OrganoAfectado fromJson(String json) {
    return OrganoAfectado.values.firstWhere(
      (o) => o.name == json,
      orElse: () => OrganoAfectado.sistemaDigestivo,
    );
  }
}

/// Severidad de un hallazgo.
enum SeveridadHallazgo {
  leve('Leve', 'Cambios menores'),
  moderado('Moderado', 'Cambios significativos'),
  severo('Severo', 'Daño extenso'),
  critico('Crítico', 'Compromiso vital');

  const SeveridadHallazgo(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static SeveridadHallazgo fromJson(String json) {
    return SeveridadHallazgo.values.firstWhere(
      (s) => s.name == json,
      orElse: () => SeveridadHallazgo.leve,
    );
  }
}

/// Muestra enviada a laboratorio.
class MuestraLaboratorio extends Equatable {
  const MuestraLaboratorio({
    required this.id,
    required this.tipo,
    required this.fechaEnvio,
    this.laboratorio,
    this.fechaResultado,
    this.resultado,
  });

  /// ID de la muestra.
  final String id;

  /// Tipo de muestra.
  final TipoMuestra tipo;

  /// Fecha de envío al laboratorio.
  final DateTime fechaEnvio;

  /// Nombre del laboratorio.
  final String? laboratorio;

  /// Fecha de resultado.
  final DateTime? fechaResultado;

  /// Resultado del análisis.
  final String? resultado;

  @override
  List<Object?> get props => [
    id,
    tipo,
    fechaEnvio,
    laboratorio,
    fechaResultado,
    resultado,
  ];

  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo.toJson(),
    'fechaEnvio': fechaEnvio.toIso8601String(),
    'laboratorio': laboratorio,
    'fechaResultado': fechaResultado?.toIso8601String(),
    'resultado': resultado,
  };

  factory MuestraLaboratorio.fromJson(Map<String, dynamic> json) {
    return MuestraLaboratorio(
      id: json['id'] as String,
      tipo: TipoMuestra.fromJson(json['tipo'] as String),
      fechaEnvio: DateTime.parse(json['fechaEnvio'] as String),
      laboratorio: json['laboratorio'] as String?,
      fechaResultado: json['fechaResultado'] != null
          ? DateTime.parse(json['fechaResultado'] as String)
          : null,
      resultado: json['resultado'] as String?,
    );
  }
}

/// Tipos de muestras para laboratorio.
enum TipoMuestra {
  sangre('Sangre', 'Para serología y hematología'),
  hisopado('Hisopado', 'Cloacal, traqueal u ocular'),
  tejido('Tejido', 'Órganos afectados'),
  heces('Heces', 'Materia fecal'),
  alimento('Alimento', 'Muestras de pienso'),
  agua('Agua', 'Muestras de agua de bebida'),
  ambiente('Ambiente', 'Hisopados de superficies');

  const TipoMuestra(this.nombre, this.descripcion);

  final String nombre;
  final String descripcion;

  String toJson() => name;

  static TipoMuestra fromJson(String json) {
    return TipoMuestra.values.firstWhere(
      (t) => t.name == json,
      orElse: () => TipoMuestra.tejido,
    );
  }
}
