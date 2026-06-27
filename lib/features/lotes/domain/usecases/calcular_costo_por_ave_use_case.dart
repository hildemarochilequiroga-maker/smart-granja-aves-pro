/// Use case: calcula el costo acumulado por ave viva de un lote a una fecha.
library;

import '../../../costos/domain/entities/costo_gasto.dart';
import '../../../costos/domain/enums/tipo_gasto.dart';
import '../../../costos/domain/repositories/costo_repository.dart';
import '../../infrastructure/datasources/lote_firebase_datasource.dart';
import '../../infrastructure/datasources/registro_consumo_firebase_datasource.dart';
import '../../infrastructure/datasources/registro_mortalidad_firebase_datasource.dart';
import '../entities/lote.dart';
import '../value_objects/costo_por_ave.dart';

/// Calcula el [CostoPorAve] acumulado de un lote hasta una fecha de corte.
///
/// Fuentes de costo (decisiones de modelado documentadas en [CostoPorAve]):
/// 1. Costo inicial de aves: `Σ CostoGasto.monto` con tipo `compraAves` del
///    lote (ya NO desde `lote.costoAveInicial`). Se muestra como línea propia.
/// 2. Alimento: `Σ RegistroConsumo.costoPorKg × cantidadKg` con `fecha ≤ corte`.
///    Los `CostoGasto` de tipo `alimento` se EXCLUYEN (evita doble conteo).
/// 3. Gastos directos: `Σ CostoGasto.monto` con `loteId == lote.id`,
///    `fecha ≤ corte`, excluyendo tipo alimento y compraAves.
/// 4. Gastos compartidos: `CostoGasto` cuyo `lotesAsignados` contiene el lote,
///    prorrateados de forma ponderada por las aves vivas del lote frente al
///    total de aves vivas de los lotes que comparten el gasto.
class CalcularCostoPorAveUseCase {
  const CalcularCostoPorAveUseCase({
    required CostoRepository costoRepository,
    required RegistroConsumoFirebaseDatasource consumoDatasource,
    required RegistroMortalidadFirebaseDatasource mortalidadDatasource,
    required LoteFirebaseDatasource loteDatasource,
  }) : _costoRepository = costoRepository,
       _consumoDatasource = consumoDatasource,
       _mortalidadDatasource = mortalidadDatasource,
       _loteDatasource = loteDatasource;

  final CostoRepository _costoRepository;
  final RegistroConsumoFirebaseDatasource _consumoDatasource;
  final RegistroMortalidadFirebaseDatasource _mortalidadDatasource;
  final LoteFirebaseDatasource _loteDatasource;

  /// Calcula el costo por ave del [lote] a [fecha] (por defecto, hoy).
  Future<CostoPorAve> call(Lote lote, {DateTime? fecha}) async {
    final corte = _finDelDia(fecha ?? DateTime.now());

    // Cache de aves vivas por lote durante este cálculo: evita releer el mismo
    // lote/mortalidad varias veces al prorratear múltiples gastos compartidos.
    final avesCache = <String, int>{};

    // --- Aves vivas a la fecha de corte -------------------------------------
    final avesVivas = await _avesVivasAFecha(lote, corte);
    avesCache[lote.id] = avesVivas;

    // --- 1. Costo inicial de aves -------------------------------------------
    // Se obtiene desde los CostoGasto de tipo `compraAves` del lote (ya NO
    // desde lote.costoAveInicial). Se acumula abajo en el bucle de gastos y se
    // muestra como línea propia del desglose.
    var costoInicialAves = 0.0;

    // --- 2. Alimento (desde registros de consumo) ---------------------------
    final consumos = await _consumoDatasource.obtenerPorLote(lote.id);
    var costoAlimento = 0.0;
    var consumosSinCosto = 0;
    for (final c in consumos) {
      if (c.fecha.isAfter(corte)) continue;
      final costoKg = c.costoPorKg;
      if (costoKg == null) {
        // Consumo sin costo: no aporta al alimento; se cuenta para advertir
        // que el costo de alimento puede estar subestimado.
        consumosSinCosto++;
        continue;
      }
      costoAlimento += costoKg * c.cantidadKg;
    }

    // --- 3 y 4. Gastos directos + compartidos -------------------------------
    // Se traen los gastos de la GRANJA (no solo por loteId) porque los gastos
    // compartidos referencian el lote en `lotesAsignados`, no en `loteId`:
    // una query por loteId NO los capturaría.
    final gastos = await _costoRepository.obtenerPorGranja(lote.granjaId);
    final desglose = <TipoGasto, double>{};
    var costoDirectos = 0.0;
    var costoCompartidos = 0.0;

    for (final g in gastos) {
      if (g.fecha.isAfter(corte)) continue;
      // El alimento ya se cuenta desde RegistroConsumo: se omite aquí.
      if (g.tipo == TipoGasto.alimento) continue;

      // Compartido: asignado a >1 lote e incluye a este lote → prorratear.
      final esCompartido =
          g.lotesAsignados.length > 1 && g.lotesAsignados.contains(lote.id);

      // Directo: asignado exclusivamente a este lote, ya sea por `loteId` o
      // por `lotesAsignados` con un único elemento (= este lote).
      final asignadoSoloAEste =
          g.lotesAsignados.length == 1 && g.lotesAsignados.first == lote.id;
      final esDirecto = !esCompartido &&
          (g.loteId == lote.id || asignadoSoloAEste);

      if (esCompartido) {
        final monto = await _montoProrrateado(g, lote, corte, avesCache);
        costoCompartidos += monto;
        _sumarDesglose(desglose, g.tipo, monto);
      } else if (esDirecto) {
        // La compra de aves se contabiliza como costo inicial (línea propia),
        // no mezclada con el resto de gastos directos.
        if (g.tipo == TipoGasto.compraAves) {
          costoInicialAves += g.monto;
        } else {
          costoDirectos += g.monto;
        }
        _sumarDesglose(desglose, g.tipo, g.monto);
      }
      // Cualquier otro gasto (de otro lote, o de granja sin asignar a este
      // lote) se ignora: no corresponde a este lote.
    }

    return CostoPorAve(
      fecha: corte,
      avesVivas: avesVivas,
      costoInicialAves: costoInicialAves,
      costoAlimento: costoAlimento,
      costoGastosDirectos: costoDirectos,
      costoGastosCompartidos: costoCompartidos,
      desglosePorTipo: desglose,
      // Sin gasto de compra de aves registrado para el lote.
      faltaCostoInicial: costoInicialAves <= 0,
      consumosSinCosto: consumosSinCosto,
    );
  }

