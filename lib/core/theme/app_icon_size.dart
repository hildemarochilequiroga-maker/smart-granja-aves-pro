/// Escala de tamaños de íconos unificada de la aplicación
library;

/// Tokens de tamaño de ícono consistentes para toda la app.
///
/// Reemplaza los valores mágicos (12, 14, 16, 18, 20, 24, 28, 32, 36, 48, etc.)
/// dispersos por el proyecto con una escala semántica clara.
///
/// Escala:
/// ```
/// xxxs = 10    xxs  = 12    xs   = 14    sm   = 16
/// md   = 20    base = 24    lg   = 28    xl   = 32
/// xxl  = 40    xxxl = 48    huge = 64    hero = 80
/// ```
abstract final class AppIconSize {
  const AppIconSize._();

  // ===========================================================================
  // ESCALA NUMÉRICA
  // ===========================================================================

  /// 10 px — íconos diminutos (indicadores, badges)
  static const double xxxs = 10;

  /// 12 px — íconos micro (dots, mini badges)
  static const double xxs = 12;

  /// 14 px — íconos extra pequeños (trailing en textos)
  static const double xs = 14;

  /// 16 px — íconos pequeños (en línea con texto body)
  static const double sm = 16;

  /// 20 px — íconos medianos (botones compactos, chips)
  static const double md = 20;

  /// 24 px — tamaño por defecto de Material (AppBar, ListTile)
  static const double base = 24;

  /// 28 px — íconos ligeramente grandes
  static const double lg = 28;

  /// 32 px — íconos grandes (botones destacados)
  static const double xl = 32;

  /// 40 px — íconos extra grandes (avatares, acciones principales)
  static const double xxl = 40;

  /// 48 px — íconos de sección (empty states, headers)
  static const double xxxl = 48;

  /// 64 px — íconos hero (empty states, onboarding)
  static const double huge = 64;

  /// 80 px — íconos feature (splash, ilustraciones)
  static const double hero = 80;

  /// 120 px — íconos ilustrativos (empty states principales)
  static const double illustration = 120;
}
