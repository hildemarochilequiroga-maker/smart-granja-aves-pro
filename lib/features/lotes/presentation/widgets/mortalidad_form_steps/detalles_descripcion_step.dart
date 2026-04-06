/// Step 2: Detalles y Descripción del Evento
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../salud/domain/enums/causa_mortalidad.dart';

/// Step 2: Detalles y Descripción
class DetallesDescripcionStep extends StatelessWidget {
  const DetallesDescripcionStep({
    super.key,
    required this.descripcionController,
    required this.causaSeleccionada,
    required this.autoValidate,
  });

  final TextEditingController descripcionController;
  final CausaMortalidad? causaSeleccionada;
  final bool autoValidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormMortalityDetailsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormMortalityDetailsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Campo de descripción
          RegistroFormField(
            controller: descripcionController,
            label: S.of(context).batchFormMortalityDescription,
            hint: S.of(context).batchFormMortalityDescriptionHint,
            required: true,
            maxLines: 6,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return S.of(context).batchRequiredField;
              }
              if (value.trim().length < 10) {
                return S.of(context).batchMin3Chars;
              }
              return null;
            },
          ),
          AppSpacing.gapXl,

          // Acciones recomendadas (si hay causa seleccionada)
          if (causaSeleccionada != null) _buildAccionesRecomendadas(context, theme),
        ],
      ),
    );
  }

  Widget _buildAccionesRecomendadas(BuildContext context, ThemeData theme) {
    if (causaSeleccionada == null) return const SizedBox.shrink();

    final acciones = causaSeleccionada!.accionesRecomendadas;

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
            S.of(context).batchFormRecommendedActions,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapSm,
          ...acciones.asMap().entries.map(
            (entry) => Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < acciones.length - 1 ? 6 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
