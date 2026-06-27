/// Step 1: Información Básica de la Granja
/// Nombre, propietario y descripción opcional
library;

import 'package:flutter/material.dart';

import '../../../../../core/utils/field_validators.dart';
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
            validator: FieldValidators.compose([
              FieldValidators.required(l.farmNameRequired),
              FieldValidators.minLength(l.farmNameMinLength, 3),
            ]),
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
            validator: FieldValidators.compose([
              FieldValidators.required(l.farmOwnerRequired),
              FieldValidators.minLength(l.farmNameMinLength, 3),
            ]),
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
        ],
      ),
    );
  }
}
