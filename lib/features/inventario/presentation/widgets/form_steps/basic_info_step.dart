/// Step 1: Información Básica del Item de Inventario
/// Nombre, código y descripción
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/presentation/widgets/granja_form_field.dart';

/// Step de información básica del item
class InventarioBasicInfoStep extends StatelessWidget {
  const InventarioBasicInfoStep({
    super.key,
    required this.nombreController,
    required this.codigoController,
    required this.descripcionController,
    this.autoValidate = false,
  });

  final TextEditingController nombreController;
  final TextEditingController codigoController;
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
            l.invBasicInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.invBasicInfoSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Nombre
          GranjaFormField(
            controller: nombreController,
            label: l.invItemNameRequired,
            hint: l.invHintExample,
            required: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.invEnterItemName;
              }
              if (value.trim().length < 2) {
                return l.invNameRequired;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Código/SKU
          GranjaFormField(
            controller: codigoController,
            label: l.invCodeOptional,
            hint: l.invInternalCode,
            maxLength: 50,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapBase,

          // Descripción
          GranjaFormField(
            controller: descripcionController,
            label: l.invDescriptionOptional,
            hint: l.invDescribeItem,
            maxLines: 3,
            maxLength: 300,
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
            l.commonImportantInfo,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.invSkuHelpsIdentify,
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
