/// P�gina de historial de peso de un lote.
///
/// Dise�o unificado con historial de mortalidad:
/// - Estad�sticas 2x2 con cards
/// - Tarjeta Ver Gr�ficos integrada
/// - Cards de registro con barra lateral de color
/// - Filtros con modal bottom sheet moderno
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_peso.dart';
import '../../domain/enums/metodo_pesaje.dart';
import 'graficos_peso_page.dart';

/// P�gina principal de historial de peso.
class HistorialPesoPage extends ConsumerStatefulWidget {
  final Lote lote;

  const HistorialPesoPage({required this.lote, super.key});

  @override
  ConsumerState<HistorialPesoPage> createState() => HistorialPesoPageState();
}

/// State p�blico para poder acceder desde el dashboard
class HistorialPesoPageState extends ConsumerState<HistorialPesoPage> {
  String _filtro = 'todos';
  MetodoPesaje? _metodoFiltro;
  bool _ordenDesc = true;

  /// Indica si hay filtros activos
  bool get hayFiltrosActivos => _filtro != 'todos' || _metodoFiltro != null;

  /// Obtiene la etiqueta del filtro actual
  String get etiquetaFiltroActual {
    final partes = <String>[];
    if (_filtro == '7d') partes.add(S.of(context).batchDays7);
    if (_filtro == '30d') partes.add(S.of(context).batchDays30);
    if (_metodoFiltro != null) {
      partes.add(_metodoFiltro!.localizedDescripcion(S.of(context)));
    }
    return partes.isEmpty ? S.of(context).batchNoFilters : partes.join(' � ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrosAsync = ref.watch(
      registrosPesoStreamProvider(widget.lote.id),
    );
    final statsAsync = ref.watch(registrosPesoStatsProvider(widget.lote.id));

    // Solo el body, sin Scaffold ni AppBar (el dashboard ya lo proporciona)
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.info,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.only(top: 8)),
          // Estad�sticas con tarjeta de gr�ficos
          SliverToBoxAdapter(
            child: statsAsync.when(
              data: (stats) => _buildEstadisticasSection(stats, theme),
              loading: () => _buildStatsLoading(theme),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Indicador de filtros activos (debajo de estad�sticas)
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_metodoFiltro != null) ...[
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _metodoFiltro!.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    AppSpacing.hGapSm,
                  ],
                  Text(
                    etiquetaFiltroActual,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                      vertical: 12,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: theme.colorScheme.onPrimary,
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
      _metodoFiltro = null;
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
            S.of(context).historialWeighingHistory,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _ordenDesc = !_ordenDesc);
            },
            child: Text(
              _ordenDesc
                  ? S.of(context).batchRecent
                  : S.of(context).batchOldest,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // SECCI�N DE ESTAD�STICAS
  // ==========================================================================

  Widget _buildEstadisticasSection(
    Map<String, dynamic> stats,
    ThemeData theme,
  ) {
    final totalRegistros = stats['totalRegistros'] as int? ?? 0;
    final ultimoPeso = (stats['ultimoPesoPromedio'] as double? ?? 0) / 1000;
    final gdp = stats['gananciaDialiaPromedio'] as double? ?? 0;
    final cv = stats['coeficienteVariacionPromedio'] as double? ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid de estad�sticas 2x2
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: totalRegistros.toString(),
                  subtitle: S.of(context).historialRecords,
                  color: AppColors.info,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${ultimoPeso.toStringAsFixed(2)} kg',
                  subtitle: S.of(context).historialLastWeight,
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
                  value: '${gdp.toStringAsFixed(1)} g',
                  subtitle: S.of(context).historialDailyGainStat,
                  color: gdp >= 0 ? AppColors.success : AppColors.error,
                  isHighlight: gdp < 0,
                ),
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: _buildStatCard(
                  theme: theme,
                  value: '${cv.toStringAsFixed(1)}%',
                  subtitle: S.of(context).historialUniformityCV,
                  color: cv <= 10 ? AppColors.success : AppColors.warning,
                  isHighlight: cv > 10,
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          // Tarjeta Ver Gr�ficos (debajo de KPIs)
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
    return Material(
      color: AppColors.info,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        onTap: _navegarAGraficos,
        borderRadius: AppRadius.allMd,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: AppRadius.allMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              AppSpacing.hGapSm,
              Text(
                S.of(context).batchViewCharts,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // TARJETAS DE REGISTRO
  // ==========================================================================

  Widget _buildAnimatedRegistroCard(
    RegistroPeso reg,
    ThemeData theme,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(reg.id),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _buildRegistroCard(reg, theme),
    );
  }

  Widget _buildRegistroCard(RegistroPeso reg, ThemeData theme) {
    final peso = reg.pesoPromedio / 1000;
    final metodColor = reg.metodoPesaje.color;
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(reg.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(reg.fecha);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.3),
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
          splashColor: metodColor.withValues(alpha: 0.1),
          highlightColor: metodColor.withValues(alpha: 0.05),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Barra lateral de color
                Container(
                  width: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
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
                        // Primera fila: Fecha y badge de peso
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
                            // Badge de peso
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: AppRadius.allSm,
                              ),
                              child: Text(
                                '${peso.toStringAsFixed(2)} kg',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        AppSpacing.gapMd,

                        // M�todo de pesaje
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: '${S.of(context).historialMethodLabel}: ',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextSpan(
                                text: reg.metodoPesaje.localizedDescripcion(
                                  S.of(context),
                                ),
                                style: TextStyle(
                                  color: metodColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Aves pesadas
                        AppSpacing.gapXxs,
                        Text(
                          S
                              .of(context)
                              .historialBirdsWeighedLabel(
                                reg.cantidadAvesPesadas,
                              ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),

                        AppSpacing.gapSm,

                        // GDP, CV y Edad
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S
                                  .of(context)
                                  .historialGdpLabel(
                                    reg.gananciaDialiaPromedio.toStringAsFixed(
                                      0,
                                    ),
                                  ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              S
                                  .of(context)
                                  .historialCvLabel(
                                    reg.coeficienteVariacion.toStringAsFixed(1),
                                  ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: reg.tieneBuenaUniformidad
                                    ? AppColors.success
                                    : AppColors.warning,
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
  // MEN� DE FILTROS
  // ==========================================================================

  /// M�todo p�blico para mostrar el men� de filtros (accesible desde el dashboard)
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

                  // Header
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
                          // Per�odo
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

                          // M�todo de pesaje
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).historialFilterWeighingMethod,
                          ),
                          AppSpacing.gapMd,
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildMetodoOption(
                              theme: theme,
                              label: S.of(context).historialAllMethods,
                              isSelected: _metodoFiltro == null,
                              color: theme.colorScheme.primary,
                              onTap: () {
                                setModalState(() {});
                                setState(() => _metodoFiltro = null);
                              },
                            ),
                          ),
                          AppSpacing.gapSm,
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.4,
                            children: MetodoPesaje.values.map((metodo) {
                              return _buildMetodoOption(
                                theme: theme,
                                label: metodo.localizedDescripcion(
                                  S.of(context),
                                ),
                                subtitle: metodo.localizedDescripcionDetallada(
                                  S.of(context),
                                ),
                                isSelected: _metodoFiltro == metodo,
                                color: metodo.color,
                                onTap: () {
                                  setModalState(() {});
                                  setState(() => _metodoFiltro = metodo);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bot�n aplicar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.warning,
                          foregroundColor: theme.colorScheme.onPrimary,
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

  Widget _buildMetodoOption({
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: BorderRadius.circular(10),
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
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sinDatos
                    ? S.of(context).historialNoWeightRecords
                    : S.of(context).historialNoResults,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.gapSm,
              Text(
                sinDatos
                    ? S.of(context).historialRegisterFirstWeighingLote
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
              style: FilledButton.styleFrom(backgroundColor: AppColors.info),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // L�GICA
  // ==========================================================================

  List<RegistroPeso> _filtrarYOrdenar(List<RegistroPeso> registros) {
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

    // Filtro por m�todo
    if (_metodoFiltro != null) {
      lista = lista.where((r) => r.metodoPesaje == _metodoFiltro).toList();
    }

    lista.sort(
      (a, b) =>
          _ordenDesc ? b.fecha.compareTo(a.fecha) : a.fecha.compareTo(b.fecha),
    );

    return lista;
  }

  Future<void> _onRefresh() async {
    ref.invalidate(registrosPesoStreamProvider(widget.lote.id));
    ref.invalidate(registrosPesoStatsProvider(widget.lote.id));
  }

  void _navegarAGraficos() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GraficosPesoPage(lote: widget.lote)),
    );
  }

  void _showDetail(RegistroPeso reg) {
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
  final RegistroPeso registro;

  const _DetailSheet({required this.registro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final metodColor = registro.metodoPesaje.color;
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

              // Header con peso y fecha
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
                      color: AppColors.warning,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      '${(registro.pesoPromedio / 1000).toStringAsFixed(2)} kg',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.gapLg,

              // Informaci�n en formato tabla
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
                      l.detailWeighingMethod,
                      registro.metodoPesaje.localizedDescripcion(S.of(context)),
                      valueColor: metodColor,
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
                      l.detailBirdsWeighed,
                      '${registro.cantidadAvesPesadas}',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailAvgWeight,
                      '${(registro.pesoPromedio / 1000).toStringAsFixed(2)} kg (${registro.pesoPromedio.toStringAsFixed(0)} g)',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailMinWeight,
                      '${(registro.pesoMinimo / 1000).toStringAsFixed(2)} kg',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailMaxWeight,
                      '${(registro.pesoMaximo / 1000).toStringAsFixed(2)} kg',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailTotalWeight,
                      '${(registro.pesoTotal / 1000).toStringAsFixed(2)} kg',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailDailyGain,
                      '${registro.gananciaDialiaPromedio.toStringAsFixed(1)} g/d�a',
                    ),
                    _buildTableRow(
                      theme,
                      l.detailCvCoefficient,
                      '${registro.coeficienteVariacion.toStringAsFixed(1)}%',
                      valueColor: registro.tieneBuenaUniformidad
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    _buildTableRow(
                      theme,
                      l.detailUniformity,
                      registro.tieneBuenaUniformidad
                          ? l.detailUniformityGood
                          : l.detailUniformityRegular,
                      valueColor: registro.tieneBuenaUniformidad
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                    _buildTableRow(
                      theme,
                      l.detailRegisteredBy,
                      registro.nombreUsuario,
                      isLast: !(registro.observaciones?.isNotEmpty ?? false),
                    ),
                    if (registro.observaciones?.isNotEmpty ?? false)
                      _buildTableRow(
                        theme,
                        l.detailObservations,
                        registro.observaciones!,
                        isLast: true,
                      ),
                  ],
                ),
              ),

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
}
