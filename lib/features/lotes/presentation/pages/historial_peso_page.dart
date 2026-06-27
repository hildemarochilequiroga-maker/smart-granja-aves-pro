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
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../widgets/historial/historial_components.dart';
import '../../../../core/widgets/app_section_header.dart';
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
    return FormTextScale(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 8)),
            // Estad�sticas con tarjeta de gr�ficos
            SliverToBoxAdapter(
              child: statsAsync.when(
                data: (stats) => _buildEstadisticasSection(stats, theme),
                loading: () => const HistorialStatsLoading(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),

            // Indicador de filtros activos (debajo de estad�sticas)
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
                title: S.of(context).historialWeighingHistory,
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
      _metodoFiltro = null;
    });
  }

  // ==========================================================================
  // LOADING Y HEADERS
  // ==========================================================================

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

    return HistorialStatsGrid(
      onVerGraficos: _navegarAGraficos,
      cards: [
        HistorialStatCard(
          value: totalRegistros.toString(),
          subtitle: S.of(context).historialRecords,
          color: AppColors.info,
        ),
        HistorialStatCard(
          value: '${ultimoPeso.toStringAsFixed(2)} kg',
          subtitle: S.of(context).historialLastWeight,
          color: theme.colorScheme.primary,
        ),
        HistorialStatCard(
          value: '${gdp.toStringAsFixed(1)} g',
          subtitle: S.of(context).historialDailyGainStat,
          color: gdp >= 0 ? AppColors.success : AppColors.error,
          isHighlight: gdp < 0,
        ),
        HistorialStatCard(
          value: '${cv.toStringAsFixed(1)}%',
          subtitle: S.of(context).historialUniformityCV,
          color: cv <= 10 ? AppColors.success : AppColors.warning,
          isHighlight: cv > 10,
        ),
      ],
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

    return HistorialRegistroCardShell(
      accentColor: metodColor,
      borderWidth: 2,
      onTap: () {
        HapticFeedback.selectionClick();
        _showDetail(reg);
      },
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
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                TextSpan(
                  text: reg.metodoPesaje.localizedDescripcion(S.of(context)),
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
            S.of(context).historialBirdsWeighedLabel(reg.cantidadAvesPesadas),
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
                      reg.gananciaDialiaPromedio.toStringAsFixed(0),
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
    );
  }

  // ==========================================================================
  // MEN� DE FILTROS
  // ==========================================================================

  /// M�todo p�blico para mostrar el men� de filtros (accesible desde el dashboard)
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

          // Método de pesaje
          AppSectionHeader(
            title: S.of(context).historialFilterWeighingMethod,
            padding: EdgeInsets.zero,
          ),
          AppSpacing.gapMd,
          AspectRatio(
            aspectRatio: 4.8,
            child: HistorialFiltroOption(
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
          // Una columna full-width: los métodos tienen nombre + descripción
          // largos, así caben completos sin recortarse.
          Column(
            children: [
              for (final metodo in MetodoPesaje.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: HistorialFiltroOption(
                    label: metodo.localizedDescripcion(S.of(context)),
                    subtitle: metodo.localizedDescripcionDetallada(
                      S.of(context),
                    ),
                    isSelected: _metodoFiltro == metodo,
                    color: metodo.color,
                    onTap: () {
                      setModalState(() {});
                      setState(() => _metodoFiltro = metodo);
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
          ? S.of(context).historialNoWeightRecords
          : S.of(context).historialNoResults,
      subtitle: sinDatos
          ? S.of(context).historialRegisterFirstWeighingLote
          : S.of(context).historialNoRecordsWithFilters,
    );
  }

  Widget _buildErrorState(ThemeData theme, Object error) {
    return HistorialErrorState(error: error.toString(), onRetry: _onRefresh);
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
    await ref.read(registrosPesoStreamProvider(widget.lote.id).future);
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

    return FormTextScale(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                        registro.metodoPesaje.localizedDescripcion(
                          S.of(context),
                        ),
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
