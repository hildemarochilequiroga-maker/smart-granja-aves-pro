import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/lotes/application/validators/lote_validators.dart';
import 'package:smartgranjaavespro/features/lotes/domain/enums/enums.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('LoteValidators', () {
    group('validarCantidadInicial()', () {
      test('rechaza cantidad menor a 10', () {
        final result = LoteValidators.validarCantidadInicial(5);
        expect(result.isValid, false);
        expect(result.message, contains('al menos 10'));
      });

      test('rechaza cantidad mayor a 100,000', () {
        final result = LoteValidators.validarCantidadInicial(100001);
        expect(result.isValid, false);
        expect(result.message, contains('100,000'));
      });

      test('acepta cantidad mínima válida (10)', () {
        final result = LoteValidators.validarCantidadInicial(10);
        expect(result.isValid, true);
      });

      test('acepta cantidad máxima válida (100,000)', () {
        final result = LoteValidators.validarCantidadInicial(100000);
        expect(result.isValid, true);
      });

      test('acepta cantidad típica (500)', () {
        final result = LoteValidators.validarCantidadInicial(500);
        expect(result.isValid, true);
      });
    });

    group('validarCantidadMortalidad()', () {
      test('rechaza mortalidad 0 o negativa', () {
        final result = LoteValidators.validarCantidadMortalidad(
          cantidadMortalidad: 0,
          cantidadActual: 100,
        );
        expect(result.isValid, false);
        expect(result.message, contains('mayor a 0'));
      });

      test('rechaza mortalidad mayor que cantidad actual', () {
        final result = LoteValidators.validarCantidadMortalidad(
          cantidadMortalidad: 101,
          cantidadActual: 100,
        );
        expect(result.isValid, false);
        expect(result.message, contains('no puede exceder'));
      });

      test('acepta mortalidad igual a cantidad actual', () {
        final result = LoteValidators.validarCantidadMortalidad(
          cantidadMortalidad: 100,
          cantidadActual: 100,
        );
        expect(result.isValid, true);
      });

      test('acepta mortalidad válida', () {
        final result = LoteValidators.validarCantidadMortalidad(
          cantidadMortalidad: 5,
          cantidadActual: 100,
        );
        expect(result.isValid, true);
      });
    });

    group('validarPeso()', () {
      test('rechaza peso 0 o negativo', () {
        final result = LoteValidators.validarPeso(0);
        expect(result.isValid, false);
        expect(result.message, contains('mayor a 0'));
      });

      test('rechaza peso mayor a 20,000 gramos', () {
        final result = LoteValidators.validarPeso(20001);
        expect(result.isValid, false);
        expect(result.message, contains('20,000'));
      });

      test('acepta peso máximo válido', () {
        final result = LoteValidators.validarPeso(20000);
        expect(result.isValid, true);
      });

      test('acepta peso típico pollo engorde (~2800g)', () {
        final result = LoteValidators.validarPeso(2800);
        expect(result.isValid, true);
      });
    });

    group('validarConsumo()', () {
      test('rechaza consumo 0 o negativo', () {
        final result = LoteValidators.validarConsumo(0);
        expect(result.isValid, false);
      });

      test('rechaza consumo mayor a 10,000 kg', () {
        final result = LoteValidators.validarConsumo(10001);
        expect(result.isValid, false);
      });

      test('acepta consumo válido', () {
        final result = LoteValidators.validarConsumo(50);
        expect(result.isValid, true);
      });
    });

    group('validarProduccionHuevos()', () {
      test('rechaza lote no ponedor', () {
        final result = LoteValidators.validarProduccionHuevos(
          cantidadHuevos: 100,
          cantidadAves: 200,
          tipoAve: TipoAve.polloEngorde,
        );
        expect(result.isValid, false);
        expect(result.message, contains('ponedoras'));
      });

      test('rechaza cantidad 0 o negativa', () {
        final result = LoteValidators.validarProduccionHuevos(
          cantidadHuevos: 0,
          cantidadAves: 200,
          tipoAve: TipoAve.gallinaPonedora,
        );
        expect(result.isValid, false);
        expect(result.message, contains('mayor a 0'));
      });

      test('advierte si tasa de postura > 120%', () {
        final result = LoteValidators.validarProduccionHuevos(
          cantidadHuevos: 250,
          cantidadAves: 200,
          tipoAve: TipoAve.gallinaPonedora,
        );
        expect(result.isValid, false);
        expect(result.isWarning, true);
        expect(result.message, contains('muy alta'));
      });

      test('acepta producción válida de ponedora', () {
        final result = LoteValidators.validarProduccionHuevos(
          cantidadHuevos: 170,
          cantidadAves: 200,
          tipoAve: TipoAve.gallinaPonedora,
        );
        expect(result.isValid, true);
      });

      test('acepta producción de codorniz', () {
        final result = LoteValidators.validarProduccionHuevos(
          cantidadHuevos: 50,
          cantidadAves: 100,
          tipoAve: TipoAve.codorniz,
        );
        expect(result.isValid, true);
      });
    });

    group('validarFechaIngreso()', () {
      test('rechaza fecha futura', () {
        final futuro = DateTime.now().add(const Duration(days: 1));
        final result = LoteValidators.validarFechaIngreso(futuro);
        expect(result.isValid, false);
        expect(result.message, contains('futura'));
      });

      test('advierte fecha muy antigua (> 5 años)', () {
        final antigua = DateTime.now().subtract(const Duration(days: 2000));
        final result = LoteValidators.validarFechaIngreso(antigua);
        expect(result.isValid, false);
        expect(result.isWarning, true);
        expect(result.message, contains('antigua'));
      });

      test('acepta fecha de hoy', () {
        final result = LoteValidators.validarFechaIngreso(DateTime.now());
        expect(result.isValid, true);
      });

      test('acepta fecha de hace 1 año', () {
        final unAnio = DateTime.now().subtract(const Duration(days: 365));
        final result = LoteValidators.validarFechaIngreso(unAnio);
        expect(result.isValid, true);
      });
    });

    group('validarFechaCierre()', () {
      test('rechaza cierre anterior al ingreso', () {
        final ingreso = DateTime(2024, 6, 1);
        final cierre = DateTime(2024, 5, 1);
        final result = LoteValidators.validarFechaCierre(
          fechaCierre: cierre,
          fechaIngreso: ingreso,
        );
        expect(result.isValid, false);
        expect(result.message, contains('anterior'));
      });

      test('rechaza cierre futuro', () {
        final ingreso = DateTime(2024, 1, 1);
        final cierre = DateTime.now().add(const Duration(days: 30));
        final result = LoteValidators.validarFechaCierre(
          fechaCierre: cierre,
          fechaIngreso: ingreso,
        );
        expect(result.isValid, false);
        expect(result.message, contains('futura'));
      });

      test('acepta cierre válido', () {
        final ingreso = DateTime(2024, 1, 1);
        final cierre = DateTime(2024, 3, 1);
        final result = LoteValidators.validarFechaCierre(
          fechaCierre: cierre,
          fechaIngreso: ingreso,
        );
        expect(result.isValid, true);
      });
    });

    group('validarCodigoUnico()', () {
      test('rechaza código duplicado', () {
        final lotes = [crearLoteTest(id: 'lote-1', codigo: 'LOT-001')];
        final result = LoteValidators.validarCodigoUnico(
          codigo: 'LOT-001',
          lotesExistentes: lotes,
        );
        expect(result.isValid, false);
        expect(result.message, contains('Ya existe'));
      });

      test('acepta código único', () {
        final lotes = [crearLoteTest(id: 'lote-1', codigo: 'LOT-001')];
        final result = LoteValidators.validarCodigoUnico(
          codigo: 'LOT-002',
          lotesExistentes: lotes,
        );
        expect(result.isValid, true);
      });

      test('acepta mismo código si es el propio lote (edición)', () {
        final lotes = [crearLoteTest(id: 'lote-1', codigo: 'LOT-001')];
        final result = LoteValidators.validarCodigoUnico(
          codigo: 'LOT-001',
          lotesExistentes: lotes,
          loteIdActual: 'lote-1',
        );
        expect(result.isValid, true);
      });
    });

    group('validarCreacionLote()', () {
      test('valida lote completo correcto', () {
        final result = LoteValidators.validarCreacionLote(
          cantidadInicial: 500,
          tipoAve: TipoAve.polloEngorde,
          fechaIngreso: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(result.isValid, true);
      });

      test('falla si cantidad es inválida', () {
        final result = LoteValidators.validarCreacionLote(
          cantidadInicial: 3,
          tipoAve: TipoAve.polloEngorde,
          fechaIngreso: DateTime.now(),
        );
        expect(result.isValid, false);
        expect(result.message, contains('al menos 10'));
      });

      test('falla si fecha es inválida', () {
        final result = LoteValidators.validarCreacionLote(
          cantidadInicial: 500,
          tipoAve: TipoAve.polloEngorde,
          fechaIngreso: DateTime.now().add(const Duration(days: 5)),
        );
        expect(result.isValid, false);
        expect(result.message, contains('futura'));
      });

      test('falla si código duplicado', () {
        final lotes = [crearLoteTest(codigo: 'LOT-001')];
        final result = LoteValidators.validarCreacionLote(
          cantidadInicial: 500,
          tipoAve: TipoAve.polloEngorde,
          fechaIngreso: DateTime.now(),
          codigo: 'LOT-001',
          lotesExistentes: lotes,
        );
        expect(result.isValid, false);
        expect(result.message, contains('Ya existe'));
      });
    });
  });

  group('ValidationResult', () {
    test('toString() para resultado válido', () {
      const result = ValidationResult(isValid: true);
      expect(result.toString(), contains('Valid'));
    });

    test('toString() para warning', () {
      const result = ValidationResult(
        isValid: false,
        isWarning: true,
        message: 'cuidado',
      );
      expect(result.toString(), contains('Warning'));
    });

    test('toString() para inválido', () {
      const result = ValidationResult(isValid: false, message: 'error');
      expect(result.toString(), contains('Invalid'));
    });

    test('hasMessage es true cuando hay mensaje', () {
      const result = ValidationResult(isValid: false, message: 'algo');
      expect(result.hasMessage, true);
    });

    test('hasMessage es false cuando no hay mensaje', () {
      const result = ValidationResult(isValid: true);
      expect(result.hasMessage, false);
    });
  });
}
