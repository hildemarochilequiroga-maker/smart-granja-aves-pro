/// Step 3: Información Adicional
/// Diseño consistente con los steps de granjas
library;

import 'package:flutter/material.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../common/salud_form_field.dart';

/// Step de información adicional - tercer paso del formulario
class InformacionAdicionalStep extends StatelessWidget {
  const InformacionAdicionalStep({
    super.key,
    required this.veterinarioController,
    required this.observacionesController,
    required this.autoValidate,
  });

  final TextEditingController veterinarioController;
  final TextEditingController observacionesController;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            l.treatStepAdditionalTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.treatStepAdditionalDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Card de información importante
          _buildInfoCard(theme, l),
          AppSpacing.gapXl,

          // Veterinario
          SaludFormField(
            controller: veterinarioController,
            label: l.treatStepVeterinarian,
            hint: l.treatStepVetName,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapBase,

          // Observaciones
          SaludFormField(
            controller: observacionesController,
            label: l.treatStepGeneralObs,
            hint: l.treatStepGeneralObsHint,
            maxLines: 5,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, S l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.treatStepAdditionalImportant,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.treatStepAdditionalImportantMsg,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
