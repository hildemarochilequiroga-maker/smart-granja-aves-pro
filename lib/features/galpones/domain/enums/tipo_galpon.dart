/// Clasificación de un galpón avícola según su uso productivo.
///
/// Define el tipo de instalación y determina qué tipo de lotes
/// puede albergar, así como las configuraciones ambientales apropiadas.
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/core/errors/error_messages.dart';

import 'package:smartgranjaavespro/core/utils/formatters.dart';
import 'package:smartgranjaavespro/core/theme/app_colors.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

enum TipoGalpon {
  /// Galpón especializado para aves de engorde.
  engorde('Engorde', 'Galpón para producción de carne'),

  /// Galpón especializado para gallinas ponedoras.
  postura('Postura', 'Galpón para producción de huevos'),

  /// Galpón especializado para aves reproductoras.
  reproductora('Reproductora', 'Galpón para producción de huevos fértiles'),

  /// Galpón de uso múltiple que puede albergar diferentes tipos.
  mixto('Mixto', 'Galpón multiuso para diferentes tipos de producción');

  const TipoGalpon(this.displayName, this.descripcion);

  final String displayName;
  final String descripcion;

  /// Ícono representativo del tipo de galpón.
  IconData get icon {
    switch (this) {
      case TipoGalpon.engorde:
        return Icons.restaurant_outlined;
      case TipoGalpon.postura:
        return Icons.egg_outlined;
      case TipoGalpon.reproductora:
        return Icons.favorite_outlined;
      case TipoGalpon.mixto:
        return Icons.grid_view_outlined;
    }
  }

  /// Color representativo del tipo de galpón.
  Color get color {
    switch (this) {
      case TipoGalpon.engorde:
        return AppColors.deepOrange;
      case TipoGalpon.postura:
        return AppColors.amber;
      case TipoGalpon.reproductora:
        return AppColors.deepPurple;
      case TipoGalpon.mixto:
        return AppColors.teal;
    }
  }

  /// Nombre localizado del tipo de galpón
  String get localizedName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoGalpon.engorde => switch (locale) { 'es' => 'Engorde', 'pt' => 'Corte', _ => 'Broiler' },
      TipoGalpon.postura => switch (locale) { 'es' => 'Postura', 'pt' => 'Postura', _ => 'Layer' },
      TipoGalpon.reproductora => switch (locale) { 'es' => 'Reproductora', 'pt' => 'Reprodutora', _ => 'Breeder' },
      TipoGalpon.mixto => switch (locale) { 'es' => 'Mixto', 'pt' => 'Misto', _ => 'Mixed' },
    };
  }

  /// Descripción localizada del tipo de galpón (fallback sin context)
  String get localizedDescripcionFallback {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoGalpon.engorde =>
        switch (locale) { 'es' => 'Galpón para producción de carne', 'pt' => 'Galpão para produção de carne', _ => 'House for meat production' },
      TipoGalpon.postura =>
        switch (locale) { 'es' => 'Galpón para producción de huevos', 'pt' => 'Galpão para produção de ovos', _ => 'House for egg production' },
      TipoGalpon.reproductora =>
        switch (locale) { 'es' => 'Galpón para producción de huevos fértiles', 'pt' => 'Galpão para produção de ovos férteis', _ => 'House for fertile egg production' },
      TipoGalpon.mixto =>
        switch (locale) { 'es' => 'Galpón multiuso para diferentes tipos de producción', 'pt' => 'Galpão multiuso para diferentes tipos de produção', _ => 'Multi-purpose house for different production types' },
    };
  }

  /// Nombre localizado para UI con AppLocalizations.
  String localizedDisplayName(S l) {
    return switch (this) {
      TipoGalpon.engorde => l.enumTipoGalponEngorde,
      TipoGalpon.postura => l.enumTipoGalponPostura,
      TipoGalpon.reproductora => l.enumTipoGalponReproductora,
      TipoGalpon.mixto => l.enumTipoGalponMixto,
    };
  }

  /// Descripción localizada para UI con AppLocalizations.
  String localizedDescripcion(S l) {
    return switch (this) {
      TipoGalpon.engorde => l.enumTipoGalponDescEngorde,
      TipoGalpon.postura => l.enumTipoGalponDescPostura,
      TipoGalpon.reproductora => l.enumTipoGalponDescReproductora,
      TipoGalpon.mixto => l.enumTipoGalponDescMixto,
    };
  }

  String toJson() => name;

  static TipoGalpon fromJson(String json) {
    return TipoGalpon.values.firstWhere(
      (e) => e.name == json,
      orElse: () => throw ArgumentError(ErrorMessages.format('ENUM_INVALID_TIPO_GALPON', {'value': json})),
    );
  }

  static TipoGalpon? tryFromJson(String? json) {
    if (json == null) return null;
    try {
      return fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Verifica si el galpón es especializado (no mixto).
  bool get esEspecializado => this != TipoGalpon.mixto;

  /// Capacidad recomendada máxima de aves.
  int get capacidadRecomendadaMaxima {
    switch (this) {
      case TipoGalpon.engorde:
        return 25000;
      case TipoGalpon.postura:
        return 15000;
      case TipoGalpon.reproductora:
        return 10000;
      case TipoGalpon.mixto:
        return 20000;
    }
  }

  /// Densidad máxima permitida (aves/m²).
  double get densidadMaximaAvesPorM2 {
    switch (this) {
      case TipoGalpon.engorde:
        return 15.0;
      case TipoGalpon.postura:
        return 10.0;
      case TipoGalpon.reproductora:
        return 8.0;
      case TipoGalpon.mixto:
        return 12.0;
    }
  }

  /// Tipos de ave compatibles con este galpón.
  List<String> get tiposAveCompatibles {
    switch (this) {
      case TipoGalpon.engorde:
        return ['engorde'];
      case TipoGalpon.postura:
        return ['postura'];
      case TipoGalpon.reproductora:
        return ['reproductora'];
      case TipoGalpon.mixto:
        return ['engorde', 'postura', 'reproductora'];
    }
  }

  /// Verifica si puede albergar un tipo de ave específico.
  bool puedeAlbergar(String tipoAve) {
    return tiposAveCompatibles.contains(tipoAve);
  }

  /// Nombre del ícono asociado.
  String get iconName {
    switch (this) {
      case TipoGalpon.engorde:
        return 'warehouse';
      case TipoGalpon.postura:
        return 'egg_alt';
      case TipoGalpon.reproductora:
        return 'nest';
      case TipoGalpon.mixto:
        return 'view_module';
    }
  }

  /// Color hex asociado.
  String get colorHex {
    switch (this) {
      case TipoGalpon.engorde:
        return '#FF6B35';
      case TipoGalpon.postura:
        return '#F7B801';
      case TipoGalpon.reproductora:
        return '#6A4C93';
      case TipoGalpon.mixto:
        return '#4ECDC4';
    }
  }
}
