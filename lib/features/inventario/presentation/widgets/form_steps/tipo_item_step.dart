/// Step para seleccionar el tipo de item de inventario.
/// Diseño inspirado en el step de tipo de producto de ventas.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/enums.dart';

/// Widget para seleccionar el tipo de item en el formulario de inventario.
///
/// Muestra una lista de opciones con diseño moderno y feedback táctil.
class TipoItemStep extends StatelessWidget {
  const TipoItemStep({
    super.key,
    required this.tipoSeleccionado,
    required this.onTipoChanged,
  });

  final TipoItem tipoSeleccionado;
  final ValueChanged<TipoItem> onTipoChanged;

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
            l.invWhatTypeOfItem,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.invSelectCategory,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          AppSpacing.gapXl,
          Expanded(
            child: ListView.separated(
              itemCount: TipoItem.values.length,
              separatorBuilder: (_, __) => AppSpacing.gapMd,
              itemBuilder: (context, index) {
                final tipo = TipoItem.values[index];
                final isSelected = tipoSeleccionado == tipo;
                final descripcion = _getDescripcion(tipo, l);
                final color = Color(int.parse('0xFF${tipo.colorHex}'));

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
                            // Punto de color del tipo
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            AppSpacing.hGapMd,
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

  String _getDescripcion(TipoItem tipo, S l) {
    return switch (tipo) {
      TipoItem.alimento => l.invDescAlimento,
      TipoItem.medicamento => l.invDescMedicamento,
      TipoItem.vacuna => l.invCatVaccines,
      TipoItem.equipo => l.invDescHerramienta,
      TipoItem.insumo => l.invCatInsumo,
      TipoItem.limpieza => l.invCatLimpieza,
      TipoItem.otro => l.invDescOtro,
    };
  }
}
