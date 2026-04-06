library;

/// Constantes generales de la aplicación
abstract final class AppConstants {
  const AppConstants._();

  // ============================================================================
  // INFORMACIÓN DE LA APP
  // ============================================================================
  static const String appName = 'Smart Granja Aves Pro';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.hilde.smartgranjaavespro';

  // ============================================================================
  // TIMEOUTS
  // ============================================================================
  static const int connectionTimeout = 30; // segundos
  static const int receiveTimeout = 30; // segundos
  static const int sendTimeout = 30; // segundos
  static const int cacheTimeout = 300; // 5 minutos en segundos
  static const int sessionTimeout = 3600; // 1 hora en segundos
  static const int debounceDelay = 500; // milisegundos
  static const int animationDuration = 300; // milisegundos
  static const int splashDuration = 2000; // milisegundos

  // ============================================================================
  // PAGINACIÓN
  // ============================================================================
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int initialPage = 1;

  // ============================================================================
  // LIMITES DE ARCHIVOS
  // ============================================================================
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10 MB
  static const int maxImageWidth = 1280;
  static const int maxImageHeight = 720;
  static const int thumbnailSize = 150;
  static const double imageQuality = 0.75;

  // ============================================================================
  // CACHE
  // ============================================================================
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const int maxCacheAge = 7; // dias
  static const int maxMemoryCacheItems = 100;

  // ============================================================================
  // STORAGE KEYS
  // ============================================================================
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String rememberedEmailKey = 'remembered_email';
  static const String lastLoginDateKey = 'last_login_date';
  static const String selectedGranjaKey = 'selected_granja';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // ============================================================================
  // FORMATOS
  // ============================================================================
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiDateTimeFormat = "yyyy-MM-dd'T'HH:mm:ss";
  static const String locale = 'es_ES';

  // ============================================================================
  // REINTENTOS
  // ============================================================================
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;
  static const double retryBackoffMultiplier = 2.0;

  // ============================================================================
  // LIMITES DE NEGOCIO
  // ============================================================================
  static const int maxGranjasPorUsuario = 10;
  static const int maxGalponesPorGranja = 50;
  static const int maxLotesPorGalpon = 100;
  static const int maxRegistrosDiarios = 1000;
  static const int diasHistorialDefault = 30;
  static const int diasHistorialMaximo = 365;

  // ============================================================================
  // VALORES POR DEFECTO
  // ============================================================================
  static const double temperaturaMinima = 15.0;
  static const double temperaturaMaxima = 40.0;
  static const double humedadMinima = 30.0;
  static const double humedadMaxima = 90.0;
  static const int edadMaximaAves = 600; // dias
  static const double mortalidadAlerta = 2.0; // porcentaje
}
