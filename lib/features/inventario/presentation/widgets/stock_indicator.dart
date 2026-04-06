/// Widget indicador visual de nivel de stock.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Widget indicador visual de nivel de stock.
class StockIndicator extends StatelessWidget {
  const StockIndicator({
    super.key,
    required this.stockActual,
    required this.stockMinimo,
    this.showLabels = true,
    this.height = 8,
    this.unidad = '',
  });

  final double stockActual;
  final double stockMinimo;
  final bool showLabels;
  final double height;
  final String unidad;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Calcular porcentaje relativo al mínimo (200% del mínimo = stock ideal)
    final stockIdeal = stockMinimo * 2;
    final porcentaje = stockIdeal > 0
        ? (stockActual / stockIdeal).clamp(0, 1)
        : 0;
    final porcentajeMinimo = stockIdeal > 0 ? stockMinimo / stockIdeal : 0;

    Color barColor;
    if (stockActual == 0) {
      barColor = AppColors.error;
    } else if (stockActual <= stockMinimo) {
      barColor = AppColors.warning;
    } else {
      barColor = AppColors.success;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            // Fondo
            Container(
              height: height,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
            // Barra de progreso
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: height,
              width: double.infinity,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: porcentaje.toDouble(),
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ),
            // Marcador de mínimo
            if (porcentajeMinimo > 0 && porcentajeMinimo < 1)
              Positioned(
                left: 0,
                right: 0,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: porcentajeMinimo.toDouble(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2,
                      height: height + 4,
                      color: AppColors.error.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (showLabels) ...[
          AppSpacing.gapXxs,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S
                    .of(context)
                    .invStockActualLabel(
                      stockActual.toStringAsFixed(0),
                      unidad,
                    ),
                style: theme.textTheme.labelSmall?.copyWith(color: barColor),
              ),
              Text(
                S
                    .of(context)
                    .invStockMinimoLabel(
                      stockMinimo.toStringAsFixed(0),
                      unidad,
                    ),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Widget de resumen rápido del inventario para dashboards.
class ResumenInventarioWidget extends StatelessWidget {
  const ResumenInventarioWidget({
    super.key,
    required this.totalItems,
    required this.itemsConStockBajo,
    required this.itemsAgotados,
    required this.itemsProximosVencer,
    this.valorTotal,
    this.onTap,
    this.compact = false,
  });

  final int totalItems;
  final int itemsConStockBajo;
  final int itemsAgotados;
  final int itemsProximosVencer;
  final double? valorTotal;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    final hayAlertas =
        itemsConStockBajo > 0 || itemsAgotados > 0 || itemsProximosVencer > 0;

    if (compact) {
      return Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allMd,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hayAlertas
                        ? AppColors.warning.withValues(alpha: 0.1)
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allMd,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.inventory_2,
                          color: hayAlertas
                              ? AppColors.warning
                              : AppColors.primary,
                        ),
                      ),
                      if (hayAlertas)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${itemsAgotados + itemsConStockBajo + itemsProximosVencer}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppColors.onError,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AppSpacing.hGapBase,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.invInventoryLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$totalItems ${l.invItemsRegistered}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.inventory_2, color: AppColors.primary),
                  AppSpacing.hGapSm,
                  Text(
                    l.invInventoryLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: onTap, child: Text(l.invViewAllItems)),
                ],
              ),
              const Divider(),
              AppSpacing.gapSm,
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      Icons.inventory,
                      '$totalItems',
                      l.invTotalItems,
                      AppColors.primary,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      Icons.warning_amber,
                      '$itemsConStockBajo',
                      l.invLowStock,
                      itemsConStockBajo > 0
                          ? AppColors.warning
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      Icons.error_outline,
                      '$itemsAgotados',
                      l.invDepletedItems,
                      itemsAgotados > 0
                          ? AppColors.error
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      theme,
                      Icons.event,
                      '$itemsProximosVencer',
                      l.invExpiringSoon,
                      itemsProximosVencer > 0
                          ? AppColors.warning
                          : AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        AppSpacing.gapXxs,
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
