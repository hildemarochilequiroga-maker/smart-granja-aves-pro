/// Card para selección de tipo de reporte.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/tipo_reporte.dart';

/// Widget de card para cada tipo de reporte.
class ReporteCard extends StatelessWidget {
  const ReporteCard({
    super.key,
    required this.tipo,
    required this.isSelected,
    required this.onTap,
  });

  final TipoReporte tipo;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? AppColors.success.withValues(alpha: 0.1)
          : colorScheme.surface,
      borderRadius: AppRadius.allMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allMd,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMd,
            border: Border.all(
              color: isSelected
                  ? AppColors.success
                  : colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(tipo),
                size: 28,
                color: isSelected
                    ? AppColors.success
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                tipo.displayName,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.success : colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxs),
              if (!tipo.isImplemented)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.2),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    S.of(context).commonComingSoon,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.warningDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    S.of(context).commonSelected,
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(TipoReporte tipo) {
    switch (tipo) {
      case TipoReporte.produccionLote:
        return Icons.layers_rounded;
      case TipoReporte.mortalidad:
        return Icons.trending_down_rounded;
      case TipoReporte.consumo:
        return Icons.restaurant_rounded;
      case TipoReporte.peso:
        return Icons.scale_rounded;
      case TipoReporte.costos:
        return Icons.payments_rounded;
      case TipoReporte.ventas:
        return Icons.point_of_sale_rounded;
      case TipoReporte.rentabilidad:
        return Icons.analytics_rounded;
      case TipoReporte.salud:
        return Icons.health_and_safety_rounded;
      case TipoReporte.inventario:
        return Icons.inventory_2_rounded;
      case TipoReporte.ejecutivo:
        return Icons.dashboard_rounded;
    }
  }
}
