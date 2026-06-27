/// Providers para el cálculo de costo por ave de un lote.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../costos/application/providers/costos_provider.dart';
import '../../domain/entities/lote.dart';
import '../../domain/usecases/calcular_costo_por_ave_use_case.dart';
import '../../domain/value_objects/costo_por_ave.dart';
import 'lote_providers.dart';
import 'registro_providers.dart';

/// Provider del use case de cálculo de costo por ave.
final calcularCostoPorAveUseCaseProvider =
    Provider<CalcularCostoPorAveUseCase>((ref) {
      return CalcularCostoPorAveUseCase(
        costoRepository: ref.watch(costoRepositoryProvider),
        consumoDatasource: ref.watch(registroConsumoDatasourceProvider),
        mortalidadDatasource: ref.watch(registroMortalidadDatasourceProvider),
        loteDatasource: ref.watch(loteFirebaseDatasourceProvider),
      );
    });

/// Parámetros del cálculo de costo por ave: lote y fecha de corte opcional.
class CostoPorAveParams {
  const CostoPorAveParams({required this.loteId, this.fecha});

  final String loteId;

  /// Fecha de corte (inclusive). `null` = hoy.
  final DateTime? fecha;

  /// Fecha normalizada a día para que el `family` cachee por día, no por
  /// instante (evita recálculos por diferencias de milisegundos).
  DateTime? get _fechaDia =>
      fecha == null ? null : DateTime(fecha!.year, fecha!.month, fecha!.day);

  @override
  bool operator ==(Object other) =>
      other is CostoPorAveParams &&
      other.loteId == loteId &&
      other._fechaDia == _fechaDia;

  @override
  int get hashCode => Object.hash(loteId, _fechaDia);
}

/// Calcula el costo acumulado por ave viva de un lote a la fecha indicada.
///
/// autoDispose + family: se libera al dejar de observarse (sin leaks por cada
/// combinación lote/fecha). Devuelve [CostoPorAve.vacio] si el lote no existe.
final costoPorAveProvider = FutureProvider.autoDispose
    .family<CostoPorAve, CostoPorAveParams>((ref, params) async {
      final Lote? lote = await ref.watch(
        loteByIdProvider(params.loteId).future,
      );
      final fecha = params.fecha ?? DateTime.now();
      if (lote == null) {
        return CostoPorAve.vacio(fecha);
      }

      final useCase = ref.watch(calcularCostoPorAveUseCaseProvider);
      return useCase(lote, fecha: params.fecha);
    });
