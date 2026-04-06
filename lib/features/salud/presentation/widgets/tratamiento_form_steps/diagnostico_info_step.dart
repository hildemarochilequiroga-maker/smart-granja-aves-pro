/// Step 1: Información del Diagnóstico y Síntomas
/// Diseño consistente con BasicInfoStep de granjas
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../common/salud_form_field.dart';

/// Step de información de diagnóstico - primer paso del formulario
class DiagnosticoInfoStep extends StatelessWidget {
  const DiagnosticoInfoStep({
    super.key,
    required this.diagnosticoController,
    required this.sintomasController,
    required this.fechaTratamiento,
    required this.autoValidate,
    required this.onFechaChanged,
  });

  final TextEditingController diagnosticoController;
  final TextEditingController sintomasController;
  final DateTime fechaTratamiento;
  final bool autoValidate;
  final void Function(DateTime) onFechaChanged;

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
            l.treatStepDiagTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.treatStepDiagDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Card de información importante
          _buildInfoCard(theme, l),
          const SizedBox(height: AppSpacing.xl),

          // Fecha del tratamiento
          _buildFechaSelector(context, theme, l),
          const SizedBox(height: AppSpacing.base),

          // Diagnóstico
          SaludFormField(
            controller: diagnosticoController,
            label: l.treatStepDiagnosis,
            hint: l.treatStepDiagnosisHint,
            required: true,
            maxLines: 2,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l.treatStepDiagRequired;
              }
              if (value.trim().length < 5) {
                return l.treatStepDiagMinLength;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.base),

          // Síntomas
          SaludFormField(
            controller: sintomasController,
            label: l.treatStepSymptoms,
            hint: l.treatStepSymptomsHint,
            maxLines: 4,
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
            l.treatStepDiagImportant,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l.treatStepDiagImportantMsg,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFechaSelector(BuildContext context, ThemeData theme, S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.treatStepDateRequired,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () => _seleccionarFecha(context),
          borderRadius: AppRadius.allSm,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    DateFormat('dd/MM/yyyy').format(fechaTratamiento),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaTratamiento,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      onFechaChanged(fecha);
    }
  }
}
