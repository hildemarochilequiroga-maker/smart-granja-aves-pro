/// Página de historial de consumo de alimento de un lote.
///
/// Diseño unificado con historial de mortalidad:
/// - Estadísticas 2x2 con cards
/// - Tarjeta Ver Gráficos integrada
/// - Cards de registro con barra lateral de color
/// - Filtros con modal bottom sheet moderno
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_consumo.dart';
import '../../domain/enums/tipo_alimento.dart';
import 'graficos_consumo_page.dart';

/// Extensión para colores de tipo de alimento
extension TipoAlimentoColor on TipoAlimento {
  Color get color {
    switch (this) {
      case TipoAlimento.preIniciador:
        return AppColors.lightGreen;
      case TipoAlimento.iniciador:
        return AppColors.success;
      case TipoAlimento.crecimiento:
        return AppColors.info;
      case TipoAlimento.finalizador:
        return AppColors.warning;
      case TipoAlimento.postura:
        return AppColors.pink;
      case TipoAlimento.levante:
        return AppColors.purple;
      case TipoAlimento.medicado:
        return AppColors.error;
      case TipoAlimento.concentrado:
        return AppColors.brown;
      case TipoAlimento.otro:
        return AppColors.outline;
    }
  }

  IconData get icon {
    switch (this) {
      case TipoAlimento.preIniciador:
        return Icons.start_rounded;
      case TipoAlimento.iniciador:
        return Icons.grain_rounded;
      case TipoAlimento.crecimiento:
        return Icons.trending_up_rounded;
      case TipoAlimento.finalizador:
        return Icons.check_circle_rounded;
      case TipoAlimento.postura:
        return Icons.egg_rounded;
      case TipoAlimento.levante:
        return Icons.arrow_upward_rounded;
      case TipoAlimento.medicado:
        return Icons.medical_services_rounded;
      case TipoAlimento.concentrado:
        return Icons.science_rounded;
      case TipoAlimento.otro:
        return Icons.inventory_2_rounded;
    }
  }
}

/// Página principal de historial de consumo.
class HistorialConsumoPage extends ConsumerStatefulWidget {
  final Lote lote;

  const HistorialConsumoPage({required this.lote, super.key});

  @override
  ConsumerState<HistorialConsumoPage> createState() =>
      HistorialConsumoPageState();
}

/// State público para poder acceder desde el dashboard
class HistorialConsumoPageState extends ConsumerState<HistorialConsumoPage> {
  String _filtro = 'todos';
  TipoAlimento? _tipoFiltro;
  bool _ordenDesc = true;

  /// Indica si hay filtros activos
  bool get hayFiltrosActivos => _filtro != 'todos' || _tipoFiltro != null;

