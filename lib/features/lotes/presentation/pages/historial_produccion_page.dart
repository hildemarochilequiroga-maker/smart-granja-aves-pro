/// Página de historial de producción de huevos de un lote.
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
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_produccion.dart';
import 'graficos_produccion_page.dart';

/// Página principal de historial de producción.
class HistorialProduccionPage extends ConsumerStatefulWidget {
  final Lote lote;

  const HistorialProduccionPage({required this.lote, super.key});

  @override
  ConsumerState<HistorialProduccionPage> createState() =>
      HistorialProduccionPageState();
}

/// State público para poder acceder desde el dashboard
class HistorialProduccionPageState
    extends ConsumerState<HistorialProduccionPage> {
  String _filtro = 'todos';
  String _filtroPostura = 'todos';
  bool _ordenDesc = true;

  /// Indica si hay filtros activos
  bool get hayFiltrosActivos => _filtro != 'todos' || _filtroPostura != 'todos';

  /// Obtiene la etiqueta del filtro actual
  String get etiquetaFiltroActual {
    final l = S.of(context);
    final partes = <String>[];
    if (_filtro == '7d') partes.add(l.batchDays7);
    if (_filtro == '30d') partes.add(l.batchDays30);
    if (_filtroPostura == 'alta') partes.add(l.batchHighPosture);
    if (_filtroPostura == 'media') partes.add(l.batchMediumPosture);
    if (_filtroPostura == 'baja') partes.add(l.batchLowPosture);
    return partes.isEmpty ? l.batchNoFilters : partes.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrosAsync = ref.watch(
      registrosProduccionStreamProvider(widget.lote.id),
    );
    final statsAsync = ref.watch(
      registrosProduccionStatsProvider(widget.lote.id),
    );

    // Solo el body, sin Scaffold ni AppBar (el dashboard ya lo proporciona)
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 8)),
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
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < lista.length - 1 ? 12 : 0,
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant,
          borderRadius: AppRadius.allMd,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              child: Text(
                etiquetaFiltroActual,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColors.white,
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
      _filtroPostura = 'todos';
    });
  }

  // ==========================================================================
  // LOADING Y HEADERS
  // ==========================================================================

  Widget _buildStatsLoading(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Text(
            S.of(context).batchProductionHistory,
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
    final totalHuevos = stats['totalHuevos'] as int? ?? 0;
    final promedioPostura = stats['promedioPostura'] as double? ?? 0;
    final totalRegistros = stats['totalRegistros'] as int? ?? 0;
    final promedioDiario = stats['promedioDiario'] as double? ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta Ver Gráficos (arriba)
          _buildGraficosCard(theme),
          AppSpacing.gapMd,
          // Grid de estadísticas 2x2
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: _formatNumber(totalHuevos),
                  subtitle: S.of(context).historialTotalEggs,
                  color: theme.colorScheme.primary,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${promedioPostura.toStringAsFixed(1)}%',
                  subtitle: S.of(context).historialAvgPosture,
                  color: _colorPostura(promedioPostura),
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
                  value: promedioDiario.toStringAsFixed(0),
                  subtitle: S.of(context).historialDailyAvg,
                  color: theme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  Color _colorPostura(double postura) {
    if (postura >= 85) return AppColors.success;
    if (postura >= 70) return AppColors.warning;
    return AppColors.error;
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
    RegistroProduccion reg,
    ThemeData theme,
    int index,
  ) {
    return _buildRegistroCard(
      reg,
      theme,
    ).staggeredEntrance(index: index, key: ValueKey(reg.id));
  }

  Widget _buildRegistroCard(RegistroProduccion reg, ThemeData theme) {
    final posturaColor = _colorPostura(reg.porcentajePostura);
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat('EEEE, d MMMM yyyy', locale).format(reg.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(reg.fecha);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
          width: 2,
        ),
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
          splashColor: posturaColor.withValues(alpha: 0.1),
          highlightColor: posturaColor.withValues(alpha: 0.05),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Barra lateral de color
                Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.info,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),

                // Contenido principal
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Primera fila: Fecha y badge de huevos
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
                            // Badge de huevos
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.info,
                                borderRadius: AppRadius.allSm,
                              ),
                              child: Text(
                                S
                                    .of(context)
                                    .historialEggsUnit(reg.huevosRecolectados),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.gapMd,

                        // Postura
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: S.of(context).historialPostureLabel,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${reg.porcentajePostura.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: posturaColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Huevos buenos
                        AppSpacing.gapXxs,
                        Text(
                          S
                              .of(context)
                              .historialGoodLabel(
                                reg.huevosBuenos,
                                reg.porcentajeBuenos.toStringAsFixed(1),
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
                              S
                                  .of(context)
                                  .historialBirdsLabel(reg.cantidadAvesActual),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if ((reg.huevosRotos ?? 0) > 0)
                              Text(
                                S
                                    .of(context)
                                    .historialBrokenLabel(reg.huevosRotos ?? 0),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Text(
                              S.of(context).historialAgeLabel(reg.edadDias),
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
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header con título
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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
                      padding: const EdgeInsets.all(20),
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

                          // Rango de postura
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).historialPostureRange,
                          ),
                          AppSpacing.gapMd,
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildPosturaOption(
                              theme: theme,
                              label: S.of(context).historialAllPostures,
                              isSelected: _filtroPostura == 'todos',
                              color: theme.colorScheme.primary,
                              onTap: () {
                                setModalState(() {});
                                setState(() => _filtroPostura = 'todos');
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
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 3.2,
                            children: [
                              _buildPosturaOption(
                                theme: theme,
                                label: S.of(context).historialHighPosture,
                                isSelected: _filtroPostura == 'alta',
                                color: AppColors.success,
                                onTap: () {
                                  setModalState(() {});
                                  setState(() => _filtroPostura = 'alta');
                                },
                              ),
                              _buildPosturaOption(
                                theme: theme,
                                label: S.of(context).historialMediumPosture,
                                isSelected: _filtroPostura == 'media',
                                color: AppColors.warning,
                                onTap: () {
                                  setModalState(() {});
                                  setState(() => _filtroPostura = 'media');
                                },
                              ),
                              _buildPosturaOption(
                                theme: theme,
                                label: S.of(context).historialLowPosture,
                                isSelected: _filtroPostura == 'baja',
                                color: AppColors.error,
                                onTap: () {
                                  setModalState(() {});
                                  setState(() => _filtroPostura = 'baja');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón aplicar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
    IconData? icon,
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

  Widget _buildPosturaOption({
    required ThemeData theme,
    required String label,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: isSelected ? color : color.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
            AppSpacing.hGapSm,
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? color : theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sinDatos
                    ? S.of(context).historialNoProductionRecords
                    : S.of(context).historialNoResults,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                sinDatos
                    ? S.of(context).historialRegisterFirstProduction
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
        padding: const EdgeInsets.all(32),
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
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
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

  List<RegistroProduccion> _filtrarYOrdenar(
    List<RegistroProduccion> registros,
  ) {
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

    // Filtro por postura
    if (_filtroPostura == 'alta') {
      lista = lista.where((r) => r.porcentajePostura >= 85).toList();
    } else if (_filtroPostura == 'media') {
      lista = lista
          .where((r) => r.porcentajePostura >= 70 && r.porcentajePostura < 85)
          .toList();
    } else if (_filtroPostura == 'baja') {
      lista = lista.where((r) => r.porcentajePostura < 70).toList();
    }

    lista.sort(
      (a, b) =>
          _ordenDesc ? b.fecha.compareTo(a.fecha) : a.fecha.compareTo(b.fecha),
    );

    return lista;
  }

  Future<void> _onRefresh() async {
    ref.invalidate(registrosProduccionStreamProvider(widget.lote.id));
    ref.invalidate(registrosProduccionStatsProvider(widget.lote.id));
  }

  void _navegarAGraficos() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GraficosProduccionPage(lote: widget.lote),
      ),
    );
  }

  void _showDetail(RegistroProduccion reg) {
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
  final RegistroProduccion registro;

  const _DetailSheet({required this.registro});

  Color _colorPostura(double postura) {
    if (postura >= 85) return AppColors.success;
    if (postura >= 70) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final posturaColor = _colorPostura(registro.porcentajePostura);
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.paddingOf(context).bottom + 20,
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

              // Header con huevos y fecha
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
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      l.historialEggsUnit(registro.huevosRecolectados),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
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
                      l.detailPosturePercentage,
                      '${registro.porcentajePostura.toStringAsFixed(1)}%',
                      valueColor: posturaColor,
                    ),
                    _buildTableRow(
                      theme,
                      l.detailBirdAge,
                      l.detailDaysWeek(
                        registro.edadDias.toString(),
                        semanasVida.toString(),
                      ),
                    ),
                    _buildTableRow(
                      theme,
                      l.detailBirdCount,
                      '${registro.cantidadAvesActual}',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailGoodEggs,
                      '${registro.huevosBuenos} (${registro.porcentajeBuenos.toStringAsFixed(1)}%)',
                      valueColor: AppColors.success,
                    ),
                    _buildTableRow(
                      theme,
                      l.detailBrokenEggs,
                      '${registro.huevosRotos ?? 0}',
                      valueColor: (registro.huevosRotos ?? 0) > 0
                          ? AppColors.error
                          : null,
                    ),
                    if (registro.huevosSucios != null)
                      _buildTableRow(
                        theme,
                        l.detailDirtyEggs,
                        '${registro.huevosSucios}',
                        valueColor: AppColors.warning,
                      ),
                    if (registro.huevosDobleYema != null)
                      _buildTableRow(
                        theme,
                        l.detailDoubleYolkEggs,
                        '${registro.huevosDobleYema}',
                      ),
                    if (registro.pesoPromedioHuevoGramos != null)
                      _buildTableRow(
                        theme,
                        l.detailAvgEggWeight,
                        '${registro.pesoPromedioHuevoGramos!.toStringAsFixed(1)} g',
                      ),
                    _buildTableRow(
                      theme,
                      l.detailRegisteredBy,
                      registro.nombreUsuario,
                      isLast:
                          !(registro.observaciones?.isNotEmpty ?? false) &&
                          !registro.tieneClasificacionCompleta,
                    ),
                    if (registro.observaciones?.isNotEmpty ?? false)
                      _buildTableRow(
                        theme,
                        l.detailObservations,
                        registro.observaciones!,
                        isLast: !registro.tieneClasificacionCompleta,
                      ),
                  ],
                ),
              ),

              // Clasificación por tamaño
              if (registro.tieneClasificacionCompleta) ...[
                AppSpacing.gapBase,
                Text(
                  l.detailSizeClassification,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapSm,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSizeChip(
                        'P',
                        registro.huevosPequenos ?? 0,
                        AppColors.info,
                        theme,
                      ),
                      _buildSizeChip(
                        'M',
                        registro.huevosMedianos ?? 0,
                        AppColors.success,
                        theme,
                      ),
                      _buildSizeChip(
                        'G',
                        registro.huevosGrandes ?? 0,
                        AppColors.warning,
                        theme,
                      ),
                      _buildSizeChip(
                        'XG',
                        registro.huevosExtraGrandes ?? 0,
                        AppColors.error,
                        theme,
                      ),
                    ],
                  ),
                ),
              ],

              // Fotos de evidencia
              if (registro.fotosUrls.isNotEmpty) ...[
                AppSpacing.gapBase,
                Text(
                  l.detailPhotoEvidence,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapSm,
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: registro.fotosUrls.length,
                    separatorBuilder: (_, __) => AppSpacing.hGapSm,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: AppRadius.allSm,
                        child: AppImage(
                          url: registro.fotosUrls[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          memCacheWidth: 200,
                          memCacheHeight: 200,
                          errorWidget: Container(
                            width: 100,
                            height: 100,
                            color: AppColors.surfaceVariant,
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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

  Widget _buildSizeChip(String label, int count, Color color, ThemeData theme) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppRadius.allMd,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        AppSpacing.gapXxs,
        Text(
          count.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