  /// Prorratea el [gasto] compartido ponderando por las aves vivas del [lote]
  /// frente al total de aves vivas de todos los lotes asignados al gasto.
  ///
  /// Si no se puede determinar el total (todos sin aves), reparte en partes
  /// iguales como degradación segura.
  Future<double> _montoProrrateado(
    CostoGasto gasto,
    Lote lote,
    DateTime corte,
    Map<String, int> avesCache,
  ) async {
    final avesVivasLote = avesCache[lote.id] ?? 0;
    var totalAves = 0;
    for (final loteId in gasto.lotesAsignados) {
      // Reutiliza el cache para no releer el mismo lote/mortalidad al
      // prorratear varios gastos compartidos entre los mismos lotes.
      var aves = avesCache[loteId];
      if (aves == null) {
        final otro = await _loteDatasource.obtenerPorId(loteId);
        aves = otro == null ? 0 : await _avesVivasAFecha(otro, corte);
        avesCache[loteId] = aves;
      }
      totalAves += aves;
    }

    if (totalAves <= 0) {
      // Sin aves en ningún lote: reparto equitativo.
      return gasto.monto / gasto.lotesAsignados.length;
    }
    return gasto.monto * (avesVivasLote / totalAves);
  }

  /// Aves vivas del [lote] a la fecha [corte].
  ///
  /// Para "hoy" usa el valor canónico `avesDisponibles`. Para fechas pasadas
  /// reconstruye desde la mortalidad registrada con `fecha ≤ corte` (los
  /// descartes y ventas no son fechables por registro en el modelo actual, por
  /// lo que se aproximan con los acumulados actuales del lote).
  Future<int> _avesVivasAFecha(Lote lote, DateTime corte) async {
    final hoy = _finDelDia(DateTime.now());
    if (!corte.isBefore(hoy)) {
      return lote.avesDisponibles;
    }

    final mortalidades = await _mortalidadDatasource.obtenerPorLote(lote.id);
    var muertasHastaCorte = 0;
    for (final m in mortalidades) {
      if (!m.fecha.isAfter(corte)) {
        muertasHastaCorte += m.cantidad;
      }
    }

    // Aproximación: descartes y ventas no son fechables por registro aquí; se
    // restan los acumulados actuales para no sobreestimar las aves vivas.
    final vivas = lote.cantidadInicial -
        muertasHastaCorte -
        lote.descartesAcumulados -
        lote.ventasAcumuladas;
    return vivas < 0 ? 0 : vivas;
  }

  void _sumarDesglose(
    Map<TipoGasto, double> desglose,
    TipoGasto tipo,
    double monto,
  ) {
    desglose[tipo] = (desglose[tipo] ?? 0) + monto;
  }

  /// Normaliza a las 23:59:59 del día para incluir todo lo registrado ese día.
  DateTime _finDelDia(DateTime f) =>
      DateTime(f.year, f.month, f.day, 23, 59, 59, 999);
}
