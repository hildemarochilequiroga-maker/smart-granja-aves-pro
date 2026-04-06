/// Step 1: Tipo de Gasto
/// Selección de tipo de gasto con cards estilo ventas
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/tipo_gasto.dart';

/// Step de tipo de gasto con diseño de cards en lista
class TipoConceptoStep extends StatelessWidget {
  const TipoConceptoStep({
    super.key,
    required this.tipoSeleccionado,
    required this.onTipoChanged,
  });

  final TipoGasto? tipoSeleccionado;
  final ValueChanged<TipoGasto> onTipoChanged;

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
            l.costoWhatType,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.costoSelectCategory,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          AppSpacing.gapXl,
          Expanded(
            child: ListView.separated(
              itemCount: TipoGasto.values.length,
              separatorBuilder: (_, __) => AppSpacing.gapMd,
              itemBuilder: (context, index) {
                final tipo = TipoGasto.values[index];
                final isSelected = tipoSeleccionado == tipo;

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
                                    tipo.descripcion,
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
}
