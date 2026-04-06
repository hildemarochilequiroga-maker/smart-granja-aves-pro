/// Tipos de aves que puede contener un lote.
///
/// Define las diferentes líneas/razas de aves
/// que se manejan en la granja.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Enumeración de tipos de aves.
enum TipoAve {
  /// Pollo de engorde.
  polloEngorde,

  /// Gallina ponedora.
  gallinaPonedora,

  /// Reproductora pesada.
  reproductoraPesada,

  /// Reproductora liviana.
  reproductoraLiviana,

  /// Pavo.
  pavo,

  /// Codorniz.
  codorniz,

  /// Pato.
  pato,

  /// Otro tipo de ave.
  otro;

  /// Nombre para mostrar en UI.
  String get displayName {
    return switch (this) {
      TipoAve.polloEngorde =>
        switch (Formatters.currentLocale) { 'es' => 'Pollo de Engorde', 'pt' => 'Frango de Corte', _ => 'Broiler' },
      TipoAve.gallinaPonedora =>
        switch (Formatters.currentLocale) { 'es' => 'Gallina Ponedora', 'pt' => 'Galinha Poedeira', _ => 'Layer Hen' },
      TipoAve.reproductoraPesada =>
        switch (Formatters.currentLocale) { 'es' => 'Reproductora Pesada', 'pt' => 'Reprodutora Pesada', _ => 'Heavy Breeder' },
      TipoAve.reproductoraLiviana =>
        switch (Formatters.currentLocale) { 'es' => 'Reproductora Liviana', 'pt' => 'Reprodutora Leve', _ => 'Light Breeder' },
      TipoAve.pavo => switch (Formatters.currentLocale) { 'es' => 'Pavo', 'pt' => 'Peru', _ => 'Turkey' },
      TipoAve.codorniz =>
        switch (Formatters.currentLocale) { 'es' => 'Codorniz', 'pt' => 'Codorna', _ => 'Quail' },
      TipoAve.pato => switch (Formatters.currentLocale) { 'es' => 'Pato', 'pt' => 'Pato', _ => 'Duck' },
      TipoAve.otro => switch (Formatters.currentLocale) { 'es' => 'Otro', 'pt' => 'Outro', _ => 'Other' },
    };
  }

  /// Nombre corto para listas.
  String get nombreCorto {
    return switch (this) {
      TipoAve.polloEngorde =>
        switch (Formatters.currentLocale) { 'es' => 'Engorde', 'pt' => 'Corte', _ => 'Broiler' },
      TipoAve.gallinaPonedora =>
        switch (Formatters.currentLocale) { 'es' => 'Ponedora', 'pt' => 'Poedeira', _ => 'Layer' },
      TipoAve.reproductoraPesada =>
        switch (Formatters.currentLocale) { 'es' => 'Rep. Pesada', 'pt' => 'Rep. Pesada', _ => 'Heavy Br.' },
      TipoAve.reproductoraLiviana =>
        switch (Formatters.currentLocale) { 'es' => 'Rep. Liviana', 'pt' => 'Rep. Leve', _ => 'Light Br.' },
      TipoAve.pavo => switch (Formatters.currentLocale) { 'es' => 'Pavo', 'pt' => 'Peru', _ => 'Turkey' },
      TipoAve.codorniz =>
        switch (Formatters.currentLocale) { 'es' => 'Codorniz', 'pt' => 'Codorna', _ => 'Quail' },
      TipoAve.pato => switch (Formatters.currentLocale) { 'es' => 'Pato', 'pt' => 'Pato', _ => 'Duck' },
      TipoAve.otro => switch (Formatters.currentLocale) { 'es' => 'Otro', 'pt' => 'Outro', _ => 'Other' },
    };
  }

  /// Icono asociado al tipo de ave.
  String get icono {
    return switch (this) {
      TipoAve.polloEngorde => '🐔',
      TipoAve.gallinaPonedora => '🥚',
      TipoAve.reproductoraPesada => '🐓',
      TipoAve.reproductoraLiviana => '🐓',
      TipoAve.pavo => '🦃',
      TipoAve.codorniz => '🐦',
      TipoAve.pato => '🦆',
      TipoAve.otro => '🐤',
    };
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) {
    return switch (this) {
      TipoAve.polloEngorde => l.enumTipoAvePolloEngorde,
      TipoAve.gallinaPonedora => l.enumTipoAveGallinaPonedora,
      TipoAve.reproductoraPesada => l.enumTipoAveReproductoraPesada,
      TipoAve.reproductoraLiviana => l.enumTipoAveReproductoraLiviana,
      TipoAve.pavo => l.enumTipoAvePavo,
      TipoAve.codorniz => l.enumTipoAveCodorniz,
      TipoAve.pato => l.enumTipoAvePato,
      TipoAve.otro => l.enumTipoAveOtro,
    };
  }

