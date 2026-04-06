/// Escala de radios de borde unificada de la aplicación
library;

import 'package:flutter/material.dart';

/// Tokens de border radius consistentes para toda la app.
///
/// Unifica los ~12 valores distintos encontrados en el proyecto
/// (4, 8, 10, 12, 15, 16, 20, 24, 25, 30, 50, 100) a una escala
/// coherente de 6 niveles.
///
/// Escala:
/// ```
/// none =  0    xs   =  4    sm   =  8
/// md   = 12    lg   = 16    xl   = 20
/// xxl  = 24    full = 100
/// ```
abstract final class AppRadius {
  const AppRadius._();

  // ===========================================================================
  // ESCALA NUMÉRICA
  // ===========================================================================

  /// 0 px — sin redondeo
  static const double none = 0;

  /// 4 px — redondeo mínimo (badges, chips pequeños)
  static const double xs = 4;

  /// 8 px — redondeo pequeño (cards, inputs, botones)
  static const double sm = 8;

  /// 12 px — redondeo medio (cards destacadas, bottom sheets)
  static const double md = 12;

  /// 16 px — redondeo grande (modales, contenedores hero)
  static const double lg = 16;

  /// 20 px — redondeo extra grande (bottom sheets, onboarding)
  static const double xl = 20;

  /// 24 px — redondeo muy grande (tarjetas hero)
  static const double xxl = 24;

  /// 100 px — completamente redondo (avatares, indicadores)
  static const double full = 100;

  // ===========================================================================
  // BORDER RADIUS PRE-CONSTRUIDOS — TODOS LOS LADOS
  // ===========================================================================

  /// BorderRadius.zero
  static const BorderRadius allNone = BorderRadius.zero;

  /// BorderRadius.circular(4)
  static final BorderRadius allXs = BorderRadius.circular(xs);

  /// BorderRadius.circular(8)
  static final BorderRadius allSm = BorderRadius.circular(sm);

  /// BorderRadius.circular(12)
  static final BorderRadius allMd = BorderRadius.circular(md);

  /// BorderRadius.circular(16)
  static final BorderRadius allLg = BorderRadius.circular(lg);

  /// BorderRadius.circular(20)
  static final BorderRadius allXl = BorderRadius.circular(xl);

  /// BorderRadius.circular(24)
  static final BorderRadius allXxl = BorderRadius.circular(xxl);

  /// BorderRadius.circular(100)
  static final BorderRadius allFull = BorderRadius.circular(full);

  // ===========================================================================
  // BORDER RADIUS PRE-CONSTRUIDOS — SOLO ARRIBA
  // ===========================================================================

  /// Solo esquinas superiores redondeadas (12) — bottom sheets, tabs
  static const BorderRadius topMd = BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(md),
  );

  /// Solo esquinas superiores redondeadas (16) — bottom sheets grandes
  static const BorderRadius topLg = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Solo esquinas superiores redondeadas (20) — bottom sheets hero
  static const BorderRadius topXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  /// Solo esquinas superiores redondeadas (24) — modales grandes
  static const BorderRadius topXxl = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  // ===========================================================================
  // BORDER RADIUS PRE-CONSTRUIDOS — SOLO ABAJO
  // ===========================================================================

  /// Solo esquinas inferiores redondeadas (12)
  static const BorderRadius bottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(md),
    bottomRight: Radius.circular(md),
  );

  /// Solo esquinas inferiores redondeadas (16)
  static const BorderRadius bottomLg = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  // ===========================================================================
  // SHAPE BORDERS PARA COMPONENTES
  // ===========================================================================

  /// Shape para cards estándar — borderRadius sm (8)
  static final RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: allSm,
  );

  /// Shape para cards destacadas — borderRadius md (12)
  static final RoundedRectangleBorder cardShapeMd = RoundedRectangleBorder(
    borderRadius: allMd,
  );

  /// Shape para diálogos — borderRadius lg (16)
  static final RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
    borderRadius: allLg,
  );

  /// Shape para bottom sheets — borderRadius topXl (20)
  static const RoundedRectangleBorder bottomSheetShape = RoundedRectangleBorder(
    borderRadius: topXl,
  );

  /// Shape para botones — borderRadius sm (8)
  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: allSm,
  );

  /// Shape para chips — borderRadius sm (8)
  static final RoundedRectangleBorder chipShape = RoundedRectangleBorder(
    borderRadius: allSm,
  );

  /// Shape completamente circular — avatares, FABs
  static final RoundedRectangleBorder circleShape = RoundedRectangleBorder(
    borderRadius: allFull,
  );
}
