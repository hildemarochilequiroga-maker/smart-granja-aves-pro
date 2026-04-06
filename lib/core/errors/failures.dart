library;

import 'package:equatable/equatable.dart';

import '../utils/formatters.dart';
import 'error_messages.dart';

/// Clase base para representar fallos en la aplicacion
/// Usada con el patron Either de dartz
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Fallo del servidor
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code, this.statusCode});

  final int? statusCode;

  factory ServerFailure.generic([String? message]) {
    return ServerFailure(
      message: message ?? ErrorMessages.get('SERVER_ERROR'),
      code: 'SERVER_ERROR',
    );
  }

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Fallo de cache
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code = 'CACHE_FAILURE'});

  factory CacheFailure.notFound() {
    return CacheFailure(
      message: ErrorMessages.get('CACHE_NOT_FOUND'),
      code: 'CACHE_NOT_FOUND',
    );
  }
}

/// Fallo de red
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code = 'NETWORK_FAILURE',
  });

  factory NetworkFailure.noConnection() {
    return NetworkFailure(
      message: ErrorMessages.get('NO_CONNECTION'),
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return NetworkFailure(
      message: ErrorMessages.get('TIMEOUT'),
      code: 'TIMEOUT',
    );
  }
}

/// Fallo de autenticacion
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code = 'AUTH_FAILURE'});

  factory AuthFailure.invalidCredentials() {
    return AuthFailure(
      message: ErrorMessages.get('INVALID_CREDENTIALS'),
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.sessionExpired() {
    return AuthFailure(
      message: ErrorMessages.get('SESSION_EXPIRED'),
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthFailure.unauthorized() {
    return AuthFailure(
      message: ErrorMessages.get('UNAUTHORIZED'),
      code: 'UNAUTHORIZED',
    );
  }
}

/// Fallo de vinculación de cuenta (Account Linking)
/// Se usa cuando un usuario intenta iniciar sesión con un proveedor
/// pero ya tiene una cuenta con el mismo email usando otro proveedor
class AccountLinkingFailure extends AuthFailure {
  const AccountLinkingFailure({
    required super.message,
    super.code = 'ACCOUNT_LINKING_REQUIRED',
    required this.email,
    required this.existingProvider,
    required this.pendingCredential,
  });

  /// Email del usuario
  final String email;

  /// Proveedor existente (ej: 'password', 'google.com')
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

/// Fallo de validacion
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_FAILURE',
    this.field,
    this.errors,
  });

  final String? field;
  final Map<String, String>? errors;

  factory ValidationFailure.single(String field, String message) {
    return ValidationFailure(
      message: message,
      field: field,
      errors: {field: message},
    );
  }

  factory ValidationFailure.multiple(Map<String, String> errors) {
    return ValidationFailure(message: errors.values.first, errors: errors);
  }

  @override
  List<Object?> get props => [...super.props, field, errors];
}

/// Fallo de recurso no encontrado
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message, super.code = 'NOT_FOUND'});

  factory NotFoundFailure.resource(String resourceType, String resourceId) {
    final locale = Formatters.currentLocale;
    final String message;
    switch (locale) {
      case 'es':
        message = '$resourceType con ID $resourceId no encontrado';
      case 'pt':
        message = '$resourceType com ID $resourceId não encontrado';
      default:
        message = '$resourceType with ID $resourceId not found';
    }
    return NotFoundFailure(message: message, code: 'RESOURCE_NOT_FOUND');
  }
}

/// Fallo de almacenamiento
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code = 'STORAGE_FAILURE',
  });
}

/// Fallo de Firebase
class FirebaseFailure extends Failure {
  const FirebaseFailure({
    required super.message,
    super.code = 'FIREBASE_FAILURE',
  });

  factory FirebaseFailure.fromCode(String code, [String? message]) {
    return FirebaseFailure(
      message: message ?? _getMessageFromCode(code),
      code: code,
    );
  }

  static String _getMessageFromCode(String code) {
    return ErrorMessages.get(
      'FIREBASE_${code.toUpperCase().replaceAll('-', '_')}',
    );
  }
}

/// Fallo desconocido
class UnknownFailure extends Failure {
  UnknownFailure({String? message, super.code = 'UNKNOWN_FAILURE'})
    : super(message: message ?? ErrorMessages.get('UNKNOWN'));
}
