/// Página de lista de galpones de una granja.
///
/// Muestra todos los galpones registrados con:
/// - Barra de búsqueda sticky
/// - Filtros por estado (tabs)
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para crear nuevo galpón
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/permission_guard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../widgets/galpones_list/galpones_error_state.dart';
import '../../application/application.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../widgets/widgets.dart';

/// Página principal de gestión de galpones
class GalponesListPage extends ConsumerStatefulWidget {
  const GalponesListPage({super.key, required this.granjaId});

  /// ID de la granja propietaria.
  final String granjaId;

  @override
  ConsumerState<GalponesListPage> createState() => _GalponesListPageState();
}

class _GalponesListPageState extends ConsumerState<GalponesListPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  EstadoGalpon? _estadoFilter;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galponesAsync = ref.watch(galponesStreamProvider(widget.granjaId));

    // Escuchar cambios en el estado de operaciones
    ref.listen<GalponState>(galponNotifierProvider, (previous, next) {
      if (next is GalponSuccess) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).commonOperationSuccess,
          esExito: true,
        );
      } else if (next is GalponError) {
        _mostrarSnackBar(next.mensaje, esExito: false);
      } else if (next is GalponDeleted) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).shedDeletedMsg,
          esExito: true,
        );
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).shedSheds),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        edgeOffset: 110,
        child: CustomScrollView(
          slivers: [
            // Barra de búsqueda sticky
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                searchController: _searchController,
                searchFocusNode: _searchFocusNode,
                searchQuery: _searchQuery,
                estadoFilter: _estadoFilter,
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                onClearSearch: () {
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                  setState(() => _searchQuery = '');
                },
                onFilterChanged: (estado) {
                  setState(() => _estadoFilter = estado);
                },
              ),
            ),

            // Contenido principal
            galponesAsync.when(
              data: (galpones) {
                final filteredGalpones = _filterGalpones(galpones);
                final hasFilters =
                    _searchQuery.isNotEmpty || _estadoFilter != null;

                if (galpones.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      icon: Icons.warehouse_outlined,
                      title: S.of(context).shedStartFirstShed,
                      description: S.of(context).shedStartFirstShedDesc,
                      actionLabel: S.of(context).shedCreateShed,
                      onAction: _navigateToCreate,
                    ),
                  );
                }

                if (filteredGalpones.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      hasFilters: hasFilters,
                      filterTitle: S.of(context).shedNoShedsFound,
                      filterDescription: S.of(context).commonAdjustFilters,
                      onClearFilters: _clearFilters,
                    ),
                  );
                }

                final size = MediaQuery.sizeOf(context);
                final listPadding = size.width < 360 ? 12.0 : 16.0;
                final cardSpacing = size.width < 360 ? 12.0 : 16.0;

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: listPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final galpon = filteredGalpones[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredGalpones.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? cardSpacing : 0,
                          bottom: isLast ? 80 : cardSpacing,
                        ),
                        child: GalponListCard(
                          galpon: galpon,
                          onTap: () => _navigateToDetail(galpon.id),
                          onEditar: () => _navigateToEdit(galpon.id),
                          onCambiarEstado: () =>
                              _showToggleEstadoDialog(galpon),
                          onEliminar: () => _confirmDelete(galpon),
                          onVerLotes: () => _navigateToLotes(galpon.id),
                        ),
                      );
                    }, childCount: filteredGalpones.length),
                  ),
                );
              },
              loading: () => const SliverSkeletonList(itemCount: 4),
              error: (error, _) => SliverFillRemaining(
                child: GalponesErrorState(
                  mensaje: error.toString(),
                  onRetry: _onRefresh,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PermissionGuard(
        granjaId: widget.granjaId,
        permiso: TipoPermiso.crearGalpones,
        showAccessDenied: false,
        child: FloatingActionButton.extended(
          heroTag: 'galpones_list_fab',
          onPressed: _navigateToCreate,
          icon: const Icon(Icons.add),
          label: Text(
            S.of(context).shedNewShed,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          tooltip: S.of(context).shedCreateShedTooltip,
        ),
      ),
    );
  }

  /// Filtra los galpones según criterios activos.
  List<Galpon> _filterGalpones(List<Galpon> galpones) {
    var filtered = galpones;

    // Filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      filtered = filtered.where((galpon) {
        final nombre = galpon.nombre.toLowerCase();
        final codigo = galpon.codigo.toLowerCase();
        final descripcion = galpon.descripcion?.toLowerCase() ?? '';
        return nombre.contains(searchLower) ||
            codigo.contains(searchLower) ||
            descripcion.contains(searchLower);
      }).toList();
    }

    // Filtro por estado
    if (_estadoFilter != null) {
      filtered = filtered.where((g) => g.estado == _estadoFilter).toList();
    }

    return filtered;
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _estadoFilter = null;
    });
  }

  Future<void> _onRefresh() async {
    ref.invalidate(galponesStreamProvider(widget.granjaId));
  }

  /// Muestra diálogo para cambiar estado.
  Future<void> _showToggleEstadoDialog(Galpon galpon) async {
    final nuevoEstado = await GalponDialogs.showCambiarEstadoDialog(
      context,
      galpon,
    );

    if (nuevoEstado == null || !mounted) return;

    try {
      final notifier = ref.read(galponNotifierProvider.notifier);
      await notifier.cambiarEstado(galpon.id, nuevoEstado);
    } on Exception catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(
        S.of(context).shedErrorChangingStatus(e.toString()),
        esExito: false,
      );
    }
  }

  Future<void> _confirmDelete(Galpon galpon) async {
    final confirmed = await GalponDialogs.showEliminarDialog(
      context,
      galpon.nombre,
    );

    if (!confirmed || !mounted) return;

    await ref.read(galponNotifierProvider.notifier).eliminarGalpon(galpon.id);

    if (!mounted) return;
    final galponState = ref.read(galponNotifierProvider);
    if (galponState is GalponError) {
      _mostrarSnackBar(
        S.of(context).shedErrorDeleting(galponState.mensaje),
        esExito: false,
      );
    } else {
      _mostrarSnackBar(S.of(context).shedDeletedCorrectly, esExito: true);
      ref.invalidate(galponesStreamProvider(widget.granjaId));
    }
  }

  // ==================== NAVEGACIÓN ====================

  void _navigateToCreate() {
    HapticFeedback.mediumImpact();
    context.push(AppRoutes.galponCrearEnGranja(widget.granjaId)).then((_) {
      // Refrescar lista al regresar
      ref.invalidate(galponesStreamProvider(widget.granjaId));
    });
  }

  void _navigateToDetail(String galponId) {
    HapticFeedback.lightImpact();
    context.push(AppRoutes.galponDetalleById(widget.granjaId, galponId));
  }

  void _navigateToEdit(String galponId) {
    HapticFeedback.lightImpact();
    context.push(AppRoutes.galponEditarById(widget.granjaId, galponId)).then((
      _,
    ) {
      // Refrescar lista al regresar
      ref.invalidate(galponesStreamProvider(widget.granjaId));
    });
  }

  void _navigateToLotes(String galponId) {
    HapticFeedback.lightImpact();
    // Navegar a la página de lotes del galpón
    context.push(AppRoutes.lotesPorGalpon(widget.granjaId, galponId)).then((_) {
      // Invalidar providers para refrescar cuando se regrese
      ref.invalidate(galponesStreamProvider(widget.granjaId));
    });
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
}

