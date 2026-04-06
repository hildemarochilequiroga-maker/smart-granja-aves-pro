import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../inventario/application/providers/providers.dart';

/// Widget que muestra el resumen del inventario en el Home.
class HomeInventarioResumen extends ConsumerWidget {
  const HomeInventarioResumen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Obtener la granja seleccionada
    final granjaSeleccionada = ref.watch(granjaSeleccionadaProvider);

    if (granjaSeleccionada == null) {
      return const SizedBox.shrink();
    }

    final resumenAsync = ref.watch(
      inventarioResumenStreamProvider(granjaSeleccionada.id),
    );

    return resumenAsync.when(
      data: (resumen) {
        // No mostrar si no hay items
        if (resumen.totalItems == 0) {
          return _buildEmptyState(context, granjaSeleccionada.id);
        }

        final hayAlertas =
            resumen.itemsAgotados > 0 ||
            resumen.itemsConStockBajo > 0 ||
            resumen.itemsProximosVencer > 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).homeInventory,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.inventario),
                  child: Text(S.of(context).commonViewAll),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: InkWell(
                onTap: () => context.push(AppRoutes.inventario),
                borderRadius: AppRadius.allMd,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.base),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(
                            theme,
                            Icons.inventory,
                            '${resumen.totalItems}',
                            S.of(context).homeInvTotal,
                            AppColors.primary,
                          ),
                          _buildStatItem(
                            theme,
                            Icons.warning_amber,
                            '${resumen.itemsConStockBajo}',
                            S.of(context).homeInvLowStock,
                            resumen.itemsConStockBajo > 0
                                ? AppColors.warning
                                : AppColors.onSurfaceVariant,
                          ),
                          _buildStatItem(
                            theme,
                            Icons.error_outline,
                            '${resumen.itemsAgotados}',
                            S.of(context).homeInvOutOfStock,
                            resumen.itemsAgotados > 0
                                ? AppColors.error
                                : AppColors.onSurfaceVariant,
                          ),
                          _buildStatItem(
                            theme,
                            Icons.event,
                            '${resumen.itemsProximosVencer}',
                            S.of(context).homeInvExpiringSoon,
                            resumen.itemsProximosVencer > 0
                                ? AppColors.warning
                                : AppColors.onSurfaceVariant,
                          ),
                        ],
                      ),
                      if (hayAlertas) ...[
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppSpacing.sm + 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: AppRadius.allSm,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                size: 18,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  _buildAlertMessage(context, resumen),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.warning),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildEmptyState(BuildContext context, String granjaId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).homeInventory,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: InkWell(
            onTap: () =>
                context.push(AppRoutes.inventarioCrearItemConGranja(granjaId)),
            borderRadius: AppRadius.allMd,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.allMd,
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.base),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).homeSetupInventory,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          S.of(context).homeSetupInventoryDesc,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _buildAlertMessage(BuildContext context, dynamic resumen) {
    final List<String> alertas = [];

    if (resumen.itemsAgotados > 0) {
      alertas.add(S.of(context).homeInvOutOfStockCount(resumen.itemsAgotados));
    }
    if (resumen.itemsConStockBajo > 0) {
      alertas.add(
        S.of(context).homeInvLowStockCount(resumen.itemsConStockBajo),
      );
    }
    if (resumen.itemsProximosVencer > 0) {
      alertas.add(
        S.of(context).homeInvExpiringSoonCount(resumen.itemsProximosVencer),
      );
    }

    return S.of(context).homeInvAttention(alertas.join(', '));
  }
}
