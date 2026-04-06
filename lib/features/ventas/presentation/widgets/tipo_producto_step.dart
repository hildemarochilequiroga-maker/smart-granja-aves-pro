import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/tipo_producto_venta.dart';

/// Widget para seleccionar el tipo de producto en el formulario de venta.
///
/// Muestra una lista de opciones con diseño moderno y feedback táctil.
class TipoProductoStep extends StatelessWidget {
  final TipoProductoVenta? tipoSeleccionado;
  final ValueChanged<TipoProductoVenta> onTipoChanged;

  const TipoProductoStep({
    super.key,
    this.tipoSeleccionado,
    required this.onTipoChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.ventaStepProductQuestion,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.selectProductHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          AppSpacing.gapXl,
          Expanded(
            child: ListView.separated(
              itemCount: TipoProductoVenta.values.length,
              separatorBuilder: (_, __) => AppSpacing.gapMd,
              itemBuilder: (context, index) {
                final tipo = TipoProductoVenta.values[index];
                final isSelected = tipoSeleccionado == tipo;
                final descripcion = _getDescripcion(tipo, l);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.allMd,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.info
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    color: isSelected
                        ? AppColors.info.withValues(alpha: 0.08)
                        : theme.colorScheme.surface,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.info.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: AppRadius.allMd,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        onTipoChanged(tipo);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Texto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tipo.displayName,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? AppColors.info
                                              : theme.colorScheme.onSurface,
                                        ),
                                  ),
                                  AppSpacing.gapXxs,
                                  Text(
                                    descripcion,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Indicador de selección
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isSelected ? 1 : 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.info,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: AppColors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getDescripcion(TipoProductoVenta tipo, S l) {
    switch (tipo) {
      case TipoProductoVenta.avesVivas:
        return l.ventaProductDescAvesEnPie;
      case TipoProductoVenta.huevos:
        return l.ventaProductDescHuevos;
      case TipoProductoVenta.pollinaza:
        return l.ventaProductDescAbono;
      case TipoProductoVenta.avesFaenadas:
        return l.ventaProductDescAvesFaenadas;
      case TipoProductoVenta.avesDescarte:
        return l.ventaProductDescOtro;
    }
  }
}
