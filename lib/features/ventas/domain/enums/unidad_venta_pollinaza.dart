import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Unidades de medida para venta de pollinaza/gallinaza.
///
/// Permite flexibilidad en la comercialización:
/// - Bultos de 50 kg (más común)
/// - Toneladas (ventas grandes)
/// - Kilogramos (ventas pequeñas)
enum UnidadVentaPollinaza {
  /// Bultos de 50 kg (presentación más común).
  bulto('Bulto', 50.0, 'Bulto de 50 kg'),

  /// Toneladas (1000 kg) para grandes volúmenes.
  tonelada('Tonelada', 1000.0, 'Tonelada métrica'),

  /// Kilogramos para ventas pequeñas o a granel.
  kilogramo('Kilogramo', 1.0, 'Kilogramo');

  const UnidadVentaPollinaza(this.nombre, this.kgEquivalente, this.descripcion);

  /// Nombre de la unidad.
  final String nombre;

  /// Kilogramos equivalentes por unidad.
  final double kgEquivalente;

  /// Descripción de la unidad.
  final String descripcion;

  /// Convierte una cantidad a kilogramos.
  double convertirAKg(double cantidad) {
    return cantidad * kgEquivalente;
  }

  /// Convierte kilogramos a esta unidad.
  double convertirDesdeKg(double kg) {
    return kg / kgEquivalente;
  }

  /// Nombre de la unidad localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      UnidadVentaPollinaza.bulto => switch (locale) { 'es' => 'Bulto', 'pt' => 'Fardo', _ => 'Bag' },
      UnidadVentaPollinaza.tonelada => switch (locale) { 'es' => 'Tonelada', 'pt' => 'Tonelada', _ => 'Ton' },
      UnidadVentaPollinaza.kilogramo => switch (locale) { 'es' => 'Kilogramo', 'pt' => 'Quilograma', _ => 'Kilogram' },
    };
  }

  /// Descripción de la unidad localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      UnidadVentaPollinaza.bulto => switch (locale) { 'es' => 'Bulto de 50 kg', 'pt' => 'Fardo de 50 kg', _ => '50 kg bag' },
      UnidadVentaPollinaza.tonelada => switch (locale) { 'es' => 'Tonelada métrica', 'pt' => 'Tonelada métrica', _ => 'Metric ton' },
      UnidadVentaPollinaza.kilogramo => switch (locale) { 'es' => 'Kilogramo', 'pt' => 'Quilograma', _ => 'Kilogram' },
    };
  }

  String toJson() => name;

  static UnidadVentaPollinaza fromJson(String json) {
    return UnidadVentaPollinaza.values.firstWhere(
      (e) => e.name == json,
      orElse: () => UnidadVentaPollinaza.bulto,
    );
  }
}
