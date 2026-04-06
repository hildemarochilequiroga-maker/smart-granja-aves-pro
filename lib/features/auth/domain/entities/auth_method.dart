library;

/// Métodos de autenticación soportados
enum AuthMethod {
  /// Autenticación con correo y contraseña
  email,

  /// Autenticación con Google
  google,

  /// Autenticación con Apple
  apple,

  /// Autenticación con Facebook
  facebook,

  /// Autenticación con número de teléfono
  telefono,

  /// Autenticación anónima
  anonimo;

  /// Nombre para mostrar
  String get displayName {
    switch (this) {
      case AuthMethod.email:
        return 'Correo electrónico';
      case AuthMethod.google:
        return 'Google';
      case AuthMethod.apple:
        return 'Apple';
      case AuthMethod.facebook:
        return 'Facebook';
      case AuthMethod.telefono:
        return 'Teléfono';
      case AuthMethod.anonimo:
        return 'Anónimo';
    }
  }

  /// Ícono asociado al método
  String get iconName {
    switch (this) {
      case AuthMethod.email:
        return 'email';
      case AuthMethod.google:
        return 'google';
      case AuthMethod.apple:
        return 'apple';
      case AuthMethod.facebook:
        return 'facebook';
      case AuthMethod.telefono:
        return 'phone';
      case AuthMethod.anonimo:
        return 'person_outline';
    }
  }

  /// Verifica si es método social
  bool get isSocial =>
      this == AuthMethod.google ||
      this == AuthMethod.apple ||
      this == AuthMethod.facebook;

  /// Convierte string a enum
  static AuthMethod fromString(String? value) {
    if (value == null) return AuthMethod.email;
    return AuthMethod.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AuthMethod.email,
    );
  }
}
