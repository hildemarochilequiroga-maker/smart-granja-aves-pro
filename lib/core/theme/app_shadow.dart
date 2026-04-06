/// Escala de sombras unificada de la aplicación
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Tokens de sombra consistentes para toda la app.
///
/// Define una escala progresiva de elevación visual:
/// - [none] para elementos planos
/// - [sm] para elevación sutil (cards en reposo)
/// - [md] para elevación media (cards hover, dropdowns)
/// - [lg] para elevación alta (modales, bottom sheets)
/// - [xl] para elevación máxima (FABs, tooltips)
abstract final class AppShadow {
  const AppShadow._();

  // ===========================================================================
  // SOMBRAS INDIVIDUALES
  // ===========================================================================

  /// Sin sombra
  static const List<BoxShadow> none = [];

  /// Sombra sutil — cards en reposo, elevación 1
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0A000000), // 4% alpha
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x05000000), // 2% alpha
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Sombra media — cards hover, dropdowns, elevación 2
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x14000000), // 8% alpha
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% alpha
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Sombra grande — modales, bottom sheets, elevación 3
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x1F000000), // 12% alpha
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0A000000), // 4% alpha
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  /// Sombra extra grande — FABs, tooltips, elevación 4
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x29000000), // 16% alpha
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x14000000), // 8% alpha
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // ===========================================================================
  // DECORACIONES PRE-CONSTRUIDAS (BoxDecoration con sombra + radius)
  // ===========================================================================

  /// Decoración de card base — radius 8, sombra sm
  static final BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: AppRadius.allSm,
    boxShadow: sm,
  );

  /// Decoración de card elevada — radius 12, sombra md
  static final BoxDecoration cardElevatedDecoration = BoxDecoration(
    borderRadius: AppRadius.allMd,
    boxShadow: md,
  );

  /// Decoración de modal — radius 16, sombra lg
  static final BoxDecoration modalDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    boxShadow: lg,
  );

  /// Decoración de FAB — circular, sombra xl
  static const BoxDecoration fabDecoration = BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: xl,
  );
}
