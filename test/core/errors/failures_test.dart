import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/core/errors/failures.dart';

void main() {
  group('ServerFailure', () {
    test('generic factory crea failure con mensaje por defecto', () {
      final failure = ServerFailure.generic();
      expect(failure.message, 'Error del servidor');
      expect(failure.code, 'SERVER_ERROR');
      expect(failure.statusCode, isNull);
    });

    test('generic factory acepta mensaje personalizado', () {
      final failure = ServerFailure.generic('Error custom');
      expect(failure.message, 'Error custom');
    });

    test('con statusCode se incluye en props', () {
      const f1 = ServerFailure(message: 'Error', code: 'E', statusCode: 500);
      const f2 = ServerFailure(message: 'Error', code: 'E', statusCode: 404);
      expect(f1, isNot(equals(f2)));
    });
  });

  group('CacheFailure', () {
    test('notFound factory', () {
      final failure = CacheFailure.notFound();
      expect(failure.code, 'CACHE_NOT_FOUND');
      expect(failure.message, contains('cache'));
    });
  });

  group('NetworkFailure', () {
    test('noConnection factory', () {
      final failure = NetworkFailure.noConnection();
      expect(failure.code, 'NO_CONNECTION');
    });

    test('timeout factory', () {
      final failure = NetworkFailure.timeout();
      expect(failure.code, 'TIMEOUT');
    });
  });

  group('AuthFailure', () {
    test('invalidCredentials factory', () {
      final failure = AuthFailure.invalidCredentials();
      expect(failure.code, 'INVALID_CREDENTIALS');
    });

    test('sessionExpired factory', () {
      final failure = AuthFailure.sessionExpired();
      expect(failure.code, 'SESSION_EXPIRED');
    });

    test('unauthorized factory', () {
      final failure = AuthFailure.unauthorized();
      expect(failure.code, 'UNAUTHORIZED');
    });
  });

  group('AccountLinkingFailure', () {
    test('es subclass de AuthFailure', () {
      const failure = AccountLinkingFailure(
        message: 'Ya existe',
        email: 'test@test.com',
        existingProvider: 'google.com',
        pendingCredential: 'cred',
      );
      expect(failure, isA<AuthFailure>());
      expect(failure.email, 'test@test.com');
      expect(failure.existingProvider, 'google.com');
    });
  });

  group('ValidationFailure', () {
    test('single factory', () {
      final failure = ValidationFailure.single('email', 'Email inválido');
      expect(failure.field, 'email');
      expect(failure.errors, {'email': 'Email inválido'});
    });

    test('multiple factory', () {
      final errors = {'email': 'Requerido', 'nombre': 'Muy corto'};
      final failure = ValidationFailure.multiple(errors);
      expect(failure.message, 'Requerido');
      expect(failure.errors, errors);
    });
  });

  group('NotFoundFailure', () {
    test('resource factory', () {
      final failure = NotFoundFailure.resource('Granja', 'g-1');
      expect(failure.message, contains('Granja'));
      expect(failure.message, contains('g-1'));
      expect(failure.code, 'RESOURCE_NOT_FOUND');
    });
  });

  group('FirebaseFailure', () {
    test('fromCode mapea códigos conocidos', () {
      final f = FirebaseFailure.fromCode('permission-denied');
      expect(f.message, contains('permiso'));

      final f2 = FirebaseFailure.fromCode('not-found');
      expect(f2.message, contains('no encontrado'));
    });

    test('fromCode con código desconocido', () {
      final f = FirebaseFailure.fromCode('unknown-code');
      expect(f.message, 'Error de Firebase');
    });

    test('fromCode con mensaje personalizado', () {
      final f = FirebaseFailure.fromCode('any', 'Msg custom');
      expect(f.message, 'Msg custom');
    });
  });

  group('Failure Equatable', () {
    test('failures iguales son iguales', () {
      const f1 = NetworkFailure(message: 'Sin red', code: 'NO_NET');
      const f2 = NetworkFailure(message: 'Sin red', code: 'NO_NET');
      expect(f1, equals(f2));
    });

    test('failures distintos no son iguales', () {
      const f1 = NetworkFailure(message: 'Sin red');
      const f2 = NetworkFailure(message: 'Timeout');
      expect(f1, isNot(equals(f2)));
    });

    test('toString incluye message y code', () {
      const f = NetworkFailure(message: 'Sin red', code: 'NO_NET');
      expect(f.toString(), contains('Sin red'));
      expect(f.toString(), contains('NO_NET'));
    });
  });
}