  /// Nombre corto localizado para UI con AppLocalizations.
  String localizedNombreCorto(S l) {
    return switch (this) {
      TipoAve.polloEngorde => l.enumTipoAveShortPolloEngorde,
      TipoAve.gallinaPonedora => l.enumTipoAveShortGallinaPonedora,
      TipoAve.reproductoraPesada => l.enumTipoAveShortReproductoraPesada,
      TipoAve.reproductoraLiviana => l.enumTipoAveShortReproductoraLiviana,
      TipoAve.pavo => l.enumTipoAveShortPavo,
      TipoAve.codorniz => l.enumTipoAveShortCodorniz,
      TipoAve.pato => l.enumTipoAveShortPato,
      TipoAve.otro => l.enumTipoAveShortOtro,
    };
  }

  /// Días típicos del ciclo productivo.
  int get diasCicloTipico {
    return switch (this) {
      TipoAve.polloEngorde => 42,
      TipoAve.gallinaPonedora => 504, // ~72 semanas
      TipoAve.reproductoraPesada => 420, // ~60 semanas
      TipoAve.reproductoraLiviana => 504, // ~72 semanas
      TipoAve.pavo => 84, // ~12 semanas
      TipoAve.codorniz => 252, // ~36 semanas
      TipoAve.pato => 56, // ~8 semanas
      TipoAve.otro => 42,
    };
  }

  /// Peso promedio al sacrificio/venta (kg).
  double get pesoPromedioVenta {
    return switch (this) {
      TipoAve.polloEngorde => 2.8,
      TipoAve.gallinaPonedora => 1.8,
      TipoAve.reproductoraPesada => 4.5,
      TipoAve.reproductoraLiviana => 2.2,
      TipoAve.pavo => 12.0,
      TipoAve.codorniz => 0.25,
      TipoAve.pato => 3.5,
      TipoAve.otro => 2.0,
    };
  }

  /// Mortalidad esperada (%).
  double get mortalidadEsperada {
    return switch (this) {
      TipoAve.polloEngorde => 4.0,
      TipoAve.gallinaPonedora => 8.0,
      TipoAve.reproductoraPesada => 10.0,
      TipoAve.reproductoraLiviana => 8.0,
      TipoAve.pavo => 6.0,
      TipoAve.codorniz => 5.0,
      TipoAve.pato => 4.0,
      TipoAve.otro => 5.0,
    };
  }

  /// Consumo diario esperado por ave (g/día).
  double get consumoDiarioEsperadoG {
    return switch (this) {
      TipoAve.polloEngorde => 100.0, // Promedio ciclo
      TipoAve.gallinaPonedora => 115.0,
      TipoAve.reproductoraPesada => 160.0,
      TipoAve.reproductoraLiviana => 120.0,
      TipoAve.pavo => 250.0,
      TipoAve.codorniz => 25.0,
      TipoAve.pato => 150.0,
      TipoAve.otro => 100.0,
    };
  }

  /// Porcentaje de postura esperado (solo para ponedoras).
  double get posturaEsperada {
    return switch (this) {
      TipoAve.polloEngorde => 0.0,
      TipoAve.gallinaPonedora => 85.0,
      TipoAve.reproductoraPesada => 65.0,
      TipoAve.reproductoraLiviana => 80.0,
      TipoAve.pavo => 0.0,
      TipoAve.codorniz => 75.0,
      TipoAve.pato => 0.0,
      TipoAve.otro => 0.0,
    };
  }

  /// Si es un ave de postura.
  bool get esPostura =>
      this == TipoAve.gallinaPonedora ||
      this == TipoAve.reproductoraPesada ||
      this == TipoAve.reproductoraLiviana ||
      this == TipoAve.codorniz;

  /// Alias para esPostura (compatibilidad).
  bool get esPonedora => esPostura;

  /// Convierte a JSON.
  String toJson() => name;

  /// Parsea desde JSON.
  static TipoAve fromJson(String json) {
    return TipoAve.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoAve.polloEngorde,
    );
  }

  /// Intenta parsear desde JSON (null-safe).
  static TipoAve? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return TipoAve.values.firstWhere((e) => e.name == json);
    } catch (_) {
      return null;
    }
  }
}
