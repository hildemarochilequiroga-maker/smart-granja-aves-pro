/// Entidad que representa una inspección de bioseguridad.
library;

import 'package:equatable/equatable.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../enums/enums.dart';

/// Inspección de bioseguridad de una granja o galpón.
class InspeccionBioseguridad extends Equatable {
  const InspeccionBioseguridad({
    required this.id,
    required this.granjaId,
    this.galponId,
    required this.fecha,
    required this.items,
    required this.inspectorId,
    required this.inspectorNombre,
    this.observaciones,
    this.accionesCorrectivas,
    this.firmaDigital,
    required this.fechaCreacion,
  });

  /// ID único de la inspección.
  final String id;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón (opcional, puede ser inspección general).
  final String? galponId;

  /// Fecha de la inspección.
  final DateTime fecha;

  /// Items evaluados.
  final List<ItemInspeccion> items;

  /// ID del inspector.
  final String inspectorId;

  /// Nombre del inspector.
  final String inspectorNombre;

  /// Observaciones generales.
  final String? observaciones;

  /// Acciones correctivas recomendadas.
  final String? accionesCorrectivas;

  /// Firma digital o confirmación.
  final String? firmaDigital;

  /// Fecha de creación del registro.
  final DateTime fechaCreacion;

  // ==================== CÁLCULOS ====================

  /// Total de items evaluados.
  int get totalItems => items.length;

  /// Items que cumplen.
  int get itemsCumplen =>
      items.where((i) => i.estado == EstadoBioseguridad.cumple).length;

  /// Items que no cumplen.
  int get itemsNoCumplen =>
      items.where((i) => i.estado == EstadoBioseguridad.noCumple).length;

  /// Items con cumplimiento parcial.
  int get itemsParciales =>
      items.where((i) => i.estado == EstadoBioseguridad.parcial).length;

  /// Items pendientes por evaluar.
  int get itemsPendientes =>
      items.where((i) => i.estado == EstadoBioseguridad.pendiente).length;

  /// Items no aplicables.
  int get itemsNoAplica =>
      items.where((i) => i.estado == EstadoBioseguridad.noAplica).length;

  /// Items evaluables (excluyendo pendientes y N/A).
  int get itemsEvaluables => totalItems - itemsNoAplica - itemsPendientes;

  /// Porcentaje de cumplimiento.
  double get porcentajeCumplimiento {
    if (itemsEvaluables == 0) return 100.0;
    final cumplimiento = itemsCumplen + (itemsParciales * 0.5);
    return (cumplimiento / itemsEvaluables) * 100;
  }

  /// Nivel de riesgo basado en cumplimiento.
  NivelRiesgoBioseguridad get nivelRiesgo {
    final pct = porcentajeCumplimiento;
    if (pct >= 90) return NivelRiesgoBioseguridad.bajo;
    if (pct >= 70) return NivelRiesgoBioseguridad.medio;
    if (pct >= 50) return NivelRiesgoBioseguridad.alto;
    return NivelRiesgoBioseguridad.critico;
  }

