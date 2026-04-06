library;

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'exceptions.dart';
import 'error_messages.dart';
import 'failures.dart';

/// Clase de utilidad para manejar errores y convertirlos a tipos apropiados
class ErrorHandler {
  const ErrorHandler._();

  /// Convierte cualquier excepción a un AppException
  static AppException toException(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioException(error);
    }

    if (error is firebase.FirebaseAuthException) {
      return AuthException.fromFirebaseCode(error.code);
    }

    if (error is FirebaseException) {
      return _handleFirebaseException(error);
    }

    if (error is SocketException) {
      return NetworkException.noConnection();
    }

    if (error is TimeoutException) {
      return NetworkException.timeout();
    }

    if (error is FormatException) {
      return ValidationException(
        message: '${ErrorMessages.get('FORMAT_ERROR')}: ${error.message}',
        code: 'FORMAT_ERROR',
      );
    }

    return UnknownException(details: error.toString());
  }

  /// Convierte cualquier error a un Failure
  static Failure toFailure(dynamic error) {
    final exception = toException(error);
    return _exceptionToFailure(exception);
  }

  /// Maneja excepciones de Dio
  static AppException _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout();

      case DioExceptionType.connectionError:
        return NetworkException.noConnection();

      case DioExceptionType.cancel:
        return NetworkException.cancelled();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode == 401) {
            return AuthException.sessionExpired();
          }
          return ServerException.fromStatusCode(
            statusCode,
            _extractErrorMessage(error.response),
          );
        }
        return const ServerException(message: 'Server error');

      case DioExceptionType.badCertificate:
        return ServerException(
          message: ErrorMessages.get('SSL_ERROR'),
          code: 'SSL_ERROR',
        );

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException.noConnection();
        }
        return UnknownException(details: error.message);
    }
  }

  /// Maneja excepciones de Firebase
  static AppException _handleFirebaseException(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return AuthException.unauthorized();
      case 'unavailable':
        return NetworkException(
          message: ErrorMessages.get('SERVICE_UNAVAILABLE'),
          code: 'SERVICE_UNAVAILABLE',
        );
      case 'cancelled':
        return NetworkException.cancelled();
      case 'deadline-exceeded':
        return NetworkException.timeout();
      case 'not-found':
        return ServerException(
          message: ErrorMessages.get('NOT_FOUND'),
          code: 'NOT_FOUND',
          statusCode: 404,
        );
      case 'already-exists':
        return ServerException(
          message: ErrorMessages.get('ALREADY_EXISTS'),
          code: 'ALREADY_EXISTS',
          statusCode: 409,
        );
      default:
        return ServerException(
          message: error.message ?? ErrorMessages.get('FIREBASE_ERROR'),
          code: error.code,
        );
    }
  }

  /// Convierte un AppException a Failure
  static Failure _exceptionToFailure(AppException exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        statusCode: exception.statusCode,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(message: exception.message, code: exception.code);
    }

    if (exception is AccountLinkingException) {
      return AccountLinkingFailure(
        message: exception.message,
        code: exception.code,
        email: exception.email,
        existingProvider: exception.existingProvider,
        pendingCredential: exception.pendingCredential,
      );
    }

    if (exception is AuthException) {
      return AuthFailure(message: exception.message, code: exception.code);
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        field: exception.field,
      );
    }

    if (exception is CacheException) {
      return CacheFailure(message: exception.message, code: exception.code);
    }

    if (exception is StorageException) {
      return StorageFailure(message: exception.message, code: exception.code);
    }

    return UnknownFailure(message: exception.message, code: exception.code);
  }

  /// Extrae mensaje de error de una respuesta
  static String? _extractErrorMessage(Response<dynamic>? response) {
    if (response?.data == null) return null;

    try {
      final data = response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ??
            data['error'] as String? ??
            data['detail'] as String?;
      }
      if (data is String) {
        return data;
      }
    } catch (_) {}

    return null;
  }

  /// Obtiene un mensaje amigable para el usuario
  static String getUserFriendlyMessage(dynamic error) {
    final exception = toException(error);
    return exception.message;
  }

  /// Registra un error (para ser usado con un logger)
  static Map<String, dynamic> getErrorDetails(dynamic error) {
    final exception = toException(error);
    return {
      'type': exception.runtimeType.toString(),
      'message': exception.message,
      'code': exception.code,
      'details': exception.details?.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

/// Extension para manejar errores en Futures
extension FutureErrorHandler<T> on Future<T> {
  /// Captura errores y los convierte a AppException
  Future<T> handleErrors() async {
    try {
      return await this;
    } catch (error) {
      throw ErrorHandler.toException(error);
    }
  }
}
