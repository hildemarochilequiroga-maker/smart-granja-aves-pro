import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Clasificación de huevos por tamaño según estándares avícolas.
///
/// Basado en peso individual del huevo:
/// - AA (Extra Grande): > 73g
/// - A (Grande): 63-73g
/// - B (Mediano): 53-63g
/// - C (Pequeño): < 53g
enum ClasificacionHuevo {
  /// Extra grande (AA) - más de 73 gramos.
  extraGrande('Extra Grande', '> 73g', 'AA', 75.0),

  /// Grande (A) - entre 63 y 73 gramos.
  grande('Grande', '63-73g', 'A', 68.0),

  /// Mediano (B) - entre 53 y 63 gramos.
  mediano('Mediano', '53-63g', 'B', 58.0),

  /// Pequeño (C) - menos de 53 gramos.
  pequeno('Pequeño', '< 53g', 'C', 48.0);

  const ClasificacionHuevo(
    this.nombre,
    this.rangoGramos,
    this.codigo,
    this.pesoPromedioGramos,
  );

  /// Nombre de la clasificación.
  final String nombre;

  /// Rango de peso en gramos.
  final String rangoGramos;

  /// Código de clasificación (AA, A, B, C).
  final String codigo;

  /// Peso promedio en gramos para cálculos.
  final double pesoPromedioGramos;

  /// Obtiene el orden de importancia (mayor valor = mejor calidad).
  int get orden {
    switch (this) {
      case ClasificacionHuevo.extraGrande:
        return 4;
      case ClasificacionHuevo.grande:
        return 3;
      case ClasificacionHuevo.mediano:
        return 2;
      case ClasificacionHuevo.pequeno:
        return 1;
    }
  }

  /// Nombre de la clasificación localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      ClasificacionHuevo.extraGrande => switch (locale) { 'es' => 'Extra Grande', 'pt' => 'Extra Grande', _ => 'Extra Large' },
      ClasificacionHuevo.grande => switch (locale) { 'es' => 'Grande', 'pt' => 'Grande', _ => 'Large' },
      ClasificacionHuevo.mediano => switch (locale) { 'es' => 'Mediano', 'pt' => 'Médio', _ => 'Medium' },
      ClasificacionHuevo.pequeno => switch (locale) { 'es' => 'Pequeño', 'pt' => 'Pequeno', _ => 'Small' },
    };
  }

  String toJson() => name;

  static ClasificacionHuevo fromJson(String json) {
    return ClasificacionHuevo.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ClasificacionHuevo.mediano,
    );
  }

  /// Determina la clasificación según el peso en gramos.
  static ClasificacionHuevo clasificarPorPeso(double pesoGramos) {
    if (pesoGramos >= 73) return ClasificacionHuevo.extraGrande;
    if (pesoGramos >= 63) return ClasificacionHuevo.grande;
    if (pesoGramos >= 53) return ClasificacionHuevo.mediano;
    return ClasificacionHuevo.pequeno;
  }
}
