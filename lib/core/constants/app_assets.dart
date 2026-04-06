/// Constantes de rutas de assets de la aplicación
library;

/// Rutas de assets centralizadas
abstract final class AppAssets {
  const AppAssets._();

  // ===========================================================================
  // LOGOS
  // ===========================================================================
  static const String _logoBase = 'assets/images/logo';

  /// Logo horizontal completo
  static const String logoHorizontal = '$_logoBase/logo_horizontal.png';

  /// Logo solo icono
  static const String logoIcon = '$_logoBase/logo_icon.png';

  /// Video de splash
  static const String logoSplash = '$_logoBase/logo_splash.mp4';

  // ===========================================================================
  // ICONOS
  // ===========================================================================
  static const String _iconsBase = 'assets/images/icons';

  /// Icono de Google para autenticación
  static const String iconGoogle = '$_iconsBase/google.png';

  // ===========================================================================
  // ILUSTRACIONES
  // ===========================================================================
  static const String _illustrationsBase = 'assets/images/illustrations';

  /// Ilustración 1
  static const String illustration1 = '$_illustrationsBase/1.png';

  /// Ilustración 2
  static const String illustration2 = '$_illustrationsBase/2.png';

  /// Ilustración 3
  static const String illustration3 = '$_illustrationsBase/3.png';

  /// Ilustración 4
  static const String illustration4 = '$_illustrationsBase/4.png';

  /// Ilustración 5
  static const String illustration5 = '$_illustrationsBase/5.png';

  /// Ilustración 6
  static const String illustration6 = '$_illustrationsBase/6.png';

  // ===========================================================================
  // ONBOARDING
  // ===========================================================================
  static const String _onboardingBase = 'assets/images/onboarding';

  /// GIF de bienvenida hero
  static const String welcomeHero = '$_onboardingBase/welcome_hero.gif';

  /// GIF de fondo de bienvenida
  static const String welcomeBackground =
      '$_onboardingBase/welcome_background.gif';

  /// GIF de onboarding 1
  static const String onboarding1 = '$_onboardingBase/onboarding_1.gif';

  // ===========================================================================
  // BACKGROUNDS
  // ===========================================================================
  // ignore: unused_field
  static const String _backgroundsBase = 'assets/images/backgrounds';

  // ===========================================================================
  // ANIMACIONES LOTTIE
  // ===========================================================================
  // ignore: unused_field
  static const String _animationsBase = 'assets/animations';
}
