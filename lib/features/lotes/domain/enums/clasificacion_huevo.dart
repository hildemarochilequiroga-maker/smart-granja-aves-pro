/// Clasificación de huevos por tamaño según estándares comerciales.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

enum ClasificacionHuevo {
  /// Huevos pequeños (< 53g).
  pequeno('Pequeño', 'S', 43, 53),

  /// Huevos medianos (53-63g).
  mediano('Mediano', 'M', 53, 63),

  /// Huevos grandes (63-73g).
  grande('Grande', 'L', 63, 73),

  /// Huevos extra grandes (> 73g).
  extraGrande('Extra Grande', 'XL', 73, 85);

  const ClasificacionHuevo(
    this.nombre,
    this.codigo,
    this.pesoMinimoGramos,
    this.pesoMaximoGramos,
  );

  /// Nombre legible para UI.
  final String nombre;

  /// Código comercial (S, M, L, XL).
  final String codigo;

  /// Peso mínimo en gramos.
  final int pesoMinimoGramos;

  /// Peso máximo en gramos.
  final int pesoMaximoGramos;

  /// Nombre para mostrar.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      ClasificacionHuevo.pequeno => switch (locale) { 'es' => 'Pequeño', 'pt' => 'Pequeno', _ => 'Small' },
      ClasificacionHuevo.mediano => switch (locale) { 'es' => 'Mediano', 'pt' => 'Médio', _ => 'Medium' },
      ClasificacionHuevo.grande => switch (locale) { 'es' => 'Grande', 'pt' => 'Grande', _ => 'Large' },
      ClasificacionHuevo.extraGrande => switch (locale) { 'es' => 'Extra Grande', 'pt' => 'Extra Grande', _ => 'Extra Large' },
    };
  }

  /// Icono representativo.
  String get icono => '🥚';

  /// Descripción completa con rango de peso.
  String get descripcion {
    final locale = Formatters.currentLocale;
    return '$displayName ($codigo) - ${pesoMinimoGramos}g ${switch (locale) { 'es' => 'a', 'pt' => 'a', _ => 'to' }} ${pesoMaximoGramos}g';
  }

  /// Peso promedio de esta clasificación.
  double get pesoPromedioGramos => (pesoMinimoGramos + pesoMaximoGramos) / 2;

  /// Verifica si un peso está dentro del rango de esta clasificación.
  bool contienePeso(double pesoGramos) {
    return pesoGramos >= pesoMinimoGramos && pesoGramos <= pesoMaximoGramos;
  }

  /// Clasifica un huevo según su peso en gramos.
  static ClasificacionHuevo clasificarPorPeso(double pesoGramos) {
    if (pesoGramos < pequeno.pesoMaximoGramos) return pequeno;
    if (pesoGramos < mediano.pesoMaximoGramos) return mediano;
    if (pesoGramos < grande.pesoMaximoGramos) return grande;
    return extraGrande;
  }

  /// Convierte a JSON.
  String toJson() => name;

  /// Crea desde JSON.
  static ClasificacionHuevo fromJson(String json) {
    return ClasificacionHuevo.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ClasificacionHuevo.mediano,
    );
  }
}
