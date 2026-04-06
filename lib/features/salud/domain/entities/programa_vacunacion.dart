/// Entidad que representa un programa de vacunación estándar.
///
/// Basado en las guías de Cobb Genetics y Aviagen.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Programa de vacunación para un tipo de ave específico.
class ProgramaVacunacion extends Equatable {
  const ProgramaVacunacion({
    required this.id,
    required this.nombre,
    required this.tipoAve,
    required this.descripcion,
    required this.vacunas,
    this.esPlantilla = true,
    this.granjaId,
    this.activo = true,
    required this.creadoPor,
    required this.fechaCreacion,
  });

  /// ID único del programa.
  final String id;

  /// Nombre del programa.
  final String nombre;

  /// Tipo de ave al que aplica.
  final TipoAveProduccion tipoAve;

  /// Descripción del programa.
  final String descripcion;

  /// Lista de vacunas programadas.
  final List<VacunaProgramada> vacunas;

  /// Si es una plantilla reutilizable.
  final bool esPlantilla;

  /// ID de la granja (null si es plantilla global).
  final String? granjaId;

  /// Si está activo.
  final bool activo;

  /// Usuario que creó el programa.
  final String creadoPor;

  /// Fecha de creación.
  final DateTime fechaCreacion;

  /// Total de vacunas en el programa.
  int get totalVacunas => vacunas.length;

  /// Vacunas ordenadas por edad de aplicación.
  List<VacunaProgramada> get vacunasOrdenadas {
    final sorted = List<VacunaProgramada>.from(vacunas);
    sorted.sort((a, b) => a.edadDias.compareTo(b.edadDias));
    return sorted;
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    tipoAve,
    descripcion,
    vacunas,
    esPlantilla,
    granjaId,
    activo,
    creadoPor,
    fechaCreacion,
  ];

  ProgramaVacunacion copyWith({
    String? id,
    String? nombre,
    TipoAveProduccion? tipoAve,
    String? descripcion,
    List<VacunaProgramada>? vacunas,
    bool? esPlantilla,
    String? granjaId,
    bool? activo,
    String? creadoPor,
    DateTime? fechaCreacion,
  }) {
    return ProgramaVacunacion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      tipoAve: tipoAve ?? this.tipoAve,
      descripcion: descripcion ?? this.descripcion,
      vacunas: vacunas ?? this.vacunas,
      esPlantilla: esPlantilla ?? this.esPlantilla,
      granjaId: granjaId ?? this.granjaId,
      activo: activo ?? this.activo,
      creadoPor: creadoPor ?? this.creadoPor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'tipoAve': tipoAve.toJson(),
    'descripcion': descripcion,
    'vacunas': vacunas.map((v) => v.toJson()).toList(),
    'esPlantilla': esPlantilla,
    'granjaId': granjaId,
    'activo': activo,
    'creadoPor': creadoPor,
    'fechaCreacion': fechaCreacion.toIso8601String(),
  };

