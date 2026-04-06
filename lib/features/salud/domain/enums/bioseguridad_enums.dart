/// Estados de inspección de bioseguridad.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Estado de cumplimiento de un item de bioseguridad.
enum EstadoBioseguridad {
  pendiente('Pendiente', '•', '#B0BEC5'),
  cumple('Cumple', '✓', '#4CAF50'),
  noCumple('No Cumple', '✗', '#F44336'),
  parcial('Parcial', '~', '#FF9800'),
  noAplica('N/A', '-', '#9E9E9E');

  const EstadoBioseguridad(this.nombre, this.simbolo, this.colorHex);

  final String nombre;
  final String simbolo;
  final String colorHex;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case EstadoBioseguridad.pendiente:
        return locale == 'pt' ? 'Pendente' : 'Pending';
      case EstadoBioseguridad.cumple:
        return locale == 'pt' ? 'Conforme' : 'Compliant';
      case EstadoBioseguridad.noCumple:
        return locale == 'pt' ? 'Não Conforme' : 'Non-Compliant';
      case EstadoBioseguridad.parcial:
        return locale == 'pt' ? 'Parcial' : 'Partial';
      case EstadoBioseguridad.noAplica:
        return 'N/A';
    }
  }

  String toJson() => name;

  static EstadoBioseguridad fromJson(String json) {
    return EstadoBioseguridad.values.firstWhere(
      (e) => e.name == json,
      orElse: () => EstadoBioseguridad.pendiente,
    );
  }
}

/// Categorías de checklist de bioseguridad.
enum CategoriaBioseguridad {
  accesoPersonal(
    'Acceso de Personal',
    'Control de ingreso y vestimenta',
    1,
    'person_outline',
  ),
  accesoVehiculos(
    'Acceso de Vehículos',
    'Control de vehículos y equipos',
    2,
    'local_shipping',
  ),
  limpiezaDesinfeccion(
    'Limpieza y Desinfección',
    'Protocolos de higiene',
    3,
    'cleaning_services',
  ),
  controlPlagas(
    'Control de Plagas',
    'Roedores, insectos, aves silvestres',
    4,
    'pest_control',
  ),
  manejoAves('Manejo de Aves', 'Prácticas con las aves', 5, 'egg'),
  manejoMortalidad(
    'Manejo de Mortalidad',
    'Disposición de aves muertas',
    6,
    'delete_outline',
  ),
  agua('Calidad del Agua', 'Potabilidad y cloración', 7, 'water_drop'),
  alimento('Manejo de Alimento', 'Almacenamiento y calidad', 8, 'restaurant'),
  instalaciones(
    'Instalaciones',
    'Estado de galpones y equipos',
    9,
    'warehouse',
  ),
  registros('Registros', 'Documentación y trazabilidad', 10, 'description');

  const CategoriaBioseguridad(
    this.nombre,
    this.descripcion,
    this.orden,
    this.icono,
  );

  final String nombre;
  final String descripcion;
  final int orden;
  final String icono;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case CategoriaBioseguridad.accesoPersonal:
        return locale == 'pt' ? 'Acesso de Pessoal' : 'Personnel Access';
      case CategoriaBioseguridad.accesoVehiculos:
        return locale == 'pt' ? 'Acesso de Veículos' : 'Vehicle Access';
      case CategoriaBioseguridad.limpiezaDesinfeccion:
        return locale == 'pt' ? 'Limpeza e Desinfecção' : 'Cleaning and Disinfection';
      case CategoriaBioseguridad.controlPlagas:
        return locale == 'pt' ? 'Controle de Pragas' : 'Pest Control';
      case CategoriaBioseguridad.manejoAves:
        return locale == 'pt' ? 'Manejo de Aves' : 'Bird Management';
      case CategoriaBioseguridad.manejoMortalidad:
        return locale == 'pt' ? 'Manejo de Mortalidade' : 'Mortality Management';
      case CategoriaBioseguridad.agua:
        return locale == 'pt' ? 'Qualidade da Água' : 'Water Quality';
      case CategoriaBioseguridad.alimento:
        return locale == 'pt' ? 'Manejo de Ração' : 'Feed Management';
      case CategoriaBioseguridad.instalaciones:
        return locale == 'pt' ? 'Instalações' : 'Facilities';
      case CategoriaBioseguridad.registros:
        return locale == 'pt' ? 'Registros' : 'Records';
    }
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    switch (this) {
      case CategoriaBioseguridad.accesoPersonal:
        return locale == 'pt' ? 'Controle de acesso e vestimenta' : 'Entry and clothing control';
      case CategoriaBioseguridad.accesoVehiculos:
        return locale == 'pt' ? 'Controle de veículos e equipamentos' : 'Vehicle and equipment control';
      case CategoriaBioseguridad.limpiezaDesinfeccion:
        return locale == 'pt' ? 'Protocolos de higiene' : 'Hygiene protocols';
      case CategoriaBioseguridad.controlPlagas:
        return locale == 'pt' ? 'Roedores, insetos, aves silvestres' : 'Rodents, insects, wild birds';
      case CategoriaBioseguridad.manejoAves:
        return locale == 'pt' ? 'Práticas com as aves' : 'Bird handling practices';
      case CategoriaBioseguridad.manejoMortalidad:
        return locale == 'pt' ? 'Disposição de aves mortas' : 'Disposal of dead birds';
      case CategoriaBioseguridad.agua:
        return locale == 'pt' ? 'Potabilidade e cloração' : 'Potability and chlorination';
      case CategoriaBioseguridad.alimento:
        return locale == 'pt' ? 'Armazenamento e qualidade' : 'Storage and quality';
      case CategoriaBioseguridad.instalaciones:
        return locale == 'pt' ? 'Estado de galpões e equipamentos' : 'Housing and equipment condition';
      case CategoriaBioseguridad.registros:
        return locale == 'pt' ? 'Documentação e rastreabilidade' : 'Documentation and traceability';
    }
  }

  String toJson() => name;

  static CategoriaBioseguridad fromJson(String json) {
    return CategoriaBioseguridad.values.firstWhere(
      (e) => e.name == json,
      orElse: () => CategoriaBioseguridad.accesoPersonal,
    );
  }
}

/// Frecuencia de inspección de bioseguridad.
enum FrecuenciaInspeccion {
  diaria('Diaria', 1),
  semanal('Semanal', 7),
  quincenal('Quincenal', 14),
  mensual('Mensual', 30),
  trimestral('Trimestral', 90),
  porLote('Por Lote', 0);

  const FrecuenciaInspeccion(this.nombre, this.dias);

  final String nombre;
  final int dias;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case FrecuenciaInspeccion.diaria:
        return locale == 'pt' ? 'Diária' : 'Daily';
      case FrecuenciaInspeccion.semanal:
        return locale == 'pt' ? 'Semanal' : 'Weekly';
      case FrecuenciaInspeccion.quincenal:
        return locale == 'pt' ? 'Quinzenal' : 'Biweekly';
      case FrecuenciaInspeccion.mensual:
        return locale == 'pt' ? 'Mensal' : 'Monthly';
      case FrecuenciaInspeccion.trimestral:
        return locale == 'pt' ? 'Trimestral' : 'Quarterly';
      case FrecuenciaInspeccion.porLote:
        return locale == 'pt' ? 'Por Lote' : 'Per Batch';
    }
  }

  String toJson() => name;

  static FrecuenciaInspeccion fromJson(String json) {
    return FrecuenciaInspeccion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => FrecuenciaInspeccion.semanal,
    );
  }
}
