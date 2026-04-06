import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_mortalidad.dart';

/// Página de gráficos y análisis visual de mortalidad del lote.
class GraficosMortalidadPage extends ConsumerWidget {
  final Lote lote;

  const GraficosMortalidadPage({required this.lote, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrosAsync = ref.watch(
      registrosMortalidadStreamProvider(lote.id),
    );
    final estadisticasAsync = ref.watch(
      estadisticasMortalidadProvider(lote.id),
    );
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).batchChartsMortality),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(registrosMortalidadStreamProvider(lote.id));
              ref.invalidate(estadisticasMortalidadProvider(lote.id));
            },
            tooltip: S.of(context).commonUpdate,
          ),
        ],
      ),
      body: registrosAsync.when(
        data: (registros) {
          if (registros.isEmpty) {
            return _buildEmptyState(context, ref);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(registrosMortalidadStreamProvider(lote.id));
              ref.invalidate(estadisticasMortalidadProvider(lote.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gráfico de mortalidad acumulada
                  _buildMortalidadAcumuladaChart(context, registros),
                  AppSpacing.gapXl,

                  // Gráfico de mortalidad diaria
                  _buildMortalidadDiariaChart(context, registros),
                  AppSpacing.gapXl,

                  // Gráfico de distribución por causa
                  estadisticasAsync.when(
                    data: (stats) =>
                        _buildCausaDistributionChart(context, stats),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => const SizedBox.shrink(),
                  ),
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
              AppSpacing.gapBase,
              Text(
                S.of(context).chartsLoading,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        error: (error, _) => Center(
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
                    AppSpacing.gapLg,
                    Text(
                      S.of(context).chartsErrorLoading,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapXl,
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
                            registrosMortalidadStreamProvider(lote.id),
                          );
                          ref.invalidate(
                            estadisticasMortalidadProvider(lote.id),
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

  Widget _buildMortalidadAcumuladaChart(
    BuildContext context,
    List<RegistroMortalidad> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    if (sortedRegistros.isEmpty) return const SizedBox.shrink();

    // Calcular límites basados en cantidad inicial del lote
    final cantidadInicial = lote.cantidadInicial.toDouble();
    final limiteAceptable = cantidadInicial * 0.05; // 5%
    final limiteAlerta = cantidadInicial * 0.10; // 10%

    // Agrupar por día y acumular correctamente
    final Map<DateTime, int> dailyTotal = {};

    // Primero, sumar todas las muertes del mismo día
    for (var registro in sortedRegistros) {
      final day = DateTime(
        registro.fecha.year,
        registro.fecha.month,
        registro.fecha.day,
      );
      dailyTotal[day] = (dailyTotal[day] ?? 0) + registro.cantidad;
    }

    // Luego, calcular el acumulado
    final Map<DateTime, int> dailyAccumulated = {};
    int acumulado = 0;
    final sortedDays = dailyTotal.keys.toList()..sort((a, b) => a.compareTo(b));

    for (var day in sortedDays) {
      acumulado += dailyTotal[day]!;
      dailyAccumulated[day] = acumulado;
    }

    // Convertir a lista ordenada de fechas únicas
    final uniqueDays = dailyAccumulated.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    if (uniqueDays.isEmpty) return const SizedBox.shrink();

    // Crear spots con días desde el inicio
    final firstDay = uniqueDays.first;
    final spots = uniqueDays.map((day) {
      final daysSinceStart = day.difference(firstDay).inDays.toDouble();
      return FlSpot(daysSinceStart, dailyAccumulated[day]!.toDouble());
    }).toList();

    final maxDays = spots.isNotEmpty ? spots.last.x : 10;
    final maxValue = spots.isNotEmpty ? spots.last.y : 10;

    // Calcular intervalo para alineación de grid y labels
    final yInterval = maxValue > 0 ? (maxValue / 5).ceilToDouble() : 1.0;

    return Card(
      elevation: 4,
      shadowColor: AppColors.error.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: AppColors.error.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).batchAccumulatedMortalityChart,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).chartsMortalityAccumulatedSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapLg,
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: yInterval,
                    verticalInterval: maxDays > 50
                        ? 10
                        : (maxDays > 20 ? 5 : 2),
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
                        interval: maxDays > 30
                            ? (maxDays / 5).ceilToDouble()
                            : maxDays > 14
                            ? 7
                            : maxDays > 7
                            ? 2
                            : 1,
                        getTitlesWidget: (value, meta) {
                          // Evitar mostrar etiqueta si está muy cerca del borde
                          if (value == meta.min || value == meta.max) {
                            return const SizedBox.shrink();
                          }
                          final dayIndex = value.toInt();
                          if (dayIndex >= 0 && dayIndex <= maxDays) {
                            final targetDate = firstDay.add(
                              Duration(days: dayIndex),
                            );
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(targetDate),
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
                        interval: yInterval > 0 ? yInterval : 1,
                        getTitlesWidget: (value, meta) {
                          // Evitar mostrar 0 y el máximo si está muy cerca
                          if (value == meta.min) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
                              ),
                            ),
                          );
                        },
                        reservedSize: 35,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  minX: 0,
                  maxX: maxDays.toDouble(),
                  minY: 0,
                  maxY: spots.isNotEmpty
                      ? spots.last.y + (spots.last.y * 0.1)
                      : 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppColors.error,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.error,
                            strokeWidth: 2,
                            strokeColor: AppColors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.error.withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          AppColors.error.withValues(alpha: 0.8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final dayIndex = touchedSpot.x.toInt();
                          final targetDate = firstDay.add(
                            Duration(days: dayIndex),
                          );
                          final porcentaje =
                              (touchedSpot.y / cantidadInicial) * 100;
                          return LineTooltipItem(
                            '${DateFormat('dd/MM').format(targetDate)}\n${S.of(context).chartsMortalityTooltipTotal(touchedSpot.y.toInt(), porcentaje.toStringAsFixed(1))}',
                            theme.textTheme.bodySmall!.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      // Línea de referencia al 5% (Aceptable)
                      HorizontalLine(
                        y: limiteAceptable,
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
                          labelResolver: (line) => '5%',
                        ),
                      ),
                      // Línea de referencia al 10% (Crítico)
                      HorizontalLine(
                        y: limiteAlerta,
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
                          labelResolver: (line) => '10%',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.gapBase,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIndicador(
                  context,
                  '< 5%',
                  AppColors.success,
                  S.of(context).chartsMortalityAcceptable,
                ),
                _buildIndicador(
                  context,
                  '5-10%',
                  AppColors.warning,
                  S.of(context).chartsMortalityAlert,
                ),
                _buildIndicador(
                  context,
                  '> 10%',
                  AppColors.error,
                  S.of(context).chartsMortalityCritical,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicador(
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
        AppSpacing.gapXxs,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMortalidadDiariaChart(
    BuildContext context,
    List<RegistroMortalidad> registros,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedRegistros = [...registros]
      ..sort((a, b) => a.fecha.compareTo(b.fecha));

    final spots = sortedRegistros.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.cantidad.toDouble());
    }).toList();

    if (spots.isEmpty) return const SizedBox.shrink();

    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 2;
    final yInterval = maxY > 10
        ? (maxY / 5).ceilToDouble()
        : (maxY > 5 ? 2.0 : 1.0);

    // Calcular ancho de barra dinámico según cantidad de registros
    final numRegistros = sortedRegistros.length;
    final barWidth = numRegistros > 20
        ? 8.0
        : numRegistros > 10
        ? 12.0
        : 16.0;

    // Calcular intervalo para mostrar etiquetas (evitar sobreposición)
    final labelInterval = numRegistros > 15
        ? 5
        : numRegistros > 8
        ? 2
        : 1;

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
              S.of(context).chartsMortalityPerRegistrationTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).chartsMortalityPerRegistrationSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapLg,
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY.toDouble(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) =>
                          AppColors.warning.withValues(alpha: 0.8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final registro = sortedRegistros[groupIndex];
                        return BarTooltipItem(
                          S
                              .of(context)
                              .chartsMortalityTooltipEvent(
                                DateFormat('dd/MM').format(registro.fecha),
                                rod.toY.toInt(),
                              ),
                          theme.textTheme.bodySmall!.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
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
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          // Solo mostrar etiqueta según el intervalo calculado
                          if (index >= 0 &&
                              index < sortedRegistros.length &&
                              index % labelInterval == 0) {
                            final registro = sortedRegistros[index];
                            return Transform.rotate(
                              angle: numRegistros > 10 ? -0.5 : 0,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  DateFormat('dd/MM').format(registro.fecha),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: colorScheme.outline,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: numRegistros > 10 ? 40 : 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: yInterval,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.min) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: colorScheme.outline,
                              ),
                            ),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: spots.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.y,
                          color: AppColors.warning,
                          width: barWidth,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCausaDistributionChart(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final distribucion =
        stats['distribucionPorCausa'] as Map<String, dynamic>? ?? {};

    if (distribucion.isEmpty) {
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
                S.of(context).chartsMortalityDistributionCauseTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSpacing.gapXl,
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.pie_chart_outline,
                      size: 48,
                      color: colorScheme.outline,
                    ),
                    AppSpacing.gapMd,
                    Text(
                      S.of(context).chartsNoCauseData,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapXl,
            ],
          ),
        ),
      );
    }

    final sortedEntries = distribucion.entries.toList()
      ..sort((a, b) => (b.value as int).compareTo(a.value as int));

    final totalAves = sortedEntries.fold<int>(
      0,
      (sum, entry) => sum + (entry.value as int),
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
              S.of(context).chartsMortalityDistributionCauseTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).chartsMortalityTotalByCauseSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapBase,
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
                          final causa = entry.value.key;
                          final cantidad = entry.value.value as int;
                          final percentage = (cantidad / totalAves * 100);
                          final color = _getCausaChartColor(causa, index);

                          return PieChartSectionData(
                            color: color,
                            value: cantidad.toDouble(),
                            title: percentage >= 10
                                ? '${percentage.toStringAsFixed(0)}%'
                                : '',
                            radius: 50,
                            titleStyle: theme.textTheme.labelSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
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
                          final causa = entry.key;
                          final cantidad = entry.value as int;
                          final percentage = (cantidad / totalAves * 100);
                          final index = sortedEntries.indexOf(entry);
                          final color = _getCausaChartColor(causa, index);

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
                                    _formatCausaLabel(context, causa),
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

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
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
                  S.of(context).commonExcellent,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                AppSpacing.gapSm,
                Text(
                  S.of(context).chartsNoMortalityRecords,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapXl,
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

  Color _getCausaChartColor(String causa, int index) {
    // Colores específicos por causa usando AppColors
    final causaColors = {
      'enfermedad': AppColors.error,
      'estres': AppColors.warning,
      'accidente': AppColors.warning,
      'depredacion': AppColors.deepOrange,
      'desnutricion': AppColors.amber,
      'metabolica': AppColors.warningLight,
      'sacrificio': AppColors.grey500,
      'vejez': AppColors.grey500,
      'desconocida': AppColors.info,
    };

    return causaColors[causa.toLowerCase()] ??
        AppColors.chartColors[index % AppColors.chartColors.length];
  }

  String _formatCausaLabel(BuildContext context, String causa) {
    final labels = {
      'enfermedad': S.of(context).mortalityCauseDisease,
      'estres': S.of(context).mortalityCauseStress,
      'accidente': S.of(context).mortalityCauseAccident,
      'depredacion': S.of(context).mortalityCausePredation,
      'desnutricion': S.of(context).mortalityCauseMalnutrition,
      'metabolica': S.of(context).mortalityCauseMetabolic,
      'sacrificio': S.of(context).mortalityCauseSacrifice,
      'vejez': S.of(context).mortalityCauseOldAge,
      'desconocida': S.of(context).mortalityCauseUnknown,
    };

    return labels[causa.toLowerCase()] ?? causa;
  }
}
