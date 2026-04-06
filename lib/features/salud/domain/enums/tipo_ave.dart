/// Tipos de aves para programas de vacunación.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Clasificación de tipos de aves para programas de salud.
enum TipoAveProduccion {
  polloCarne('Pollo de Engorde', 'Broiler', 6, 8),
  gallinaPonedoraComercial('Gallina Ponedora Comercial', 'Layer', 72, 90),
  gallinaPonedoraLibre('Gallina Ponedora Pastoreo', 'Free Range', 72, 90),
  reproductoraPesada('Reproductora Pesada', 'Broiler Breeder', 60, 65),
  reproductoraLigera('Reproductora Ligera', 'Layer Breeder', 72, 80),
  pavoEngorde('Pavo de Engorde', 'Turkey', 12, 20),
  codorniz('Codorniz', 'Quail', 40, 52),
  pato('Pato', 'Duck', 8, 10);

  const TipoAveProduccion(
    this.nombre,
    this.nombreIngles,
    this.vidaProductivaSemanas,
    this.vidaMaximaSemanas,
  );

  final String nombre;
  final String nombreIngles;
  final int vidaProductivaSemanas;
  final int vidaMaximaSemanas;

  /// Nombre localizado del tipo de ave.
  String get displayName {
    final locale = Formatters.currentLocale;
    if (locale == 'es') return nombre;
    if (locale == 'pt') {
      return switch (this) {
        TipoAveProduccion.polloCarne => 'Frango de Corte',
        TipoAveProduccion.gallinaPonedoraComercial => 'Galinha Poedeira Comercial',
        TipoAveProduccion.gallinaPonedoraLibre => 'Galinha Poedeira Pastoreio',
        TipoAveProduccion.reproductoraPesada => 'Reprodutora Pesada',
        TipoAveProduccion.reproductoraLigera => 'Reprodutora Leve',
        TipoAveProduccion.pavoEngorde => 'Peru de Corte',
        TipoAveProduccion.codorniz => 'Codorna',
        TipoAveProduccion.pato => 'Pato',
      };
    }
    return nombreIngles;
  }

  /// Indica si es un ave de ciclo corto (engorde).
  bool get esCicloCorto => vidaProductivaSemanas <= 12;

  /// Indica si es ponedora.
  bool get esPonedora =>
      this == TipoAveProduccion.gallinaPonedoraComercial ||
      this == TipoAveProduccion.gallinaPonedoraLibre ||
      this == TipoAveProduccion.reproductoraLigera;

  /// Indica si es reproductora.
  bool get esReproductora =>
      this == TipoAveProduccion.reproductoraPesada ||
      this == TipoAveProduccion.reproductoraLigera;

  String toJson() => name;

  static TipoAveProduccion fromJson(String json) {
    return TipoAveProduccion.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoAveProduccion.polloCarne,
    );
  }
}
