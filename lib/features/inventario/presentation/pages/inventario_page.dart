/// Página principal de inventario.
library;

import 'package:flutter/material.dart';
import '../../../../core/widgets/permission_guard.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../widgets/widgets.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página principal del inventario.
class InventarioPage extends ConsumerStatefulWidget {
  const InventarioPage({super.key, this.granjaId});

  final String? granjaId;

  @override
  ConsumerState<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends ConsumerState<InventarioPage>
    with SingleTickerProviderStateMixin {
  S get l => S.of(context);

  late TabController _tabController;
  TipoItem? _filtroTipo;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Obtiene el ID de la granja a usar (parámetro o seleccionada)
  String? get _granjaId {
    if (widget.granjaId != null) return widget.granjaId;
    return ref.watch(granjaSeleccionadaProvider)?.id;
  }

  /// Indica si hay filtros activos
  bool get _hayFiltrosActivos => _filtroTipo != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final granjaId = _granjaId;

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.inventarioTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              _hayFiltrosActivos ? Icons.filter_alt : Icons.filter_alt_outlined,
              color: _hayFiltrosActivos ? AppColors.primary : null,
            ),
            onPressed: _mostrarFiltros,
            tooltip: l.invFilterByType,
          ),
        ],
      ),
      body: granjaId == null
          ? _buildEmptyGranjaState(theme)
          : Column(
              children: [
                // Barra de búsqueda
                _buildSearchBar(theme),
                // Chip de filtros activos
                if (_hayFiltrosActivos) _buildFiltrosActivosChip(theme),
                // Tabs
                _buildTabBar(theme),
                // Contenido
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildItemsTab(theme, granjaId),
                      _buildMovimientosTab(theme, granjaId),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: granjaId != null
          ? PermissionGuard(
              granjaId: granjaId,
              permiso: TipoPermiso.gestionarInventario,
              showAccessDenied: false,
              child: FloatingActionButton.extended(
                heroTag: 'inventario_fab',
                tooltip: l.invAddNewItemTooltip,
                onPressed: () => context.push(
                  AppRoutes.inventarioCrearItemConGranja(granjaId),
                ),
                icon: const Icon(Icons.add),
                label: Text(l.invNewItem),
              ),
            )
          : null,
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return AppSearchBar(
      controller: _searchController,
      searchQuery: _searchQuery,
      focusNode: _searchFocusNode,
      hintText: l.invSearchByNameOrCode,
      onSearchChanged: (value) => setState(() => _searchQuery = value),
      onClearSearch: () {
        _searchController.clear();
        _searchFocusNode.unfocus();
        setState(() => _searchQuery = '');
      },
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor: theme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge,
        tabs: [
          Tab(text: l.invTabItems),
          Tab(text: l.invTabMovements),
        ],
      ),
    );
  }

  Widget _buildEmptyGranjaState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.home_work_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant,
          ),
          AppSpacing.gapBase,
          Text(l.invNoFarmSelected, style: theme.textTheme.titleLarge),
          AppSpacing.gapSm,
          Text(
            l.invSelectFarmFromHome,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTab(ThemeData theme, String granjaId) {
    final itemsAsync = ref.watch(inventarioItemsStreamProvider(granjaId));

    return Column(
      children: [
        // Lista de items
        Expanded(
          child: itemsAsync.when(
            data: (items) {
              var filteredItems = items;

              // Filtrar por tipo
              if (_filtroTipo != null) {
                filteredItems = filteredItems
                    .where((i) => i.tipo == _filtroTipo)
                    .toList();
              }

              // Filtrar por búsqueda
              if (_searchQuery.isNotEmpty) {
                final query = _searchQuery.toLowerCase();
                filteredItems = filteredItems
                    .where(
                      (i) =>
                          i.nombre.toLowerCase().contains(query) ||
                          (i.codigo?.toLowerCase().contains(query) ?? false),
                    )
                    .toList();
              }

              if (filteredItems.isEmpty) {
                return _buildEmptyItemsState(theme, granjaId);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(inventarioItemsStreamProvider(granjaId));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: ItemInventarioCard(
                        item: item,
                        onTap: () => context.push(
                          AppRoutes.inventarioItemDetalleById(item.id),
                        ),
                        onEditar: () => context.push(
                          AppRoutes.inventarioEditarItemById(item.id),
                        ),
                        onEliminar: () => _confirmarEliminarItem(item),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  AppSpacing.gapBase,
                  Text(l.commonErrorWithDetail(error.toString())),
                  AppSpacing.gapBase,
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(inventarioItemsStreamProvider(granjaId)),
                    child: Text(l.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovimientosTab(ThemeData theme, String granjaId) {
    final movimientosAsync = ref.watch(
      inventarioMovimientosGranjaProvider((
        granjaId: granjaId,
        desde: null,
        hasta: null,
        limite: 50,
      )),
    );

    return movimientosAsync.when(
      data: (movimientos) {
        // Filtrar por búsqueda si hay query
        var filteredMovimientos = movimientos;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          filteredMovimientos = movimientos
              .where(
                (m) =>
                    m.itemId.toLowerCase().contains(query) ||
                    (m.observaciones?.toLowerCase().contains(query) ?? false) ||
                    (m.numeroDocumento?.toLowerCase().contains(query) ?? false),
              )
              .toList();
        }

        if (filteredMovimientos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.swap_vert,
                  size: 80,
                  color: AppColors.onSurfaceVariant,
                ),
                AppSpacing.gapBase,
                Text(
                  _searchQuery.isNotEmpty ? l.invNoResults : l.invNoMovements,
                  style: theme.textTheme.titleLarge,
                ),
                AppSpacing.gapSm,
                Text(
                  _searchQuery.isNotEmpty
                      ? l.invNoMovementsMatchSearch
                      : l.invNoMovementsYet,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              inventarioMovimientosGranjaProvider((
                granjaId: granjaId,
                desde: null,
                hasta: null,
                limite: 50,
              )),
            );
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 80,
            ),
            itemCount: filteredMovimientos.length,
            itemBuilder: (context, index) {
              final movimiento = filteredMovimientos[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MovimientoInventarioCard(movimiento: movimiento),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(message: l.invErrorLoadingMovements),
    );
  }

  Widget _buildEmptyItemsState(ThemeData theme, String granjaId) {
    final hasFilters = _filtroTipo != null || _searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.inventory_2_outlined,
            size: 80,
            color: AppColors.onSurfaceVariant,
          ),
          AppSpacing.gapBase,
          Text(
            hasFilters ? l.invNoResults : l.invNoItemsInInventory,
            style: theme.textTheme.titleLarge,
          ),
          AppSpacing.gapSm,
          Text(
            hasFilters ? l.invNoItemsMatchFilters : l.invAddYourFirstItem,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapXl,
          if (hasFilters)
            FilledButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _filtroTipo = null;
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.surface,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
              ),
              child: Text(l.invClearFilters),
            )
          else
            ElevatedButton.icon(
              onPressed: () => context.push(
                AppRoutes.inventarioCrearItemConGranja(granjaId),
              ),
              icon: const Icon(Icons.add),
              label: Text(l.invAddItem),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminarItem(ItemInventario item) async {
    final confirmed = await InventarioDialogs.showEliminarItemDialog(
      context,
      item,
    );

    if (confirmed) {
      final notifier = ref.read(inventarioItemNotifierProvider.notifier);
      await notifier.eliminarItem(item.id);

      if (!mounted) return;
      AppSnackBar.success(context, message: l.invItemDeletedSuccess);
    }
  }

  Widget _buildFiltrosActivosChip(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        width: double.infinity,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant,
          borderRadius: AppRadius.allSm,
        ),
        child: Text(
          _filtroTipo?.displayName ?? '',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.surface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _mostrarFiltros() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
                      l.invFilterByType,
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Opción "Todos" - ocupa todo el ancho
                        AspectRatio(
                          aspectRatio: 4.8,
                          child: _buildTipoOption(
                            theme: theme,
                            label: l.commonAllTypes,
                            isSelected: _filtroTipo == null,
                            color: theme.colorScheme.primary,
                            onTap: () {
                              setModalState(() {});
                              setState(() => _filtroTipo = null);
                            },
                          ),
                        ),
                        AppSpacing.gapSm,

                        // Grid de tipos 2 columnas
                        GridView.count(
                          crossAxisCount: AppBreakpoints.of(
                            context,
                          ).gridColumns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.4,
                          children: TipoItem.values.map((tipo) {
                            final color = Color(
                              int.parse('0xFF${tipo.colorHex}'),
                            );
                            return _buildTipoOption(
                              theme: theme,
                              label: tipo.displayName,
                              isSelected: _filtroTipo == tipo,
                              color: color,
                              onTap: () {
                                setModalState(() {});
                                setState(() => _filtroTipo = tipo);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  // Botón aplicar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allMd,
                          ),
                        ),
                        child: Text(
                          _hayFiltrosActivos ? l.invApplyFilter : l.commonClose,
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

  Widget _buildTipoOption({
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
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.info
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
