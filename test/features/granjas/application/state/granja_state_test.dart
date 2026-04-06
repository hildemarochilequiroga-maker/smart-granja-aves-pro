import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/granjas/application/state/granja_state.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  final granja = crearGranjaTest(id: 'g-1', nombre: 'Mi Granja');
  final granjas = [granja, crearGranjaTest(id: 'g-2', nombre: 'Otra')];

  group('GranjaState — tipos básicos', () {
    test('GranjaInitial', () {
      const state = GranjaInitial();
      expect(state.props, isEmpty);
    });

    test('GranjaLoading con datos previos', () {
      final state = GranjaLoading(
        mensaje: 'Cargando...',
        granja: granja,
        granjas: granjas,
      );
      expect(state.mensaje, 'Cargando...');
      expect(state.granja, granja);
      expect(state.granjas, granjas);
    });

    test('GranjaLoading sin datos previos', () {
      const state = GranjaLoading();
      expect(state.granja, isNull);
      expect(state.granjas, isNull);
    });

    test('GranjaSuccess', () {
      final state = GranjaSuccess(granja: granja, mensaje: 'Creada');
      expect(state.granja, granja);
      expect(state.mensaje, 'Creada');
    });

    test('GranjasLoaded', () {
      final state = GranjasLoaded(granjas: granjas);
      expect(state.granjas, hasLength(2));
    });

    test('GranjaError con datos previos', () {
      final state = GranjaError(
        mensaje: 'Error',
        code: 'E001',
        granja: granja,
        granjas: granjas,
      );
      expect(state.mensaje, 'Error');
      expect(state.code, 'E001');
      expect(state.granja, granja);
      expect(state.granjas, granjas);
    });

    test('GranjaDeleted', () {
      const state = GranjaDeleted(mensaje: 'Eliminada');
      expect(state.mensaje, 'Eliminada');
    });
  });

  group('GranjaStateX — extension', () {
    test('isLoading', () {
      const state = GranjaLoading();
      expect(state.isLoading, isTrue);
      expect(state.hasError, isFalse);
    });

    test('hasError', () {
      const state = GranjaError(mensaje: 'Error');
      expect(state.hasError, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('isSuccess — GranjaSuccess', () {
      final state = GranjaSuccess(granja: granja);
      expect(state.isSuccess, isTrue);
    });

    test('isSuccess — GranjasLoaded', () {
      final state = GranjasLoaded(granjas: granjas);
      expect(state.isSuccess, isTrue);
    });

    test('granja desde GranjaSuccess', () {
      final GranjaState state = GranjaSuccess(granja: granja);
      expect(state.granja, granja);
    });

    test('granja preservada en GranjaLoading', () {
      final GranjaState state = GranjaLoading(granja: granja);
      expect(state.granja, granja);
    });

    test('granja preservada en GranjaError', () {
      final GranjaState state = GranjaError(mensaje: 'Error', granja: granja);
      expect(state.granja, granja);
    });

    test('granja null en GranjaInitial', () {
      const GranjaState state = GranjaInitial();
      expect(state.granja, isNull);
    });

    test('granjas desde GranjasLoaded', () {
      final GranjaState state = GranjasLoaded(granjas: granjas);
      expect(state.granjas, hasLength(2));
    });

    test('granjas preservadas en GranjaLoading', () {
      final GranjaState state = GranjaLoading(granjas: granjas);
      expect(state.granjas, hasLength(2));
    });

    test('granjas preservadas en GranjaError', () {
      final GranjaState state = GranjaError(mensaje: 'Error', granjas: granjas);
      expect(state.granjas, hasLength(2));
    });

    test('granjas vacías en GranjaInitial', () {
      const GranjaState state = GranjaInitial();
      expect(state.granjas, isEmpty);
    });

    test('errorMessage desde GranjaError', () {
      const GranjaState state = GranjaError(mensaje: 'Algo falló');
      expect(state.errorMessage, 'Algo falló');
    });

    test('errorMessage null cuando no es error', () {
      const GranjaState state = GranjaLoading();
      expect(state.errorMessage, isNull);
    });
  });

  group('GranjaState — Equatable', () {
    test('estados iguales son iguales', () {
      final s1 = GranjaSuccess(granja: granja);
      final s2 = GranjaSuccess(granja: granja);
      expect(s1, equals(s2));
    });

    test('GranjaLoading con datos distintos no son iguales', () {
      const s1 = GranjaLoading(mensaje: 'A');
      const s2 = GranjaLoading(mensaje: 'B');
      expect(s1, isNot(equals(s2)));
    });
  });
}
