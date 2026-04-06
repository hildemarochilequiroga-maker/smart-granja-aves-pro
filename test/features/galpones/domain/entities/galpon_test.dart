import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/galpones/domain/entities/galpon.dart';
import 'package:smartgranjaavespro/features/galpones/domain/enums/enums.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Galpon — propiedades calculadas', () {
    test('estaActivo', () {
      final g = crearGalponTest(estado: EstadoGalpon.activo);
      expect(g.estaActivo, isTrue);
    });

    test('estaDisponible cuando activo y sin lote', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: null,
      );
      expect(g.estaDisponible, isTrue);
    });

    test('no disponible si tiene lote', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: 'lote-1',
      );
      expect(g.estaDisponible, isFalse);
    });

    test('no disponible si en mantenimiento', () {
      final g = crearGalponTest(estado: EstadoGalpon.mantenimiento);
      expect(g.estaDisponible, isFalse);
    });

    test('tieneLoteActual', () {
      final g = crearGalponTest(loteActualId: 'lote-1');
      expect(g.tieneLoteActual, isTrue);
      expect(g.estaOcupado, isTrue);
      expect(g.estaVacio, isFalse);
    });

    test('estaVacio sin lote', () {
      final g = crearGalponTest(loteActualId: null);
      expect(g.estaVacio, isTrue);
    });

    test('estaEnMantenimiento', () {
      final g = crearGalponTest(estado: EstadoGalpon.mantenimiento);
      expect(g.estaEnMantenimiento, isTrue);
    });

    test('estaEnDesinfeccion', () {
      final g = crearGalponTest(estado: EstadoGalpon.desinfeccion);
      expect(g.estaEnDesinfeccion, isTrue);
    });

    test('estaEnCuarentena', () {
      final g = crearGalponTest(estado: EstadoGalpon.cuarentena);
      expect(g.estaEnCuarentena, isTrue);
    });

    test('estaInactivo', () {
      final g = crearGalponTest(estado: EstadoGalpon.inactivo);
      expect(g.estaInactivo, isTrue);
    });

    test('requiereAtencion en cuarentena y mantenimiento', () {
      expect(
        crearGalponTest(estado: EstadoGalpon.cuarentena).requiereAtencion,
        isTrue,
      );
      expect(
        crearGalponTest(estado: EstadoGalpon.mantenimiento).requiereAtencion,
        isTrue,
      );
      expect(
        crearGalponTest(estado: EstadoGalpon.activo).requiereAtencion,
        isFalse,
      );
    });

    test('porcentajeOcupacion', () {
      final g = crearGalponTest(capacidadMaxima: 1000, avesActuales: 500);
      expect(g.porcentajeOcupacion, 50.0);
    });

    test('porcentajeOcupacion con capacidad 0', () {
      final g = crearGalponTest(capacidadMaxima: 1000, avesActuales: 0);
      expect(g.porcentajeOcupacion, 0.0);
    });

    test('densidadMaximaAvesM2', () {
      final g = crearGalponTest(capacidadMaxima: 5000, areaM2: 500.0);
      expect(g.densidadMaximaAvesM2, 10.0);
    });

    test('densidadMaximaAvesM2 sin área', () {
      final g = crearGalponTest(areaM2: null);
      expect(g.densidadMaximaAvesM2, isNull);
    });

    test('densidadActualAvesM2', () {
      final g = crearGalponTest(avesActuales: 1000, areaM2: 500.0);
      expect(g.densidadActualAvesM2, 2.0);
    });

    test('mantenimientoVencido', () {
      final g = crearGalponTest(
        proximoMantenimiento: DateTime.now().subtract(const Duration(days: 5)),
      );
      expect(g.mantenimientoVencido, isTrue);
    });

    test('mantenimientoProximo', () {
      final g = crearGalponTest(
        proximoMantenimiento: DateTime.now().add(const Duration(days: 3)),
      );
      expect(g.mantenimientoProximo, isTrue);
    });

    test('mantenimientoProximo false si > 7 días', () {
      final g = crearGalponTest(
        proximoMantenimiento: DateTime.now().add(const Duration(days: 30)),
      );
      expect(g.mantenimientoProximo, isFalse);
    });

    test('mantenimientoVencido false sin fecha programada', () {
      final g = crearGalponTest(proximoMantenimiento: null);
      expect(g.mantenimientoVencido, isFalse);
    });
  });

  group('Galpon — transiciones de estado', () {
    test('activar desde mantenimiento', () {
      final g = crearGalponTest(estado: EstadoGalpon.mantenimiento);
      final activado = g.activar();
      expect(activado.estado, EstadoGalpon.activo);
    });

    test('ponerEnMantenimiento desde activo', () {
      final g = crearGalponTest(estado: EstadoGalpon.activo);
      final result = g.ponerEnMantenimiento(motivo: 'Reparación');
      expect(result.estado, EstadoGalpon.mantenimiento);
    });

    test('iniciarDesinfeccion desde activo sin lote', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: null,
      );
      final result = g.iniciarDesinfeccion();
      expect(result.estado, EstadoGalpon.desinfeccion);
      expect(result.ultimaDesinfeccion, isNotNull);
    });

    test('iniciarDesinfeccion con lote lanza excepción', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: 'lote-1',
      );
      expect(() => g.iniciarDesinfeccion(), throwsA(isA<GalponException>()));
    });

    test('ponerEnCuarentena', () {
      final g = crearGalponTest(estado: EstadoGalpon.activo);
      final result = g.ponerEnCuarentena(motivo: 'Brote');
      expect(result.estado, EstadoGalpon.cuarentena);
    });

    test('inactivar', () {
      final g = crearGalponTest(estado: EstadoGalpon.activo);
      final result = g.inactivar();
      expect(result.estado, EstadoGalpon.inactivo);
    });

    test('transición no permitida lanza excepción', () {
      final g = crearGalponTest(estado: EstadoGalpon.inactivo);
      expect(() => g.activar(), throwsA(isA<GalponException>()));
    });

    test('transición forzada permite transición no permitida', () {
      final g = crearGalponTest(estado: EstadoGalpon.inactivo);
      final result = g.cambiarEstado(EstadoGalpon.activo, forzar: true);
      expect(result.estado, EstadoGalpon.activo);
    });

    test('cambiar a estado que requiere vacío con lote lanza excepción', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: 'lote-1',
      );
      expect(
        () => g.cambiarEstado(EstadoGalpon.desinfeccion),
        throwsA(isA<GalponException>()),
      );
    });
  });

  group('Galpon — asignarLote / liberarLote', () {
    test('asignarLote a galpón disponible', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.activo,
        loteActualId: null,
      );
      final result = g.asignarLote('lote-nuevo');
      expect(result.loteActualId, 'lote-nuevo');
    });

    test('asignarLote a galpón no disponible lanza excepción', () {
      final g = crearGalponTest(loteActualId: 'lote-existente');
      expect(
        () => g.asignarLote('lote-nuevo'),
        throwsA(isA<GalponException>()),
      );
    });

    test('liberarLote resetea aves y agrega al historial', () {
      final g = crearGalponTest(
        loteActualId: 'lote-1',
        avesActuales: 500,
        lotesHistoricos: ['lote-old'],
      );
      final result = g.liberarLote();
      expect(result.loteActualId, isNull);
      expect(result.avesActuales, 0);
      expect(result.lotesHistoricos, ['lote-old', 'lote-1']);
    });
  });

  group('Galpon — actualizarCapacidad', () {
    test('actualiza capacidad válida', () {
      final g = crearGalponTest(capacidadMaxima: 5000);
      final result = g.actualizarCapacidad(8000);
      expect(result.capacidadMaxima, 8000);
    });

    test('capacidad <= 0 lanza excepción', () {
      final g = crearGalponTest();
      expect(() => g.actualizarCapacidad(0), throwsA(isA<GalponException>()));
    });
  });

  group('Galpon — actualizarAvesActuales', () {
    test('actualiza cantidad válida', () {
      final g = crearGalponTest(capacidadMaxima: 5000);
      final result = g.actualizarAvesActuales(3000);
      expect(result.avesActuales, 3000);
    });

    test('cantidad negativa lanza excepción', () {
      final g = crearGalponTest();
      expect(
        () => g.actualizarAvesActuales(-1),
        throwsA(isA<GalponException>()),
      );
    });

    test('cantidad > capacidad lanza excepción', () {
      final g = crearGalponTest(capacidadMaxima: 100);
      expect(
        () => g.actualizarAvesActuales(200),
        throwsA(isA<GalponException>()),
      );
    });
  });

  group('Galpon — validar', () {
    test('galpón válido retorna null', () {
      final g = crearGalponTest();
      expect(g.validar(), isNull);
      expect(g.esValido, isTrue);
    });

    test('granjaId vacío', () {
      final g = crearGalponTest(granjaId: '');
      expect(g.validar(), isNotNull);
    });

    test('codigo vacío', () {
      final g = crearGalponTest(codigo: '  ');
      expect(g.validar(), isNotNull);
    });

    test('nombre vacío', () {
      final g = crearGalponTest(nombre: '  ');
      expect(g.validar(), isNotNull);
    });

    test('avesActuales > capacidad', () {
      final g = crearGalponTest(capacidadMaxima: 100, avesActuales: 200);
      expect(g.validar(), isNotNull);
    });

    test('estado vacío requerido con lote', () {
      final g = crearGalponTest(
        estado: EstadoGalpon.desinfeccion,
        loteActualId: 'lote-1',
      );
      expect(g.validar(), isNotNull);
    });
  });

  group('Galpon — copyWith', () {
    test('copia sin cambios es igual', () {
      final g = crearGalponTest();
      final copia = g.copyWith();
      expect(copia, equals(g));
    });

    test('copia con cambios de campo nullable a null', () {
      final g = crearGalponTest(loteActualId: 'lote-1');
      final copia = g.copyWith(loteActualId: null);
      expect(copia.loteActualId, isNull);
    });
  });

  group('Galpon — Equatable', () {
    test('galpones iguales son iguales', () {
      final g1 = crearGalponTest();
      final g2 = crearGalponTest();
      expect(g1, equals(g2));
    });

    test('galpones con distinto id no son iguales', () {
      final g1 = crearGalponTest(id: 'a');
      final g2 = crearGalponTest(id: 'b');
      expect(g1, isNot(equals(g2)));
    });
  });

  group('Galpon — toString', () {
    test('incluye id, codigo, nombre', () {
      final g = crearGalponTest(id: 'g-1', codigo: 'GAL-001', nombre: 'Test');
      final str = g.toString();
      expect(str, contains('g-1'));
      expect(str, contains('GAL-001'));
      expect(str, contains('Test'));
    });
  });

  group('Galpon.nuevo factory', () {
    test('crea galpón con estado activo y id vacío', () {
      final g = Galpon.nuevo(
        granjaId: 'granja-1',
        codigo: 'GAL-002',
        nombre: 'Nuevo',
        tipo: TipoGalpon.postura,
        capacidadMaxima: 3000,
      );
      expect(g.id, '');
      expect(g.estado, EstadoGalpon.activo);
      expect(g.granjaId, 'granja-1');
    });
  });

  group('GalponException', () {
    test('toString incluye mensaje', () {
      final e = GalponException('Algo falló');
      expect(e.toString(), contains('Algo falló'));
    });
  });
}
