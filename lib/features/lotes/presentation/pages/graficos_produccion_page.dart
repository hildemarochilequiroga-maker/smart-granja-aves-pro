import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_produccion.dart';

/// Página de gráficos y análisis visual de producción del lote.
class GraficosProduccionPage extends ConsumerWidget {
  final Lote lote;

  const GraficosProduccionPage({required this.lote, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(
      registrosProduccionStreamProvider(lote.id),
    );
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).batchChartsProduction),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(registrosProduccionStreamProvider(lote.id));
            },
            tooltip: S.of(context).commonUpdate,
          ),
        ],
      ),
      body: registrosAsync.when(
        data: (registros) {
          if (registros.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: theme.colorScheme.primary,
            onRefresh: () async {
              ref.invalidate(registrosProduccionStreamProvider(lote.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gráfico de porcentaje de postura
                  _buildPosturaChart(context, registros),
                  const SizedBox(height: AppSpacing.xl),

                  // Gráfico de producción diaria
                  _buildProduccionChart(context, registros),
                  const SizedBox(height: AppSpacing.xl),

                  // Gráfico de calidad (buenos vs defectos)
                  _buildCalidadChart(context, registros),
                  const SizedBox(height: AppSpacing.base),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                S.of(context).chartsLoading,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Card(
              elevation: 4,
              shadowColor: AppColors.error.withValues(alpha: 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.allLg,
                side: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error.withValues(alpha: 0.1),
                            AppColors.errorContainer,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      S.of(context).chartsErrorLoading,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.error, AppColors.error],
                        ),
                        borderRadius: AppRadius.allMd,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FilledButton.icon(
                        onPressed: () {
                          ref.invalidate(
                            registrosProduccionStreamProvider(lote.id),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allMd,
                          ),
                        ),
                        icon: const Icon(Icons.refresh, size: 20),
                        label: Text(
                          S.of(context).commonRetry,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosturaChart(
    BuildContext context,
    List<RegistroProduccion> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    final spots = sortedRegistros.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.porcentajePostura.clamp(0.0, 100.0),
      );
    }).toList();

    const yInterval = 10.0;

    return Card(
      elevation: 4,
      shadowColor: AppColors.success.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.success.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchPosturePercentage,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).batchPostureEvolution,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: yInterval,
                    verticalInterval: spots.length > 20
                        ? 5.0
                        : (spots.length > 10
                              ? 3.0
                              : (spots.length > 5 ? 2.0 : 1.0)),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: spots.length > 20
                            ? 5.0
                            : (spots.length > 10
                                  ? 3.0
                                  : (spots.length > 5 ? 2.0 : 1.0)),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < sortedRegistros.length) {
                            final registro = sortedRegistros[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(registro.fecha),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: yInterval,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '${value.toInt()}%',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [AppColors.successLight, AppColors.success],
                      ),
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          Color color = AppColors.success;
                          if (spot.y < 70) {
                            color = AppColors.error;
                          } else if (spot.y < 85) {
                            color = AppColors.warning;
                          }
                          return FlDotCirclePainter(
                            radius: 4.5,
                            color: color,
                            strokeWidth: 2.5,
                            strokeColor: colorScheme.onPrimary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.success.withValues(alpha: 0.3),
                            AppColors.success.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          AppColors.success.withValues(alpha: 0.96),
                      tooltipRoundedRadius: 10,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final registro =
                              sortedRegistros[touchedSpot.x.toInt()];
                          String emoji = '🥚';
                          if (touchedSpot.y >= 85) {
                            emoji = '🌟';
                          } else if (touchedSpot.y < 70) {
                            emoji = '⚠️';
                          }
                          return LineTooltipItem(
                            S
                                .of(context)
                                .chartsProductionTooltipPosture(
                                  emoji,
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(registro.fecha),
                                  touchedSpot.y.toStringAsFixed(1),
                                ),
                            theme.textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduccionChart(
    BuildContext context,
    List<RegistroProduccion> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    final spots = sortedRegistros.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.huevosRecolectados.toDouble(),
      );
    }).toList();

    final maxY = spots.isNotEmpty
        ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 50).clamp(
            100,
            double.infinity,
          )
        : 100.0;
    final yInterval = (maxY / 5).ceilToDouble().clamp(10, double.infinity);

    return Card(
      elevation: 4,
      shadowColor: AppColors.success.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.success.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).chartsProductionDailyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsProductionDailySubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: yInterval.toDouble(),
                    verticalInterval: spots.length > 20
                        ? 5.0
                        : (spots.length > 10
                              ? 3.0
                              : (spots.length > 5 ? 2.0 : 1.0)),
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: spots.length > 20
                            ? 5.0
                            : (spots.length > 10
                                  ? 3.0
                                  : (spots.length > 5 ? 2.0 : 1.0)),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < sortedRegistros.length) {
                            final registro = sortedRegistros[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(registro.fecha),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: yInterval.toDouble(),
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: colorScheme.outline, width: 1.5),
                  ),
                  minX: 0,
                  maxX: (spots.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxY.toDouble(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [AppColors.successLight, AppColors.success],
                      ),
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4.5,
                            color: AppColors.success,
                            strokeWidth: 2.5,
                            strokeColor: colorScheme.onPrimary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.success.withValues(alpha: 0.3),
                            AppColors.success.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          AppColors.success.withValues(alpha: 0.96),
                      tooltipRoundedRadius: 10,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final registro =
                              sortedRegistros[touchedSpot.x.toInt()];
                          return LineTooltipItem(
                            S
                                .of(context)
                                .chartsProductionTooltipDaily(
                                  DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(registro.fecha),
                                  touchedSpot.y.toInt().toString(),
                                ),
                            theme.textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalidadChart(
    BuildContext context,
    List<RegistroProduccion> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final totalBuenos = registros.fold<int>(
      0,
      (sum, r) => sum + r.huevosBuenos,
    );
    final totalRotos = registros.fold<int>(
      0,
      (sum, r) => sum + (r.huevosRotos ?? 0),
    );
    final totalSucios = registros.fold<int>(
      0,
      (sum, r) => sum + (r.huevosSucios ?? 0),
    );
    final totalDobleYema = registros.fold<int>(
      0,
      (sum, r) => sum + (r.huevosDobleYema ?? 0),
    );

    final total = totalBuenos + totalRotos + totalSucios + totalDobleYema;

    if (total == 0) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      shadowColor: AppColors.success.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.success.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).chartsProductionQualityTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsProductionQualitySubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 35,
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {},
                        ),
                        sections: [
                          PieChartSectionData(
                            color: AppColors.success,
                            value: totalBuenos.toDouble(),
                            title: (totalBuenos / total * 100) >= 10
                                ? '${(totalBuenos / total * 100).toStringAsFixed(0)}%'
                                : '',
                            radius: 50,
                            titleStyle: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          if (totalRotos > 0)
                            PieChartSectionData(
                              color: AppColors.error,
                              value: totalRotos.toDouble(),
                              title: (totalRotos / total * 100) >= 10
                                  ? '${(totalRotos / total * 100).toStringAsFixed(0)}%'
                                  : '',
                              radius: 50,
                              titleStyle: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          if (totalSucios > 0)
                            PieChartSectionData(
                              color: AppColors.warning,
                              value: totalSucios.toDouble(),
                              title: (totalSucios / total * 100) >= 10
                                  ? '${(totalSucios / total * 100).toStringAsFixed(0)}%'
                                  : '',
                              radius: 50,
                              titleStyle: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          if (totalDobleYema > 0)
                            PieChartSectionData(
                              color: AppColors.amber,
                              value: totalDobleYema.toDouble(),
                              title: (totalDobleYema / total * 100) >= 10
                                  ? '${(totalDobleYema / total * 100).toStringAsFixed(0)}%'
                                  : '',
                              radius: 50,
                              titleStyle: theme.textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xl),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            context,
                            S.of(context).eggTypeGood,
                            totalBuenos,
                            AppColors.success,
                          ),
                          if (totalRotos > 0)
                            _buildLegendItem(
                              context,
                              S.of(context).eggTypeBroken,
                              totalRotos,
                              AppColors.error,
                            ),
                          if (totalSucios > 0)
                            _buildLegendItem(
                              context,
                              S.of(context).eggTypeDirty,
                              totalSucios,
                              AppColors.warning,
                            ),
                          if (totalDobleYema > 0)
                            _buildLegendItem(
                              context,
                              S.of(context).eggTypeDoubleYolk,
                              totalDobleYema,
                              AppColors.amber,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.allXs,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            '$value',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).historialNoProductionData,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  S.of(context).historialChartsAppearProduction,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                  child: Text(S.of(context).batchBackToHistory),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