  factory ProgramaVacunacion.fromJson(Map<String, dynamic> json) {
    return ProgramaVacunacion(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      tipoAve: TipoAveProduccion.fromJson(json['tipoAve'] as String),
      descripcion: json['descripcion'] as String,
      vacunas: (json['vacunas'] as List<dynamic>)
          .map((v) => VacunaProgramada.fromJson(v as Map<String, dynamic>))
          .toList(),
      esPlantilla: json['esPlantilla'] as bool? ?? true,
      granjaId: json['granjaId'] as String?,
      activo: json['activo'] as bool? ?? true,
      creadoPor: json['creadoPor'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }

  // ==================== PLANTILLAS PREDEFINIDAS ====================

  /// Programa estándar para pollo de engorde (Broiler).
  static ProgramaVacunacion plantillaBroiler() {
    return ProgramaVacunacion(
      id: 'plantilla_broiler',
      nombre: 'Programa Estándar Broiler',
      tipoAve: TipoAveProduccion.polloCarne,
      descripcion:
          'Programa de vacunación básico para pollo de engorde (6-8 semanas)',
      vacunas: const [
        VacunaProgramada(
          nombre: 'Marek',
          enfermedad: EnfermedadAvicola.marek,
          edadDias: 0,
          via: ViaAdministracion.inyeccionSubcutanea,
          esObligatoria: true,
          notas: 'Aplicar en incubadora o día 1',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis (Primer)',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 1,
          via: ViaAdministracion.spray,
          esObligatoria: true,
          notas: 'Vacuna combinada ND-IB',
        ),
        VacunaProgramada(
          nombre: 'Gumboro (Primera)',
          enfermedad: EnfermedadAvicola.gumboro,
          edadDias: 7,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Intermedia o intermedia plus según presión',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis (Refuerzo)',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 14,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Refuerzo ND-IB',
        ),
        VacunaProgramada(
          nombre: 'Gumboro (Refuerzo)',
          enfermedad: EnfermedadAvicola.gumboro,
          edadDias: 21,
          via: ViaAdministracion.agua,
          esObligatoria: false,
          notas: 'Solo si hay alta presión de campo',
        ),
      ],
      esPlantilla: true,
      activo: true,
      creadoPor: 'sistema',
      fechaCreacion: DateTime(2024, 1, 1),
    );
  }

  /// Programa estándar para ponedora comercial.
  static ProgramaVacunacion plantillaPonedora() {
    return ProgramaVacunacion(
      id: 'plantilla_ponedora',
      nombre: 'Programa Estándar Ponedora Comercial',
      tipoAve: TipoAveProduccion.gallinaPonedoraComercial,
      descripcion:
          'Programa de vacunación completo para gallina ponedora comercial',
      vacunas: const [
        VacunaProgramada(
          nombre: 'Marek',
          enfermedad: EnfermedadAvicola.marek,
          edadDias: 0,
          via: ViaAdministracion.inyeccionSubcutanea,
          esObligatoria: true,
          notas: 'HVT + Rispens recomendado',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 1,
          via: ViaAdministracion.spray,
          esObligatoria: true,
          notas: 'Primera dosis',
        ),
        VacunaProgramada(
          nombre: 'Coccidiosis',
          enfermedad: EnfermedadAvicola.coccidiosis,
          edadDias: 3,
          via: ViaAdministracion.spray,
          esObligatoria: false,
          notas: 'Alternativa a anticoccidiales en alimento',
        ),
        VacunaProgramada(
          nombre: 'Gumboro (Primera)',
          enfermedad: EnfermedadAvicola.gumboro,
          edadDias: 7,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Vacuna intermedia',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis (2da)',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 14,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Refuerzo',
        ),
        VacunaProgramada(
          nombre: 'Gumboro (Refuerzo)',
          enfermedad: EnfermedadAvicola.gumboro,
          edadDias: 21,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Vacuna intermedia plus',
        ),
        VacunaProgramada(
          nombre: 'Viruela Aviar',
          enfermedad: EnfermedadAvicola.viruelaAviar,
          edadDias: 28,
          via: ViaAdministracion.ala,
          esObligatoria: false,
          notas: 'En zonas endémicas',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis (3ra)',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 35,
          via: ViaAdministracion.agua,
          esObligatoria: true,
          notas: 'Tercer refuerzo',
        ),
        VacunaProgramada(
          nombre: 'Encefalomielitis Aviar',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 56,
          via: ViaAdministracion.agua,
          esObligatoria: false,
          notas: 'Semana 8',
        ),
        VacunaProgramada(
          nombre: 'Coriza Infecciosa',
          enfermedad: EnfermedadAvicola.coriza,
          edadDias: 63,
          via: ViaAdministracion.inyeccionSubcutanea,
          esObligatoria: false,
          notas: 'En zonas endémicas - Semana 9',
        ),
        VacunaProgramada(
          nombre: 'Newcastle + Bronquitis (Inactivada)',
          enfermedad: EnfermedadAvicola.newcastle,
          edadDias: 84,
          via: ViaAdministracion.inyeccionIntramuscular,
          esObligatoria: true,
          notas: 'Vacuna oleosa - Semana 12',
        ),
        VacunaProgramada(
          nombre: 'Salmonella',
          enfermedad: EnfermedadAvicola.salmonelosis,
          edadDias: 98,
          via: ViaAdministracion.inyeccionSubcutanea,
          esObligatoria: false,
          notas: 'Bacterina - Semana 14',
        ),
      ],
      esPlantilla: true,
      activo: true,
      creadoPor: 'sistema',
      fechaCreacion: DateTime(2024, 1, 1),
    );
  }

  /// Obtiene todas las plantillas predefinidas.
  static List<ProgramaVacunacion> plantillasPredefinidas() {
    return [plantillaBroiler(), plantillaPonedora()];
  }
}

/// Vacuna programada dentro de un programa de vacunación.
class VacunaProgramada extends Equatable {
  const VacunaProgramada({
    String? id,
    required this.nombre,
    required this.enfermedad,
    required this.edadDias,
    required this.via,
    this.esObligatoria = true,
    this.notas,
  }) : id = id ?? '';

  /// ID único de la vacuna programada.
  final String id;

  /// Nombre de la vacuna.
  final String nombre;

  /// Enfermedad que previene.
  final EnfermedadAvicola enfermedad;

  /// Edad en días para aplicación.
  final int edadDias;

  /// Vía de administración.
  final ViaAdministracion via;

  /// Si es obligatoria en el programa.
  final bool esObligatoria;

  /// Notas adicionales.
  final String? notas;

  /// Edad en semanas.
  int get edadSemanas => (edadDias / 7).floor();

  /// Descripción de edad formateada.
  String get edadFormateada {
    if (edadDias == 0) return 'Día 1 (Nacimiento)';
    if (edadDias < 7) return 'Día $edadDias';
    final semanas = edadSemanas;
    final diasRestantes = edadDias % 7;
    if (diasRestantes == 0) return 'Semana $semanas';
    return 'Semana $semanas, día $diasRestantes';
  }

  @override
  List<Object?> get props => [
    id,
    nombre,
    enfermedad,
    edadDias,
    via,
    esObligatoria,
    notas,
  ];

  /// Alias: día de aplicación (igual a edadDias).
  int get diaAplicacion => edadDias;

  /// Alias: nombre de la vacuna.
  String get vacuna => nombre;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'enfermedad': enfermedad.toJson(),
    'edadDias': edadDias,
    'via': via.toJson(),
    'esObligatoria': esObligatoria,
    'notas': notas,
  };

  factory VacunaProgramada.fromJson(Map<String, dynamic> json) {
    return VacunaProgramada(
      id: json['id'] as String? ?? '',
      nombre: json['nombre'] as String,
      enfermedad: EnfermedadAvicola.fromJson(json['enfermedad'] as String),
      edadDias: json['edadDias'] as int,
      via: ViaAdministracion.fromJson(json['via'] as String),
      esObligatoria: json['esObligatoria'] as bool? ?? true,
      notas: json['notas'] as String?,
    );
  }
}
