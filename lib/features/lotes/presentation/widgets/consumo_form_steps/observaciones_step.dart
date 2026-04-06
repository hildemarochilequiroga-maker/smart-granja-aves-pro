/// Step 3: Observaciones del consumo de alimento
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 3: Observaciones
class ObservacionesStep extends StatelessWidget {
  const ObservacionesStep({
    super.key,
    required this.formKey,
    required this.observacionesController,
    required this.autoValidate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController observacionesController;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).feedObsTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            S.of(context).feedObsOptionalHint,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapBase,

          // Campo de observaciones
          TextFormField(
            controller: observacionesController,
            maxLines: 6,
            maxLength: 500,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            decoration: InputDecoration(
              labelText: S.of(context).consumoObservationsOptional,
              hintText: S.of(context).feedObsDescribeHint,
              alignLabelWithHint: true,
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
              errorBorder: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
            ),
            validator: (value) {
              return null; // Opcional
            },
          ),
          AppSpacing.gapXl,

          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.info,
                  size: 20,
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Text(
                    S.of(context).feedObsHelpText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
