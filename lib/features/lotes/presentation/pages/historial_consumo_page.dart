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
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../widgets/historial/historial_components.dart';
import '../../../../core/widgets/app_section_header.dart';
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
    return FormTextScale(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: AppSpacing.sm)),
            // Estadísticas con tarjeta de gráficos
            SliverToBoxAdapter(
              child: statsAsync.when(
                data: (stats) => _buildEstadisticasSection(stats, theme),
                loading: () => const HistorialStatsLoading(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Indicador de filtros activos (debajo de estadísticas)
            if (hayFiltrosActivos)
              SliverToBoxAdapter(
                child: HistorialFiltrosActivosChip(
                  label: etiquetaFiltroActual,
                  onClear: _limpiarFiltros,
                ),
              ),

            // Divider visual
            const SliverToBoxAdapter(child: AppSpacing.gapSm),
            SliverToBoxAdapter(
              child: HistorialRegistrosHeader(
                title: S.of(context).historialConsumptionHistory,
                ordenDesc: _ordenDesc,
                onToggleOrden: () {
                  HapticFeedback.selectionClick();
                  setState(() => _ordenDesc = !_ordenDesc);
                },
              ),
            ),

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
      ),
    );
  }

  // ==========================================================================
  // CHIP DE FILTROS ACTIVOS
  // ==========================================================================

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

    return HistorialStatsGrid(
      onVerGraficos: _navegarAGraficos,
      cards: [
        HistorialStatCard(
          value: '${totalKg.toStringAsFixed(1)} kg',
          subtitle: S.of(context).historialTotalConsumed,
          color: theme.colorScheme.tertiary,
        ),
        HistorialStatCard(
          value: '${promedioDiario.toStringAsFixed(2)} kg',
          subtitle: S.of(context).historialAvgDaily,
          color: theme.colorScheme.primary,
        ),
        HistorialStatCard(
          value: totalRegistros.toString(),
          subtitle: S.of(context).historialRecords,
          color: theme.colorScheme.secondary,
        ),
        HistorialStatCard(
          value: '${(consumoPorAve * 1000).toStringAsFixed(0)} g',
          subtitle: S.of(context).historialAccumulatedPerBird,
          color: AppColors.success,
        ),
      ],
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

    return HistorialRegistroCardShell(
      accentColor: tipoColor,
      onTap: () {
        HapticFeedback.selectionClick();
        _showDetail(reg);
      },
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
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                TextSpan(
                  text: reg.tipoAlimento.localizedDisplayName(S.of(context)),
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
    );
  }

  // ==========================================================================
  // MENÚ DE FILTROS
  // ==========================================================================

  /// Método público para mostrar el menú de filtros (accesible desde el dashboard)
  void showFilterMenu() {
    HistorialFiltrosBottomSheet.show(
      context: context,
      hasActiveFilters: () => hayFiltrosActivos,
      sectionsBuilder: (setModalState) {
        final theme = Theme.of(context);
        return [
          // Período
          HistorialPeriodoFilterSection(
            selected: _filtro,
            onSelect: (value) {
              setModalState(() {});
              setState(() => _filtro = value);
            },
          ),

          AppSpacing.gapXl,

          // Tipo de alimento
          AppSectionHeader(
            title: S.of(context).historialFilterFoodType,
            padding: EdgeInsets.zero,
          ),
          AppSpacing.gapMd,
          AspectRatio(
            aspectRatio: 4.8,
            child: HistorialFiltroOption(
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
          // Tipos a ancho completo (texto completo sin recortes)
          Column(
            children: [
              for (final tipo in TipoAlimento.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: HistorialFiltroOption(
                    label: tipo.localizedDisplayName(S.of(context)),
                    subtitle: tipo.localizedRangoEdadDescripcion(S.of(context)),
                    isSelected: _tipoFiltro == tipo,
                    color: tipo.color,
                    onTap: () {
                      setModalState(() {});
                      setState(() => _tipoFiltro = tipo);
                    },
                  ),
                ),
            ],
          ),
        ];
      },
    );
  }

  // ==========================================================================
  // ESTADOS
  // ==========================================================================

  Widget _buildEmptyState(ThemeData theme, bool sinDatos) {
    return HistorialEmptyState(
      title: sinDatos
          ? S.of(context).historialNoConsumptionRecords
          : S.of(context).historialNoResults,
      subtitle: sinDatos
          ? S.of(context).historialRegisterFirstConsumption
          : S.of(context).historialNoRecordsWithFilters,
    );
  }

  Widget _buildErrorState(ThemeData theme, Object error) {
    return HistorialErrorState(error: error.toString(), onRetry: _onRefresh);
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
    await ref.read(registrosConsumoStreamProvider(widget.lote.id).future);
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

    return FormTextScale(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
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
                        registro.tipoAlimento.localizedDisplayName(
                          S.of(context),
                        ),
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
