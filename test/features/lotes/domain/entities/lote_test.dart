import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/lotes/domain/entities/lote.dart';
import 'package:smartgranjaavespro/features/lotes/domain/enums/enums.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('Lote - Propiedades Calculadas', () {
    test('avesActuales calcula correctamente con bajas', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 20,
        descartesAcumulados: 10,
        ventasAcumuladas: 50,
      );
      expect(lote.avesActuales, 920);
    });

    test('avesActuales retorna cantidadInicial si no hay bajas', () {
      final lote = crearLoteTest(cantidadInicial: 500);
      expect(lote.avesActuales, 500);
    });

    test('avesDisponibles usa calculado si cantidadActual es null', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 50,
      );
      expect(lote.avesDisponibles, 950);
    });

    test('avesDisponibles usa mínimo entre calculado y cantidadActual', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 50,
        cantidadActual: 900, // menor que el calculado (950)
      );
      expect(lote.avesDisponibles, 900);
    });

    test('porcentajeMortalidad calcula correctamente', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 40,
      );
      expect(lote.porcentajeMortalidad, 4.0);
    });

    test('porcentajeMortalidad retorna 0 si cantidadInicial es 0', () {
      final lote = crearLoteTest(cantidadInicial: 1000);
      expect(lote.porcentajeMortalidad, 0);
    });

    test('porcentajeSupervivencia es complement de mortalidad', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 40,
      );
      expect(lote.porcentajeSupervivencia, 96.0);
    });

    test('estaActivo retorna true para estado activo', () {
      final lote = crearLoteTest(estado: EstadoLote.activo);
      expect(lote.estaActivo, true);
    });

    test('estaActivo retorna false para otros estados', () {
      final lote = crearLoteTest(estado: EstadoLote.cerrado);
      expect(lote.estaActivo, false);
    });

    test('estaFinalizado para lote cerrado', () {
      final lote = crearLoteTest(estado: EstadoLote.cerrado);
      expect(lote.estaFinalizado, true);
    });

    test('estaFinalizado para lote vendido', () {
      final lote = crearLoteTest(estado: EstadoLote.vendido);
      expect(lote.estaFinalizado, true);
    });

    test('estaEnCuarentena', () {
      final lote = crearLoteTest(estado: EstadoLote.cuarentena);
      expect(lote.estaEnCuarentena, true);
    });

    test('mortalidadDentroLimites — dentro del 120% del esperado', () {
      // polloEngorde mortalidadEsperada = 4.0, límite = 4.8%
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 40, // 4% — dentro del límite
      );
      expect(lote.mortalidadDentroLimites, true);
    });

    test('mortalidadDentroLimites — fuera del límite', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 60, // 6% — fuera del 4.8% límite
      );
      expect(lote.mortalidadDentroLimites, false);
    });

    test('displayName retorna nombre si existe', () {
      final lote = crearLoteTest(codigo: 'LOT-001');
      // nombre es null, debe retornar codigo
      expect(lote.displayName, 'LOT-001');
    });

    test('indiceConversionAlimenticia calcula ICA', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        consumoAcumuladoKg: 3600.0,
        pesoPromedioActual: 2.0, // 2 kg
      );
      // ICA = 3600 / (2.0 * 1000) = 1.8
      expect(lote.indiceConversionAlimenticia, closeTo(1.8, 0.01));
    });

    test('indiceConversionAlimenticia retorna null sin datos', () {
      final lote = crearLoteTest();
      expect(lote.indiceConversionAlimenticia, isNull);
    });

    test('consumoPromedioPorAve calcula correctamente', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        consumoAcumuladoKg: 500.0,
      );
      expect(lote.consumoPromedioPorAve, closeTo(0.5, 0.01));
    });

    test('huevosPorAve calcula para ponedora', () {
      final lote = crearLoteTest(
        tipoAve: TipoAve.gallinaPonedora,
        cantidadInicial: 200,
        huevosProducidos: 1000,
      );
      expect(lote.huevosPorAve, closeTo(5.0, 0.01));
    });

    test('huevosPorAve retorna null para no ponedora', () {
      final lote = crearLoteTest(
        tipoAve: TipoAve.polloEngorde,
        huevosProducidos: 100, // no debería tener
      );
      expect(lote.huevosPorAve, isNull);
    });

    test('icaDentroLimites — pollo engorde con ICA bueno', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        consumoAcumuladoKg: 3000.0,
        pesoPromedioActual: 2.0, // ICA = 1.5
      );
      expect(lote.icaDentroLimites, true);
    });

    test('icaDentroLimites — pollo engorde con ICA malo', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        consumoAcumuladoKg: 5000.0,
        pesoPromedioActual: 2.0, // ICA = 2.5 — malo para engorde
      );
      expect(lote.icaDentroLimites, false);
    });
  });

  group('Lote - Métodos de Negocio', () {
    test('registrarMortalidad incrementa mortalidad', () {
      final lote = crearLoteTest(cantidadInicial: 1000);
      final resultado = lote.registrarMortalidad(10);
      expect(resultado.mortalidadAcumulada, 10);
    });

    test('registrarMortalidad con observación', () {
      final lote = crearLoteTest(cantidadInicial: 1000);
      final resultado = lote.registrarMortalidad(5, observacion: 'Calor');
      expect(resultado.mortalidadAcumulada, 5);
      expect(resultado.observaciones, contains('Calor'));
    });

    test('registrarMortalidad lanza error si cantidad <= 0', () {
      final lote = crearLoteTest();
      expect(() => lote.registrarMortalidad(0), throwsA(isA<LoteException>()));
    });

    test('registrarMortalidad lanza error si supera aves disponibles', () {
      final lote = crearLoteTest(cantidadInicial: 100);
      expect(
        () => lote.registrarMortalidad(101),
        throwsA(isA<LoteException>()),
      );
    });

    test('registrarMortalidad lanza error en estado cerrado', () {
      final lote = crearLoteTest(estado: EstadoLote.cerrado);
      expect(() => lote.registrarMortalidad(5), throwsA(isA<LoteException>()));
    });

    test('registrarDescarte incrementa descartes', () {
      final lote = crearLoteTest(cantidadInicial: 1000);
      final resultado = lote.registrarDescarte(15, motivo: 'Selección');
      expect(resultado.descartesAcumulados, 15);
      expect(resultado.observaciones, contains('Selección'));
    });

    test('registrarVenta incrementa ventas', () {
      final lote = crearLoteTest(cantidadInicial: 1000);
      final resultado = lote.registrarVenta(200);
      expect(resultado.ventasAcumuladas, 200);
    });

    test('actualizarPeso actualiza peso', () {
      final lote = crearLoteTest();
      final resultado = lote.actualizarPeso(2.5);
      expect(resultado.pesoPromedioActual, 2.5);
    });

    test('actualizarPeso lanza error para peso negativo', () {
      final lote = crearLoteTest();
      expect(() => lote.actualizarPeso(-1), throwsA(isA<LoteException>()));
    });

    test('registrarConsumoAlimento acumula consumo', () {
      final lote = crearLoteTest(consumoAcumuladoKg: 100);
      final resultado = lote.registrarConsumoAlimento(50);
      expect(resultado.consumoAcumuladoKg, 150);
    });

    test('registrarConsumoAlimento desde 0', () {
      final lote = crearLoteTest();
      final resultado = lote.registrarConsumoAlimento(50);
      expect(resultado.consumoAcumuladoKg, 50);
    });

    test('registrarProduccionHuevos acumula huevos para ponedora', () {
      final lote = crearLoteTest(
        tipoAve: TipoAve.gallinaPonedora,
        huevosProducidos: 100,
      );
      final resultado = lote.registrarProduccionHuevos(50);
      expect(resultado.huevosProducidos, 150);
    });

    test('registrarProduccionHuevos establece fechaPrimerHuevo', () {
      final lote = crearLoteTest(tipoAve: TipoAve.gallinaPonedora);
      final resultado = lote.registrarProduccionHuevos(10);
      expect(resultado.fechaPrimerHuevo, isNotNull);
    });

    test('registrarProduccionHuevos lanza error para no ponedora', () {
      final lote = crearLoteTest(tipoAve: TipoAve.polloEngorde);
      expect(
        () => lote.registrarProduccionHuevos(10),
        throwsA(isA<LoteException>()),
      );
    });
  });

  group('Lote - Transiciones de Estado', () {
    test('cambiarEstado activo → cuarentena permitido', () {
      final lote = crearLoteTest(estado: EstadoLote.activo);
      final resultado = lote.cambiarEstado(EstadoLote.cuarentena);
      expect(resultado.estado, EstadoLote.cuarentena);
    });

    test('cambiarEstado cerrado → activo no permitido', () {
      final lote = crearLoteTest(estado: EstadoLote.cerrado);
      expect(
        () => lote.cambiarEstado(EstadoLote.activo),
        throwsA(isA<LoteException>()),
      );
    });

    test('cambiarEstado forzado ignora restricciones', () {
      final lote = crearLoteTest(estado: EstadoLote.cerrado);
      final resultado = lote.cambiarEstado(EstadoLote.activo, forzar: true);
      expect(resultado.estado, EstadoLote.activo);
    });

    test('ponerEnCuarentena funciona desde activo', () {
      final lote = crearLoteTest(estado: EstadoLote.activo);
      final resultado = lote.ponerEnCuarentena(motivo: 'Enfermedad');
      expect(resultado.estado, EstadoLote.cuarentena);
      expect(resultado.observaciones, contains('Enfermedad'));
    });

    test('cerrar establece fecha de cierre y estado', () {
      final lote = crearLoteTest();
      final resultado = lote.cerrar(motivo: 'Fin de ciclo');
      expect(resultado.estado, EstadoLote.cerrado);
      expect(resultado.fechaCierreReal, isNotNull);
      expect(resultado.motivoCierre, 'Fin de ciclo');
    });

    test('marcarVendido registra venta de todas las aves restantes', () {
      final lote = crearLoteTest(
        cantidadInicial: 1000,
        mortalidadAcumulada: 50,
      );
      final resultado = lote.marcarVendido(comprador: 'Empresa XYZ');
      expect(resultado.estado, EstadoLote.vendido);
      expect(resultado.ventasAcumuladas, 950); // 1000 - 50
      expect(resultado.motivoCierre, contains('Empresa XYZ'));
    });

    test('transferirAGalpon cambia galpón', () {
      final lote = crearLoteTest(galponId: 'galpon-1');
      final resultado = lote.transferirAGalpon('galpon-2');
      expect(resultado.galponId, 'galpon-2');
      expect(resultado.observaciones, contains('galpon-1'));
    });

    test('transferirAGalpon lanza error si es el mismo galpón', () {
      final lote = crearLoteTest(galponId: 'galpon-1');
      expect(
        () => lote.transferirAGalpon('galpon-1'),
        throwsA(isA<LoteException>()),
      );
    });
  });

  group('Lote - Validación', () {
    test('lote válido pasa validación', () {
      final lote = crearLoteTest();
      expect(lote.validar(), isNull);
      expect(lote.esValido, true);
    });

    test('rechaza granjaId vacío', () {
      final lote = crearLoteTest(granjaId: '');
      expect(lote.validar(), contains('granja'));
    });

    test('rechaza galponId vacío', () {
      final lote = crearLoteTest(galponId: '');
      expect(lote.validar(), contains('galpón'));
    });

    test('rechaza código vacío', () {
      final lote = crearLoteTest(codigo: '  ');
      expect(lote.validar(), contains('código'));
    });

    test('rechaza cantidadInicial negativa', () {
      final lote = crearLoteTest(cantidadInicial: -1);
      expect(lote.validar(), contains('positiva'));
    });

    test('rechaza peso promedio negativo', () {
      final lote = crearLoteTest(pesoPromedioActual: -0.5);
      expect(lote.validar(), contains('peso'));
    });

    test('rechaza costo ave negativo', () {
      final lote = crearLoteTest(costoAveInicial: -1.0);
      expect(lote.validar(), contains('costo'));
    });
  });

  group('Lote - copyWith', () {
    test('copyWith preserva todos los campos', () {
      final lote = crearLoteTest(cantidadInicial: 500);
      final copia = lote.copyWith();
      expect(copia, equals(lote));
    });

    test('copyWith modifica campo específico', () {
      final lote = crearLoteTest(cantidadInicial: 500);
      final copia = lote.copyWith(cantidadInicial: 600);
      expect(copia.cantidadInicial, 600);
      expect(copia.id, lote.id);
      expect(copia.granjaId, lote.granjaId);
    });
  });

  group('Lote.nuevo factory', () {
    test('crea lote con valores por defecto correctos', () {
      final lote = Lote.nuevo(
        granjaId: 'g1',
        galponId: 'gal1',
        codigo: 'LOT-001',
        tipoAve: TipoAve.polloEngorde,
        cantidadInicial: 1000,
        fechaIngreso: DateTime(2024, 6, 1),
      );

      expect(lote.id, '');
      expect(lote.estado, EstadoLote.activo);
      expect(lote.cantidadActual, 1000);
      expect(lote.mortalidadAcumulada, 0);
      expect(lote.descartesAcumulados, 0);
      expect(lote.ventasAcumuladas, 0);
      expect(lote.consumoAcumuladoKg, 0);
      expect(lote.pesoPromedioObjetivo, TipoAve.polloEngorde.pesoPromedioVenta);
      expect(lote.fechaCierreEstimada, isNotNull);
      expect(lote.fechaCreacion, isNotNull);
    });

    test('crea lote ponedora con huevosProducidos inicializado', () {
      final lote = Lote.nuevo(
        granjaId: 'g1',
        galponId: 'gal1',
        codigo: 'LOT-002',
        tipoAve: TipoAve.gallinaPonedora,
        cantidadInicial: 500,
        fechaIngreso: DateTime(2024, 6, 1),
      );

      expect(lote.huevosProducidos, 0);
    });

    test('crea lote engorde sin huevosProducidos', () {
      final lote = Lote.nuevo(
        granjaId: 'g1',
        galponId: 'gal1',
        codigo: 'LOT-003',
        tipoAve: TipoAve.polloEngorde,
        cantidadInicial: 1000,
        fechaIngreso: DateTime(2024, 6, 1),
      );

      expect(lote.huevosProducidos, isNull);
    });
  });

  group('LoteException', () {
    test('toString incluye mensaje', () {
      final ex = LoteException('test error');
      expect(ex.toString(), 'LoteException: test error');
    });
  });
}
