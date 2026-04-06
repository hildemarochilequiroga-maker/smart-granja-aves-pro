/// Métodos de pesaje disponibles para registro de peso.
library;

import 'dart:ui';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:smartgranjaavespro/core/theme/app_colors.dart';

enum MetodoPesaje {
  /// Pesaje manual con báscula.
  manual,

  /// Báscula individual por ave.
  basculaIndividual,

  /// Báscula de grupo/lote.
  basculaLote,

  /// Báscula automática.
  automatica;

  /// Descripción legible del método de pesaje (localizada).
  String localizedDisplayName(S l) {
    switch (this) {
      case MetodoPesaje.manual:
        return l.enumMetodoPesajeManual;
      case MetodoPesaje.basculaIndividual:
        return l.enumMetodoPesajeBasculaIndividual;
      case MetodoPesaje.basculaLote:
        return l.enumMetodoPesajeBasculaLote;
      case MetodoPesaje.automatica:
        return l.enumMetodoPesajeAutomatica;
    }
  }

  /// Color representativo del método.
  Color get color {
    switch (this) {
      case MetodoPesaje.manual:
        return AppColors.success;
      case MetodoPesaje.basculaIndividual:
        return AppColors.info;
      case MetodoPesaje.basculaLote:
        return AppColors.warning;
      case MetodoPesaje.automatica:
        return AppColors.purple;
    }
  }

  /// Ícono representativo.
  String get icono {
    switch (this) {
      case MetodoPesaje.manual:
        return '✋';
      case MetodoPesaje.basculaIndividual:
        return '⚖️';
      case MetodoPesaje.basculaLote:
        return '🏋️';
      case MetodoPesaje.automatica:
        return '🤖';
    }
  }

  /// Descripción del método de pesaje (localizada).
  String localizedDescripcion(S l) {
    switch (this) {
      case MetodoPesaje.manual:
        return l.enumMetodoPesajeDescManual;
      case MetodoPesaje.basculaIndividual:
        return l.enumMetodoPesajeDescBasculaIndividual;
      case MetodoPesaje.basculaLote:
        return l.enumMetodoPesajeDescBasculaLote;
      case MetodoPesaje.automatica:
        return l.enumMetodoPesajeDescAutomatica;
    }
  }

  /// Descripción detallada del método (localizada).
  String localizedDescripcionDetallada(S l) {
    switch (this) {
      case MetodoPesaje.manual:
        return l.enumMetodoPesajeDetalleManual;
      case MetodoPesaje.basculaIndividual:
        return l.enumMetodoPesajeDetalleBasculaIndividual;
      case MetodoPesaje.basculaLote:
        return l.enumMetodoPesajeDetalleBasculaLote;
      case MetodoPesaje.automatica:
        return l.enumMetodoPesajeDetalleAutomatica;
    }
  }

  /// Indica si requiere báscula electrónica.
  bool get requiereBascula => this != MetodoPesaje.manual;

  /// Convierte a JSON.
  String toJson() => name;

  /// Crea desde JSON.
  static MetodoPesaje fromJson(String json) {
    return MetodoPesaje.values.firstWhere(
      (e) => e.name == json,
      orElse: () => MetodoPesaje.manual,
    );
  }
}
