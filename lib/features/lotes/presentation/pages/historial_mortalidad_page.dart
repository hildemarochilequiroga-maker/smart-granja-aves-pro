/// Página de historial de mortalidad de un lote.
///
/// Diseño integrado en el dashboard del lote con:
/// - Estadísticas horizontales
/// - Lista de registros con cards modernas
/// - Filtros accesibles desde el AppBar
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
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';
import '../../application/providers/registro_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_mortalidad.dart';
import 'graficos_mortalidad_page.dart';

// =============================================================================
// EXTENSIÓN PARA COLORES DE CAUSA DE MORTALIDAD
// =============================================================================

/// Extensión para obtener el color asociado a cada causa de mortalidad.
extension CausaMortalidadColor on CausaMortalidad {
  /// Retorna el color correspondiente a la causa de mortalidad.
  Color get color {
    switch (this) {
      case CausaMortalidad.enfermedad:
        return AppColors.error;
      case CausaMortalidad.accidente:
        return AppColors.warning;
      case CausaMortalidad.desnutricion:
        return AppColors.amber;
      case CausaMortalidad.estres:
        return AppColors.purple;
      case CausaMortalidad.metabolica:
        return AppColors.deepPurple;
      case CausaMortalidad.depredacion:
        return AppColors.brown;
      case CausaMortalidad.sacrificio:
        return AppColors.blueGrey;
      case CausaMortalidad.vejez:
        return AppColors.outline;
      case CausaMortalidad.desconocida:
        return AppColors.onSurfaceVariant;
    }
  }
}

/// Página principal de historial de mortalidad.
class HistorialMortalidadPage extends ConsumerStatefulWidget {
  final Lote lote;

  const HistorialMortalidadPage({required this.lote, super.key});

  @override
  ConsumerState<HistorialMortalidadPage> createState() =>
      HistorialMortalidadPageState();
}