// ==================== SEARCH BAR DELEGATE ====================

/// Delegate para hacer que la barra de búsqueda sea sticky
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  const _SearchBarDelegate({
    required this.searchController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.estadoFilter,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterChanged,
  });

  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final EstadoGalpon? estadoFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<EstadoGalpon?> onFilterChanged;

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
    return Container(
      height: maxExtent,
      alignment: Alignment.topCenter,
      child: AppSearchBar(
        controller: searchController,
        focusNode: searchFocusNode,
        searchQuery: searchQuery,
        hintText: S.of(context).shedSearchHint,
        onSearchChanged: onSearchChanged,
        onClearSearch: onClearSearch,
        filterBuilder: (theme) => AppFilterTabRow(
          tabs: [
            AppFilterTab(
              label: S.of(context).commonAll,
              isSelected: estadoFilter == null,
              onTap: () => onFilterChanged(null),
            ),
            AppFilterTab(
              label: S.of(context).commonActivePlural,
              isSelected: estadoFilter == EstadoGalpon.activo,
              color: AppColors.success,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGalpon.activo
                    ? null
                    : EstadoGalpon.activo,
              ),
            ),
            AppFilterTab(
              label: S.of(context).commonInactivePlural,
              isSelected: estadoFilter == EstadoGalpon.inactivo,
              color: AppColors.inactive,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGalpon.inactivo
                    ? null
                    : EstadoGalpon.inactivo,
              ),
            ),
            AppFilterTab(
              label: S.of(context).commonMaintenance,
              isSelected: estadoFilter == EstadoGalpon.mantenimiento,
              color: AppColors.warning,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGalpon.mantenimiento
                    ? null
                    : EstadoGalpon.mantenimiento,
              ),
            ),
            AppFilterTab(
              label: S.of(context).shedDisinfection,
              isSelected: estadoFilter == EstadoGalpon.desinfeccion,
              color: AppColors.info,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGalpon.desinfeccion
                    ? null
                    : EstadoGalpon.desinfeccion,
              ),
            ),
            AppFilterTab(
              label: S.of(context).shedQuarantine,
              isSelected: estadoFilter == EstadoGalpon.cuarentena,
              color: AppColors.error,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGalpon.cuarentena
                    ? null
                    : EstadoGalpon.cuarentena,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return searchQuery != oldDelegate.searchQuery ||
        estadoFilter != oldDelegate.estadoFilter;
  }
}


