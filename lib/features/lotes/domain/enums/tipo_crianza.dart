/// Tipo de crianza de un lote de aves.
///
/// Distingue entre el ciclo completo (engorde hasta peso de mercado) y la
/// recría (criar solo hasta cierta edad y luego trasladar/vender las aves
/// jóvenes). En recría las aves se van pronto, ocupan menos espacio, por lo
/// que se admite mayor densidad de alojamiento.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum TipoCrianza {
  /// Ciclo completo: se cría hasta el peso/edad final de mercado.
  engorde,

  /// Recría: se cría solo hasta cierta edad (p. ej. 14, 21, 24 días) y las
  /// aves jóvenes se trasladan o venden. Admite mayor densidad.
  recria,

  /// Producción: postura de huevos (gallinas ponedoras) hasta el fin del ciclo
  /// productivo. No tiene edad de salida (como engorde).
  produccion;

  /// Nombre para mostrar (fallback sin context).
  String get displayName {
    final l = Formatters.currentLocale;
    return switch (this) {
      TipoCrianza.engorde =>
        switch (l) { 'es' => 'Engorde', 'pt' => 'Engorde', _ => 'Fattening' },
      TipoCrianza.recria =>
        switch (l) { 'es' => 'Recría', 'pt' => 'Recria', _ => 'Rearing' },
      TipoCrianza.produccion => switch (l) {
        'es' => 'Producción',
        'pt' => 'Produção',
        _ => 'Production',
      },
    };
  }

  /// Descripción (fallback sin context).
  String get descripcion {
    final l = Formatters.currentLocale;
    return switch (this) {
      TipoCrianza.engorde => switch (l) {
        'es' => 'Ciclo completo hasta peso de mercado',
        'pt' => 'Ciclo completo até o peso de mercado',
        _ => 'Full cycle to market weight',
      },
      TipoCrianza.recria => switch (l) {
        'es' => 'Cría hasta cierta edad; admite mayor densidad',
        'pt' => 'Cria até certa idade; admite maior densidade',
        _ => 'Rearing to a given age; allows higher density',
      },
      TipoCrianza.produccion => switch (l) {
        'es' => 'Postura de huevos hasta fin del ciclo productivo',
        'pt' => 'Postura de ovos até o fim do ciclo produtivo',
        _ => 'Egg laying until the end of the production cycle',
      },
    };
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) => switch (this) {
    TipoCrianza.engorde => l.enumTipoCrianzaEngorde,
    TipoCrianza.recria => l.enumTipoCrianzaRecria,
    TipoCrianza.produccion => l.enumTipoCrianzaProduccion,
  };

  /// Descripción localizada para UI con AppLocalizations.
  String localizedDescripcion(S l) => switch (this) {
    TipoCrianza.engorde => l.enumTipoCrianzaDescEngorde,
    TipoCrianza.recria => l.enumTipoCrianzaDescRecria,
    TipoCrianza.produccion => l.enumTipoCrianzaDescProduccion,
  };

  /// `true` si es una recría (cría hasta cierta edad de salida).
  bool get esRecria => this == TipoCrianza.recria;

  /// `true` si es producción (postura de huevos).
  bool get esProduccion => this == TipoCrianza.produccion;

  /// Opciones de tipo de crianza disponibles según el tipo de ave.
  /// - Ponedoras: Producción o Recría.
  /// - Resto (engorde/campero/otro): Engorde o Recría.
  static List<TipoCrianza> opcionesPara({required bool esPonedora}) {
    if (esPonedora) {
      return const [TipoCrianza.produccion, TipoCrianza.recria];
    }
    return const [TipoCrianza.engorde, TipoCrianza.recria];
  }

  String toJson() => name;

  /// Parseo seguro: desconocido/nulo ⇒ engorde (comportamiento por defecto).
  static TipoCrianza fromJson(String? json) {
    if (json == null) return TipoCrianza.engorde;
    return TipoCrianza.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoCrianza.engorde,
    );
  }
}
