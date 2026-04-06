import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_consumo.dart';
import '../../domain/enums/tipo_alimento.dart';

/// Página de gráficos y análisis visual de consumo de alimento del lote.
class GraficosConsumoPage extends ConsumerWidget {
  final Lote lote;

  const GraficosConsumoPage({required this.lote, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(registrosConsumoStreamProvider(lote.id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).chartsConsumptionTitle),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(registrosConsumoStreamProvider(lote.id));
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
            onRefresh: () async {
              ref.invalidate(registrosConsumoStreamProvider(lote.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gráfico de consumo diario
                  _buildConsumoDiarioChart(context, registros),
                  const SizedBox(height: AppSpacing.xl),

                  // Gráfico de consumo por ave
                  _buildConsumoPorAveChart(context, registros),
                  const SizedBox(height: AppSpacing.xl),

                  // Gráfico de distribución por tipo de alimento
                  _buildDistribucionTipoChart(context, registros),
                  const SizedBox(height: AppSpacing.xl),

                  // Gráfico de costos
                  _buildCostosChart(context, registros),
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
                  color: colorScheme.onSurfaceVariant,
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
                        color: colorScheme.onSurfaceVariant,
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
                            registrosConsumoStreamProvider(lote.id),
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

  Widget _buildConsumoDiarioChart(
    BuildContext context,
    List<RegistroConsumo> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    // Validar datos antes de graficar
    final spots = sortedRegistros
        .where((r) => r.cantidadKg > 0)
        .toList()
        .asMap()
        .entries
        .map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.cantidadKg);
        })
        .toList();

    if (spots.isEmpty) {
      return _buildEmptyChartCard(
        context: context,
        icon: Icons.show_chart,
        color: AppColors.success,
        title: S.of(context).chartsDailyConsumptionTitle,
        subtitle: S.of(context).chartsNoValidData,
      );
    }

    final maxValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue * 1.15).ceilToDouble(); // 15% margen superior
    final yInterval = _calcularIntervalo(maxY, 5);

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
              S.of(context).chartsDailyConsumptionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsDailyConsumptionSubtitle,
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
                        ? 5
                        : (spots.length > 10 ? 3 : null),
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
                        reservedSize: 30,
                        interval: spots.length > 20
                            ? 5
                            : (spots.length > 10 ? 3 : null),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < sortedRegistros.length) {
                            final registro = sortedRegistros[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(registro.fecha),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.outline,
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
                              '${value.toInt()}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
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
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.success,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
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
                            AppColors.success.withValues(alpha: 0.1),
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
                      getTooltipColor: (touchedSpot) => AppColors.success,
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      tooltipMargin: 12,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() < sortedRegistros.length) {
                            final registro =
                                sortedRegistros[touchedSpot.x.toInt()];
                            return LineTooltipItem(
                              '${DateFormat('dd/MM').format(registro.fecha)}\n${touchedSpot.y.toStringAsFixed(1)} kg\n${S.of(context).commonType}: ${registro.tipoAlimento.localizedDisplayName(S.of(context))}',
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            );
                          }
                          return const LineTooltipItem('', TextStyle());
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

  Widget _buildConsumoPorAveChart(
    BuildContext context,
    List<RegistroConsumo> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    // Validar consumo por ave positivo y guardar registros filtrados
    final registrosFiltrados = sortedRegistros
        .where((r) => r.consumoPorAve > 0)
        .toList();

    final spots = registrosFiltrados.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.consumoPorAve * 1000, // Convertir a gramos
      );
    }).toList();

    if (spots.isEmpty) {
      return _buildEmptyChartCard(
        context: context,
        icon: Icons.pets,
        color: AppColors.success,
        title: S.of(context).chartsConsumptionPerBirdTitle,
        subtitle: S.of(context).chartsNoValidData,
      );
    }