  /// Obtiene la etiqueta del filtro actual
  String get etiquetaFiltroActual {
    final partes = <String>[];
    if (_filtro == '7d') partes.add(S.of(context).batchDays7);
    if (_filtro == '30d') partes.add(S.of(context).batchDays30);
    if (_tipoFiltro != null) {
      partes.add(_tipoFiltro!.localizedDisplayName(S.of(context)));
    }
    return partes.isEmpty ? S.of(context).batchNoFilters : partes.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrosAsync = ref.watch(
      registrosConsumoStreamProvider(widget.lote.id),
    );
    final statsAsync = ref.watch(registrosConsumoStatsProvider(widget.lote.id));

    // Solo el body, sin Scaffold ni AppBar (el dashboard ya lo proporciona)
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.tertiary,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: AppSpacing.sm)),
          // Estadísticas con tarjeta de gráficos
          SliverToBoxAdapter(
            child: statsAsync.when(
              data: (stats) => _buildEstadisticasSection(stats, theme),
              loading: () => _buildStatsLoading(theme),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Indicador de filtros activos (debajo de estadísticas)
          if (hayFiltrosActivos)
            SliverToBoxAdapter(child: _buildFiltrosActivosChip(theme)),

          // Divider visual
          const SliverToBoxAdapter(child: AppSpacing.gapSm),
          SliverToBoxAdapter(child: _buildRegistrosHeader(theme)),

          // Lista de registros (lazy-loaded con SliverList)
          registrosAsync.when(
            data: (registros) {
              final lista = _filtrarYOrdenar(registros);

              if (lista.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(theme, registros.isEmpty),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.sm,
                  left: AppSpacing.base,
                  right: AppSpacing.base,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < lista.length - 1 ? AppSpacing.md : 0,
                      ),
                      child: _buildAnimatedRegistroCard(
                        lista[index],
                        theme,
                        index,
                      ),
                    ),
                    childCount: lista.length,
                  ),
                ),
              );
            },
            loading: () => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                ),
                child: Column(
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md),
                      child: SkeletonListCard(
                        hasIcon: true,
                        hasSubtitle: true,
                        hasBadge: true,
                        hasFooter: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            error: (error, _) =>
                SliverToBoxAdapter(child: _buildErrorState(theme, error)),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  // ==========================================================================
  // CHIP DE FILTROS ACTIVOS
  // ==========================================================================

  Widget _buildFiltrosActivosChip(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.base,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant,
          borderRadius: AppRadius.allMd,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxxl,
                vertical: AppSpacing.md,
              ),
              child: Text(
                etiquetaFiltroActual,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _limpiarFiltros,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: AppSpacing.md,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: theme.colorScheme.surface,
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

  void _limpiarFiltros() {
    HapticFeedback.lightImpact();
    setState(() {
      _filtro = 'todos';
      _tipoFiltro = null;
    });
  }

  // ==========================================================================
  // LOADING Y HEADERS
  // ==========================================================================

  Widget _buildStatsLoading(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSkeletonCard(theme)),
              AppSpacing.hGapMd,
              Expanded(child: _buildSkeletonCard(theme)),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(child: _buildSkeletonCard(theme)),
              AppSpacing.hGapMd,
              Expanded(child: _buildSkeletonCard(theme)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonCard(ThemeData theme) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.allMd,
      ),
    );
  }

  Widget _buildRegistrosHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
        0,
      ),
      child: Row(
        children: [
          Text(
            S.of(context).historialConsumptionHistory,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _ordenDesc = !_ordenDesc);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Text(
                _ordenDesc
                    ? S.of(context).batchRecent
                    : S.of(context).batchOldest,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECCIÓN DE ESTADÍSTICAS
  // ==========================================================================

  Widget _buildEstadisticasSection(
    Map<String, dynamic> stats,
    ThemeData theme,
  ) {
    final totalKg = stats['totalConsumo'] as double? ?? 0;
    final promedioDiario = stats['promedioDiario'] as double? ?? 0;
    final totalRegistros = stats['totalRegistros'] as int? ?? 0;
    final consumoPorAve = stats['consumoPorAve'] as double? ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.sm,
        AppSpacing.base,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid de estadísticas 2x2
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${totalKg.toStringAsFixed(1)} kg',
                  subtitle: S.of(context).historialTotalConsumed,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${promedioDiario.toStringAsFixed(2)} kg',
                  subtitle: S.of(context).historialAvgDaily,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: totalRegistros.toString(),
                  subtitle: S.of(context).historialRecords,
                  color: theme.colorScheme.secondary,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${(consumoPorAve * 1000).toStringAsFixed(0)} g',
                  subtitle: S.of(context).historialAccumulatedPerBird,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          // Tarjeta Ver Gráficos (debajo de KPIs)
          _buildGraficosCard(theme),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required ThemeData theme,
    required String value,
    required String subtitle,
    required Color color,
    bool isHighlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isHighlight
            ? color.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: isHighlight
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
        boxShadow: isHighlight
            ? null
            : [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXxs,
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGraficosCard(ThemeData theme) {
    return GestureDetector(
      onTap: _navegarAGraficos,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.info,
          borderRadius: AppRadius.allMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 24),
            const SizedBox(width: AppSpacing.sm),
            Text(
              S.of(context).batchViewCharts,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // TARJETAS DE REGISTRO
  // ==========================================================================

  Widget _buildAnimatedRegistroCard(
    RegistroConsumo reg,
    ThemeData theme,
    int index,
  ) {
    return _buildRegistroCard(
      reg,
      theme,
    ).staggeredEntrance(index: index, key: ValueKey(reg.id));
  }

  Widget _buildRegistroCard(RegistroConsumo reg, ThemeData theme) {
    final tipoColor = reg.tipoAlimento.color;
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(reg.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(reg.fecha);
    final semanasVida = (reg.edadDias / 7).ceil();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: tipoColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.allMd,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            _showDetail(reg);
          },
          borderRadius: AppRadius.allMd,
          splashColor: tipoColor.withValues(alpha: 0.1),
          highlightColor: tipoColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera fila: Fecha y badge de cantidad
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fecha y hora
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fechaFormat,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            horaFormat,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Badge de cantidad
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: tipoColor,
                        borderRadius: AppRadius.allSm,
                      ),
                      child: Text(
                        '${reg.cantidadKg.toStringAsFixed(2)} kg',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.surface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                AppSpacing.gapMd,

                // Tipo de alimento
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: '${S.of(context).historialFilterFoodType}: ',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextSpan(
                        text: reg.tipoAlimento.localizedDisplayName(
                          S.of(context),
                        ),
                        style: TextStyle(
                          color: tipoColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Consumo por ave
                AppSpacing.gapXxs,
                Text(
                  S
                      .of(context)
                      .historialConsumptionValue(
                        (reg.consumoPorAve * 1000).toStringAsFixed(0),
                      ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                AppSpacing.gapSm,

                // Aves y Edad
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).historialBirdNumber(reg.cantidadAvesActual),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      S
                          .of(context)
                          .detailDaysWeek(
                            reg.edadDias.toString(),
                            semanasVida.toString(),
                          ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // MENÚ DE FILTROS
  // ==========================================================================

  /// Método público para mostrar el menú de filtros (accesible desde el dashboard)
  void showFilterMenu() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final theme = Theme.of(context);

          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppSpacing.md,
                      bottom: AppSpacing.sm,
                    ),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.base,
                    ),
                    child: Text(
                      S.of(context).batchFilterRecords,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),

                  // Contenido
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Período
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).batchTimePeriod,
                          ),
                          AppSpacing.gapMd,
                          Row(
                            children: [
                              Expanded(
                                child: _buildPeriodOption(
                                  theme: theme,
                                  label: S.of(context).batchAllTime,
                                  subtitle: S.of(context).batchNoTimeLimit,
                                  icon: Icons.all_inclusive_rounded,
                                  isSelected: _filtro == 'todos',
                                  onTap: () {
                                    setModalState(() {});
                                    setState(() => _filtro = 'todos');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildPeriodOption(
                                  theme: theme,
                                  label: S.of(context).batchDays7,
                                  subtitle: S.of(context).batchLastWeek,
                                  icon: Icons.today_rounded,
                                  isSelected: _filtro == '7d',
                                  onTap: () {
                                    setModalState(() {});
                                    setState(() => _filtro = '7d');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildPeriodOption(
                                  theme: theme,
                                  label: S.of(context).batchDays30,
                                  subtitle: S.of(context).batchLastMonth,
                                  icon: Icons.date_range_rounded,
                                  isSelected: _filtro == '30d',
                                  onTap: () {
                                    setModalState(() {});
                                    setState(() => _filtro = '30d');
                                  },
                                ),
                              ),
                            ],
                          ),

                          AppSpacing.gapXl,

                          // Tipo de alimento
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).historialFilterFoodType,
                          ),
                          AppSpacing.gapMd,
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildTipoOption(
                              theme: theme,
                              label: S.of(context).historialAllFoodTypes,
                              isSelected: _tipoFiltro == null,
                              color: theme.colorScheme.primary,
                              onTap: () {
                                setModalState(() {});
                                setState(() => _tipoFiltro = null);
                              },
                            ),
                          ),
                          AppSpacing.gapSm,
                          GridView.count(
                            crossAxisCount: AppBreakpoints.of(
                              context,
                            ).gridColumns,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppSpacing.sm,
                            crossAxisSpacing: AppSpacing.sm,
                            childAspectRatio: 2.4,
                            children: TipoAlimento.values.map((tipo) {
                              return _buildTipoOption(
                                theme: theme,
                                label: tipo.localizedDisplayName(S.of(context)),
                                subtitle: tipo.localizedRangoEdadDescripcion(
                                  S.of(context),
                                ),
                                isSelected: _tipoFiltro == tipo,
                                color: tipo.color,
                                onTap: () {
                                  setModalState(() {});
                                  setState(() => _tipoFiltro = tipo);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón aplicar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.base,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allMd,
                          ),
                        ),
                        child: Text(
                          hayFiltrosActivos
                              ? S.of(context).commonApplyFilters
                              : S.of(context).commonClose,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSectionHeader({
    required ThemeData theme,
    required String title,
  }) {
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildPeriodOption({
    required ThemeData theme,
    required String label,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? AppColors.info.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppColors.info
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoOption({
    required ThemeData theme,
    required String label,
    String? subtitle,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? AppColors.info.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.info
                          : theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // ESTADOS
  // ==========================================================================

  Widget _buildEmptyState(ThemeData theme, bool sinDatos) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(scale: 0.9 + (0.1 * value), child: child),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sinDatos
                    ? S.of(context).historialNoConsumptionRecords
                    : S.of(context).historialNoResults,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                sinDatos
                    ? S.of(context).historialRegisterFirstConsumption
                    : S.of(context).historialNoRecordsWithFilters,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: theme.colorScheme.error,
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).batchErrorLoadingRecords,
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
            FilledButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: Text(S.of(context).commonRetry),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // LÓGICA
  // ==========================================================================

  List<RegistroConsumo> _filtrarYOrdenar(List<RegistroConsumo> registros) {
    var lista = registros.toList();

    // Filtro por periodo
    if (_filtro != 'todos') {
      final dias = _filtro == '7d' ? 7 : 30;
      final ahora = DateTime.now();
      final limite = DateTime(
        ahora.year,
        ahora.month,
        ahora.day,
      ).subtract(Duration(days: dias));
      lista = lista.where((r) {
        final fechaNorm = DateTime(r.fecha.year, r.fecha.month, r.fecha.day);
        return fechaNorm.isAfter(limite) || fechaNorm.isAtSameMomentAs(limite);
      }).toList();
    }

    // Filtro por tipo
    if (_tipoFiltro != null) {
      lista = lista.where((r) => r.tipoAlimento == _tipoFiltro).toList();
    }

    lista.sort(
      (a, b) =>
          _ordenDesc ? b.fecha.compareTo(a.fecha) : a.fecha.compareTo(b.fecha),
    );

    return lista;
  }

  Future<void> _onRefresh() async {
    ref.invalidate(registrosConsumoStreamProvider(widget.lote.id));
    ref.invalidate(registrosConsumoStatsProvider(widget.lote.id));
  }

  void _navegarAGraficos() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GraficosConsumoPage(lote: widget.lote)),
    );
  }

  void _showDetail(RegistroConsumo reg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DetailSheet(registro: reg),
    );
  }
}

// =============================================================================
// SHEET DE DETALLE
// =============================================================================

class _DetailSheet extends StatelessWidget {
  final RegistroConsumo registro;

  const _DetailSheet({required this.registro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tipoColor = registro.tipoAlimento.color;
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(registro.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(registro.fecha);
    final semanasVida = (registro.edadDias / 7).ceil();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            MediaQuery.paddingOf(context).bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              AppSpacing.gapLg,

              // Header con cantidad y fecha
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fechaFormat,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          horaFormat,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      '${registro.cantidadKg.toStringAsFixed(2)} kg',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.gapLg,

              // Información en formato tabla
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTableRow(
                      theme,
                      S.of(context).detailFoodType,
                      registro.tipoAlimento.localizedDisplayName(S.of(context)),
                      valueColor: tipoColor,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).detailBirdAge,
                      S
                          .of(context)
                          .detailDaysWeek(
                            registro.edadDias.toString(),
                            semanasVida.toString(),
                          ),
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).detailBirdCount,
                      '${registro.cantidadAvesActual}',
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).detailConsumptionPerBird,
                      '${(registro.consumoPorAve * 1000).toStringAsFixed(0)} g',
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).detailAccumulatedConsumption,
                      '${registro.consumoAcumulado.toStringAsFixed(2)} kg',
                    ),
                    if (registro.loteAlimento != null)
                      _buildTableRow(
                        theme,
                        S.of(context).detailFoodBatch,
                        registro.loteAlimento!,
                      ),
                    if (registro.costoPorKg != null)
                      _buildTableRow(
                        theme,
                        S.of(context).detailCostPerKg,
                        '\$${registro.costoPorKg!.toStringAsFixed(2)}',
                        valueColor: AppColors.success,
                      ),
                    if (registro.costoTotal != null)
                      _buildTableRow(
                        theme,
                        S.of(context).detailTotalCost,
                        '\$${registro.costoTotal!.toStringAsFixed(2)}',
                        valueColor: AppColors.success,
                      ),
                    _buildTableRow(
                      theme,
                      S.of(context).detailRegisteredBy,
                      registro.nombreUsuario,
                      isLast: !(registro.observaciones?.isNotEmpty ?? false),
                    ),
                    if (registro.observaciones?.isNotEmpty ?? false)
                      _buildTableRow(
                        theme,
                        S.of(context).detailObservations,
                        registro.observaciones!,
                        isLast: true,
                      ),
                  ],
                ),
              ),

              AppSpacing.gapSm,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(
    ThemeData theme,
    String label,
    String value, {
    Color? valueColor,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
