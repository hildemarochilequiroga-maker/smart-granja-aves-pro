import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/galpones/domain/enums/enums.dart';

void main() {
  group('EstadoGalpon — propiedades', () {
    test('displayName', () {
      expect(EstadoGalpon.activo.displayName, 'Activo');
      expect(EstadoGalpon.mantenimiento.displayName, 'Mantenimiento');
      expect(EstadoGalpon.inactivo.displayName, 'Inactivo');
      expect(EstadoGalpon.desinfeccion.displayName, 'Desinfección');
      expect(EstadoGalpon.cuarentena.displayName, 'Cuarentena');
    });

    test('disponibleParaNuevosLotes solo activo', () {
      expect(EstadoGalpon.activo.disponibleParaNuevosLotes, isTrue);
      expect(EstadoGalpon.mantenimiento.disponibleParaNuevosLotes, isFalse);
      expect(EstadoGalpon.cuarentena.disponibleParaNuevosLotes, isFalse);
    });

    test('debeEstarVacio — desinfeccion e inactivo', () {
      expect(EstadoGalpon.desinfeccion.debeEstarVacio, isTrue);
      expect(EstadoGalpon.inactivo.debeEstarVacio, isTrue);
      expect(EstadoGalpon.activo.debeEstarVacio, isFalse);
      expect(EstadoGalpon.cuarentena.debeEstarVacio, isFalse);
    });

    test('requiereAtencion — cuarentena y mantenimiento', () {
      expect(EstadoGalpon.cuarentena.requiereAtencion, isTrue);
      expect(EstadoGalpon.mantenimiento.requiereAtencion, isTrue);
      expect(EstadoGalpon.activo.requiereAtencion, isFalse);
    });

    test('nivelUrgencia', () {
      expect(EstadoGalpon.cuarentena.nivelUrgencia, 10);
      expect(EstadoGalpon.mantenimiento.nivelUrgencia, 7);
      expect(EstadoGalpon.desinfeccion.nivelUrgencia, 5);
      expect(EstadoGalpon.activo.nivelUrgencia, 0);
    });

    test('diasTipicosEnEstado', () {
      expect(EstadoGalpon.desinfeccion.diasTipicosEnEstado, 10);
      expect(EstadoGalpon.mantenimiento.diasTipicosEnEstado, 5);
      expect(EstadoGalpon.cuarentena.diasTipicosEnEstado, 21);
      expect(EstadoGalpon.activo.diasTipicosEnEstado, isNull);
      expect(EstadoGalpon.inactivo.diasTipicosEnEstado, isNull);
    });
  });

  group('EstadoGalpon — transiciones', () {
    test(
      'activo puede ir a mantenimiento, desinfeccion, cuarentena, inactivo',
      () {
        final t = EstadoGalpon.activo.transicionesPermitidas;
        expect(t, contains(EstadoGalpon.mantenimiento));
        expect(t, contains(EstadoGalpon.desinfeccion));
        expect(t, contains(EstadoGalpon.cuarentena));
        expect(t, contains(EstadoGalpon.inactivo));
      },
    );

    test('mantenimiento puede ir a activo, inactivo, cuarentena', () {
      final t = EstadoGalpon.mantenimiento.transicionesPermitidas;
      expect(t, contains(EstadoGalpon.activo));
      expect(t, contains(EstadoGalpon.inactivo));
      expect(t, contains(EstadoGalpon.cuarentena));
      expect(t, isNot(contains(EstadoGalpon.desinfeccion)));
    });

    test('desinfeccion puede ir a activo, mantenimiento', () {
      final t = EstadoGalpon.desinfeccion.transicionesPermitidas;
      expect(t, contains(EstadoGalpon.activo));
      expect(t, contains(EstadoGalpon.mantenimiento));
      expect(t.length, 2);
    });

    test('cuarentena puede ir a desinfeccion, mantenimiento', () {
      final t = EstadoGalpon.cuarentena.transicionesPermitidas;
      expect(t, contains(EstadoGalpon.desinfeccion));
      expect(t, contains(EstadoGalpon.mantenimiento));
      expect(t, isNot(contains(EstadoGalpon.activo)));
    });

    test('inactivo puede ir a mantenimiento, desinfeccion', () {
      final t = EstadoGalpon.inactivo.transicionesPermitidas;
      expect(t, contains(EstadoGalpon.mantenimiento));
      expect(t, contains(EstadoGalpon.desinfeccion));
      expect(t, isNot(contains(EstadoGalpon.activo)));
    });

    test('puedeTransicionarA valida correctamente', () {
      expect(
        EstadoGalpon.activo.puedeTransicionarA(EstadoGalpon.mantenimiento),
        isTrue,
      );
      expect(
        EstadoGalpon.inactivo.puedeTransicionarA(EstadoGalpon.activo),
        isFalse,
      );
    });
  });

  group('EstadoGalpon — serialization', () {
    test('toJson retorna name', () {
      expect(EstadoGalpon.activo.toJson(), 'activo');
      expect(EstadoGalpon.cuarentena.toJson(), 'cuarentena');
    });

    test('fromJson roundtrip', () {
      for (final estado in EstadoGalpon.values) {
        expect(EstadoGalpon.fromJson(estado.toJson()), estado);
      }
    });

    test('fromJson con valor inválido lanza excepción', () {
      expect(
        () => EstadoGalpon.fromJson('invalido'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('tryFromJson con valor inválido retorna null', () {
      expect(EstadoGalpon.tryFromJson('invalido'), isNull);
      expect(EstadoGalpon.tryFromJson(null), isNull);
    });

    test('tryFromJson con valor válido', () {
      expect(EstadoGalpon.tryFromJson('activo'), EstadoGalpon.activo);
    });
  });
}
