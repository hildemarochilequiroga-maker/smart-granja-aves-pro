import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/core/errors/error_handler.dart';
import 'package:smartgranjaavespro/core/errors/exceptions.dart';
import 'package:smartgranjaavespro/core/errors/failures.dart';

void main() {
  group('ErrorHandler.toException', () {
    test('retorna AppException sin cambios', () {
      const exception = ServerException(message: 'Error', code: 'E');
      final result = ErrorHandler.toException(exception);
      expect(result, same(exception));
    });

    test('convierte SocketException a NetworkException', () {
      const error = SocketException('No internet');
      final result = ErrorHandler.toException(error);
      expect(result, isA<NetworkException>());
      expect(result.code, 'NO_CONNECTION');
    });

    test('convierte TimeoutException a NetworkException', () {
      final error = TimeoutException('Timeout');
      final result = ErrorHandler.toException(error);
      expect(result, isA<NetworkException>());
      expect(result.code, 'TIMEOUT');
    });

    test('convierte FormatException a ValidationException', () {
      const error = FormatException('Bad format');
      final result = ErrorHandler.toException(error);
      expect(result, isA<ValidationException>());
      expect(result.code, 'FORMAT_ERROR');
    });

    test('convierte error desconocido a UnknownException', () {
      final result = ErrorHandler.toException('random string error');
      expect(result, isA<UnknownException>());
    });
  });

  group('ErrorHandler.toFailure', () {
    test('convierte ServerException a ServerFailure', () {
      const exception = ServerException(
        message: 'Error',
        code: 'E',
        statusCode: 500,
      );
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<ServerFailure>());
      expect((result as ServerFailure).statusCode, 500);
    });

    test('convierte NetworkException a NetworkFailure', () {
      final exception = NetworkException.noConnection();
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<NetworkFailure>());
    });

    test('convierte AuthException a AuthFailure', () {
      final exception = AuthException.sessionExpired();
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<AuthFailure>());
      expect(result.code, 'SESSION_EXPIRED');
    });

    test('convierte AccountLinkingException a AccountLinkingFailure', () {
      final exception = AccountLinkingException(
        email: 'a@b.com',
        existingProvider: 'google.com',
        pendingCredential: 'cred',
      );
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<AccountLinkingFailure>());
      expect((result as AccountLinkingFailure).email, 'a@b.com');
    });

    test('convierte ValidationException a ValidationFailure', () {
      final exception = ValidationException.required('email');
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<ValidationFailure>());
      expect((result as ValidationFailure).field, 'email');
    });

    test('convierte CacheException a CacheFailure', () {
      final exception = CacheException.notFound();
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<CacheFailure>());
    });

    test('convierte StorageException a StorageFailure', () {
      final exception = StorageException.readError();
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<StorageFailure>());
    });

    test('convierte UnknownException a UnknownFailure', () {
      final exception = UnknownException();
      final result = ErrorHandler.toFailure(exception);
      expect(result, isA<UnknownFailure>());
    });

    test('convierte SocketException directamente a NetworkFailure', () {
      const error = SocketException('No internet');
      final result = ErrorHandler.toFailure(error);
      expect(result, isA<NetworkFailure>());
    });
  });

  group('ErrorHandler.getUserFriendlyMessage', () {
    test('retorna mensaje del exception', () {
      const exception = ServerException(message: 'Error del servidor');
      final msg = ErrorHandler.getUserFriendlyMessage(exception);
      expect(msg, 'Error del servidor');
    });

    test('retorna mensaje para error genérico', () {
      final msg = ErrorHandler.getUserFriendlyMessage('random');
      expect(msg, isNotEmpty);
    });
  });

  group('ErrorHandler.getErrorDetails', () {
    test('retorna mapa con campos esperados', () {
      const exception = ServerException(message: 'Error', code: 'E');
      final details = ErrorHandler.getErrorDetails(exception);
      expect(details, containsPair('type', 'ServerException'));
      expect(details, containsPair('message', 'Error'));
      expect(details, containsPair('code', 'E'));
      expect(details, contains('timestamp'));
    });
  });

  group('FutureErrorHandler extension', () {
    test('handleErrors re-lanza como AppException', () async {
      final future = Future<void>.error(
        const SocketException('No internet'),
      ).handleErrors();

      expect(future, throwsA(isA<NetworkException>()));
    });

    test('handleErrors deja pasar valor correcto', () async {
      final result = await Future.value(42).handleErrors();
      expect(result, 42);
    });
  });
}