/// State público para poder acceder desde el dashboard
class HistorialMortalidadPageState
    extends ConsumerState<HistorialMortalidadPage> {
  String _filtro = 'todos';
  CausaMortalidad? _causaFiltro;
  bool _ordenDesc = true;

  /// Indica si hay filtros activos
  bool get hayFiltrosActivos => _filtro != 'todos' || _causaFiltro != null;

  /// Obtiene la etiqueta del filtro actual
  String get etiquetaFiltroActual {
    final partes = <String>[];
    if (_filtro == '7d') partes.add(S.of(context).batchDays7);
    if (_filtro == '30d') partes.add(S.of(context).batchDays30);
    if (_causaFiltro != null) {
      partes.add(_causaFiltro!.localizedName(S.of(context)));
    }
    return partes.isEmpty ? S.of(context).batchNoFilters : partes.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final registrosAsync = ref.watch(
      registrosMortalidadStreamProvider(widget.lote.id),
    );
    final statsAsync = ref.watch(
      estadisticasMortalidadProvider(widget.lote.id),
    );

    // Solo el body, sin Scaffold ni AppBar (el dashboard ya lo proporciona)
    return FormTextScale(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            const SliverPadding(padding: EdgeInsets.only(top: 8)),
            // Estadísticas con botón de gráficos integrado
            SliverToBoxAdapter(
              child: statsAsync.when(
                data: (stats) => _buildEstadisticasSection(
                  stats,
                  theme,
                  widget.lote.cantidadInicial,
                ),
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
                title: S.of(context).historialNoEventsRecords,
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
                        key: ValueKey('mort_${lista[index].id}'),
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

  /// Limpia todos los filtros activos
  void _limpiarFiltros() {
    HapticFeedback.lightImpact();
    setState(() {
      _filtro = 'todos';
      _causaFiltro = null;
    });
  }

  // ==========================================================================
  // LOADING Y HEADERS
  // ==========================================================================

  // ==========================================================================
  // SECCIÓN DE ESTADÍSTICAS Y GRÁFICOS
  // ==========================================================================

  Widget _buildEstadisticasSection(
    Map<String, dynamic> stats,
    ThemeData theme,
    int cantidadInicialLote,
  ) {
    final totalEventos = stats['totalEventos'] as int? ?? 0;
    final totalAves = stats['totalMuertes'] as int? ?? 0;
    final promedio = stats['promedioPorEvento'] as double? ?? 0;

    // Calcular tasa usando cantidadInicial del lote (más preciso)
    final tasa = cantidadInicialLote > 0
        ? (totalAves / cantidadInicialLote) * 100
        : 0.0;

    return HistorialStatsGrid(
      onVerGraficos: _navegarAGraficos,
      cards: [
        HistorialStatCard(
          value: totalEventos.toString(),
          subtitle: S.of(context).historialRecords,
          color: AppColors.info,
        ),
        HistorialStatCard(
          value: totalAves.toString(),
          subtitle: S.of(context).historialDeadBirds,
          color: AppColors.warning,
        ),
        HistorialStatCard(
          value: promedio.toStringAsFixed(1),
          subtitle: S.of(context).historialPerEvent,
          color: AppColors.warning,
        ),
        HistorialStatCard(
          value: '${tasa.toStringAsFixed(1)}%',
          subtitle: S.of(context).historialAccumulatedRate,
          color: tasa > 5 ? AppColors.error : AppColors.success,
          isHighlight: tasa > 5,
        ),
      ],
    );
  }

  // ==========================================================================
  // TARJETAS DE REGISTRO
  // ==========================================================================

  /// Construye la card con animación de entrada
  Widget _buildAnimatedRegistroCard(
    RegistroMortalidad reg,
    ThemeData theme,
    int index,
  ) {
    return _buildRegistroCard(
      reg,
      theme,
    ).staggeredEntrance(index: index, key: ValueKey(reg.id));
  }

  Widget _buildRegistroCard(RegistroMortalidad reg, ThemeData theme) {
    final causaColor = reg.causa.color;
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(reg.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(reg.fecha);

    return HistorialRegistroCardShell(
      accentColor: causaColor,
      borderWidth: 2,
      onTap: () {
        HapticFeedback.selectionClick();
        _showDetail(reg);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primera fila: Fecha y badge de aves
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
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: AppRadius.allSm,
                ),
                child: Text(
                  S.of(context).historialBirdsUnit(reg.cantidad),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Causa
          RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: S.of(context).historialCauseLabel,
                  style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                ),
                TextSpan(
                  text: reg.causa.localizedName(S.of(context)),
                  style: TextStyle(
                    color: causaColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Descripción (si existe)
          if (reg.descripcion.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              S.of(context).historialDescriptionLabel(reg.descripcion),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Usuario y Edad
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).historialUserLabel(reg.nombreUsuario),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                S.of(context).historialAgeDaysLabel(reg.edadAvesDias),
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
          // Sección: Período
          HistorialPeriodoFilterSection(
            selected: _filtro,
            onSelect: (value) {
              setModalState(() {});
              setState(() => _filtro = value);
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // Sección: Causa
          AppSectionHeader(
            title: S.of(context).historialFilterMortalityCause,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.md),

          // Opción "Todas las causas" - usa AspectRatio para igualar con el grid
          AspectRatio(
            aspectRatio:
                4.8, // El doble del grid (2.4 * 2) porque ocupa todo el ancho
            child: HistorialFiltroOption(
              label: S.of(context).historialAllCauses,
              isSelected: _causaFiltro == null,
              color: theme.colorScheme.primary,
              onTap: () {
                setModalState(() {});
                setState(() => _causaFiltro = null);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Causas a ancho completo (texto completo sin recortes)
          Column(
            children: [
              for (final causa in CausaMortalidad.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: HistorialFiltroOption(
                    label: causa.localizedName(S.of(context)),
                    subtitle: causa.localizedDescripcion(S.of(context)),
                    isSelected: _causaFiltro == causa,
                    color: causa.color,
                    onTap: () {
                      setModalState(() {});
                      setState(() => _causaFiltro = causa);
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
          ? S.of(context).historialNoMortalityRecords
          : S.of(context).historialNoResults,
      subtitle: sinDatos
          ? S.of(context).historialNoMortalityExcellent
          : S.of(context).historialNoRecordsWithFilters,
    );
  }

  Widget _buildErrorState(ThemeData theme, Object error) {
    return HistorialErrorState(
      error: error.toString(),
      onRetry: () => _onRefresh(),
    );
  }

  // ==========================================================================
  // LÓGICA
  // ==========================================================================

  List<RegistroMortalidad> _filtrarYOrdenar(
    List<RegistroMortalidad> registros,
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

    // Filtro por causa
    if (_causaFiltro != null) {
      lista = lista.where((r) => r.causa == _causaFiltro).toList();
    }

    lista.sort(
      (a, b) =>
          _ordenDesc ? b.fecha.compareTo(a.fecha) : a.fecha.compareTo(b.fecha),
    );

    return lista;
  }

  Future<void> _onRefresh() async {
    ref.invalidate(registrosMortalidadStreamProvider(widget.lote.id));
    ref.invalidate(estadisticasMortalidadProvider(widget.lote.id));
    await ref.read(registrosMortalidadStreamProvider(widget.lote.id).future);
  }

  void _navegarAGraficos() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GraficosMortalidadPage(lote: widget.lote),
      ),
    );
  }

  void _showDetail(RegistroMortalidad reg) {
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
  final RegistroMortalidad registro;

  const _DetailSheet({required this.registro});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final causaColor = registro.causa.color;
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(registro.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(registro.fecha);

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
                const SizedBox(height: AppSpacing.lg),

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
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: AppRadius.allSm,
                      ),
                      child: Text(
                        l.historialBirdsUnit(registro.cantidad),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

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
                        l.detailCause,
                        registro.causa.localizedName(S.of(context)),
                        valueColor: causaColor,
                      ),
                      _buildTableRow(
                        theme,
                        l.detailBirdAge,
                        l.detailDaysWeek(
                          registro.edadAvesDias.toString(),
                          registro.semanasVida.toString(),
                        ),
                      ),
                      _buildTableRow(
                        theme,
                        l.detailBirdsBeforeEvent,
                        '${registro.cantidadAntesEvento}',
                      ),
                      _buildTableRow(
                        theme,
                        l.detailImpact,
                        '${registro.impactoPorcentual.toStringAsFixed(2)}%',
                        valueColor: registro.impactoPorcentual > 2
                            ? AppColors.error
                            : AppColors.warning,
                      ),
                      _buildTableRow(
                        theme,
                        l.detailRegisteredBy,
                        registro.nombreUsuario,
                        isLast: !registro.descripcion.isNotEmpty,
                      ),
                      if (registro.descripcion.isNotEmpty)
                        _buildTableRow(
                          theme,
                          l.detailDescription,
                          registro.descripcion,
                          isLast: true,
                        ),
                    ],
                  ),
                ),

                // Fotos de evidencia
                if (registro.tieneEvidencia) ...[
                  const SizedBox(height: AppSpacing.base),
                  Text(
                    l.detailPhotoEvidence,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: registro.fotosUrls.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: AppSpacing.sm),
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

                const SizedBox(height: AppSpacing.sm),
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
