import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../inventario/application/providers/providers.dart';
import '../../../../lotes/application/providers/lote_providers.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

class HomeAlerts extends ConsumerWidget {
  const HomeAlerts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granjaSeleccionada = ref.watch(granjaSeleccionadaProvider);

    if (granjaSeleccionada == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    // Obtener alertas de inventario
    final inventarioAsync = ref.watch(
      inventarioResumenStreamProvider(granjaSeleccionada.id),
    );

    // Obtener alertas de lotes
    final lotesStatsAsync = ref.watch(
      estadisticasLotesProvider(granjaSeleccionada.id),
    );

    return inventarioAsync.when(
      data: (inventarioResumen) {
        return lotesStatsAsync.when(
          data: (lotesStats) {
            final List<Map<String, dynamic>> alerts = [];

            // Alertas de inventario
            if (inventarioResumen.itemsAgotados > 0) {
              alerts.add({
                'title': S.of(context).homeOutOfStock,
                'description': S
                    .of(context)
                    .homeProductsOutOfStockCount(
                      inventarioResumen.itemsAgotados,
                    ),
                'type': 'error',
                'icon': Icons.error_outline,
              });
            }

            if (inventarioResumen.itemsConStockBajo > 0) {
              alerts.add({
                'title': S.of(context).homeLowStock,
                'description': S
                    .of(context)
                    .homeProductsLowStockCount(
                      inventarioResumen.itemsConStockBajo,
                    ),
                'type': 'warning',
                'icon': Icons.warning_amber_rounded,
              });
            }

            if (inventarioResumen.itemsProximosVencer > 0) {
              alerts.add({
                'title': S.of(context).homeExpiringSoon,
                'description': S
                    .of(context)
                    .homeProductsExpiringSoonCount(
                      inventarioResumen.itemsProximosVencer,
                    ),
                'type': 'warning',
                'icon': Icons.event_busy,
              });
            }

            // Alertas de mortalidad alta
            if (lotesStats.mortalidadPromedio > 5) {
              alerts.add({
                'title': S.of(context).homeHighMortality,
                'description': S
                    .of(context)
                    .homeMortalityPercent(
                      lotesStats.mortalidadPromedio.toStringAsFixed(1),
                    ),
                'type': 'error',
                'icon': Icons.healing,
              });
            }

            // Si no hay lotes activos y hay granjas
            if (lotesStats.lotesActivos == 0 && lotesStats.totalLotes == 0) {
              alerts.add({
                'title': S.of(context).homeNoActiveBatches,
                'description': S.of(context).homeCreateBatchToStart,
                'type': 'info',
                'icon': Icons.add_box_outlined,
              });
            }

            if (alerts.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).homeAlerts,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (alerts.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: AppRadius.allMd,
                        ),
                        child: Text(
                          '${alerts.length}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onError,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                ...alerts.map((alert) => _buildAlertCard(context, alert)),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildAlertCard(BuildContext context, Map<String, dynamic> alert) {
    final InfoCardType type = switch (alert['type']) {
      'error' => InfoCardType.error,
      'warning' => InfoCardType.warning,
      _ => InfoCardType.info,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: FormInfoCard(
        type: type,
        title: alert['title'] as String,
        description: alert['description'] as String,
      ),
    );
  }
}
