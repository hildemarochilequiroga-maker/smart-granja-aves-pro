/// Breakpoints y utilidades de responsividad para SmartGranjaAves.
///
/// Uso:
/// ```dart
/// final bp = AppBreakpoints.of(context);
/// // → bp.isSmallPhone, bp.isTablet, bp.padding, bp.gridColumns
/// ```
library;

import 'package:flutter/material.dart';

/// Breakpoints centralizados (anchos en dp).
class AppBreakpoints {
  const AppBreakpoints._();

  // ──────────── Umbrales ────────────
  /// Teléfonos pequeños (Galaxy A01, iPhone SE 1st gen).
  static const double smallPhone = 360;

  /// Límite teléfono → tablet (Material 3 compact → medium).
  static const double tablet = 600;

  /// Tablet grande / desktop (Material 3 medium → expanded).
  static const double desktop = 900;

  // ──────────── Helper rápido ────────────
  /// Devuelve un [ResponsiveData] basado en el ancho actual de la pantalla.
  static ResponsiveData of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return ResponsiveData._(width);
  }

  /// Calcula las columnas óptimas para un grid dado el ancho disponible
  /// y un ancho mínimo de tile deseado.
  static int gridColumns(double availableWidth, {double minTileWidth = 160}) {
    final cols = (availableWidth / minTileWidth).floor();
    return cols.clamp(1, 6);
  }
}

/// Datos de responsividad calculados a partir del ancho actual.
class ResponsiveData {
  ResponsiveData._(this.width);

  final double width;

  // ──────────── Clasificación ────────────
  bool get isSmallPhone => width < AppBreakpoints.smallPhone;
  bool get isPhone =>
      width >= AppBreakpoints.smallPhone && width < AppBreakpoints.tablet;
  bool get isTablet =>
      width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  bool get isDesktop => width >= AppBreakpoints.desktop;

  /// `true` para tablet o superior (layout expandido).
  bool get isExpanded => width >= AppBreakpoints.tablet;

  // ──────────── Valores adaptativos ────────────

  /// Padding horizontal de página.
  double get pagePadding {
    if (isSmallPhone) return 12;
    if (isExpanded) return 24;
    return 16; // phone estándar
  }

  /// Columnas de grid para resúmenes / filtros.
  int get gridColumns {
    if (isSmallPhone) return 1;
    if (isExpanded) return 3;
    return 2; // phone estándar
  }

  /// Ancho máximo para formularios (evita estiramiento en tablet).
  double get formMaxWidth => isExpanded ? 480 : double.infinity;
}