  /// Verifica si hay items críticos sin cumplir.
  bool get tieneIncumplimientosCriticos =>
      items.any((i) => i.esCritico && i.estado == EstadoBioseguridad.noCumple);

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    fecha,
    items,
    inspectorId,
    inspectorNombre,
    observaciones,
    accionesCorrectivas,
    firmaDigital,
    fechaCreacion,
  ];

  InspeccionBioseguridad copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    DateTime? fecha,
    List<ItemInspeccion>? items,
    String? inspectorId,
    String? inspectorNombre,
    String? observaciones,
    String? accionesCorrectivas,
    String? firmaDigital,
    DateTime? fechaCreacion,
  }) {
    return InspeccionBioseguridad(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      fecha: fecha ?? this.fecha,
      items: items ?? this.items,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectorNombre: inspectorNombre ?? this.inspectorNombre,
      observaciones: observaciones ?? this.observaciones,
      accionesCorrectivas: accionesCorrectivas ?? this.accionesCorrectivas,
      firmaDigital: firmaDigital ?? this.firmaDigital,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'granjaId': granjaId,
    'galponId': galponId,
    'fecha': fecha.toIso8601String(),
    'fechaInspeccion': fecha.toIso8601String(),
    'items': items.map((i) => i.toJson()).toList(),
    'inspectorId': inspectorId,
    'inspectorNombre': inspectorNombre,
    'observaciones': observaciones,
    'accionesCorrectivas': accionesCorrectivas,
    'firmaDigital': firmaDigital,
    'porcentajeCumplimiento': porcentajeCumplimiento,
    'nivelRiesgo': nivelRiesgo.name,
    'tieneIncumplimientosCriticos': tieneIncumplimientosCriticos,
    'fechaCreacion': fechaCreacion.toIso8601String(),
  };

  factory InspeccionBioseguridad.fromJson(Map<String, dynamic> json) {
    final fechaRaw = json['fecha'] ?? json['fechaInspeccion'];
    return InspeccionBioseguridad(
      id: json['id'] as String,
      granjaId: json['granjaId'] as String,
      galponId: json['galponId'] as String?,
      fecha: _parseDateTime(fechaRaw),
      items: (json['items'] as List<dynamic>)
          .map((i) => ItemInspeccion.fromJson(i as Map<String, dynamic>))
          .toList(),
      inspectorId: json['inspectorId'] as String,
      inspectorNombre: json['inspectorNombre'] as String,
      observaciones: json['observaciones'] as String?,
      accionesCorrectivas: json['accionesCorrectivas'] as String?,
      firmaDigital: json['firmaDigital'] as String?,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value;
    return DateTime.parse(value as String);
  }
}

/// Item individual de inspección de bioseguridad.
class ItemInspeccion extends Equatable {
  const ItemInspeccion({
    required this.codigo,
    required this.descripcion,
    required this.categoria,
    required this.estado,
    this.observacion,
    this.evidenciaUrl,
    this.esCritico = false,
  });

  /// Código del item (ej: "ACC-01").
  final String codigo;

  /// Descripción del item a evaluar.
  final String descripcion;

  /// Categoría de bioseguridad.
  final CategoriaBioseguridad categoria;

  /// Estado de cumplimiento.
  final EstadoBioseguridad estado;

  /// Observación específica.
  final String? observacion;

  /// URL de foto como evidencia.
  final String? evidenciaUrl;

  /// Si es un item crítico.
  final bool esCritico;

  @override
  List<Object?> get props => [
    codigo,
    descripcion,
    categoria,
    estado,
    observacion,
    evidenciaUrl,
    esCritico,
  ];

  ItemInspeccion copyWith({
    String? codigo,
    String? descripcion,
    CategoriaBioseguridad? categoria,
    EstadoBioseguridad? estado,
    String? observacion,
    String? evidenciaUrl,
    bool? esCritico,
  }) {
    return ItemInspeccion(
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      estado: estado ?? this.estado,
      observacion: observacion ?? this.observacion,
      evidenciaUrl: evidenciaUrl ?? this.evidenciaUrl,
      esCritico: esCritico ?? this.esCritico,
    );
  }

  Map<String, dynamic> toJson() => {
    'codigo': codigo,
    'descripcion': descripcion,
    'categoria': categoria.toJson(),
    'estado': estado.toJson(),
    'observacion': observacion,
    'evidenciaUrl': evidenciaUrl,
    'esCritico': esCritico,
  };

  factory ItemInspeccion.fromJson(Map<String, dynamic> json) {
    return ItemInspeccion(
      codigo: json['codigo'] as String,
      descripcion: json['descripcion'] as String,
      categoria: CategoriaBioseguridad.fromJson(json['categoria'] as String),
      estado: EstadoBioseguridad.fromJson(json['estado'] as String),
      observacion: json['observacion'] as String?,
      evidenciaUrl: json['evidenciaUrl'] as String?,
      esCritico: json['esCritico'] as bool? ?? false,
    );
  }
}

/// Nivel de riesgo de bioseguridad.
enum NivelRiesgoBioseguridad {
  bajo('Bajo', 'Cumplimiento óptimo', '#4CAF50'),
  medio('Medio', 'Requiere mejoras', '#FF9800'),
  alto('Alto', 'Riesgo significativo', '#F44336'),
  critico('Crítico', 'Acción inmediata requerida', '#9C27B0');

  const NivelRiesgoBioseguridad(this.nombre, this.descripcion, this.colorHex);

  final String nombre;
  final String descripcion;
  final String colorHex;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    return switch (this) {
      NivelRiesgoBioseguridad.bajo => locale == 'pt' ? 'Baixa' : 'Low',
      NivelRiesgoBioseguridad.medio => locale == 'pt' ? 'Médio' : 'Medium',
      NivelRiesgoBioseguridad.alto => locale == 'pt' ? 'Alta' : 'High',
      NivelRiesgoBioseguridad.critico => locale == 'pt' ? 'Crítica' : 'Critical',
    };
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    return switch (this) {
      NivelRiesgoBioseguridad.bajo => locale == 'pt' ? 'Conformidade ótima' : 'Optimal compliance',
      NivelRiesgoBioseguridad.medio => locale == 'pt' ? 'Precisa melhorar' : 'Needs improvement',
      NivelRiesgoBioseguridad.alto => locale == 'pt' ? 'Risco significativo' : 'Significant risk',
      NivelRiesgoBioseguridad.critico => locale == 'pt' ? 'Ação imediata necessária' : 'Immediate action required',
    };
  }
}

