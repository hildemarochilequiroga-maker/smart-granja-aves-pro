/// Unidades de medida para items de inventario.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Unidades de medida disponibles.
enum UnidadMedida {
  /// Kilogramos.
  kilogramo('kg', 'Kilogramo', 'Peso'),

  /// Gramos.
  gramo('g', 'Gramo', 'Peso'),

  /// Libras.
  libra('lb', 'Libra', 'Peso'),

  /// Litros.
  litro('L', 'Litro', 'Volumen'),

  /// Mililitros.
  mililitro('mL', 'Mililitro', 'Volumen'),

  /// Unidades individuales.
  unidad('ud', 'Unidad', 'Cantidad'),

  /// Docenas.
  docena('doc', 'Docena', 'Cantidad'),

  /// Sacos.
  saco('saco', 'Saco', 'Empaque'),

  /// Bultos.
  bulto('bulto', 'Bulto', 'Empaque'),

  /// Cajas.
  caja('caja', 'Caja', 'Empaque'),

  /// Frascos.
  frasco('frasco', 'Frasco', 'Empaque'),

  /// Dosis.
  dosis('dosis', 'Dosis', 'Aplicación'),

  /// Ampolla.
  ampolla('amp', 'Ampolla', 'Aplicación');

  const UnidadMedida(this.simbolo, this.nombre, this.categoria);

  /// Símbolo corto de la unidad.
  final String simbolo;

  /// Nombre completo de la unidad.
  final String nombre;

  /// Categoría de la unidad.
  final String categoria;

  /// Verifica si es una unidad de peso.
  bool get esPeso => categoria == 'Peso';

  /// Verifica si es una unidad de volumen.
  bool get esVolumen => categoria == 'Volumen';

  /// Verifica si es una unidad de cantidad.
  bool get esCantidad => categoria == 'Cantidad';

  /// Nombre de la unidad localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      UnidadMedida.kilogramo => switch (locale) { 'es' => 'Kilogramo', 'pt' => 'Quilograma', _ => 'Kilogram' },
      UnidadMedida.gramo => switch (locale) { 'es' => 'Gramo', 'pt' => 'Grama', _ => 'Gram' },
      UnidadMedida.libra => switch (locale) { 'es' => 'Libra', 'pt' => 'Libra', _ => 'Pound' },
      UnidadMedida.litro => switch (locale) { 'es' => 'Litro', 'pt' => 'Litro', _ => 'Liter' },
      UnidadMedida.mililitro => switch (locale) { 'es' => 'Mililitro', 'pt' => 'Mililitro', _ => 'Milliliter' },
      UnidadMedida.unidad => switch (locale) { 'es' => 'Unidad', 'pt' => 'Unidade', _ => 'Unit' },
      UnidadMedida.docena => switch (locale) { 'es' => 'Docena', 'pt' => 'Dúzia', _ => 'Dozen' },
      UnidadMedida.saco => switch (locale) { 'es' => 'Saco', 'pt' => 'Saco', _ => 'Sack' },
      UnidadMedida.bulto => switch (locale) { 'es' => 'Bulto', 'pt' => 'Fardo', _ => 'Bag' },
      UnidadMedida.caja => switch (locale) { 'es' => 'Caja', 'pt' => 'Caixa', _ => 'Box' },
      UnidadMedida.frasco => switch (locale) { 'es' => 'Frasco', 'pt' => 'Frasco', _ => 'Vial' },
      UnidadMedida.dosis => switch (locale) { 'es' => 'Dosis', 'pt' => 'Dose', _ => 'Dose' },
      UnidadMedida.ampolla => switch (locale) { 'es' => 'Ampolla', 'pt' => 'Ampola', _ => 'Ampoule' },
    };
  }

  /// Categoría de la unidad localizada.
  String get displayCategoria {
    final locale = Formatters.currentLocale;
    return switch (categoria) {
      'Peso' => switch (locale) { 'es' => 'Peso', 'pt' => 'Peso', _ => 'Weight' },
      'Volumen' => switch (locale) { 'es' => 'Volumen', 'pt' => 'Volume', _ => 'Volume' },
      'Cantidad' => switch (locale) { 'es' => 'Cantidad', 'pt' => 'Quantidade', _ => 'Quantity' },
      'Empaque' => switch (locale) { 'es' => 'Empaque', 'pt' => 'Embalagem', _ => 'Packaging' },
      'Aplicación' => switch (locale) { 'es' => 'Aplicación', 'pt' => 'Aplicação', _ => 'Application' },
      _ => categoria,
    };
  }

  /// Serialización a JSON.
  String toJson() => name;

  /// Deserialización desde JSON.
  static UnidadMedida fromJson(String json) {
    return UnidadMedida.values.firstWhere(
      (e) => e.name == json,
      orElse: () => UnidadMedida.unidad,
    );
  }
}
