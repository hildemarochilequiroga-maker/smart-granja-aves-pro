import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_shadow.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../galpones/application/providers/galpon_providers.dart';
import '../../../../granjas/application/providers/granja_providers.dart';
import '../../../../lotes/application/providers/lote_providers.dart';

class HomeKpisGrid extends ConsumerWidget {
  const HomeKpisGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granjaSeleccionada = ref.watch(granjaSeleccionadaProvider);

    // Si no hay granja seleccionada, mostrar mensaje
    if (granjaSeleccionada == null) {
      return _buildNoGranjaSelected(context);
    }

    // Estadísticas de lotes
    final lotesStatsAsync = ref.watch(
      estadisticasLotesProvider(granjaSeleccionada.id),
    );

    // Estadísticas de galpones
    final galponesStatsAsync = ref.watch(
      estadisticasGalponesProvider(granjaSeleccionada.id),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          S.of(context).homeGeneralStats,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.md),
        // Primera fila - Galpones Libres y Lotes Activos
        Row(
          children: [
            Expanded(
              child: galponesStatsAsync.when(
                data: (stats) => _buildKpiCard(
                  context,
                  label: S.of(context).homeAvailableSheds,
                  value: '${stats.galponesDisponibles}',
                  subtitle: stats.totalGalpones == 0
                      ? S.of(context).homeNoSheds
                      : S.of(context).homeTotalShedsCount(stats.totalGalpones),
                  color: stats.galponesDisponibles > 0
                      ? AppColors.success
                      : AppColors.grey400,
                  isEmpty: stats.totalGalpones == 0,
                ),
                loading: () => _buildKpiCardSkeleton(context),
                error: (error, __) => _buildKpiCardError(
                  context,
                  label: S.of(context).homeAvailableSheds,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: lotesStatsAsync.when(
                data: (stats) => _buildKpiCard(
                  context,
                  label: S.of(context).homeActiveBatches,
                  value: '${stats.lotesActivos}',
                  subtitle: stats.totalLotes == 0
                      ? S.of(context).homeNoBatches
                      : S.of(context).homeTotalBatchesCount(stats.totalLotes),
                  color: stats.lotesActivos > 0
                      ? AppColors.warning
                      : AppColors.grey400,
                  isEmpty: stats.totalLotes == 0,
                ),
                loading: () => _buildKpiCardSkeleton(context),
                error: (error, __) => _buildKpiCardError(
                  context,
                  label: S.of(context).homeActiveBatches,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // Segunda fila - Aves Totales y Ocupación
        Row(
          children: [
            Expanded(
              child: lotesStatsAsync.when(
                data: (stats) => _buildKpiCard(
                  context,
                  label: S.of(context).homeTotalBirds,
                  value: _formatNumber(stats.totalAvesActuales),
                  subtitle: S.of(context).homeAcrossFarm,
                  color: stats.totalAvesActuales > 0
                      ? AppColors.info
                      : AppColors.grey400,
                  isEmpty: stats.totalAvesActuales == 0,
                ),
                loading: () => _buildKpiCardSkeleton(context),
                error: (error, __) => _buildKpiCardError(
                  context,
                  label: S.of(context).homeTotalBirds,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: galponesStatsAsync.when(
                data: (stats) {
                  final ocupacion = stats.porcentajeOcupacion;
                  final tieneCapacidad = stats.capacidadTotal > 0;
                  return _buildKpiCard(
                    context,
                    label: S.of(context).homeOccupancy,
                    value: tieneCapacidad
                        ? '${ocupacion.toStringAsFixed(0)}%'
                        : '-',
                    subtitle: tieneCapacidad
                        ? _getOcupacionMessage(context, ocupacion)
                        : S.of(context).homeNoCapacityDefined,
                    color: tieneCapacidad
                        ? _getOcupacionColor(ocupacion)
                        : AppColors.grey400,
                    isEmpty: !tieneCapacidad,
                  );
                },
                loading: () => _buildKpiCardSkeleton(context),
                error: (error, __) => _buildKpiCardError(
                  context,
                  label: S.of(context).homeOccupancy,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoGranjaSelected(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).homeGeneralStats,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: AppRadius.allMd,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Icon(
                Icons.agriculture_outlined,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                S.of(context).homeSelectAFarm,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                S.of(context).homeStatsAppearHere,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getOcupacionMessage(BuildContext context, double ocupacion) {
    if (ocupacion == 0) {
      return S.of(context).homeNoOccupancy;
    } else if (ocupacion < 30) {
      return S.of(context).homeOccupancyLow;
    } else if (ocupacion < 60) {
      return S.of(context).homeOccupancyMedium;
    } else if (ocupacion < 85) {
      return S.of(context).homeOccupancyHigh;
    } else {
      return S.of(context).homeOccupancyMax;
    }
  }

  Color _getOcupacionColor(double ocupacion) {
    if (ocupacion == 0) {
      return AppColors.grey400;
    } else if (ocupacion < 30) {
      return AppColors.info;
    } else if (ocupacion < 60) {
      return AppColors.warning;
    } else if (ocupacion < 85) {
      return AppColors.warning;
    } else {
      return AppColors.error;
    }
  }

  String _formatNumber(int number) {
    return Formatters.numeroMiles.format(number);
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String label,
    required String value,
    required String subtitle,
    required Color color,
    bool isEmpty = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: isEmpty
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: isEmpty ? null : AppShadow.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Value
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          // Subtitle
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCardError(BuildContext context, {required String label}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              const SizedBox(width: AppSpacing.xs),
              Text(
                S.of(context).commonError,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            S.of(context).homeCouldNotLoad,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCardSkeleton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 14,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppRadius.allXs,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 50,
            height: 28,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppRadius.allXs,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            width: 70,
            height: 12,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: AppRadius.allXs,
            ),
          ),
        ],
      ),
    );
  }
}
