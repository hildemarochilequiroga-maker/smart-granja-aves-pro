/// Resultado del cálculo de costo acumulado por ave viva de un lote a una
/// fecha determinada.
library;

import 'package:equatable/equatable.dart';

import '../../../costos/domain/enums/tipo_gasto.dart';

/// Costo acumulado por ave viva de un lote hasta una fecha de corte.
///
/// Métrica pecuaria estándar: el costo total incurrido (incluido el de las
/// aves que ya murieron) se reparte entre las aves que siguen vivas a la fecha,
/// respondiendo "¿cuánto llevo invertido en cada ave que sobrevive?".
///
/// Composición del costo (ver `CalcularCostoPorAveUseCase`):
/// - [costoInicialAves]: compra de las aves (`costoAveInicial × cantidadInicial`).
/// - [costoAlimento]: alimento consumido (`Σ RegistroConsumo.costoPorKg × kg`).
///   El alimento se cuenta SOLO desde los registros de consumo; los
///   `CostoGasto` de tipo alimento se excluyen para evitar doble conteo.
/// - [costoGastosDirectos]: gastos asignados al lote vía `loteId` (sin alimento).
/// - [costoGastosCompartidos]: gastos compartidos (`lotesAsignados`) prorrateados
///   de forma ponderada por las aves vivas del lote frente al total de aves
///   vivas de los lotes que comparten el gasto.
class CostoPorAve extends Equatable {
  const CostoPorAve({
    required this.fecha,
    required this.avesVivas,
    required this.costoInicialAves,
    required this.costoAlimento,
    required this.costoGastosDirectos,
    required this.costoGastosCompartidos,
    required this.desglosePorTipo,
    this.faltaCostoInicial = false,
    this.consumosSinCosto = 0,
  });

  /// Fecha de corte del cálculo (inclusive).
  final DateTime fecha;

  /// Aves vivas del lote a [fecha].
  final int avesVivas;

  /// Costo de compra de las aves al ingreso.
  final double costoInicialAves;

  /// Costo del alimento consumido hasta [fecha].
  final double costoAlimento;

  /// Gastos directos del lote (excluye alimento) hasta [fecha].
  final double costoGastosDirectos;

  /// Gastos compartidos prorrateados hasta [fecha].
  final double costoGastosCompartidos;

  /// Desglose del costo acumulado por tipo de gasto (para visualización).
  final Map<TipoGasto, double> desglosePorTipo;

  /// `true` si el lote no tiene `costoAveInicial` definido (el costo inicial
  /// de aves se tomó como 0 y conviene avisarlo en la UI).
  final bool faltaCostoInicial;

  /// Número de registros de consumo (hasta [fecha]) que NO tienen `costoPorKg`
  /// y por tanto no aportaron al costo de alimento. Si es > 0, el alimento (y
  /// el costo por ave) puede estar subestimado. La UI lo advierte.
  final int consumosSinCosto;

  /// Costo acumulado total del lote hasta [fecha].
  double get costoAcumuladoTotal =>
      costoInicialAves +
      costoAlimento +
      costoGastosDirectos +
      costoGastosCompartidos;

  /// Costo acumulado por cada ave viva. `0` si no hay aves vivas (evita la
  /// división por cero y permite a la UI mostrar un estado neutro).
  double get costoPorAveViva =>
      avesVivas > 0 ? costoAcumuladoTotal / avesVivas : 0;

  /// `true` si no se registró ningún costo para el lote (ni inicial de aves, ni
  /// alimento, ni gastos). La UI muestra un estado vacío en vez de "0".
  bool get sinDatosDeCosto => costoAcumuladoTotal <= 0;

  /// Cálculo vacío (sin costos) para [fecha], útil como valor por defecto.
  factory CostoPorAve.vacio(DateTime fecha, {int avesVivas = 0}) {
    return CostoPorAve(
      fecha: fecha,
      avesVivas: avesVivas,
      costoInicialAves: 0,
      costoAlimento: 0,
      costoGastosDirectos: 0,
      costoGastosCompartidos: 0,
      desglosePorTipo: const {},
    );
  }

  @override
  List<Object?> get props => [
    fecha,
    avesVivas,
    costoInicialAves,
    costoAlimento,
    costoGastosDirectos,
    costoGastosCompartidos,
    desglosePorTipo,
    faltaCostoInicial,
    consumosSinCosto,
  ];
}
