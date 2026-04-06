import 'dart:math' show pow;

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
import '../../domain/entities/registro_peso.dart';

/// Página de gráficos y análisis visual de peso del lote.
class GraficosPesoPage extends ConsumerWidget {
  final Lote lote;

  const GraficosPesoPage({required this.lote, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(registrosPesoStreamProvider(lote.id));
    final statsAsync = ref.watch(registrosPesoStatsProvider(lote.id));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).batchChartsWeight),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(registrosPesoStreamProvider(lote.id));
              ref.invalidate(registrosPesoStatsProvider(lote.id));
            },
            tooltip: S.of(context).commonUpdate,
          ),
        ],
      ),
      body: registrosAsync.when(
        data: (registros) => _buildContent(context, registros, statsAsync),
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
                          ref.invalidate(registrosPesoStreamProvider(lote.id));
                          ref.invalidate(registrosPesoStatsProvider(lote.id));
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

  Widget _buildContent(
    BuildContext context,
    List<RegistroPeso> registros,
    AsyncValue<Map<String, dynamic>> statsAsync,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (registros.isEmpty) {
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
                    S.of(context).batchNoWeightData,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    S.of(context).batchChartsAppearWhenData,
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

    // Ordenar registros por fecha
    final registrosOrdenados = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gráfico de evolución de peso
          _buildEvolucionPesoChart(context, registrosOrdenados),
          const SizedBox(height: AppSpacing.xl),

          // Gráfico de ganancia diaria promedio
          _buildGananciaDiariaChart(context, registrosOrdenados),
          const SizedBox(height: AppSpacing.xl),

          // Gráfico de uniformidad
          _buildUniformidadChart(context, registrosOrdenados),
          const SizedBox(height: AppSpacing.xl),

          // Gráfico de comparación con estándar (si hay datos)
          if (registrosOrdenados.length > 3) ...[
            _buildComparacionEstandarChart(context, registrosOrdenados),
            const SizedBox(height: AppSpacing.base),
          ],
        ],
      ),
    );
  }

  Widget _buildEvolucionPesoChart(
    BuildContext context,
    List<RegistroPeso> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spots = registros
        .asMap()
        .entries
        .map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.pesoPromedio / 1000, // Convertir a kg
          );
        })
        .where((spot) => spot.y.isFinite)
        .toList();

    final minYData = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a < b ? a : b)
        : 0.0;
    final maxYData = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b)
        : 3.0;
    final minY = (minYData - 0.2).clamp(0.0, double.infinity);
    final maxY = maxYData + (maxYData == minYData ? 1.0 : 0.2);
    final yInterval = ((maxY - minY) / 5).ceilToDouble().clamp(
      0.1,
      double.infinity,
    );

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
              S.of(context).chartsWeightEvolutionTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsWeightEvolutionSubtitle,
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
                              value.toInt() < registros.length) {
                            final registro = registros[value.toInt()];
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
                              '${value.toStringAsFixed(1)}kg',
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
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [AppColors.successLight, AppColors.success],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 3.5,
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
                            AppColors.success.withValues(alpha: 0.2),
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
                          AppColors.success.withValues(alpha: 0.95),
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() < registros.length) {
                            final registro = registros[touchedSpot.x.toInt()];
                            return LineTooltipItem(
                              S
                                  .of(context)
                                  .chartsWeightTooltipEvolution(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(registro.fecha),
                                    touchedSpot.y.toStringAsFixed(2),
                                    registro.edadDias.toString(),
                                  ),
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
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

  Widget _buildGananciaDiariaChart(
    BuildContext context,
    List<RegistroPeso> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spots = registros
        .asMap()
        .entries
        .map((entry) {
          return FlSpot(
            entry.key.toDouble(),
            entry.value.gananciaDialiaPromedio,
          );
        })
        .where((spot) => spot.y.isFinite)
        .toList();

    final maxYData = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b)
        : 100.0;
    final maxY = maxYData + 10;
    final yInterval = (maxY / 5).ceilToDouble().clamp(1.0, double.infinity);

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
              S.of(context).chartsWeightADGTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsWeightADGSubtitle,
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
                              value.toInt() < registros.length) {
                            final registro = registros[value.toInt()];
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
                      gradient: const LinearGradient(
                        colors: [AppColors.successLight, AppColors.success],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 3.5,
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
                            AppColors.success.withValues(alpha: 0.2),
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
                          AppColors.success.withValues(alpha: 0.95),
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() < registros.length) {
                            final registro = registros[touchedSpot.x.toInt()];
                            return LineTooltipItem(
                              S
                                  .of(context)
                                  .chartsWeightTooltipADG(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(registro.fecha),
                                    registro.edadDias.toString(),
                                    touchedSpot.y.toStringAsFixed(1),
                                  ),
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
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

  Widget _buildUniformidadChart(
    BuildContext context,
    List<RegistroPeso> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spots = registros
        .asMap()
        .entries
        .map((entry) {
          return FlSpot(entry.key.toDouble(), entry.value.coeficienteVariacion);
        })
        .where((spot) => spot.y.isFinite)
        .toList();

    final maxYData = spots.isNotEmpty
        ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b)
        : 10.0;
    final maxY = maxYData > 20 ? maxYData + 5 : 20.0;
    final yInterval = (maxY / 5).clamp(1.0, double.infinity);

    return Card(
      elevation: 4,
      shadowColor: AppColors.warning.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.warning.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).chartsWeightUniformityTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsWeightUniformitySubtitle,
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
                              value.toInt() < registros.length) {
                            final registro = registros[value.toInt()];
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
                              '${value.toInt()}%',
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
                      gradient: const LinearGradient(
                        colors: [AppColors.warningLight, AppColors.warning],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          if (index >= 0 && index < registros.length) {
                            final registro = registros[index];
                            final color = registro.tieneBuenaUniformidad
                                ? AppColors.success
                                : AppColors.error;
                            return FlDotCirclePainter(
                              radius: 5,
                              color: color,
                              strokeWidth: 2.5,
                              strokeColor: colorScheme.onPrimary,
                            );
                          }
                          return FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.warning,
                            strokeWidth: 2.5,
                            strokeColor: colorScheme.onPrimary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.warning.withValues(alpha: 0.2),
                            AppColors.warning.withValues(alpha: 0.05),
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
                          AppColors.warning.withValues(alpha: 0.95),
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          if (touchedSpot.x.toInt() >= 0 &&
                              touchedSpot.x.toInt() < registros.length) {
                            final registro = registros[touchedSpot.x.toInt()];
                            final estado = touchedSpot.y <= 10
                                ? '✅ ${S.of(context).chartsWeightUniformityExcellent}'
                                : (touchedSpot.y <= 15
                                      ? '⚠️ ${S.of(context).chartsWeightUniformityGood}'
                                      : '❌ ${S.of(context).chartsWeightUniformityImprove}');
                            return LineTooltipItem(
                              S
                                  .of(context)
                                  .chartsWeightTooltipUniformity(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).format(registro.fecha),
                                    touchedSpot.y.toStringAsFixed(1),
                                    estado,
                                  ),
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            );
                          }
                          return const LineTooltipItem('', TextStyle());
                        }).toList();
                      },
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 10,
                        color: AppColors.success.withValues(alpha: 0.7),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                          style: theme.textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                          labelResolver: (line) => '10%',
                        ),
                      ),
                      HorizontalLine(
                        y: 15,
                        color: AppColors.error.withValues(alpha: 0.7),
                        strokeWidth: 2,
                        dashArray: [5, 5],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 5, bottom: 5),
                          style: theme.textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                          labelResolver: (line) => '15%',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUniformidadIndicador(
                  context,
                  '≤ 10%',
                  AppColors.success,
                  S.of(context).chartsWeightUniformityExcellent,
                ),
                _buildUniformidadIndicador(
                  context,
                  '10-15%',
                  AppColors.warning,
                  S.of(context).chartsWeightUniformityGood,
                ),
                _buildUniformidadIndicador(
                  context,
                  '> 15%',
                  AppColors.error,
                  S.of(context).chartsWeightUniformityImprove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniformidadIndicador(
    BuildContext context,
    String rango,
    Color color,
    String label,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.allSm,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                rango,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildComparacionEstandarChart(
    BuildContext context,
    List<RegistroPeso> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Peso estándar aproximado (Ross 308 o similar)
    // Estos son valores de referencia, deberían venir de una tabla estándar
    final spotsReales = registros.asMap().entries.map((entry) {
      return FlSpot(
        entry.value.edadDias.toDouble(),
        entry.value.pesoPromedio / 1000, // kg
      );
    }).toList();

    // Generar línea de peso estándar basada en las edades de los registros
    final spotsEstandar = registros.map((r) {
      // Fórmula aproximada para peso estándar de pollo de engorde
      // Basada en curva de crecimiento típica: Peso(kg) = 0.04 * edad^1.1
      final pesoEstandar = 0.04 * pow(r.edadDias.toDouble(), 1.1);
      return FlSpot(r.edadDias.toDouble(), pesoEstandar);
    }).toList();

    final allYValues = [
      ...spotsReales.map((e) => e.y),
      ...spotsEstandar.map((e) => e.y),
    ];
    final maxY = allYValues.isNotEmpty
        ? (allYValues.reduce((a, b) => a > b ? a : b) + 0.3)
        : 5.0;
    final yInterval = (maxY / 5).ceilToDouble().clamp(0.1, double.infinity);

    return Card(
      elevation: 4,
      shadowColor: AppColors.info.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.info.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).chartsWeightComparisonTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              S.of(context).chartsWeightComparisonSubtitle,
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
                    verticalInterval: spotsReales.length > 20
                        ? 5
                        : (spotsReales.length > 10 ? 3 : null),
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
                        interval: spotsReales.length > 20
                            ? 5
                            : (spotsReales.length > 10 ? 3 : null),
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}d',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
                              ),
                            ),
                          );
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
                              '${value.toStringAsFixed(1)}kg',
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
                  minX: spotsReales.isNotEmpty ? spotsReales.first.x : 0,
                  maxX: spotsReales.isNotEmpty ? spotsReales.last.x : 50,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    // Línea real
                    LineChartBarData(
                      spots: spotsReales,
                      isCurved: true,
                      gradient: const LinearGradient(
                        colors: [AppColors.infoLight, AppColors.info],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.info,
                            strokeWidth: 2.5,
                            strokeColor: colorScheme.onPrimary,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.info.withValues(alpha: 0.15),
                            AppColors.info.withValues(alpha: 0.03),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Línea estándar
                    LineChartBarData(
                      spots: spotsEstandar,
                      isCurved: true,
                      color: colorScheme.outline,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dashArray: [8, 4],
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          AppColors.info.withValues(alpha: 0.95),
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final isReal = touchedSpot.barIndex == 0;
                          if (isReal) {
                            // Línea real - mostrar comparación completa
                            final estandar = touchedSpots.length > 1
                                ? touchedSpots[1].y
                                : 0;
                            final diferencia = touchedSpot.y - estandar;
                            final emoji = diferencia >= 0 ? '✅' : '⚠️';
                            return LineTooltipItem(
                              S
                                  .of(context)
                                  .chartsWeightTooltipComparison(
                                    touchedSpot.y.toStringAsFixed(2),
                                    estandar.toStringAsFixed(2),
                                    emoji,
                                    diferencia >= 0 ? '+' : '',
                                    diferencia.toStringAsFixed(2),
                                  ),
                              theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                              ),
                            );
                          } else {
                            // Línea estándar - no mostrar tooltip duplicado
                            return const LineTooltipItem('', TextStyle());
                          }
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  context,
                  S.of(context).commonActual,
                  AppColors.info,
                ),
                const SizedBox(width: AppSpacing.base),
                _buildLegendItem(
                  context,
                  S.of(context).commonStandard,
                  colorScheme.outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
