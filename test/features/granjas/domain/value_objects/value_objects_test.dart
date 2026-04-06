import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/granjas/domain/value_objects/coordenadas.dart';
import 'package:smartgranjaavespro/features/granjas/domain/value_objects/direccion.dart';
import 'package:smartgranjaavespro/features/granjas/domain/value_objects/umbrales_ambientales.dart';

void main() {
  // ===========================================================================
  // Coordenadas
  // ===========================================================================
  group('Coordenadas', () {
    test('fromJson crea instancia correcta', () {
      final json = {'latitud': -12.046374, 'longitud': -77.042793};
      final coord = Coordenadas.fromJson(json);
      expect(coord.latitud, -12.046374);
      expect(coord.longitud, -77.042793);
    });

    test('toJson serializa correctamente', () {
      const coord = Coordenadas(latitud: -12.0, longitud: -77.0);
      final json = coord.toJson();
      expect(json['latitud'], -12.0);
      expect(json['longitud'], -77.0);
    });

    test('fromJson/toJson roundtrip', () {
      const original = Coordenadas(latitud: -12.046374, longitud: -77.042793);
      final json = original.toJson();
      final restored = Coordenadas.fromJson(json);
      expect(restored, equals(original));
    });

    test('validar acepta coordenadas válidas', () {
      const coord = Coordenadas(latitud: -12.0, longitud: -77.0);
      expect(coord.validar(), isNull);
      expect(coord.esValida, true);
    });

    test('validar rechaza latitud fuera de rango', () {
      const coord = Coordenadas(latitud: 91, longitud: 0);
      expect(coord.validar(), contains('Latitud'));
    });

    test('validar rechaza latitud negativa fuera de rango', () {
      const coord = Coordenadas(latitud: -91, longitud: 0);
      expect(coord.validar(), contains('Latitud'));
    });

    test('validar rechaza longitud fuera de rango', () {
      const coord = Coordenadas(latitud: 0, longitud: 181);
      expect(coord.validar(), contains('Longitud'));
    });

    test('validar rechaza longitud negativa fuera de rango', () {
      const coord = Coordenadas(latitud: 0, longitud: -181);
      expect(coord.validar(), contains('Longitud'));
    });

    test('acepta límites exactos', () {
      const coord1 = Coordenadas(latitud: 90, longitud: 180);
      expect(coord1.esValida, true);
      const coord2 = Coordenadas(latitud: -90, longitud: -180);
      expect(coord2.esValida, true);
    });

    test('Equatable funciona correctamente', () {
      const c1 = Coordenadas(latitud: -12.0, longitud: -77.0);
      const c2 = Coordenadas(latitud: -12.0, longitud: -77.0);
      const c3 = Coordenadas(latitud: 0, longitud: 0);
      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
    });

    test('toString retorna formato legible', () {
      const coord = Coordenadas(latitud: -12.0, longitud: -77.0);
      expect(coord.toString(), contains('-12.0'));
      expect(coord.toString(), contains('-77.0'));
    });
  });

  // ===========================================================================
  // Direccion
  // ===========================================================================
  group('Direccion', () {
    test('fromJson crea instancia con todos los campos', () {
      final json = {
        'calle': 'Av. Lima 123',
        'numero': '456',
        'ciudad': 'Lima',
        'provincia': 'Lima',
        'departamento': 'Lima',
        'codigoPostal': '15001',
        'pais': 'Perú',
        'referencia': 'Cerca al parque',
      };
      final dir = Direccion.fromJson(json);
      expect(dir.calle, 'Av. Lima 123');
      expect(dir.numero, '456');
      expect(dir.ciudad, 'Lima');
      expect(dir.provincia, 'Lima');
      expect(dir.departamento, 'Lima');
      expect(dir.codigoPostal, '15001');
      expect(dir.pais, 'Perú');
      expect(dir.referencia, 'Cerca al parque');
    });

    test('fromJson usa defaults para campos faltantes', () {
      final json = <String, dynamic>{};
      final dir = Direccion.fromJson(json);
      expect(dir.calle, '');
      expect(dir.pais, 'Perú');
      expect(dir.numero, isNull);
    });

    test('toJson serializa solo campos no-null', () {
      const dir = Direccion(calle: 'Av. Test 123');
      final json = dir.toJson();
      expect(json['calle'], 'Av. Test 123');
      expect(json['pais'], 'Perú');
      expect(json.containsKey('numero'), false);
      expect(json.containsKey('ciudad'), false);
    });

    test('fromJson/toJson roundtrip', () {
      const original = Direccion(
        calle: 'Av. Lima 123',
        numero: '456',
        ciudad: 'Trujillo',
      );
      final json = original.toJson();
      final restored = Direccion.fromJson(json);
      expect(restored.calle, original.calle);
      expect(restored.numero, original.numero);
      expect(restored.ciudad, original.ciudad);
    });

    test('validar acepta dirección válida', () {
      const dir = Direccion(calle: 'Av. Lima 123');
      expect(dir.validar(), isNull);
      expect(dir.esValida, true);
    });

    test('validar rechaza calle vacía', () {
      const dir = Direccion(calle: '');
      expect(dir.validar(), contains('obligatoria'));
    });

    test('validar rechaza calle solo espacios', () {
      const dir = Direccion(calle: '   ');
      expect(dir.validar(), contains('obligatoria'));
    });

    test('validar rechaza calle muy corta (< 3)', () {
      const dir = Direccion(calle: 'AB');
      expect(dir.validar(), contains('3 caracteres'));
    });

    test('direccionCorta formatea solo calle', () {
      const dir = Direccion(calle: 'Av. Lima');
      expect(dir.direccionCorta, 'Av. Lima');
    });

    test('direccionCorta incluye número y ciudad', () {
      const dir = Direccion(
        calle: 'Av. Lima',
        numero: '123',
        ciudad: 'Trujillo',
      );
      expect(dir.direccionCorta, 'Av. Lima, #123, Trujillo');
    });
  });

  // ===========================================================================
  // UmbralesAmbientales
  // ===========================================================================
  group('UmbralesAmbientales', () {
    test('fromJson/toJson roundtrip', () {
      final original = UmbralesAmbientales.engordeAdulto();
      final json = original.toJson();
      final restored = UmbralesAmbientales.fromJson(json);
      expect(restored.temperaturaMinima, original.temperaturaMinima);
      expect(restored.temperaturaMaxima, original.temperaturaMaxima);
      expect(restored.humedadMinima, original.humedadMinima);
      expect(restored.humedadMaxima, original.humedadMaxima);
    });

    test('engordeAdulto() tiene umbrales razonables', () {
      final umbrales = UmbralesAmbientales.engordeAdulto();
      expect(umbrales.temperaturaMinima, greaterThan(15));
      expect(umbrales.temperaturaMaxima, lessThan(40));
      expect(umbrales.humedadMinima, greaterThan(30));
      expect(umbrales.humedadMaxima, lessThan(90));
    });

    test('pollitosRecienNacidos() tiene umbrales más altos', () {
      final pollitos = UmbralesAmbientales.pollitosRecienNacidos();
      final adultos = UmbralesAmbientales.engordeAdulto();
      expect(
        pollitos.temperaturaMinima,
        greaterThan(adultos.temperaturaMinima),
      );
    });

    test('temperaturaEnRango verifica correctamente', () {
      final umbrales = UmbralesAmbientales.engordeAdulto();
      // Dentro del rango
      expect(
        umbrales.temperaturaEnRango(
          (umbrales.temperaturaMinima + umbrales.temperaturaMaxima) / 2,
        ),
        true,
      );
      // Fuera del rango (muy frío)
      expect(
        umbrales.temperaturaEnRango(umbrales.temperaturaMinima - 10),
        false,
      );
      // Fuera del rango (muy caliente)
      expect(
        umbrales.temperaturaEnRango(umbrales.temperaturaMaxima + 10),
        false,
      );
    });

    test('humedadEnRango verifica correctamente', () {
      final umbrales = UmbralesAmbientales.engordeAdulto();
      expect(
        umbrales.humedadEnRango(
          (umbrales.humedadMinima + umbrales.humedadMaxima) / 2,
        ),
        true,
      );
      expect(umbrales.humedadEnRango(umbrales.humedadMinima - 20), false);
    });

    test('validar acepta umbrales válidos', () {
      final umbrales = UmbralesAmbientales.engordeAdulto();
      expect(umbrales.validar(), isNull);
      expect(umbrales.esValido, true);
    });
  });
}
