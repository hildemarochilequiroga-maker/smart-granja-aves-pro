library;

import 'dart:ui';

/// Colores de la aplicación Smart Granja Aves Pro
/// Basado en Material Design 3
abstract final class AppColors {
  const AppColors._();

  // ============================================================================
  // COLORES PRIMARIOS (Amarillo - #FFDD13)
  // ============================================================================
  static const Color primary = Color(0xFFFFDD13);
  static const Color primaryLight = Color(0xFFFFE74D);
  static const Color primaryDark = Color(0xFFCCAA00);
  static const Color onPrimary = Color(0xFF1A1A00);

  // Variantes de seed
  static const Color primaryContainer = Color(0xFFFFE873);
  static const Color onPrimaryContainer = Color(0xFF1F1C00);

  // ============================================================================
  // COLORES SECUNDARIOS
  // ============================================================================
  static const Color secondary = Color(0xFFFE6A86);
  static const Color secondaryLight = Color(0xFFFF9BAA);
  static const Color secondaryDark = Color(0xFFB33E4B);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFF8E676);
  static const Color onSecondaryContainer = Color(0xFF211C00);

  // ============================================================================
  // COLORES TERCIARIOS
  // ============================================================================
  static const Color tertiary = Color(0xFF45664C);
  static const Color tertiaryContainer = Color(0xFFC7EDCB);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF02210C);

  // ============================================================================
  // COLORES DE ERROR
  // ============================================================================
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorLight = Color(0xFFFF6B6B);
  static const Color errorDark = Color(0xFF8C0009);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  // ============================================================================
  // COLORES DE SUPERFICIE (CLARO)
  // ============================================================================
  static const Color surface = Color(0xFFFFFBFF);
  static const Color surfaceVariant = Color(0xFFE9E2D0);
  static const Color onSurface = Color(0xFF1D1C16);
  static const Color onSurfaceVariant = Color(0xFF4A4739);
  static const Color outline = Color(0xFF7C7868);
  static const Color outlineVariant = Color(0xFFCDC6B4);
  static const Color inverseSurface = Color(0xFF32302A);
  static const Color onInverseSurface = Color(0xFFF5F0E7);
  static const Color inversePrimary = Color(0xFFE4C400);
  static const Color scrim = Color(0xFF000000);
  static const Color shadow = Color(0xFF000000);

  // ============================================================================
  // COLORES DE SUPERFICIE (OSCURO)
  // ============================================================================
  static const Color surfaceDark = Color(0xFF14140E);
  static const Color surfaceVariantDark = Color(0xFF4A4739);
  static const Color onSurfaceDark = Color(0xFFE8E2D9);
  static const Color onSurfaceVariantDark = Color(0xFFCDC6B4);
  static const Color outlineDark = Color(0xFF969080);
  static const Color outlineVariantDark = Color(0xFF4A4739);
  static const Color inverseSurfaceDark = Color(0xFFE8E2D9);
  static const Color onInverseSurfaceDark = Color(0xFF32302A);
  static const Color inversePrimaryDark = Color(0xFF6B5E00);

  // ============================================================================
  // COLORES SEMANTICOS
  // ============================================================================
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFF60AD5E);
  static const Color successDark = Color(0xFF005005);
  static const Color onSuccess = Color(0xFFFFFFFF);

  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFAD42);
  static const Color warningDark = Color(0xFFBB4D00);
  static const Color onWarning = Color(0xFF000000);

  static const Color info = Color(0xFF0288D1);
  static const Color infoLight = Color(0xFF5EB8FF);
  static const Color infoDark = Color(0xFF005B9F);
  static const Color onInfo = Color(0xFFFFFFFF);

  // ============================================================================
  // COLORES DE ESTADO
  // ============================================================================
  static const Color active = Color(0xFF4CAF50);
  static const Color inactive = Color(0xFF9E9E9E);
  static const Color pending = Color(0xFFFFC107);
  static const Color disabled = Color(0xFFBDBDBD);

  // ============================================================================
  // COLORES NEUTRALES
  // ============================================================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Grises
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============================================================================
  // COLORES ESPECÍFICOS DEL DOMINIO
  // ============================================================================

  // Tipos de ave
  static const Color polloEngorde = Color(0xFFFF9800);
  static const Color gallinaPonedora = Color(0xFFE91E63);
  static const Color gallinaReproductora = Color(0xFF9C27B0);
  static const Color pavo = Color(0xFF795548);
  static const Color pato = Color(0xFF00BCD4);
  static const Color codorniz = Color(0xFF8BC34A);

  // Estados de lote
  static const Color loteActivo = active;
  static const Color lotePausado = pending;
  static const Color loteCerrado = inactive;
  static const Color loteFinalizado = grey600;

  // ============================================================================
  // COLORES ADICIONALES
  // ============================================================================
  static const Color brown = Color(0xFF795548);
  static const Color deepOrange = Color(0xFFFF5722);
  static const Color deepPurple = Color(0xFF673AB7);
  static const Color pink = Color(0xFFE91E63);
  static const Color purple = Color(0xFF9C27B0);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color teal = Color(0xFF009688);
  static const Color lime = Color(0xFFCDDC39);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color amber = Color(0xFFFFC107);
  static const Color indigo = Color(0xFF3F51B5);
  static const Color blueGrey = Color(0xFF607D8B);

  // Gráficos
  static const List<Color> chartColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFFE91E63),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFFEB3B),
    Color(0xFF795548),
  ];
}
