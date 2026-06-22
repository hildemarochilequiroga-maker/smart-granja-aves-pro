/// Zonas climáticas del Perú para recomendaciones avícolas.
library;

/// Zona climática del Perú.
enum ZonaClimatica {
  costa,
  sierra,
  selva;

  String get nombre {
    return switch (this) {
      ZonaClimatica.costa => 'Costa',
      ZonaClimatica.sierra => 'Sierra',
      ZonaClimatica.selva => 'Selva',
    };
  }
}
