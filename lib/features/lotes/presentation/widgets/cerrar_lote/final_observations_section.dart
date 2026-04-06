/// Sección de observaciones finales para cerrar lote.
///
/// Widget modular para capturar observaciones
/// y notas finales al cerrar el lote.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Widget para capturar observaciones finales
class FinalObservationsSection extends StatelessWidget {
  const FinalObservationsSection({
    super.key,
    required this.observacionesController,
    required this.autoValidate,
  });

  final TextEditingController observacionesController;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).batchCloseFinalObservations,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapMd,

        TextFormField(
          controller: observacionesController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: S.of(context).batchCloseObservationsHint,
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Icon(Icons.notes, color: colorScheme.onSurface),
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.info, width: 2),
            ),
          ),
        ),
        AppSpacing.gapXl,

        // Advertencia de cierre irreversible
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: AppRadius.allMd,
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber,
                color: AppColors.warning,
                size: 24,
              ),
              AppSpacing.hGapMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).batchCloseIrreversible,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSpacing.gapXxs,
                    Text(
                      S.of(context).batchCloseIrreversibleMessage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