    final maxValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue * 1.15).ceilToDouble();
    final yInterval = _calcularIntervalo(maxY, 5);

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
              S.of(context).chartsConsumptionPerBirdTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsConsumptionPerBirdSubtitle,
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
                        ? 5
                        : (spots.length > 10 ? 3 : null),
                    getDrawingHorizontalLine: (value) {
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
                        reservedSize: 30,
                        interval: spots.length > 20
                            ? 5
                            : (spots.length > 10 ? 3 : null),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < registrosFiltrados.length) {
                            final registro = registrosFiltrados[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(registro.fecha),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.outline,
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
                              '${value.toInt()}g',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
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
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.success,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
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
                            AppColors.success.withValues(alpha: 0.1),
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
                      getTooltipColor: (touchedSpot) => AppColors.success,
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      tooltipMargin: 12,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() <
                                  registrosFiltrados.length) {
                            final registro =
                                registrosFiltrados[touchedSpot.x.toInt()];
                            return LineTooltipItem(
                              '${DateFormat('dd/MM').format(registro.fecha)}\n${touchedSpot.y.toStringAsFixed(0)} g/ave\n${S.of(context).commonType}: ${registro.tipoAlimento.localizedDisplayName(S.of(context))}',

                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            );
                          }
                          return const LineTooltipItem('', TextStyle());
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

  Widget _buildDistribucionTipoChart(
    BuildContext context,
    List<RegistroConsumo> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Agrupar por tipo de alimento
    final Map<TipoAlimento, double> consumoPorTipo = {};
    for (var registro in registros) {
      consumoPorTipo[registro.tipoAlimento] =
          (consumoPorTipo[registro.tipoAlimento] ?? 0) + registro.cantidadKg;
    }

    if (consumoPorTipo.isEmpty) return const SizedBox.shrink();

    final sortedEntries = consumoPorTipo.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sortedEntries.fold<double>(
      0,
      (sum, entry) => sum + entry.value,
    );

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
              S.of(context).chartsFoodTypeDistributionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsFoodTypeDistributionSubtitle,
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
                        sections: sortedEntries.asMap().entries.map((entry) {
                          final index = entry.key;
                          final tipo = entry.value.key;
                          final cantidad = entry.value.value;
                          final percentage = (cantidad / total * 100);
                          final color = _getTipoColor(tipo, index);

                          return PieChartSectionData(
                            color: color,
                            value: cantidad,
                            title: percentage >= 10
                                ? '${percentage.toStringAsFixed(0)}%'
                                : '',
                            radius: 50,
                            titleStyle: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sortedEntries.map((entry) {
                          final tipo = entry.key;
                          final cantidad = entry.value;
                          final percentage = (cantidad / total * 100);
                          final index = sortedEntries.indexOf(entry);
                          final color = _getTipoColor(tipo, index);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: AppRadius.allXs,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Expanded(
                                  child: Text(
                                    tipo.displayName,
                                    style: theme.textTheme.labelSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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

  Widget _buildCostosChart(
    BuildContext context,
    List<RegistroConsumo> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final registrosConCosto =
        registros.where((r) => r.costoPorKg != null).toList()
          ..sort((a, b) => a.fecha.compareTo(b.fecha));

    if (registrosConCosto.isEmpty) {
      return _buildEmptyChartCard(
        context: context,
        icon: Icons.attach_money,
        color: AppColors.success,
        title: S.of(context).chartsCostEvolutionTitle,
        subtitle: S.of(context).chartsCostNoValidData,
      );
    }

    final spots = registrosConCosto.asMap().entries.map((entry) {
      final costoTotal = entry.value.cantidadKg * entry.value.costoPorKg!;
      return FlSpot(entry.key.toDouble(), costoTotal);
    }).toList();

    final maxValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    final maxY = (maxValue * 1.2).ceilToDouble(); // 20% margen para costos
    final yInterval = _calcularIntervalo(maxY, 5);

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
              S.of(context).chartsCostEvolutionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsCostEvolutionSubtitle,
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
                        ? 5
                        : (spots.length > 10 ? 3 : null),
                    getDrawingHorizontalLine: (value) {
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
                        reservedSize: 30,
                        interval: spots.length > 20
                            ? 5
                            : (spots.length > 10 ? 3 : null),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < registrosConCosto.length) {
                            final registro = registrosConCosto[value.toInt()];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(registro.fecha),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: colorScheme.outline,
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
                              '\$${value.toInt()}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                        reservedSize: 45,
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
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: AppColors.success,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
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
                            AppColors.success.withValues(alpha: 0.1),
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
                      getTooltipColor: (touchedSpot) => AppColors.success,
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      tooltipMargin: 12,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() <
                                  registrosConCosto.length) {
                            final registro =
                                registrosConCosto[touchedSpot.x.toInt()];
                            final formatCurrency = NumberFormat.currency(
                              symbol: Formatters.currencySymbol,
                              locale: Formatters.currencyLocale,
                              decimalDigits: 2,
                            );
                            return LineTooltipItem(
                              '${DateFormat('dd/MM').format(registro.fecha)}\n${formatCurrency.format(touchedSpot.y)}',
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            );
                          }
                          return const LineTooltipItem('', TextStyle());
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

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  S.of(context).historialNoConsumptionRecords,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  S.of(context).chartsGraphsAppearWhenData,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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

  Color _getTipoColor(TipoAlimento tipo, int index) {
    final tipoColors = {
      TipoAlimento.preIniciador: AppColors.purple,
      TipoAlimento.iniciador: AppColors.info,
      TipoAlimento.crecimiento: AppColors.success,
      TipoAlimento.finalizador: AppColors.warning,
      TipoAlimento.postura: AppColors.amber,
      TipoAlimento.levante: AppColors.success,
      TipoAlimento.medicado: AppColors.error,
      TipoAlimento.concentrado: AppColors.brown,
      TipoAlimento.otro: AppColors.grey600,
    };

    return tipoColors[tipo] ??
        AppColors.chartColors[index % AppColors.chartColors.length];
  }

  /// Calcula un intervalo apropiado para el eje Y
  double _calcularIntervalo(double maxValue, int numIntervalos) {
    if (maxValue <= 0) return 10.0;

    final rawInterval = maxValue / numIntervalos;

    // Redondear al múltiplo de 5, 10, 25, 50, 100, etc.
    if (rawInterval <= 5) return 5.0;
    if (rawInterval <= 10) return 10.0;
    if (rawInterval <= 25) return 25.0;
    if (rawInterval <= 50) return 50.0;
    if (rawInterval <= 100) return 100.0;
    if (rawInterval <= 250) return 250.0;
    if (rawInterval <= 500) return 500.0;
    if (rawInterval <= 1000) return 1000.0;

    // Para valores muy grandes, redondear al múltiplo de 1000 más cercano
    return ((rawInterval / 1000).ceil() * 1000).toDouble();
  }

  /// Widget reutilizable para gráficos vacíos
  Widget _buildEmptyChartCard({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Card(
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 48, color: colorScheme.outline),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
