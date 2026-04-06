/// Sección de métricas finales para cerrar lote.
///
/// Widget modular que muestra las métricas calculadas
/// del lote al momento del cierre.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Widget para mostrar métricas finales del lote
class FinalMetricsSection extends StatelessWidget {
  const FinalMetricsSection({
    super.key,
    required this.mortalidadTotal,
    required this.mortalidadPorcentaje,
    required this.duracionCicloDias,
    required this.pesoGananciaPromedio,
    required this.conversionAlimenticia,
  });

  final int mortalidadTotal;
  final double mortalidadPorcentaje;
  final int duracionCicloDias;
  final double? pesoGananciaPromedio;
  final double? conversionAlimenticia;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchCloseFinalMetrics,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          _buildMetricRow(
            theme,
            S.of(context).batchCloseTotalMortality,
            '$mortalidadTotal ${S.of(context).batchCloseBirdsUnit}',
            Icons.healing,
            mortalidadPorcentaje > 5 ? AppColors.error : AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),

          _buildMetricRow(
            theme,
            S.of(context).batchCloseMortalityPercent,
            '${mortalidadPorcentaje.toStringAsFixed(2)}%',
            Icons.percent,
            mortalidadPorcentaje > 5 ? AppColors.error : AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),

          _buildMetricRow(
            theme,
            S.of(context).batchCloseCycleDuration,
            '$duracionCicloDias ${S.of(context).batchCloseDays}',
            Icons.access_time,
            AppColors.info,
          ),

          if (pesoGananciaPromedio != null && pesoGananciaPromedio! > 0) ...[
            const SizedBox(height: AppSpacing.md),
            _buildMetricRow(
              theme,
              S.of(context).batchCloseWeightGain,
              '${pesoGananciaPromedio!.toStringAsFixed(0)} g',
              Icons.trending_up,
              AppColors.success,
            ),
          ],

          if (conversionAlimenticia != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildMetricRow(
              theme,
              S.of(context).batchCloseFeedConversion,
              conversionAlimenticia!.toStringAsFixed(2),
              Icons.restaurant,
              conversionAlimenticia! < 2.0
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricRow(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: Text(label, style: theme.textTheme.labelLarge)),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
