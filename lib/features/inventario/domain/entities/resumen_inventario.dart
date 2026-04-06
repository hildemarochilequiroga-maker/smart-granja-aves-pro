/// Resumen de inventario para dashboards y reportes.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';
import 'item_inventario.dart';

/// Resumen del estado del inventario.
class ResumenInventario extends Equatable {
  const ResumenInventario({
    required this.totalItems,
    required this.itemsConStockBajo,
    required this.itemsAgotados,
    required this.itemsProximosVencer,
    required this.itemsVencidos,
    required this.valorTotalInventario,
    required this.distribucionPorTipo,
    required this.alertasCriticas,
  });

  /// Total de items en inventario.
  final int totalItems;

  /// Items con stock bajo.
  final int itemsConStockBajo;

  /// Items agotados.
  final int itemsAgotados;

  /// Items próximos a vencer.
  final int itemsProximosVencer;

  /// Items ya vencidos.
  final int itemsVencidos;

  /// Valor total del inventario.
  final double valorTotalInventario;

  /// Distribución de items por tipo.
  final Map<TipoItem, int> distribucionPorTipo;

  /// Lista de alertas críticas.
  final List<AlertaInventario> alertasCriticas;

  /// Total de alertas.
  int get totalAlertas =>
      itemsConStockBajo + itemsAgotados + itemsProximosVencer + itemsVencidos;

  /// Verifica si hay alertas.
  bool get tieneAlertas => totalAlertas > 0;

  /// Factory desde lista de items.
  factory ResumenInventario.fromItems(List<ItemInventario> items) {
    final stockBajo = items.where((i) => i.stockBajo).length;
    final agotados = items.where((i) => i.agotado).length;
    final proximosVencer = items.where((i) => i.proximoVencer).length;
    final vencidos = items.where((i) => i.vencido).length;

    double valorTotal = 0;
    for (final item in items) {
      valorTotal += item.valorTotal ?? 0;
    }

    final distribucion = <TipoItem, int>{};
    for (final tipo in TipoItem.values) {
      final count = items.where((i) => i.tipo == tipo).length;
      if (count > 0) {
        distribucion[tipo] = count;
      }
    }

    final alertas = <AlertaInventario>[];
    for (final item in items) {
      if (item.agotado) {
        alertas.add(
          AlertaInventario(
            item: item,
            tipo: TipoAlerta.agotado,
            mensaje: '${item.nombre} está agotado',
          ),
        );
      } else if (item.vencido) {
        alertas.add(
          AlertaInventario(
            item: item,
            tipo: TipoAlerta.vencido,
            mensaje: '${item.nombre} ha vencido',
          ),
        );
      } else if (item.stockBajo) {
        alertas.add(
          AlertaInventario(
            item: item,
            tipo: TipoAlerta.stockBajo,
            mensaje: '${item.nombre} tiene stock bajo',
          ),
        );
      } else if (item.proximoVencer) {
        alertas.add(
          AlertaInventario(
            item: item,
            tipo: TipoAlerta.proximoVencer,
            mensaje: '${item.nombre} vence en ${item.diasParaVencer} días',
          ),
        );
      }
    }

    return ResumenInventario(
      totalItems: items.length,
      itemsConStockBajo: stockBajo,
      itemsAgotados: agotados,
      itemsProximosVencer: proximosVencer,
      itemsVencidos: vencidos,
      valorTotalInventario: valorTotal,
      distribucionPorTipo: distribucion,
      alertasCriticas: alertas,
    );
  }

  @override
  List<Object?> get props => [
    totalItems,
    itemsConStockBajo,
    itemsAgotados,
    itemsProximosVencer,
    itemsVencidos,
    valorTotalInventario,
    distribucionPorTipo,
    alertasCriticas,
  ];
}

/// Tipos de alertas de inventario.
enum TipoAlerta { stockBajo, agotado, proximoVencer, vencido }

/// Alerta de inventario.
class AlertaInventario extends Equatable {
  const AlertaInventario({
    required this.item,
    required this.tipo,
    required this.mensaje,
  });

  final ItemInventario item;
  final TipoAlerta tipo;
  final String mensaje;

  @override
  List<Object?> get props => [item, tipo, mensaje];
}
