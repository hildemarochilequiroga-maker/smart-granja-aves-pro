/// Step 1: Información Básica de la Granja
/// Nombre, propietario y descripción opcional
library;

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../granja_form_field.dart';

/// Step de información básica
class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({
    super.key,
    required this.nombreController,
    required this.propietarioController,
    required this.descripcionController,
    this.autoValidate = false,
  });

  final TextEditingController nombreController;
  final TextEditingController propietarioController;
  final TextEditingController descripcionController;
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
            l.commonBasicInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.farmEnterBasicData,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Nombre de la Granja
          GranjaFormField(
            controller: nombreController,
            label: l.farmName,
            hint: l.farmNameHint,
            required: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.farmNameRequired;
              }
              if (value.trim().length < 3) {
                return l.farmNameMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Propietario
          GranjaFormField(
            controller: propietarioController,
            label: l.farmOwnerName,
            hint: l.farmOwnerHint,
            required: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.farmOwnerRequired;
              }
              if (value.trim().length < 3) {
                return l.farmNameMinLength;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Descripción (opcional)
          GranjaFormField(
            controller: descripcionController,
            label: l.farmDescriptionOptional,
            hint: l.commonDescription,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
          AppSpacing.gapXl,

          // Card informativa
          _buildInfoCard(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
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
            l.commonImportantInfo,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.farmInfoUsedToIdentify,
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
