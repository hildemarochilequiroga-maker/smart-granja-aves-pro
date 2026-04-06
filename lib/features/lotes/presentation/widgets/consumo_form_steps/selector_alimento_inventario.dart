/// Widget para seleccionar un item de alimento del inventario.
///
/// Permite buscar y seleccionar alimentos del inventario para
/// autocompletar información en el registro de consumo.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../inventario/application/providers/providers.dart';
import '../../../../inventario/domain/entities/item_inventario.dart';
import '../../../../inventario/domain/enums/enums.dart';

/// Widget para seleccionar un alimento del inventario.
class SelectorAlimentoInventario extends ConsumerStatefulWidget {
  const SelectorAlimentoInventario({
    super.key,
    required this.granjaId,
    required this.onItemSelected,
    this.itemSeleccionado,
  });

  final String granjaId;
  final void Function(ItemInventario?) onItemSelected;
  final ItemInventario? itemSeleccionado;

  @override
  ConsumerState<SelectorAlimentoInventario> createState() =>
      _SelectorAlimentoInventarioState();
}

class _SelectorAlimentoInventarioState
    extends ConsumerState<SelectorAlimentoInventario> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Obtener items de alimento del inventario
    final itemsAsync = ref.watch(
      inventarioItemsPorTipoProvider((
        granjaId: widget.granjaId,
        tipo: TipoItem.alimento,
      )),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              S.of(context).batchFormFoodFromInventory,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.hGapSm,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: AppRadius.allXs,
              ),
              child: Text(
                S.of(context).batchFormOptional,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        AppSpacing.gapSm,

        // Selector
        itemsAsync.when(
          data: (items) => _buildSelector(context, items),
          loading: () => _buildLoadingState(context),
          error: (_, __) => _buildErrorState(context),
        ),

        // Info card
        if (widget.itemSeleccionado == null) ...[
          AppSpacing.gapMd,
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: AppRadius.allSm,
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.info,
                  size: 18,
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Text(
                    S.of(context).batchFormSelectFoodHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelector(BuildContext context, List<ItemInventario> items) {
    final theme = Theme.of(context);

    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          borderRadius: AppRadius.allSm,
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Text(
                S.of(context).batchFormNoFoodInInventory,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Si hay un item seleccionado, mostrar la card
    if (widget.itemSeleccionado != null) {
      return _buildSelectedItemCard(context, widget.itemSeleccionado!);
    }

    // Dropdown para seleccionar
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          // Header del dropdown
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: AppRadius.allSm,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Text(
                      S.of(context).batchFormSelectFoodType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Lista expandible
          if (_isExpanded) ...[
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
            ...items.map((item) => _buildItemOption(context, item)),
          ],
        ],
      ),
    );
  }

  Widget _buildItemOption(BuildContext context, ItemInventario item) {
    final theme = Theme.of(context);
    final stockBajo = item.stockActual <= item.stockMinimo;

    return InkWell(
      onTap: () {
        widget.onItemSelected(item);
        setState(() => _isExpanded = false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          children: [
            // Info del item
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nombre,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  AppSpacing.gapXxxs,
                  Row(
                    children: [
                      Text(
                        S.of(context).inventoryStockLabel(item.stockActual.toStringAsFixed(1), item.unidad.simbolo),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: stockBajo
                              ? AppColors.warning
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (item.precioUnitario != null) ...[
                        AppSpacing.hGapMd,
                        Text(
                          '\$${item.precioUnitario!.toStringAsFixed(2)}/${item.unidad.simbolo}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Indicador de stock bajo
            if (stockBajo)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allXs,
                ),
                child: Text(
                  S.of(context).batchFormLowStock,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedItemCard(BuildContext context, ItemInventario item) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: AppRadius.allSm,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nombre,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      S.of(context).inventoryStockLabel(item.stockActual.toStringAsFixed(1), item.unidad.simbolo),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Botón para cambiar/quitar
              IconButton(
                onPressed: () => widget.onItemSelected(null),
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                tooltip: S.of(context).consumoRemoveSelection,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          if (item.precioUnitario != null) ...[
            AppSpacing.gapSm,
            Row(
              children: [
                const Icon(
                  Icons.attach_money,
                  color: AppColors.success,
                  size: 16,
                ),
                AppSpacing.hGapXxs,
                Text(
                  S.of(context).inventoryPriceLabel('\$${item.precioUnitario!.toStringAsFixed(2)}', item.unidad.simbolo),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppRadius.allSm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.hGapMd,
          Text(
            S.of(context).feedLoadingItems,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          AppSpacing.hGapMd,
          Text(
            S.of(context).feedLoadError,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
