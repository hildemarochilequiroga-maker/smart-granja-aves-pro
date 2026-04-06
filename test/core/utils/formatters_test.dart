import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('es_ES', null);
    await initializeDateFormatting('es', null);
    await initializeDateFormatting('es_PE', null);
  });

  group('Formatters - Fechas', () {
    test('date() formatea a dd/MM/yyyy', () {
      final fecha = DateTime(2024, 3, 15);
      expect(Formatters.date(fecha), '15/03/2024');
    });

    test('date() retorna vacío para null', () {
      expect(Formatters.date(null), '');
    });

    test('time() formatea a HH:mm', () {
      final fecha = DateTime(2024, 3, 15, 14, 30);
      expect(Formatters.time(fecha), '14:30');
    });

    test('time() retorna vacío para null', () {
      expect(Formatters.time(null), '');
    });

    test('dateTime() formatea a dd/MM/yyyy HH:mm', () {
      final fecha = DateTime(2024, 3, 15, 14, 30);
      expect(Formatters.dateTime(fecha), '15/03/2024 14:30');
    });

    test('dateTime() retorna vacío para null', () {
      expect(Formatters.dateTime(null), '');
    });

    test('dateShort() formatea fecha corta', () {
      final fecha = DateTime(2024, 3, 15);
      final result = Formatters.dateShort(fecha);
      expect(result, isNotEmpty);
      expect(result, contains('2024'));
    });

    test('dateShort() retorna vacío para null', () {
      expect(Formatters.dateShort(null), '');
    });

    test('dateApi() formatea a yyyy-MM-dd', () {
      final fecha = DateTime(2024, 3, 15);
      expect(Formatters.dateApi(fecha), '2024-03-15');
    });

    test('dateApi() retorna vacío para null', () {
      expect(Formatters.dateApi(null), '');
    });

    test('dateLong() formatea fecha larga con locale español', () {
      final fecha = DateTime(2024, 1, 15); // lunes
      final result = Formatters.dateLong(fecha);
      expect(result, isNotEmpty);
      expect(result, contains('2024'));
    });

    test('dateLong() retorna vacío para null', () {
      expect(Formatters.dateLong(null), '');
    });

    group('dateRelative()', () {
      test('retorna "Hoy" para fecha de hoy', () {
        expect(Formatters.dateRelative(DateTime.now()), 'Hoy');
      });

      test('retorna "Ayer" para fecha de ayer', () {
        final ayer = DateTime.now().subtract(const Duration(days: 1));
        expect(Formatters.dateRelative(ayer), 'Ayer');
      });

      test('retorna "Mañana" para fecha mañana', () {
        final manana = DateTime.now().add(const Duration(days: 1));
        expect(Formatters.dateRelative(manana), 'Mañana');
      });

      test('retorna "Hace X días" para menos de 7 días', () {
        final hace3Dias = DateTime.now().subtract(const Duration(days: 3));
        expect(Formatters.dateRelative(hace3Dias), 'Hace 3 días');
      });

      test('retorna "En X dias" para futuro menor a 7 días', () {
        final en3Dias = DateTime.now().add(const Duration(days: 3));
        expect(Formatters.dateRelative(en3Dias), 'En 3 dias');
      });

      test('retorna fecha formateada para más de 7 días', () {
        final hace30Dias = DateTime.now().subtract(const Duration(days: 30));
        final result = Formatters.dateRelative(hace30Dias);
        // Debe ser una fecha dd/MM/yyyy
        expect(result, contains('/'));
      });

      test('retorna vacío para null', () {
        expect(Formatters.dateRelative(null), '');
      });
    });
  });

  group('Formatters - Números', () {
    test('number() formatea con separadores de miles', () {
      final result = Formatters.number(1234);
      expect(result, isNotEmpty);
    });

    test('number() retorna vacío para null', () {
      expect(Formatters.number(null), '');
    });

    test('currency() formatea como moneda', () {
      final result = Formatters.currency(1234.56);
      expect(result, isNotEmpty);
      // Debe contener el símbolo monetario
      expect(result, contains('\$'));
    });

    test('currency() con símbolo custom', () {
      final result = Formatters.currency(100, symbol: 'S/');
      expect(result, contains('S/'));
    });

    test('currency() retorna vacío para null', () {
      expect(Formatters.currency(null), '');
    });

    test('percentage() formatea porcentaje con 1 decimal por defecto', () {
      expect(Formatters.percentage(85.5), '85.5%');
    });

    test('percentage() con 0 decimales', () {
      expect(Formatters.percentage(85.5, decimals: 0), '86%');
    });

    test('percentage() retorna vacío para null', () {
      expect(Formatters.percentage(null), '');
    });

    test('compact() formatea números compactos', () {
      final result = Formatters.compact(1500000);
      expect(result, isNotEmpty);
    });

    test('compact() retorna vacío para null', () {
      expect(Formatters.compact(null), '');
    });
  });

  group('Formatters - Unidades', () {
    test('weight() convierte gramos a kg cuando >= 1000', () {
      expect(Formatters.weight(2500), '2.50 kg');
    });

    test('weight() mantiene gramos cuando < 1000', () {
      expect(Formatters.weight(500), '500 g');
    });

    test('weight() retorna vacío para null', () {
      expect(Formatters.weight(null), '');
    });

    test('temperature() formatea con grado Celsius', () {
      expect(Formatters.temperature(25.3), '25.3 °C');
    });

    test('temperature() con unidad Fahrenheit', () {
      expect(Formatters.temperature(77, unit: 'F'), '77.0 °F');
    });

    test('temperature() retorna vacío para null', () {
      expect(Formatters.temperature(null), '');
    });

    test('humidity() formatea con porcentaje', () {
      expect(Formatters.humidity(65.5), '65.5%');
    });

    test('humidity() retorna vacío para null', () {
      expect(Formatters.humidity(null), '');
    });

    test('withUnit() formatea valor con unidad', () {
      expect(Formatters.withUnit(50, 'kg'), '50 kg');
    });

    test('withUnit() con decimales', () {
      expect(Formatters.withUnit(50.5, 'kg', decimals: 1), '50.5 kg');
    });

    test('withUnit() retorna vacío para null', () {
      expect(Formatters.withUnit(null, 'kg'), '');
    });

    test('aves() singular', () {
      expect(Formatters.aves(1), '1 ave');
    });

    test('aves() plural', () {
      expect(Formatters.aves(100), '100 aves');
    });

    test('aves() retorna vacío para null', () {
      expect(Formatters.aves(null), '');
    });

    test('dias() singular', () {
      expect(Formatters.dias(1), '1 día');
    });

    test('dias() plural', () {
      expect(Formatters.dias(30), '30 días');
    });

    test('dias() retorna vacío para null', () {
      expect(Formatters.dias(null), '');
    });
  });

  group('Formatters - Texto', () {
    test('capitalize() capitaliza primera letra', () {
      expect(Formatters.capitalize('hola'), 'Hola');
    });

    test('capitalize() retorna vacío para null', () {
      expect(Formatters.capitalize(null), '');
    });

    test('capitalize() retorna vacío para string vacío', () {
      expect(Formatters.capitalize(''), '');
    });

    test('titleCase() capitaliza cada palabra', () {
      expect(Formatters.titleCase('hola mundo'), 'Hola Mundo');
    });

    test('titleCase() retorna vacío para null', () {
      expect(Formatters.titleCase(null), '');
    });

    test('titleCase() retorna vacío para string vacío', () {
      expect(Formatters.titleCase(''), '');
    });

    test('truncate() no trunca si es más corto que maxLength', () {
      expect(Formatters.truncate('hola', 10), 'hola');
    });

    test('truncate() trunca con ellipsis', () {
      expect(Formatters.truncate('hola mundo cruel', 10), 'hola mu...');
    });

    test('truncate() retorna vacío para null', () {
      expect(Formatters.truncate(null, 10), '');
    });

    test('maskEmail() enmascara nombre de email', () {
      expect(
        Formatters.maskEmail('juan.perez@gmail.com'),
        'ju********@gmail.com',
      );
    });

    test('maskEmail() retorna vacío para null', () {
      expect(Formatters.maskEmail(null), '');
    });

    test('maskEmail() retorna vacío si no contiene @', () {
      expect(Formatters.maskEmail('invalido'), '');
    });

    test('maskPhone() enmascara mostrando últimos 4 dígitos', () {
      expect(Formatters.maskPhone('987654321'), '****4321');
    });

    test('maskPhone() retorna vacío para null', () {
      expect(Formatters.maskPhone(null), '');
    });

    test('maskPhone() retorna vacío para teléfono corto', () {
      expect(Formatters.maskPhone('123'), '');
    });
  });
}
