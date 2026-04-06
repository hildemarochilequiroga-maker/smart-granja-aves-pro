/// Escala de espaciado unificada de la aplicación
library;

import 'package:flutter/material.dart';

/// Tokens de espaciado consistentes para toda la app.
///
/// Usa estos valores en lugar de números mágicos para mantener
/// un ritmo visual uniforme en toda la interfaz.
///
/// Escala basada en múltiplos de 4 (con excepción de xxxs y xs):
/// ```
/// xxxs  =  2    xxs  =  4    xs   =  6
/// sm    =  8    md   = 12    base = 16
/// lg    = 20    xl   = 24    xxl  = 32
/// xxxl  = 48    huge = 64
/// ```
abstract final class AppSpacing {
  const AppSpacing._();

  // ===========================================================================
  // ESCALA NUMÉRICA
  // ===========================================================================

  /// 2 px — separación mínima entre íconos/indicadores
  static const double xxxs = 2;

  /// 4 px — padding interno mínimo
  static const double xxs = 4;

  /// 6 px — separación compacta
  static const double xs = 6;

  /// 8 px — separación estándar pequeña
  static const double sm = 8;

  /// 12 px — separación media
  static const double md = 12;

  /// 16 px — separación base / padding de página
  static const double base = 16;

  /// 20 px — separación grande
  static const double lg = 20;

  /// 24 px — separación entre secciones
  static const double xl = 24;

  /// 32 px — separación entre bloques
  static const double xxl = 32;

  /// 48 px — separación entre grupos mayores
  static const double xxxl = 48;

  /// 64 px — separación máxima / hero spacing
  static const double huge = 64;

  // ===========================================================================
  // GAPS VERTICALES (SizedBox pre-construidos)
  // ===========================================================================

  /// Gap vertical de 2 px
  static const SizedBox gapXxxs = SizedBox(height: xxxs);

  /// Gap vertical de 4 px
  static const SizedBox gapXxs = SizedBox(height: xxs);

  /// Gap vertical de 6 px
  static const SizedBox gapXs = SizedBox(height: xs);

  /// Gap vertical de 8 px
  static const SizedBox gapSm = SizedBox(height: sm);

  /// Gap vertical de 12 px
  static const SizedBox gapMd = SizedBox(height: md);

  /// Gap vertical de 16 px
  static const SizedBox gapBase = SizedBox(height: base);

  /// Gap vertical de 20 px
  static const SizedBox gapLg = SizedBox(height: lg);

  /// Gap vertical de 24 px
  static const SizedBox gapXl = SizedBox(height: xl);

  /// Gap vertical de 32 px
  static const SizedBox gapXxl = SizedBox(height: xxl);

  /// Gap vertical de 48 px
  static const SizedBox gapXxxl = SizedBox(height: xxxl);

  /// Gap vertical de 64 px
  static const SizedBox gapHuge = SizedBox(height: huge);

  // ===========================================================================
  // GAPS HORIZONTALES (SizedBox pre-construidos)
  // ===========================================================================

  /// Gap horizontal de 2 px
  static const SizedBox hGapXxxs = SizedBox(width: xxxs);

  /// Gap horizontal de 4 px
  static const SizedBox hGapXxs = SizedBox(width: xxs);

  /// Gap horizontal de 6 px
  static const SizedBox hGapXs = SizedBox(width: xs);

  /// Gap horizontal de 8 px
  static const SizedBox hGapSm = SizedBox(width: sm);

  /// Gap horizontal de 12 px
  static const SizedBox hGapMd = SizedBox(width: md);

  /// Gap horizontal de 16 px
  static const SizedBox hGapBase = SizedBox(width: base);

  /// Gap horizontal de 24 px
  static const SizedBox hGapXl = SizedBox(width: xl);

  // ===========================================================================
  // PADDINGS PRE-CONSTRUIDOS
  // ===========================================================================

  /// Padding de página estándar (16 horizontal)
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: base);

  /// Padding de página completo (16 horizontal, 16 vertical)
  static const EdgeInsets pageAllPadding = EdgeInsets.all(base);

  /// Padding de card estándar (16 todos los lados)
  static const EdgeInsets cardPadding = EdgeInsets.all(base);

  /// Padding de card compacto (12 todos los lados)
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);

  /// Padding de sección (24 vertical)
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(vertical: xl);

  /// Padding de lista (16 horizontal, 8 vertical por ítem)
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: sm,
  );

  /// Padding de diálogo (24 todos los lados)
  static const EdgeInsets dialogPadding = EdgeInsets.all(xl);

  /// Padding de formulario (16 horizontal, 12 vertical entre campos)
  static const EdgeInsets formFieldPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: md,
  );

  /// Padding de chip/tag (12 horizontal, 6 vertical)
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  /// Padding de botón (16 horizontal, 12 vertical)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: md,
  );
}