/// Plantilla de checklist de bioseguridad estándar.
class PlantillaBioseguridad {
  /// Obtiene los items estándar para una inspección completa.
  static List<ItemInspeccion> itemsEstandar() {
    return [
      // ACCESO DE PERSONAL
      const ItemInspeccion(
        codigo: 'ACC-01',
        descripcion: 'Existe arco o pediluvio sanitario funcional',
        categoria: CategoriaBioseguridad.accesoPersonal,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'ACC-02',
        descripcion: 'Personal usa ropa y calzado exclusivo de granja',
        categoria: CategoriaBioseguridad.accesoPersonal,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'ACC-03',
        descripcion: 'Existe registro de visitantes',
        categoria: CategoriaBioseguridad.accesoPersonal,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'ACC-04',
        descripcion:
            'Se cumple período de vacío sanitario entre visitas a otras granjas',
        categoria: CategoriaBioseguridad.accesoPersonal,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),

      // ACCESO DE VEHÍCULOS
      const ItemInspeccion(
        codigo: 'VEH-01',
        descripcion: 'Vehículos son desinfectados antes de entrar',
        categoria: CategoriaBioseguridad.accesoVehiculos,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'VEH-02',
        descripcion: 'Área de carga/descarga está separada de galpones',
        categoria: CategoriaBioseguridad.accesoVehiculos,
        estado: EstadoBioseguridad.pendiente,
      ),

      // LIMPIEZA Y DESINFECCIÓN
      const ItemInspeccion(
        codigo: 'LIM-01',
        descripcion: 'Galpones limpios y sin acumulación de pollinaza',
        categoria: CategoriaBioseguridad.limpiezaDesinfeccion,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'LIM-02',
        descripcion: 'Equipos de alimentación limpios',
        categoria: CategoriaBioseguridad.limpiezaDesinfeccion,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'LIM-03',
        descripcion: 'Bebederos limpios y sin biofilm',
        categoria: CategoriaBioseguridad.limpiezaDesinfeccion,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'LIM-04',
        descripcion: 'Se realiza desinfección periódica de instalaciones',
        categoria: CategoriaBioseguridad.limpiezaDesinfeccion,
        estado: EstadoBioseguridad.pendiente,
      ),

      // CONTROL DE PLAGAS
      const ItemInspeccion(
        codigo: 'PLA-01',
        descripcion: 'Programa de control de roedores activo',
        categoria: CategoriaBioseguridad.controlPlagas,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'PLA-02',
        descripcion: 'Mallas antipajaros en buen estado',
        categoria: CategoriaBioseguridad.controlPlagas,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'PLA-03',
        descripcion: 'Control de moscas y otros insectos',
        categoria: CategoriaBioseguridad.controlPlagas,
        estado: EstadoBioseguridad.pendiente,
      ),

      // MANEJO DE MORTALIDAD
      const ItemInspeccion(
        codigo: 'MOR-01',
        descripcion: 'Aves muertas se retiran y disponen diariamente',
        categoria: CategoriaBioseguridad.manejoMortalidad,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'MOR-02',
        descripcion: 'Existe compostador o fosa séptica adecuada',
        categoria: CategoriaBioseguridad.manejoMortalidad,
        estado: EstadoBioseguridad.pendiente,
      ),

      // AGUA
      const ItemInspeccion(
        codigo: 'AGU-01',
        descripcion: 'Agua potable con cloración adecuada (2-5 ppm)',
        categoria: CategoriaBioseguridad.agua,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
      const ItemInspeccion(
        codigo: 'AGU-02',
        descripcion: 'Tanques de agua limpios y tapados',
        categoria: CategoriaBioseguridad.agua,
        estado: EstadoBioseguridad.pendiente,
      ),

      // ALIMENTO
      const ItemInspeccion(
        codigo: 'ALI-01',
        descripcion: 'Alimento almacenado correctamente (seco, sin plagas)',
        categoria: CategoriaBioseguridad.alimento,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'ALI-02',
        descripcion: 'Silos limpios y sin residuos viejos',
        categoria: CategoriaBioseguridad.alimento,
        estado: EstadoBioseguridad.pendiente,
      ),

      // INSTALACIONES
      const ItemInspeccion(
        codigo: 'INS-01',
        descripcion: 'Cerco perimetral en buen estado',
        categoria: CategoriaBioseguridad.instalaciones,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'INS-02',
        descripcion: 'Galpones sin huecos ni aberturas',
        categoria: CategoriaBioseguridad.instalaciones,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'INS-03',
        descripcion: 'Ventilación funcionando correctamente',
        categoria: CategoriaBioseguridad.instalaciones,
        estado: EstadoBioseguridad.pendiente,
      ),

      // REGISTROS
      const ItemInspeccion(
        codigo: 'REG-01',
        descripcion: 'Registros de mortalidad al día',
        categoria: CategoriaBioseguridad.registros,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'REG-02',
        descripcion: 'Registros de vacunación completos',
        categoria: CategoriaBioseguridad.registros,
        estado: EstadoBioseguridad.pendiente,
      ),
      const ItemInspeccion(
        codigo: 'REG-03',
        descripcion: 'Registros de uso de medicamentos actualizados',
        categoria: CategoriaBioseguridad.registros,
        estado: EstadoBioseguridad.pendiente,
        esCritico: true,
      ),
    ];
  }
}
