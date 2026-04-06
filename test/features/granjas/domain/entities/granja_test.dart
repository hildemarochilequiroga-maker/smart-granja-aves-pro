import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/granjas/domain/entities/granja.dart';
import 'package:smartgranjaavespro/features/granjas/domain/enums/enums.dart';
import 'package:smartgranjaavespro/features/granjas/domain/value_objects/value_objects.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Granja - Propiedades Calculadas', () {
    test('estaActiva retorna true para estado activo', () {
      final granja = crearGranjaTest(estado: EstadoGranja.activo);
      expect(granja.estaActiva, true);
    });

    test('estaSuspendida retorna true para estado inactivo', () {
      final granja = crearGranjaTest(estado: EstadoGranja.inactivo);
      expect(granja.estaSuspendida, true);
    });

    test('estaEnMantenimiento retorna true para estado mantenimiento', () {
      final granja = crearGranjaTest(estado: EstadoGranja.mantenimiento);
      expect(granja.estaEnMantenimiento, true);
    });

    test('puedeOperar para activo', () {
      final granja = crearGranjaTest(estado: EstadoGranja.activo);
      expect(granja.puedeOperar, true);
    });

    test('puedeOperar para mantenimiento (permite modificaciones)', () {
      final granja = crearGranjaTest(estado: EstadoGranja.mantenimiento);
      expect(granja.puedeOperar, true);
    });

    test('puedeCrearLotes solo para activo', () {
      expect(
        crearGranjaTest(estado: EstadoGranja.activo).puedeCrearLotes,
        true,
      );
      expect(
        crearGranjaTest(estado: EstadoGranja.inactivo).puedeCrearLotes,
        false,
      );
      expect(
        crearGranjaTest(estado: EstadoGranja.mantenimiento).puedeCrearLotes,
        false,
      );
    });

    test('tieneRucValido — RUC de 11 dígitos', () {
      final granja = crearGranjaTest(ruc: '20123456789');
      expect(granja.tieneRucValido, true);
    });

    test('tieneRucValido — RUC inválido (10 dígitos)', () {
      final granja = crearGranjaTest(ruc: '2012345678');
      expect(granja.tieneRucValido, false);
    });

    test('tieneRucValido — RUC inválido (letras)', () {
      final granja = crearGranjaTest(ruc: '2012345678A');
      expect(granja.tieneRucValido, false);
    });

    test('tieneRucValido — sin RUC es false', () {
      final granja = crearGranjaTest();
      expect(granja.tieneRucValido, false);
    });

    test('tieneCorreoValido — correo válido', () {
      final granja = crearGranjaTest(correo: 'granja@email.com');
      expect(granja.tieneCorreoValido, true);
    });

    test('tieneCorreoValido — correo inválido', () {
      final granja = crearGranjaTest(correo: 'no-es-correo');
      expect(granja.tieneCorreoValido, false);
    });

    test('tieneCorreoValido — sin correo es false', () {
      final granja = crearGranjaTest();
      expect(granja.tieneCorreoValido, false);
    });

    test('densidadPromedioAvesM2 calcula correctamente', () {
      final granja = crearGranjaTest(
        capacidadTotalAves: 10000,
        areaTotalM2: 500,
      );
      expect(granja.densidadPromedioAvesM2, 20.0);
    });

    test('densidadPromedioAvesM2 retorna null sin datos', () {
      final granja = crearGranjaTest();
      expect(granja.densidadPromedioAvesM2, isNull);
    });

    test('densidadPromedioAvesM2 retorna null si área es 0', () {
      final granja = crearGranjaTest(capacidadTotalAves: 1000, areaTotalM2: 0);
      expect(granja.densidadPromedioAvesM2, isNull);
    });

    test('capacidadPromedioPorGalpon calcula correctamente', () {
      final granja = crearGranjaTest(
        capacidadTotalAves: 10000,
        numeroTotalGalpones: 4,
      );
      expect(granja.capacidadPromedioPorGalpon, 2500.0);
    });

    test('capacidadPromedioPorGalpon retorna null si galpones es 0', () {
      final granja = crearGranjaTest(
        capacidadTotalAves: 1000,
        numeroTotalGalpones: 0,
      );
      expect(granja.capacidadPromedioPorGalpon, isNull);
    });

    test('datosDesactualizados — true si más de 30 días', () {
      final granja = crearGranjaTest(
        ultimaActualizacion: DateTime.now().subtract(const Duration(days: 31)),
      );
      expect(granja.datosDesactualizados, true);
    });

    test('datosDesactualizados — false si menos de 30 días', () {
      final granja = crearGranjaTest(
        ultimaActualizacion: DateTime.now().subtract(const Duration(days: 5)),
      );
      expect(granja.datosDesactualizados, false);
    });

    test('datosDesactualizados — true si nunca actualizado', () {
      final granja = crearGranjaTest();
      expect(granja.datosDesactualizados, true);
    });
  });

  group('Granja - Transiciones de Estado', () {
    test('activar() desde inactivo', () {
      final granja = crearGranjaTest(estado: EstadoGranja.inactivo);
      final activada = granja.activar();
      expect(activada.estado, EstadoGranja.activo);
      expect(activada.ultimaActualizacion, isNotNull);
    });

    test('activar() desde mantenimiento', () {
      final granja = crearGranjaTest(estado: EstadoGranja.mantenimiento);
      final activada = granja.activar();
      expect(activada.estado, EstadoGranja.activo);
    });

    test('activar() lanza error si ya está activa', () {
      final granja = crearGranjaTest(estado: EstadoGranja.activo);
      expect(() => granja.activar(), throwsA(isA<GranjaException>()));
    });

    test('suspender() desde activa', () {
      final granja = crearGranjaTest(estado: EstadoGranja.activo);
      final suspendida = granja.suspender(razon: 'Pandemia');
      expect(suspendida.estado, EstadoGranja.inactivo);
      expect(suspendida.notas, contains('Pandemia'));
    });

    test('suspender() lanza error desde inactiva', () {
      final granja = crearGranjaTest(estado: EstadoGranja.inactivo);
      expect(() => granja.suspender(), throwsA(isA<GranjaException>()));
    });

    test('ponerEnMantenimiento() desde activa', () {
      final granja = crearGranjaTest(estado: EstadoGranja.activo);
      final enMantenimiento = granja.ponerEnMantenimiento(razon: 'Reparación');
      expect(enMantenimiento.estado, EstadoGranja.mantenimiento);
      expect(enMantenimiento.notas, contains('Reparación'));
    });

    test('ponerEnMantenimiento() lanza error desde inactiva', () {
      final granja = crearGranjaTest(estado: EstadoGranja.inactivo);
      expect(
        () => granja.ponerEnMantenimiento(),
        throwsA(isA<GranjaException>()),
      );
    });
  });

  group('Granja - Validación', () {
    test('granja válida pasa validación', () {
      final granja = crearGranjaTest();
      expect(granja.validar(), isNull);
      expect(granja.esValida, true);
    });

    test('rechaza id vacío', () {
      final granja = crearGranjaTest(id: '');
      expect(granja.validar(), contains('ID'));
    });

    test('rechaza nombre vacío', () {
      final granja = crearGranjaTest(nombre: '');
      expect(granja.validar(), contains('nombre'));
    });

    test('rechaza nombre corto (< 3 chars)', () {
      final granja = crearGranjaTest(nombre: 'AB');
      expect(granja.validar(), contains('3 caracteres'));
    });

    test('rechaza RUC inválido si está presente', () {
      final granja = crearGranjaTest(ruc: '12345');
      expect(granja.validar(), contains('RUC'));
    });

    test('acepta RUC vacío (no obligatorio)', () {
      final granja = crearGranjaTest();
      expect(granja.validar(), isNull);
    });

    test('rechaza correo inválido si está presente', () {
      final granja = crearGranjaTest(correo: 'no-email');
      expect(granja.validar(), contains('Correo'));
    });

    test('rechaza capacidad negativa', () {
      final granja = crearGranjaTest(capacidadTotalAves: -1);
      expect(granja.validar(), contains('capacidad'));
    });

    test('rechaza área <= 0', () {
      final granja = crearGranjaTest(areaTotalM2: 0);
      expect(granja.validar(), contains('área'));
    });

    test('rechaza galpones negativos', () {
      final granja = crearGranjaTest(numeroTotalGalpones: -1);
      expect(granja.validar(), contains('galpones'));
    });

    test('valida coordenadas si están presentes', () {
      final granja = crearGranjaTest(
        coordenadas: const Coordenadas(latitud: 200, longitud: 0), // inválida
      );
      expect(granja.validar(), contains('Coordenadas'));
    });
  });

  group('Granja - copyWith', () {
    test('copyWith preserva campos', () {
      final granja = crearGranjaTest(nombre: 'Original');
      final copia = granja.copyWith();
      expect(copia, equals(granja));
    });

    test('copyWith modifica nombre', () {
      final granja = crearGranjaTest(nombre: 'Original');
      final copia = granja.copyWith(nombre: 'Modificada');
      expect(copia.nombre, 'Modificada');
      expect(copia.id, granja.id);
    });
  });

  group('Granja - Métodos de actualización', () {
    test('actualizarContacto actualiza teléfono y correo', () {
      final granja = crearGranjaTest();
      final actualizada = granja.actualizarContacto(
        telefono: '999888777',
        correo: 'nuevo@email.com',
      );
      expect(actualizada.telefono, '999888777');
      expect(actualizada.correo, 'nuevo@email.com');
    });

    test('actualizarEstadisticas actualiza capacidad', () {
      final granja = crearGranjaTest();
      final actualizada = granja.actualizarEstadisticas(
        capacidadTotalAves: 10000,
        areaTotalM2: 500.0,
        numeroTotalGalpones: 4,
      );
      expect(actualizada.capacidadTotalAves, 10000);
      expect(actualizada.areaTotalM2, 500.0);
      expect(actualizada.numeroTotalGalpones, 4);
    });

    test('marcarActualizado actualiza fecha', () {
      final granja = crearGranjaTest();
      final marcada = granja.marcarActualizado();
      expect(marcada.ultimaActualizacion, isNotNull);
    });
  });

  group('GranjaException', () {
    test('toString incluye mensaje', () {
      final ex = GranjaException('test');
      expect(ex.toString(), 'GranjaException: test');
    });
  });
}
