import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/auth/domain/entities/entities.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Usuario — propiedades calculadas', () {
    test('nombreCompleto con nombre y apellido', () {
      final u = crearUsuarioTest(nombre: 'Juan', apellido: 'Perez');
      expect(u.nombreCompleto, 'Juan Perez');
    });

    test('nombreCompleto solo nombre', () {
      final u = crearUsuarioTest(nombre: 'Juan', apellido: null);
      expect(u.nombreCompleto, 'Juan');
    });

    test('nombreCompleto solo apellido', () {
      final u = crearUsuarioTest(nombre: null, apellido: 'Perez');
      expect(u.nombreCompleto, 'Perez');
    });

    test('nombreCompleto sin nombre ni apellido', () {
      final u = crearUsuarioTest(nombre: null, apellido: null);
      expect(u.nombreCompleto, '');
    });

    test('iniciales con nombre y apellido', () {
      final u = crearUsuarioTest(nombre: 'Juan', apellido: 'Perez');
      expect(u.iniciales, 'JP');
    });

    test('iniciales sin nombre ni apellido usa email', () {
      final u = crearUsuarioTest(
        nombre: null,
        apellido: null,
        email: 'test@test.com',
      );
      expect(u.iniciales, 'T');
    });

    test('perfilCompleto true cuando tiene nombre y apellido', () {
      final u = crearUsuarioTest(nombre: 'Juan', apellido: 'Perez');
      expect(u.perfilCompleto, isTrue);
    });

    test('perfilCompleto false cuando falta nombre', () {
      final u = crearUsuarioTest(nombre: null, apellido: 'Perez');
      expect(u.perfilCompleto, isFalse);
    });

    test('perfilCompleto false cuando nombre vacío', () {
      final u = crearUsuarioTest(nombre: '', apellido: 'Perez');
      expect(u.perfilCompleto, isFalse);
    });
  });

  group('Usuario — proveedores vinculados', () {
    test('tieneGoogleVinculado', () {
      final u = crearUsuarioTest(
        proveedoresVinculados: ['google.com', 'password'],
      );
      expect(u.tieneGoogleVinculado, isTrue);
      expect(u.tienePasswordVinculado, isTrue);
      expect(u.tieneAppleVinculado, isFalse);
    });

    test('tieneAppleVinculado', () {
      final u = crearUsuarioTest(proveedoresVinculados: ['apple.com']);
      expect(u.tieneAppleVinculado, isTrue);
    });
  });

  group('Usuario — copyWith', () {
    test('copia con campos actualizados', () {
      final u = crearUsuarioTest();
      final copia = u.copyWith(nombre: 'Carlos', activo: false);
      expect(copia.nombre, 'Carlos');
      expect(copia.activo, isFalse);
      expect(copia.email, u.email);
    });

    test('copia sin cambios es igual', () {
      final u = crearUsuarioTest();
      final copia = u.copyWith();
      expect(copia, equals(u));
    });
  });

  group('Usuario — empty / isEmpty', () {
    test('empty tiene id y email vacíos', () {
      expect(Usuario.empty.id, '');
      expect(Usuario.empty.email, '');
      expect(Usuario.empty.isEmpty, isTrue);
      expect(Usuario.empty.isNotEmpty, isFalse);
    });

    test('usuario normal no está vacío', () {
      final u = crearUsuarioTest();
      expect(u.isEmpty, isFalse);
      expect(u.isNotEmpty, isTrue);
    });
  });

  group('Usuario — Equatable', () {
    test('usuarios iguales son iguales', () {
      final u1 = crearUsuarioTest();
      final u2 = crearUsuarioTest();
      expect(u1, equals(u2));
    });

    test('usuarios con distinto id no son iguales', () {
      final u1 = crearUsuarioTest(id: 'a');
      final u2 = crearUsuarioTest(id: 'b');
      expect(u1, isNot(equals(u2)));
    });
  });

  group('AuthMethod', () {
    test('enum tiene valores esperados', () {
      expect(AuthMethod.values, contains(AuthMethod.email));
      expect(AuthMethod.values, contains(AuthMethod.google));
    });
  });
}
