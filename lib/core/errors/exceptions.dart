library;

import 'package:equatable/equatable.dart';

import 'error_messages.dart';

/// Clase base para errores personalizados de la aplicacion
abstract class AppException extends Equatable implements Exception {
  const AppException({required this.message, this.code, this.details});

  final String message;
  final String? code;
  final dynamic details;

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Error de servidor
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  final int? statusCode;

  factory ServerException.fromStatusCode(int statusCode, [String? message]) {
    return ServerException(
      message: message ?? _getMessageFromStatusCode(statusCode),
      statusCode: statusCode,
      code: 'SERVER_ERROR_$statusCode',
    );
  }

  static String _getMessageFromStatusCode(int statusCode) {
    return ErrorMessages.get('SERVER_ERROR_$statusCode');
  }

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Error de cache
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code = 'CACHE_ERROR',
    super.details,
  });

  factory CacheException.notFound([String? key]) {
    return CacheException(
      message: key != null
          ? '${ErrorMessages.get('CACHE_NOT_FOUND')}: $key'
          : ErrorMessages.get('CACHE_NOT_FOUND'),
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.expired([String? key]) {
    return CacheException(
      message: key != null
          ? '${ErrorMessages.get('CACHE_EXPIRED')}: $key'
          : ErrorMessages.get('CACHE_EXPIRED'),
      code: 'CACHE_EXPIRED',
    );
  }

  factory CacheException.writeError([String? details]) {
    return CacheException(
      message: ErrorMessages.get('CACHE_WRITE_ERROR'),
      code: 'CACHE_WRITE_ERROR',
      details: details,
    );
  }
}

/// Error de red
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.details,
  });

  factory NetworkException.noConnection() {
    return NetworkException(
      message: ErrorMessages.get('NO_CONNECTION'),
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return NetworkException(
      message: ErrorMessages.get('TIMEOUT'),
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.cancelled() {
    return NetworkException(
      message: ErrorMessages.get('CANCELLED'),
      code: 'CANCELLED',
    );
  }
}

/// Error de autenticacion
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.details,
  });

  factory AuthException.invalidCredentials() {
    return AuthException(
      message: ErrorMessages.get('INVALID_CREDENTIALS'),
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
    return AuthException(
      message: ErrorMessages.get('USER_NOT_FOUND'),
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.emailAlreadyInUse() {
    return AuthException(
      message: ErrorMessages.get('EMAIL_ALREADY_IN_USE'),
      code: 'EMAIL_ALREADY_IN_USE',
    );
  }

  factory AuthException.weakPassword() {
    return AuthException(
      message: ErrorMessages.get('WEAK_PASSWORD'),
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.sessionExpired() {
    return AuthException(
      message: ErrorMessages.get('SESSION_EXPIRED'),
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthException.noSession() {
    return AuthException(
      message: ErrorMessages.get('NO_SESSION'),
      code: 'NO_SESSION',
    );
  }

  factory AuthException.unauthorized() {
    return AuthException(
      message: ErrorMessages.get('UNAUTHORIZED'),
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthException.emailNotVerified() {
    return AuthException(
      message: ErrorMessages.get('EMAIL_NOT_VERIFIED'),
      code: 'EMAIL_NOT_VERIFIED',
    );
  }

  /// Excepción cuando una cuenta ya existe con otro proveedor
  factory AuthException.accountExistsWithDifferentCredential({
    required String email,
    required String existingProvider,
    required dynamic pendingCredential,
  }) {
    return AccountLinkingException(
      email: email,
      existingProvider: existingProvider,
      pendingCredential: pendingCredential,
    );
  }

  factory AuthException.fromFirebaseCode(String code) {
    switch (code) {
      case 'user-not-found':
        return AuthException.userNotFound();
      case 'wrong-password':
        return AuthException.invalidCredentials();
      case 'email-already-in-use':
        return AuthException.emailAlreadyInUse();
      case 'weak-password':
        return AuthException.weakPassword();
      case 'invalid-email':
        return AuthException(
          message: ErrorMessages.get('INVALID_EMAIL'),
          code: 'INVALID_EMAIL',
        );
      case 'user-disabled':
        return AuthException(
          message: ErrorMessages.get('USER_DISABLED'),
          code: 'USER_DISABLED',
        );
      case 'too-many-requests':
        return AuthException(
          message: ErrorMessages.get('TOO_MANY_REQUESTS'),
          code: 'TOO_MANY_REQUESTS',
        );
      default:
        return AuthException(
          message: ErrorMessages.get('AUTH_ERROR'),
          code: code,
        );
    }
  }
}

/// Excepción específica para Account Linking
/// Se lanza cuando un usuario intenta iniciar sesión con un proveedor
/// pero ya tiene una cuenta con el mismo email usando otro proveedor
class AccountLinkingException extends AuthException {
  AccountLinkingException({
    required this.email,
    required this.existingProvider,
    required this.pendingCredential,
  }) : super(
         message: ErrorMessages.get('ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL'),
         code: 'ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL',
       );

  /// Email del usuario
  final String email;

  /// Proveedor con el que ya existe la cuenta (ej: 'password', 'google.com')
  final String existingProvider;

  /// Credencial pendiente para vincular después de autenticar
  final dynamic pendingCredential;

  @override
  List<Object?> get props => [
    ...super.props,
    email,
    existingProvider,
    pendingCredential,
  ];
}

/// Error de validacion
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.details,
    this.field,
  });

  final String? field;

  factory ValidationException.required(String field) {
    return ValidationException(
      message: ErrorMessages.format('FIELD_REQUIRED', {'field': field}),
      code: 'FIELD_REQUIRED',
      field: field,
    );
  }

  factory ValidationException.invalid(String field, [String? reason]) {
    return ValidationException(
      message:
          reason ??
          ErrorMessages.format('FIELD_INVALID', {'field': field}),
      code: 'FIELD_INVALID',
      field: field,
    );
  }

  @override
  List<Object?> get props => [...super.props, field];
}

/// Error de almacenamiento
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.details,
  });

  factory StorageException.readError([String? path]) {
    return StorageException(
      message: ErrorMessages.format('STORAGE_READ_ERROR', {
        'path': path != null ? ': $path' : '',
      }),
      code: 'STORAGE_READ_ERROR',
    );
  }

  factory StorageException.writeError([String? path]) {
    return StorageException(
      message: ErrorMessages.format('STORAGE_WRITE_ERROR', {
        'path': path != null ? ': $path' : '',
      }),
      code: 'STORAGE_WRITE_ERROR',
    );
  }

  factory StorageException.deleteError([String? path]) {
    return StorageException(
      message: ErrorMessages.format('STORAGE_DELETE_ERROR', {
        'path': path != null ? ': $path' : '',
      }),
      code: 'STORAGE_DELETE_ERROR',
    );
  }

  factory StorageException.notFound([String? path]) {
    return StorageException(
      message: ErrorMessages.format('STORAGE_NOT_FOUND', {
        'path': path != null ? ': $path' : '',
      }),
      code: 'STORAGE_NOT_FOUND',
    );
  }

  factory StorageException.quotaExceeded() {
    return StorageException(
      message: ErrorMessages.get('STORAGE_QUOTA_EXCEEDED'),
      code: 'STORAGE_QUOTA_EXCEEDED',
    );
  }
}

/// Error desconocido
class UnknownException extends AppException {
  UnknownException({
    String? message,
    super.code = 'UNKNOWN_ERROR',
    super.details,
  }) : super(message: message ?? ErrorMessages.get('UNKNOWN'));
}
