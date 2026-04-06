import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/inventario/domain/entities/item_inventario.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  group('ItemInventario - Propiedades Calculadas', () {
    test('stockBajo cuando stock <= mínimo y > 0', () {
      final item = crearItemInventarioTest(stockActual: 15, stockMinimo: 20);
      expect(item.stockBajo, true);
    });

    test('stockBajo false cuando stock > mínimo', () {
      final item = crearItemInventarioTest(stockActual: 50, stockMinimo: 20);
      expect(item.stockBajo, false);
    });

    test('stockBajo false cuando agotado (stockActual == 0)', () {
      final item = crearItemInventarioTest(stockActual: 0, stockMinimo: 20);
      expect(item.stockBajo, false);
    });

    test('agotado cuando stockActual <= 0', () {
      final item = crearItemInventarioTest(stockActual: 0);
      expect(item.agotado, true);
    });

    test('agotado false cuando hay stock', () {
      final item = crearItemInventarioTest(stockActual: 10);
      expect(item.agotado, false);
    });

    test('disponible cuando stockActual > 0', () {
      final item = crearItemInventarioTest(stockActual: 1);
      expect(item.disponible, true);
    });

    test('disponible false cuando agotado', () {
      final item = crearItemInventarioTest(stockActual: 0);
      expect(item.disponible, false);
    });

    test('proximoVencer — dentro de 30 días', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().add(const Duration(days: 15)),
      );
      expect(item.proximoVencer, true);
    });

    test('proximoVencer — más de 30 días no es próximo', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().add(const Duration(days: 60)),
      );
      expect(item.proximoVencer, false);
    });

    test('proximoVencer — sin fecha es false', () {
      final item = crearItemInventarioTest();
      expect(item.proximoVencer, false);
    });

    test('proximoVencer — ya vencido no es próximo', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(item.proximoVencer, false);
    });

    test('vencido — fecha pasada', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(item.vencido, true);
    });

    test('vencido — fecha futura no está vencido', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().add(const Duration(days: 30)),
      );
      expect(item.vencido, false);
    });

    test('vencido — sin fecha no está vencido', () {
      final item = crearItemInventarioTest();
      expect(item.vencido, false);
    });

    test('diasParaVencer cuenta días correctamente', () {
      final item = crearItemInventarioTest(
        fechaVencimiento: DateTime.now().add(const Duration(days: 15)),
      );
      expect(item.diasParaVencer, closeTo(15, 1));
    });

    test('diasParaVencer retorna null sin fecha', () {
      final item = crearItemInventarioTest();
      expect(item.diasParaVencer, isNull);
    });

    test('valorTotal calcula stock * precio', () {
      final item = crearItemInventarioTest(
        stockActual: 100,
        precioUnitario: 25.0,
      );
      expect(item.valorTotal, 2500.0);
    });

    test('valorTotal retorna null sin precio', () {
      final item = crearItemInventarioTest(stockActual: 100);
      expect(item.valorTotal, isNull);
    });

    test('porcentajeStock calcula correctamente', () {
      final item = crearItemInventarioTest(stockActual: 50, stockMinimo: 100);
      expect(item.porcentajeStock, 50.0);
    });

    test('porcentajeStock retorna 100 si mínimo es 0', () {
      final item = crearItemInventarioTest(stockActual: 50, stockMinimo: 0);
      expect(item.porcentajeStock, 100);
    });

    test('porcentajeStock clamp a 200', () {
      final item = crearItemInventarioTest(stockActual: 500, stockMinimo: 100);
      expect(item.porcentajeStock, 200);
    });
  });

  group('ItemInventario - copyWith', () {
    test('copyWith preserva todos los campos', () {
      final item = crearItemInventarioTest(
        stockActual: 100,
        precioUnitario: 25.0,
      );
      final copia = item.copyWith();
      expect(copia, equals(item));
    });

    test('copyWith modifica campo específico', () {
      final item = crearItemInventarioTest(stockActual: 100);
      final copia = item.copyWith(stockActual: 80);
      expect(copia.stockActual, 80);
      expect(copia.nombre, item.nombre);
    });
  });

  group('ItemInventario - Equatable', () {
    test('items iguales son equal', () {
      final a = crearItemInventarioTest(id: 'item-1', stockActual: 100);
      final b = crearItemInventarioTest(id: 'item-1', stockActual: 100);
      expect(a, equals(b));
    });

    test('items con diferente stock no son equal', () {
      final a = crearItemInventarioTest(id: 'item-1', stockActual: 100);
      final b = crearItemInventarioTest(id: 'item-1', stockActual: 50);
      expect(a, isNot(equals(b)));
    });
  });

  group('ItemInventarioException', () {
    test('toString incluye mensaje', () {
      const ex = ItemInventarioException('Test error');
      expect(ex.toString(), 'ItemInventarioException: Test error');
    });
  });
}
