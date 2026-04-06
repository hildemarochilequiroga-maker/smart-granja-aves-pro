import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Tipo de producto que se puede vender en una granja avícola.
///
/// Define todos los productos comercializables:
/// - Aves vivas, faenadas, de descarte
/// - Huevos por clasificación
/// - Pollinaza/gallinaza (subproducto)
enum TipoProductoVenta {
  /// Aves vivas en pie para venta (engorde, postura, reproductoras).
  ///
  /// - Unidad: kg
  /// - Precio: por kg de peso vivo
  /// - Requiere: guía sanitaria
  avesVivas('Aves Vivas', 'kg', 'Venta de aves en pie'),

  /// Huevos clasificados por tamaño para venta.
  ///
  /// - Unidad: docenas
  /// - Precio: por docena según clasificación
  /// - Clasificaciones: Extra Grande, Grande, Mediano, Pequeño
  huevos('Huevos', 'docena', 'Venta de huevos por clasificación'),

  /// Pollinaza o gallinaza (subproducto orgánico).
  ///
  /// - Unidad: bultos, toneladas, kg
  /// - Precio: por unidad seleccionada
  /// - Uso: fertilizante orgánico
  pollinaza('Pollinaza/Gallinaza', 'bulto', 'Subproducto orgánico'),

  /// Aves procesadas y faenadas para consumo.
  ///
  /// - Unidad: kg
  /// - Precio: por kg de peso faenado
  /// - Rendimiento típico: 70-75%
  avesFaenadas('Aves Faenadas', 'kg', 'Aves procesadas para consumo'),

  /// Aves de descarte al final del ciclo productivo.
  ///
  /// - Unidad: kg
  /// - Precio: por kg (menor que aves de engorde)
  /// - Típico en postura/reproductoras
  avesDescarte('Aves de Descarte', 'kg', 'Aves al final del ciclo productivo');

  const TipoProductoVenta(this.nombre, this.unidadBase, this.descripcion);

  /// Nombre del producto.
  final String nombre;

  /// Unidad base de medida (kg, docena, bulto).
  final String unidadBase;

  /// Descripción del tipo de producto.
  final String descripcion;

  /// Indica si el producto requiere pesaje.
  bool get requierePesaje {
    return this == TipoProductoVenta.avesVivas ||
        this == TipoProductoVenta.avesFaenadas ||
        this == TipoProductoVenta.avesDescarte;
  }

  /// Indica si el producto es de tipo ave.
  bool get esAve {
    return this == TipoProductoVenta.avesVivas ||
        this == TipoProductoVenta.avesFaenadas ||
        this == TipoProductoVenta.avesDescarte;
  }

  /// Indica si requiere guía sanitaria.
  bool get requiereGuiaSanitaria {
    return esAve;
  }

  /// Nombre del producto localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoProductoVenta.avesVivas => switch (locale) { 'es' => 'Aves Vivas', 'pt' => 'Aves Vivas', _ => 'Live Birds' },
      TipoProductoVenta.huevos => switch (locale) { 'es' => 'Huevos', 'pt' => 'Ovos', _ => 'Eggs' },
      TipoProductoVenta.pollinaza =>
        switch (locale) { 'es' => 'Pollinaza/Gallinaza', 'pt' => 'Cama de Aviário', _ => 'Poultry Manure' },
      TipoProductoVenta.avesFaenadas =>
        switch (locale) { 'es' => 'Aves Faenadas', 'pt' => 'Aves Abatidas', _ => 'Processed Birds' },
      TipoProductoVenta.avesDescarte =>
        switch (locale) { 'es' => 'Aves de Descarte', 'pt' => 'Aves de Descarte', _ => 'Cull Birds' },
    };
  }

  /// Descripción del producto localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoProductoVenta.avesVivas =>
        switch (locale) { 'es' => 'Venta de aves en pie', 'pt' => 'Venda de aves vivas', _ => 'Live bird sales' },
      TipoProductoVenta.huevos =>
        switch (locale) { 'es' => 'Venta de huevos por clasificación', 'pt' => 'Venda de ovos por classificação', _ => 'Egg sales by classification' },
      TipoProductoVenta.pollinaza =>
        switch (locale) { 'es' => 'Subproducto orgánico', 'pt' => 'Subproduto orgânico', _ => 'Organic by-product' },
      TipoProductoVenta.avesFaenadas =>
        switch (locale) { 'es' => 'Aves procesadas para consumo', 'pt' => 'Aves processadas para consumo', _ => 'Birds processed for consumption' },
      TipoProductoVenta.avesDescarte =>
        switch (locale) { 'es' => 'Aves al final del ciclo productivo', 'pt' => 'Aves ao final do ciclo produtivo', _ => 'Birds at end of production cycle' },
    };
  }

  String toJson() => name;

  static TipoProductoVenta fromJson(String json) {
    return TipoProductoVenta.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoProductoVenta.avesVivas,
    );
  }
}
