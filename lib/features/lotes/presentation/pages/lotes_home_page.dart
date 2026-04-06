/// Pagina principal de lotes en el shell de navegacion.
///
/// Muestra todos los lotes del usuario con:
/// - Barra de busqueda sticky (igual que granjas_list)
/// - Filtros por estado (tabs con underline)
/// - Cards modernas agrupadas por granja
/// - Pull-to-refresh
/// - FAB para crear nuevo lote
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../widgets/lotes_empty_state.dart';
import '../../../granjas/domain/entities/granja.dart';
import '../../application/providers/providers.dart';
import '../../application/state/lote_state.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/enums/tipo_ave.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_search_bar.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Pagina principal de lotes para el bottom navigation.
class LotesHomePage extends ConsumerStatefulWidget {
  const LotesHomePage({super.key});

  @override
  ConsumerState<LotesHomePage> createState() => _LotesHomePageState();
}

class _LotesHomePageState extends ConsumerState<LotesHomePage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  EstadoLote? _estadoFilter;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final granjasAsync = ref.watch(granjasStreamProvider);

    // Escuchar cambios en el estado de operaciones de lotes
    ref.listen<LoteState>(loteNotifierProvider, (previous, next) {
      if (next is LoteSuccess) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).batchOperationSuccess,
          esExito: true,
        );
      } else if (next is LoteError) {
        _mostrarSnackBar(next.mensaje, esExito: false);
      } else if (next is LoteDeleted) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).batchDeletedSuccess,
          esExito: true,
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).batchTitle),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        edgeOffset: 110,
        child: CustomScrollView(
          slivers: [
            // Barra de busqueda sticky - Usando SliverPersistentHeader
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                searchQuery: _searchQuery,
                estadoFilter: _estadoFilter,
                child: AppSearchBar(
                  controller: _searchController,
                  searchQuery: _searchQuery,
                  hintText: S.of(context).batchSearchHint,
                  onSearchChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  onClearSearch: () {
                    _searchController.clear();
                    _searchFocusNode.unfocus();
                    setState(() => _searchQuery = '');
                  },
                  filterBuilder: (theme) => AppFilterTabRow(
                    tabs: [
                      AppFilterTab(
                        label: S.of(context).batchAll,
                        isSelected: _estadoFilter == null,
                        onTap: () => setState(() => _estadoFilter = null),
                      ),
                      AppFilterTab(
                        label: S.of(context).batchActive,
                        isSelected: _estadoFilter == EstadoLote.activo,
                        color: AppColors.success,
                        onTap: () => setState(() {
                          _estadoFilter = _estadoFilter == EstadoLote.activo
                              ? null
                              : EstadoLote.activo;
                        }),
                      ),
                      AppFilterTab(
                        label: S.of(context).batchClosed,
                        isSelected: _estadoFilter == EstadoLote.cerrado,
                        color: AppColors.grey600,
                        onTap: () => setState(() {
                          _estadoFilter = _estadoFilter == EstadoLote.cerrado
                              ? null
                              : EstadoLote.cerrado;
                        }),
                      ),
                      AppFilterTab(
                        label: S.of(context).batchInQuarantine,
                        isSelected: _estadoFilter == EstadoLote.cuarentena,
                        color: AppColors.warning,
                        onTap: () => setState(() {
                          _estadoFilter = _estadoFilter == EstadoLote.cuarentena
                              ? null
                              : EstadoLote.cuarentena;
                        }),
                      ),
                      AppFilterTab(
                        label: S.of(context).batchSold,
                        isSelected: _estadoFilter == EstadoLote.vendido,
                        color: AppColors.info,
                        onTap: () => setState(() {
                          _estadoFilter = _estadoFilter == EstadoLote.vendido
                              ? null
                              : EstadoLote.vendido;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal
            granjasAsync.when(
              data: (granjas) {
                if (granjas.isEmpty) {
                  return SliverFillRemaining(
                    child: _EmptyState(
                      icon: Icons.agriculture_outlined,
                      title: S.of(context).batchNoFarms,
                      subtitle: S.of(context).batchCreateFarmFirst,
                      actionLabel: S.of(context).batchCreateFarm,
                      onAction: () => context.push(AppRoutes.granjaCrear),
                    ),
                  );
                }

                // Usamos un widget que agrupa todo para detectar si hay lotes
                return _LotesContent(
                  granjas: granjas,
                  searchQuery: _searchQuery,
                  estadoFilter: _estadoFilter,
                  onClearFilters: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _estadoFilter = null;
                    });
                  },
                  onCrearLote: () => _navegarACrearLote(context, granjas),
                );
              },
              loading: () => const SliverSkeletonList(itemCount: 4),
              error: (error, _) => SliverFillRemaining(
                child: _ErrorWidget(
                  mensaje: S.of(context).batchErrorLoadingBatches,
                  onReintentar: () => ref.invalidate(granjasStreamProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Invalidar granjas y todos los lotes
    ref.invalidate(granjasStreamProvider);
    // Los lotes se refrescarán automáticamente al refrescar las granjas
  }

  void _mostrarSnackBar(String mensaje, {required bool esExito}) {
    if (esExito) {
      HapticFeedback.mediumImpact();
      AppSnackBar.success(context, message: mensaje);
    } else {
      HapticFeedback.heavyImpact();
      AppSnackBar.error(context, message: mensaje);
    }
  }

  void _navegarACrearLote(BuildContext context, List<Granja> granjas) {
    HapticFeedback.lightImpact();
    // Si solo hay una granja, ir a sus galpones para seleccionar donde crear
    if (granjas.length == 1) {
      context.push(AppRoutes.granjaDetalleById(granjas.first.id));
    } else {
      // Mostrar selector de granja
      _showGranjaSelector(context, granjas);
    }
  }

  void _showGranjaSelector(BuildContext context, List<Granja> granjas) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.25,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.sm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  S.of(context).batchSelectFarm,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: granjas.length,
                  padding: const EdgeInsets.only(bottom: 16),
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: 72,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  itemBuilder: (context, index) {
                    final granja = granjas[index];
                    return Semantics(
                      button: true,
                      label: S.of(context).batchSelectFarmName(granja.nombre),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 4,
                        ),
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: AppRadius.allMd,
                          ),
                          child: Icon(
                            Icons.agriculture_rounded,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          granja.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          granja.direccion.direccionCorta,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                        ),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          Navigator.pop(context);
                          context.push(AppRoutes.granjaDetalleById(granja.id));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget que maneja el contenido de lotes y detecta si hay lotes para mostrar
class _LotesContent extends ConsumerWidget {
  const _LotesContent({
    required this.granjas,
    required this.searchQuery,
    required this.estadoFilter,
    required this.onClearFilters,
    required this.onCrearLote,
  });

  final List<Granja> granjas;
  final String searchQuery;
  final EstadoLote? estadoFilter;
  final VoidCallback onClearFilters;
  final VoidCallback onCrearLote;

  bool get _hasFilters => searchQuery.isNotEmpty || estadoFilter != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Recopilar todos los lotes de todas las granjas
    final allLotesResults = <(Granja, List<Lote>)>[];
    var isLoading = false;
    var hasError = false;
    var errorCount = 0;
    var totalLotesCount = 0;

    for (final granja in granjas) {
      final lotesAsync = ref.watch(lotesStreamProvider(granja.id));
      lotesAsync.when(
        data: (lotes) {
          totalLotesCount += lotes.length;
          final filteredLotes = _filterLotes(lotes);
          if (filteredLotes.isNotEmpty) {
            allLotesResults.add((granja, filteredLotes));
          }
        },
        loading: () => isLoading = true,
        error: (_, __) {
          hasError = true;
          errorCount++;
        },
      );
    }

    // Si esta cargando, mostrar skeleton
    if (isLoading && allLotesResults.isEmpty) {
      return const SliverSkeletonList(itemCount: 4);
    }

    // Si todos los providers tienen error, mostrar error
    if (hasError && errorCount == granjas.length) {
      return SliverFillRemaining(
        child: LotesErrorState(
          mensaje: S.of(context).batchErrorLoadingBatches,
          onRetry: () {
            // Invalidar todos los providers de lotes
            for (final granja in granjas) {
              ref.invalidate(lotesStreamProvider(granja.id));
            }
          },
        ),
      );
    }

    // Si no hay resultados despues de aplicar filtros
    if (allLotesResults.isEmpty) {
      // Verificar si realmente no hay lotes o si es por filtros
      final noHayLotes = totalLotesCount == 0 && !_hasFilters;
      return SliverFillRemaining(
        child: AppEmptyState(
          icon: Icons.egg_outlined,
          title: noHayLotes ? S.of(context).batchNoRegistered : null,
          description: noHayLotes ? S.of(context).batchRegisterFirst : null,
          actionLabel: noHayLotes ? S.of(context).batchCreateBatch : null,
          actionIcon: noHayLotes ? Icons.add_rounded : null,
          onAction: noHayLotes ? onCrearLote : null,
          hasFilters: _hasFilters || (!noHayLotes && totalLotesCount > 0),
          filterTitle: S.of(context).batchNotFoundFilter,
          filterDescription: S.of(context).batchAdjustFilters,
          onClearFilters: _hasFilters ? onClearFilters : null,
        ),
      );
    }

    // Mostrar las secciones de lotes agrupadas por granja
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final (granja, lotes) = allLotesResults[index];
          return _GranjaLotesSectionContent(
            key: ValueKey('granja_section_${granja.id}'),
            granja: granja,
            lotes: lotes,
            isFirst: index == 0,
            isLast: index == allLotesResults.length - 1,
          );
        }, childCount: allLotesResults.length),
      ),
    );
  }

  List<Lote> _filterLotes(List<Lote> lotes) {
    return lotes.where((lote) {
      // Filtro por estado
      if (estadoFilter != null && lote.estado != estadoFilter) {
        return false;
      }

      // Filtro por busqueda
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return lote.codigo.toLowerCase().contains(query) ||
            (lote.nombre?.toLowerCase().contains(query) ?? false) ||
            lote.tipoAve.displayName.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }
}

/// Contenido de una seccion de granja con lotes ya filtrados
class _GranjaLotesSectionContent extends StatelessWidget {
  const _GranjaLotesSectionContent({
    super.key,
    required this.granja,
    required this.lotes,
    required this.isFirst,
    required this.isLast,
  });

  final Granja granja;
  final List<Lote> lotes;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de granja
        Semantics(
          header: true,
          label: S
              .of(context)
              .batchFarmWithBatchesLabel(granja.nombre, lotes.length),
          child: Padding(
            padding: EdgeInsets.only(top: isFirst ? 16 : 24, bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        granja.nombre,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        granja.direccion.direccionCorta,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    '${lotes.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lista de lotes
        ...lotes.asMap().entries.map((entry) {
          final index = entry.key;
          final lote = entry.value;
          return Padding(
            key: ValueKey('lote_card_${lote.id}'),
            padding: EdgeInsets.only(
              bottom: index == lotes.length - 1 ? (isLast ? 100 : 0) : 12,
            ),
            child: _LoteCard(
              lote: lote,
              granjaId: granja.id,
              onTap: () {
                HapticFeedback.lightImpact();
                context.push(
                  AppRoutes.loteDashboardById(granja.id, lote.id),
                  extra: lote,
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

/// Card de lote moderna - igual que GranjaListCard
class _LoteCard extends StatelessWidget {
  const _LoteCard({
    required this.lote,
    required this.granjaId,
    required this.onTap,
  });

  final Lote lote;
  final String granjaId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(context);
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 360;

    return Semantics(
      button: true,
      label:
          S.of(context).semanticsLoteSummary(lote.codigo, lote.tipoAve.localizedDisplayName(S.of(context)), '${lote.avesActuales}', statusInfo.text),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadius.allMd,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppRadius.allMd,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.allMd,
            splashColor: statusInfo.color.withValues(alpha: 0.1),
            highlightColor: statusInfo.color.withValues(alpha: 0.05),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header: Codigo + Estado
                  _buildHeader(theme, statusInfo, isSmallScreen),
                  const SizedBox(height: AppSpacing.base),

                  // Seccion de imagen con estadisticas
                  _buildImageSection(context, theme, statusInfo, size.width),
                  const SizedBox(height: AppSpacing.base),

                  // Boton de accion
                  _buildActionButton(context, theme),
                ],
              ),
            ),
          ),
        ),
      ).cardEntrance(),
    );
  }

  Widget _buildHeader(
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Row(
      children: [
        // Codigo del lote
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lote.codigo,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (lote.nombre != null && lote.nombre!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  lote.nombre!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        // Badge de estado
        _buildStatusBadge(theme, statusInfo, isSmallScreen),
      ],
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    ThemeData theme,
    _StatusInfo statusInfo,
    double screenWidth,
  ) {
    // Altura responsive: 40% del ancho de la pantalla, min 160, max 220 (igual que granjas)
    final imageHeight = (screenWidth * 0.4).clamp(160.0, 220.0);

    return Column(
      children: [
        // Imagen
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: statusInfo.color.withValues(alpha: 0.1),
            borderRadius: AppRadius.allSm,
          ),
          child: ClipRRect(
            borderRadius: AppRadius.allSm,
            child: Builder(
              builder: (context) {
                final dpr = MediaQuery.devicePixelRatioOf(context);
                return Image.asset(
                  _getImageByTipoAve(),
                  fit: BoxFit.contain,
                  cacheWidth: (imageHeight * dpr).round(),
                  errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Estadisticas debajo de la imagen - sin iconos, texto negro
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              lote.tipoAve.localizedNombreCorto(S.of(context)),
              S.of(context).batchType,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${lote.avesActuales}',
              S.of(context).batchBirds,
            ),
            Container(
              width: 1,
              height: 32,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            _buildStatItem(
              theme,
              '${lote.edadActualDias}d',
              S.of(context).batchAge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    ThemeData theme,
    _StatusInfo statusInfo,
    bool isSmallScreen,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 10 : 12,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: statusInfo.color,
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        statusInfo.text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 10 : 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return ExcludeSemantics(
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: FilledButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            elevation: 0,
          ),
          child: Text(
            S.of(context).batchViewRecords,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Imagen segun tipo de ave - CORREGIDO
  String _getImageByTipoAve() {
    return switch (lote.tipoAve) {
      TipoAve.polloEngorde => 'assets/images/illustrations/3.png',
      TipoAve.gallinaPonedora => 'assets/images/illustrations/4.png',
      TipoAve.otro => 'assets/images/illustrations/6.png',
      _ => 'assets/images/illustrations/3.png', // Default para otros tipos
    };
  }

  _StatusInfo _getStatusInfo(BuildContext context) {
    return switch (lote.estado) {
      EstadoLote.activo => _StatusInfo(
        color: AppColors.success,
        icon: Icons.check_circle,
        text: S.of(context).batchActive,
      ),
      EstadoLote.cerrado => _StatusInfo(
        color: AppColors.grey600,
        icon: Icons.cancel,
        text: S.of(context).batchClosed,
      ),
      EstadoLote.cuarentena => _StatusInfo(
        color: AppColors.warning,
        icon: Icons.warning,
        text: S.of(context).batchInQuarantine,
      ),
      EstadoLote.vendido => _StatusInfo(
        color: AppColors.info,
        icon: Icons.sell,
        text: S.of(context).batchSold,
      ),
      EstadoLote.enTransferencia => _StatusInfo(
        color: AppColors.purple,
        icon: Icons.swap_horiz,
        text: S.of(context).batchTransfer,
      ),
      EstadoLote.suspendido => _StatusInfo(
        color: AppColors.error,
        icon: Icons.pause_circle,
        text: S.of(context).batchSuspended,
      ),
    };
  }
}

class _StatusInfo {
  final Color color;
  final IconData icon;
  final String text;

  _StatusInfo({required this.color, required this.icon, required this.text});
}

/// Estado vacio
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de error
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.mensaje, required this.onReintentar});

  final String mensaje;
  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  mensaje,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.base),
                FilledButton.icon(
                  onPressed: onReintentar,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(S.of(context).batchRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Delegate para la barra de busqueda sticky
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  const _SearchBarDelegate({
    required this.child,
    this.searchQuery = '',
    this.estadoFilter,
  });

  final Widget child;
  final String searchQuery;
  final EstadoLote? estadoFilter;

  @override
  double get minExtent => 110;

  @override
  double get maxExtent => 110;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    return searchQuery != oldDelegate.searchQuery ||
        estadoFilter != oldDelegate.estadoFilter ||
        child != oldDelegate.child;
  }
}
