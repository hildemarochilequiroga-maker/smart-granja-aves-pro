/// Widget selector de productos del inventario.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';

/// Widget que permite seleccionar un item del inventario.
class InventarioSelector extends ConsumerStatefulWidget {
  const InventarioSelector({
    super.key,
    required this.granjaId,
    required this.onItemSelected,
    this.tipoFiltro,
    this.itemSeleccionado,
    this.label,
    this.hint,
    this.required = false,
    this.validator,
    this.enabled = true,
  });

  /// ID de la granja para filtrar inventario.
  final String granjaId;

  /// Callback cuando se selecciona un item.
  final ValueChanged<ItemInventario?> onItemSelected;

  /// Tipo de item a filtrar (null = todos).
  final TipoItem? tipoFiltro;

  /// Item actualmente seleccionado.
  final ItemInventario? itemSeleccionado;

  /// Etiqueta del campo.
  final String? label;

  /// Texto de hint.
  final String? hint;

  /// Si el campo es requerido.
  final bool required;

  /// Validador personalizado.
  final String? Function(ItemInventario?)? validator;

  /// Si el selector está habilitado.
  final bool enabled;

  @override
  ConsumerState<InventarioSelector> createState() => _InventarioSelectorState();
}

class _InventarioSelectorState extends ConsumerState<InventarioSelector> {
  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              widget.label ?? l.invSelectProduct,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            if (widget.required)
              Text(
                ' *',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
        AppSpacing.gapSm,

        // Selector
        InkWell(
          onTap: widget.enabled ? _mostrarDialogoSeleccion : null,
          borderRadius: AppRadius.allMd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: widget.enabled
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Ícono
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.itemSeleccionado != null
                        ? _getColorForTipo(
                            widget.itemSeleccionado!.tipo,
                          ).withValues(alpha: 0.2)
                        : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Icon(
                    widget.itemSeleccionado != null
                        ? _getIconForTipo(widget.itemSeleccionado!.tipo)
                        : Icons.inventory_2_outlined,
                    color: widget.itemSeleccionado != null
                        ? _getColorForTipo(widget.itemSeleccionado!.tipo)
                        : colorScheme.primary,
                    size: 20,
                  ),
                ),
                AppSpacing.hGapMd,

                // Contenido
                Expanded(
                  child: widget.itemSeleccionado != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemSeleccionado!.nombre,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            AppSpacing.gapXxxs,
                            Text(
                              l.inventoryStockLabel(
                                widget.itemSeleccionado!.stockActual
                                    .toStringAsFixed(1),
                                widget.itemSeleccionado!.unidad.simbolo,
                              ),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: widget.itemSeleccionado!.stockBajo
                                    ? AppColors.warning
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.hint ?? l.invSearchInventory,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),

                // Flecha o clear
                if (widget.itemSeleccionado != null && widget.enabled)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => widget.onItemSelected(null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),

        // Validación
        if (widget.validator != null)
          Builder(
            builder: (context) {
              final error = widget.validator!(widget.itemSeleccionado);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 12),
                  child: Text(
                    error,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  void _mostrarDialogoSeleccion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InventarioSelectorSheet(
        granjaId: widget.granjaId,
        tipoFiltro: widget.tipoFiltro,
        itemSeleccionado: widget.itemSeleccionado,
        onItemSelected: (item) {
          Navigator.pop(context);
          widget.onItemSelected(item);
        },
      ),
    );
  }

  Color _getColorForTipo(TipoItem tipo) {
    switch (tipo) {
      case TipoItem.alimento:
        return AppColors.warning;
      case TipoItem.medicamento:
        return AppColors.error;
      case TipoItem.vacuna:
        return AppColors.success;
      case TipoItem.equipo:
        return AppColors.info;
      case TipoItem.insumo:
        return AppColors.purple;
      case TipoItem.limpieza:
        return AppColors.cyan;
      case TipoItem.otro:
        return AppColors.outline;
    }
  }

  IconData _getIconForTipo(TipoItem tipo) {
    switch (tipo) {
      case TipoItem.alimento:
        return Icons.restaurant;
      case TipoItem.medicamento:
        return Icons.medication;
      case TipoItem.vacuna:
        return Icons.vaccines;
      case TipoItem.equipo:
        return Icons.build;
      case TipoItem.insumo:
        return Icons.category;
      case TipoItem.limpieza:
        return Icons.cleaning_services;
      case TipoItem.otro:
        return Icons.inventory_2;
    }
  }
}

/// Bottom sheet para selección de items del inventario.
class _InventarioSelectorSheet extends ConsumerStatefulWidget {
  const _InventarioSelectorSheet({
    required this.granjaId,
    required this.onItemSelected,
    this.tipoFiltro,
    this.itemSeleccionado,
  });

  final String granjaId;
  final TipoItem? tipoFiltro;
  final ItemInventario? itemSeleccionado;
  final ValueChanged<ItemInventario> onItemSelected;

  @override
  ConsumerState<_InventarioSelectorSheet> createState() =>
      _InventarioSelectorSheetState();
}

class _InventarioSelectorSheetState
    extends ConsumerState<_InventarioSelectorSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final itemsAsync = ref.watch(
      inventarioItemsStreamProvider(widget.granjaId),
    );

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                Text(
                  l.invSelectProduct,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.gapBase,

                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l.invSearchProduct,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.allMd,
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ],
            ),
          ),

          // Lista de items
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                // Filtrar por tipo si es necesario
                var filteredItems = widget.tipoFiltro != null
                    ? items.where((i) => i.tipo == widget.tipoFiltro).toList()
                    : items;

                // Filtrar por búsqueda
                if (_searchQuery.isNotEmpty) {
                  filteredItems = filteredItems
                      .where(
                        (i) => i.nombre.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();
                }

                // Solo mostrar activos y con stock
                filteredItems = filteredItems
                    .where((i) => i.activo && i.stockActual > 0)
                    .toList();

                if (filteredItems.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        AppSpacing.gapBase,
                        Text(
                          _searchQuery.isNotEmpty
                              ? l.invNoProductsFound
                              : l.invNoProductsAvailable,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (widget.tipoFiltro != null)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.sm),
                            child: Text(
                              S
                                  .of(context)
                                  .inventoryOfType(
                                    widget.tipoFiltro!.displayName,
                                  ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    final isSelected = widget.itemSeleccionado?.id == item.id;

                    return _ItemInventarioTile(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => widget.onItemSelected(item),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  l.invErrorLoadingInventory,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile de item de inventario para selección.
class _ItemInventarioTile extends StatelessWidget {
  const _ItemInventarioTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final ItemInventario item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: isSelected
            ? BorderSide(color: colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getColorForTipo(item.tipo).withValues(alpha: 0.2),
            borderRadius: AppRadius.allMd,
          ),
          child: Icon(
            _getIconForTipo(item.tipo),
            color: _getColorForTipo(item.tipo),
            size: 24,
          ),
        ),
        title: Text(
          item.nombre,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.gapXxs,
            Row(
              children: [
                Icon(
                  Icons.inventory,
                  size: 14,
                  color: item.stockBajo
                      ? AppColors.warning
                      : colorScheme.primary,
                ),
                AppSpacing.hGapXxs,
                Text(
                  '${item.stockActual.toStringAsFixed(1)} ${item.unidad.simbolo}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: item.stockBajo
                        ? AppColors.warning
                        : colorScheme.onSurfaceVariant,
                    fontWeight: item.stockBajo ? FontWeight.w600 : null,
                  ),
                ),
                if (item.stockBajo) ...[
                  AppSpacing.hGapSm,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xxxs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: AppRadius.allXs,
                    ),
                    child: Text(
                      l.invSelectorStockLow,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (item.fechaVencimiento != null) ...[
              AppSpacing.gapXxs,
              Row(
                children: [
                  Icon(
                    Icons.event,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.hGapXxs,
                  Text(
                    l.inventoryExpiresLabel(
                      _formatFecha(item.fechaVencimiento!),
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: item.vencido
                          ? AppColors.error
                          : item.proximoVencer
                          ? AppColors.warning
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: colorScheme.primary)
            : Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
      ),
    );
  }

  Color _getColorForTipo(TipoItem tipo) {
    switch (tipo) {
      case TipoItem.alimento:
        return AppColors.warning;
      case TipoItem.medicamento:
        return AppColors.error;
      case TipoItem.vacuna:
        return AppColors.success;
      case TipoItem.equipo:
        return AppColors.info;
      case TipoItem.insumo:
        return AppColors.purple;
      case TipoItem.limpieza:
        return AppColors.cyan;
      case TipoItem.otro:
        return AppColors.outline;
    }
  }

  IconData _getIconForTipo(TipoItem tipo) {
    switch (tipo) {
      case TipoItem.alimento:
        return Icons.restaurant;
      case TipoItem.medicamento:
        return Icons.medication;
      case TipoItem.vacuna:
        return Icons.vaccines;
      case TipoItem.equipo:
        return Icons.build;
      case TipoItem.insumo:
        return Icons.category;
      case TipoItem.limpieza:
        return Icons.cleaning_services;
      case TipoItem.otro:
        return Icons.inventory_2;
    }
  }

  String _formatFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }
}
