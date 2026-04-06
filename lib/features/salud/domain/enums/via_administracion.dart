/// Vías de administración de medicamentos y vacunas.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Vías de administración para medicamentos y vacunas avícolas.
enum ViaAdministracion {
  oral('Oral', 'Administración por vía oral', 'water_drop'),
  agua('En Agua', 'Disuelta en agua de bebida', 'local_drink'),
  alimento('En Alimento', 'Mezclado en el alimento', 'restaurant'),
  ocular('Ocular', 'Gota en el ojo', 'visibility'),
  nasal('Nasal', 'Spray o gota nasal', 'air'),
  spray('Spray', 'Aspersión sobre las aves', 'shower'),
  inyeccionSubcutanea('Inyección SC', 'Subcutánea en cuello', 'vaccines'),
  inyeccionIntramuscular(
    'Inyección IM',
    'Intramuscular en pechuga',
    'vaccines',
  ),
  ala('En Ala', 'Punción en membrana del ala', 'air'),
  inOvo('In-Ovo', 'Inyección en el huevo', 'egg'),
  topica('Tópica', 'Aplicación externa en piel', 'healing');

  const ViaAdministracion(this.nombre, this.descripcion, this.iconName);

  final String nombre;
  final String descripcion;
  final String iconName;

  String toJson() => name;

  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    switch (this) {
      case ViaAdministracion.oral:
        return 'Oral';
      case ViaAdministracion.agua:
        return locale == 'pt' ? 'Na Água' : 'In Water';
      case ViaAdministracion.alimento:
        return locale == 'pt' ? 'Na Ração' : 'In Feed';
      case ViaAdministracion.ocular:
        return 'Ocular';
      case ViaAdministracion.nasal:
        return 'Nasal';
      case ViaAdministracion.spray:
        return 'Spray';
      case ViaAdministracion.inyeccionSubcutanea:
        return locale == 'pt' ? 'Injeção SC' : 'SC Injection';
      case ViaAdministracion.inyeccionIntramuscular:
        return locale == 'pt' ? 'Injeção IM' : 'IM Injection';
      case ViaAdministracion.ala:
        return locale == 'pt' ? 'Na Asa' : 'Wing Web';
      case ViaAdministracion.inOvo:
        return 'In-Ovo';
      case ViaAdministracion.topica:
        return locale == 'pt' ? 'Tópica' : 'Topical';
    }
  }

  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return descripcion;
    switch (this) {
      case ViaAdministracion.oral:
        return locale == 'pt' ? 'Administração por via oral' : 'Oral administration';
      case ViaAdministracion.agua:
        return locale == 'pt' ? 'Dissolvida na água de bebida' : 'Dissolved in drinking water';
      case ViaAdministracion.alimento:
        return locale == 'pt' ? 'Misturado na ração' : 'Mixed in feed';
      case ViaAdministracion.ocular:
        return locale == 'pt' ? 'Gota no olho' : 'Eye drop';
      case ViaAdministracion.nasal:
        return locale == 'pt' ? 'Spray ou gota nasal' : 'Nasal spray or drop';
      case ViaAdministracion.spray:
        return locale == 'pt' ? 'Aspersão sobre as aves' : 'Spraying over birds';
      case ViaAdministracion.inyeccionSubcutanea:
        return locale == 'pt' ? 'Subcutânea no pescoço' : 'Subcutaneous in neck';
      case ViaAdministracion.inyeccionIntramuscular:
        return locale == 'pt' ? 'Intramuscular no peito' : 'Intramuscular in breast';
      case ViaAdministracion.ala:
        return locale == 'pt' ? 'Punção na membrana da asa' : 'Puncture in wing membrane';
      case ViaAdministracion.inOvo:
        return locale == 'pt' ? 'Injeção no ovo' : 'Injection in egg';
      case ViaAdministracion.topica:
        return locale == 'pt' ? 'Aplicação externa na pele' : 'External skin application';
    }
  }

  static ViaAdministracion fromJson(String json) {
    return ViaAdministracion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ViaAdministracion.agua,
    );
  }

  /// Vías comunes para vacunación masiva.
  static List<ViaAdministracion> get paraVacunacionMasiva => [
    ViaAdministracion.agua,
    ViaAdministracion.spray,
  ];

  /// Vías para vacunación individual.
  static List<ViaAdministracion> get paraVacunacionIndividual => [
    ViaAdministracion.ocular,
    ViaAdministracion.nasal,
    ViaAdministracion.inyeccionSubcutanea,
    ViaAdministracion.inyeccionIntramuscular,
    ViaAdministracion.ala,
  ];
}
