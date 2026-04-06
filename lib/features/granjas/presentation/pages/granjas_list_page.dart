/// Página de lista de granjas del usuario
///
/// Muestra todas las granjas registradas con:
/// - Barra de búsqueda sticky
/// - Filtros por estado (tabs)
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para crear nueva granja
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';
import '../../domain/domain.dart';
import '../widgets/widgets.dart';

/// Página principal de gestión de granjas
class GranjasListPage extends ConsumerStatefulWidget {
  const GranjasListPage({super.key});

  @override
  ConsumerState<GranjasListPage> createState() => _GranjasListPageState();
}

class _GranjasListPageState extends ConsumerState<GranjasListPage> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String _searchQuery = '';
  EstadoGranja? _estadoFilter;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final granjasAsync = ref.watch(granjasStreamProvider);

    // Escuchar cambios en el estado de operaciones
    ref.listen<GranjaState>(granjaNotifierProvider, (previous, next) {
      if (next is GranjaSuccess) {
        _mostrarSnackBar(
          next.mensaje ?? l.commonOperationSuccess,
          esExito: true,
        );
      } else if (next is GranjaError) {
        _mostrarSnackBar(next.mensaje, esExito: false);
      } else if (next is GranjaDeleted) {
        _mostrarSnackBar(next.mensaje ?? l.farmDeletedSuccess, esExito: true);
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.farmFarms),
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
            granjasAsync.when(
              data: (granjas) {
                final filteredGranjas = _filterGranjas(granjas);

                if (granjas.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      icon: Icons.home_work_outlined,
                      title: l.farmStartFirstFarm,
                      description: l.farmStartFirstFarmDesc,
                      actionLabel: l.farmCreateFarm,
                      onAction: () => context.push(AppRoutes.granjaCrear),
                    ),
                  );
                }

                if (filteredGranjas.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      hasFilters: true,
                      filterTitle: l.farmNoFarmsFound,
                      filterDescription: l.farmNoFarmsFoundHint,
                      onClearFilters: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _estadoFilter = null;
                        });
                      },
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
                      final granja = filteredGranjas[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredGranjas.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? cardSpacing : 0,
                          bottom: isLast ? 80 : cardSpacing,
                        ),
                        child: GranjaListCard(
                          granja: granja,
                          onDetalles: () => _navegarADetalle(granja.id),
                          onEdit: () => _navegarAEditar(granja.id),
                          onCambiarEstado: () => _cambiarEstado(granja),
                          onEliminar: () => _confirmarEliminar(granja),
                          onVerCasas: () => _navegarACasas(granja.id),
                        ),
                      );
                    }, childCount: filteredGranjas.length),
                  ),
                );
              },
              loading: () => const SliverSkeletonList(itemCount: 4),
              error: (error, stack) => SliverFillRemaining(
                child: GranjaErrorWidget(
                  mensaje: l.farmErrorLoadingFarms(error.toString()),
                  onReintentar: () {
                    ref.invalidate(granjasStreamProvider);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'granjas_list_fab',
        onPressed: () => context.push(AppRoutes.granjaCrear),
        icon: const Icon(Icons.add),
        label: Text(
          l.farmNewFarm,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        tooltip: l.farmCreateNewFarmTooltip,
      ),
    );
  }

  /// Filtra las granjas según búsqueda y filtro de estado
  List<Granja> _filterGranjas(List<Granja> granjas) {
    return granjas.where((granja) {
      // Filtro por búsqueda
      final searchTerm = _searchQuery.trim();
      if (searchTerm.isNotEmpty) {
        final query = searchTerm.toLowerCase();
        final matchesNombre = granja.nombre.toLowerCase().contains(query);
        final matchesPropietario = granja.propietarioNombre
            .toLowerCase()
            .contains(query);
        final matchesDireccion = granja.direccion.direccionCompleta
            .toLowerCase()
            .contains(query);

        // También buscar por ciudad y departamento individual
        final matchesCiudad = (granja.direccion.ciudad ?? '')
            .toLowerCase()
            .contains(query);
        final matchesDepartamento = (granja.direccion.departamento ?? '')
            .toLowerCase()
            .contains(query);

        if (!matchesNombre &&
            !matchesPropietario &&
            !matchesDireccion &&
            !matchesCiudad &&
            !matchesDepartamento) {
          return false;
        }
      }

      // Filtro por estado
      if (_estadoFilter != null && granja.estado != _estadoFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(granjasStreamProvider);
  }

  void _navegarADetalle(String granjaId) {
    HapticFeedback.lightImpact();
    context.push(AppRoutes.granjaDetalleById(granjaId));
  }

  void _navegarAEditar(String granjaId) {
    HapticFeedback.lightImpact();
    context.push(AppRoutes.granjaEditarById(granjaId));
  }

  void _navegarACasas(String granjaId) {
    HapticFeedback.lightImpact();
    context.push(AppRoutes.galponesPorGranja(granjaId));
  }

  Future<void> _cambiarEstado(Granja granja) async {
    final nuevoEstado = await GranjaDialogs.showCambiarEstadoDialog(
      context,
      granja,
    );

    if (nuevoEstado == null || !mounted) return;

    try {
      final notifier = ref.read(granjaNotifierProvider.notifier);

      switch (nuevoEstado) {
        case EstadoGranja.activo:
          await notifier.activarGranja(granja.id);
          break;
        case EstadoGranja.inactivo:
          await notifier.suspenderGranja(granja.id);
          break;
        case EstadoGranja.mantenimiento:
          await notifier.ponerEnMantenimiento(granja.id);
          break;
      }
    } on Exception catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(
        S.of(context).farmErrorChangingStatus(e.toString()),
        esExito: false,
      );
    }
  }

  Future<void> _confirmarEliminar(Granja granja) async {
    final confirmed = await GranjaDialogs.showEliminarDialog(
      context,
      granja.nombre,
    );

    if (!confirmed || !mounted) return;

    await ref.read(granjaNotifierProvider.notifier).eliminarGranja(granja.id);

    if (!mounted) return;
    final granjaState = ref.read(granjaNotifierProvider);
    if (granjaState is GranjaError) {
      _mostrarSnackBar(
        S.of(context).farmErrorDeleting(granjaState.mensaje),
        esExito: false,
      );
    } else {
      _mostrarSnackBar(S.of(context).farmDeletedSuccess, esExito: true);
    }
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
  final EstadoGranja? estadoFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<EstadoGranja?> onFilterChanged;

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
        hintText: S.of(context).farmSearchHint,
        onSearchChanged: onSearchChanged,
        onClearSearch: onClearSearch,
        filterBuilder: (theme) => AppFilterTabRow(
          tabs: [
            AppFilterTab(
              label: S.of(context).farmFilterAll,
              isSelected: estadoFilter == null,
              onTap: () => onFilterChanged(null),
            ),
            AppFilterTab(
              label: S.of(context).farmFilterActive,
              isSelected: estadoFilter == EstadoGranja.activo,
              color: AppColors.success,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGranja.activo
                    ? null
                    : EstadoGranja.activo,
              ),
            ),
            AppFilterTab(
              label: S.of(context).farmFilterInactive,
              isSelected: estadoFilter == EstadoGranja.inactivo,
              color: AppColors.grey600,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGranja.inactivo
                    ? null
                    : EstadoGranja.inactivo,
              ),
            ),
            AppFilterTab(
              label: S.of(context).farmFilterMaintenance,
              isSelected: estadoFilter == EstadoGranja.mantenimiento,
              color: AppColors.warning,
              onTap: () => onFilterChanged(
                estadoFilter == EstadoGranja.mantenimiento
                    ? null
                    : EstadoGranja.mantenimiento,
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
