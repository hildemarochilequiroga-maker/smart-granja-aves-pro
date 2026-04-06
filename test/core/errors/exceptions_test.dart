import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/core/errors/exceptions.dart';

void main() {
  group('ServerException', () {
    test('fromStatusCode mapea código 400', () {
      final e = ServerException.fromStatusCode(400);
      expect(e.statusCode, 400);
      expect(e.message, 'Solicitud incorrecta');
    });

    test('fromStatusCode mapea código 401', () {
      final e = ServerException.fromStatusCode(401);
      expect(e.message, 'No autorizado');
    });

    test('fromStatusCode mapea código 500', () {
      final e = ServerException.fromStatusCode(500);
      expect(e.message, 'Error interno del servidor');
    });

    test('fromStatusCode con mensaje custom', () {
      final e = ServerException.fromStatusCode(500, 'Custom');
      expect(e.message, 'Custom');
      expect(e.statusCode, 500);
    });

    test('fromStatusCode código desconocido', () {
      final e = ServerException.fromStatusCode(418);
      expect(e.message, 'Error del servidor');
    });
  });

  group('CacheException', () {
    test('notFound factory sin key', () {
      final e = CacheException.notFound();
      expect(e.code, 'CACHE_NOT_FOUND');
      expect(e.message, contains('cache'));
    });

    test('notFound factory con key', () {
      final e = CacheException.notFound('user_token');
      expect(e.message, contains('user_token'));
    });

    test('expired factory', () {
      final e = CacheException.expired('session');
      expect(e.code, 'CACHE_EXPIRED');
    });

    test('writeError factory', () {
      final e = CacheException.writeError('disk full');
      expect(e.code, 'CACHE_WRITE_ERROR');
    });
  });

  group('NetworkException', () {
    test('noConnection factory', () {
      final e = NetworkException.noConnection();
      expect(e.code, 'NO_CONNECTION');
    });

    test('timeout factory', () {
      final e = NetworkException.timeout();
      expect(e.code, 'TIMEOUT');
    });

    test('cancelled factory', () {
      final e = NetworkException.cancelled();
      expect(e.code, 'CANCELLED');
    });
  });

  group('AuthException', () {
    test('fromFirebaseCode mapea códigos comunes', () {
      expect(
        AuthException.fromFirebaseCode('user-not-found').code,
        'USER_NOT_FOUND',
      );
      expect(
        AuthException.fromFirebaseCode('wrong-password').code,
        'INVALID_CREDENTIALS',
      );
      expect(
        AuthException.fromFirebaseCode('email-already-in-use').code,
        'EMAIL_ALREADY_IN_USE',
      );
      expect(
        AuthException.fromFirebaseCode('weak-password').code,
        'WEAK_PASSWORD',
      );
      expect(
        AuthException.fromFirebaseCode('invalid-email').code,
        'INVALID_EMAIL',
      );
      expect(
        AuthException.fromFirebaseCode('user-disabled').code,
        'USER_DISABLED',
      );
      expect(
        AuthException.fromFirebaseCode('too-many-requests').code,
        'TOO_MANY_REQUESTS',
      );
    });

    test('fromFirebaseCode con código desconocido', () {
      final e = AuthException.fromFirebaseCode('unknown');
      expect(e.code, 'unknown');
      expect(e.message, 'Error de autenticación');
    });

    test('factory methods', () {
      expect(AuthException.invalidCredentials().code, 'INVALID_CREDENTIALS');
      expect(AuthException.userNotFound().code, 'USER_NOT_FOUND');
      expect(AuthException.emailAlreadyInUse().code, 'EMAIL_ALREADY_IN_USE');
      expect(AuthException.weakPassword().code, 'WEAK_PASSWORD');
      expect(AuthException.sessionExpired().code, 'SESSION_EXPIRED');
      expect(AuthException.noSession().code, 'NO_SESSION');
      expect(AuthException.unauthorized().code, 'UNAUTHORIZED');
      expect(AuthException.emailNotVerified().code, 'EMAIL_NOT_VERIFIED');
    });

    test(
      'accountExistsWithDifferentCredential crea AccountLinkingException',
      () {
        final e = AuthException.accountExistsWithDifferentCredential(
          email: 'test@test.com',
          existingProvider: 'google.com',
          pendingCredential: 'cred',
        );
        expect(e, isA<AccountLinkingException>());
      },
    );
  });

  group('AccountLinkingException', () {
    test('incluye campos en props', () {
      final e1 = AccountLinkingException(
        email: 'a@b.com',
        existingProvider: 'google.com',
        pendingCredential: 'x',
      );
      final e2 = AccountLinkingException(
        email: 'a@b.com',
        existingProvider: 'google.com',
        pendingCredential: 'x',
      );
      expect(e1, equals(e2));
    });
  });

  group('ValidationException', () {
    test('required factory', () {
      final e = ValidationException.required('email');
      expect(e.field, 'email');
      expect(e.code, 'FIELD_REQUIRED');
      expect(e.message, contains('email'));
    });

    test('invalid factory sin reason', () {
      final e = ValidationException.invalid('edad');
      expect(e.field, 'edad');
      expect(e.message, contains('edad'));
    });

    test('invalid factory con reason', () {
      final e = ValidationException.invalid('edad', 'Debe ser > 0');
      expect(e.message, 'Debe ser > 0');
    });
  });

  group('StorageException', () {
    test('readError con path', () {
      final e = StorageException.readError('/img/a.png');
      expect(e.code, 'STORAGE_READ_ERROR');
      expect(e.message, contains('/img/a.png'));
    });

    test('readError sin path', () {
      final e = StorageException.readError();
      expect(e.message, contains('leer'));
    });

    test('writeError factory', () {
      final e = StorageException.writeError();
      expect(e.code, 'STORAGE_WRITE_ERROR');
    });

    test('deleteError factory', () {
      final e = StorageException.deleteError('/path');
      expect(e.code, 'STORAGE_DELETE_ERROR');
    });

    test('notFound factory', () {
      final e = StorageException.notFound('/img/b.png');
      expect(e.code, 'STORAGE_NOT_FOUND');
      expect(e.message, contains('/img/b.png'));
    });
  });

  group('AppException Equatable', () {
    test('exceptions iguales son iguales', () {
      final e1 = NetworkException.noConnection();
      final e2 = NetworkException.noConnection();
      expect(e1, equals(e2));
    });

    test('toString incluye type y message', () {
      const e = ServerException(message: 'Error', code: 'E');
      expect(e.toString(), contains('AppException'));
    });
  });
}
