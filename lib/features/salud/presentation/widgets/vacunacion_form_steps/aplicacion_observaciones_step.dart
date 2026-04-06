/// Step 2: Aplicación y Observaciones
/// Fecha de aplicación y notas - Estilo Wialon
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/presentation/widgets/granja_form_field.dart';

/// Step de aplicación y observaciones
class AplicacionObservacionesStep extends StatelessWidget {
  const AplicacionObservacionesStep({
    super.key,
    required this.observacionesController,
    required this.fechaAplicacion,
    required this.autoValidate,
    required this.onFechaAplicacionChanged,
    required this.onClearFechaAplicacion,
  });

  final TextEditingController observacionesController;
  final DateTime? fechaAplicacion;
  final bool autoValidate;
  final void Function(DateTime) onFechaAplicacionChanged;
  final VoidCallback onClearFechaAplicacion;

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
            l.vacStepAppObsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.vacStepAppObsDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Fecha de aplicación
          _buildFechaAplicacionField(context, theme, l),
          AppSpacing.gapBase,

          // Observaciones
          GranjaFormField(
            controller: observacionesController,
            label: l.vacStepObservationsOptional,
            hint: l.vacStepObservationsHint,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
          ),
          AppSpacing.gapXl,

          // Estado Card
          _buildEstadoCard(theme, l),
          AppSpacing.gapBase,

          // Info Card
          _buildInfoCard(theme, l),
        ],
      ),
    );
  }

  Widget _buildFechaAplicacionField(
    BuildContext context,
    ThemeData theme,
    S l,
  ) {
    final isAplicada = fechaAplicacion != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.vacStepAppDateOptional,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InkWell(
          onTap: () => _seleccionarFechaAplicacion(context),
          borderRadius: AppRadius.allSm,
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              fillColor: isAplicada
                  ? AppColors.success.withValues(alpha: 0.08)
                  : theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: isAplicada
                      ? AppColors.success.withValues(alpha: 0.4)
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: isAplicada
                      ? AppColors.success.withValues(alpha: 0.4)
                      : theme.colorScheme.outline.withValues(alpha: 0.4),
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
                    isAplicada
                        ? DateFormat('dd/MM/yyyy').format(fechaAplicacion!)
                        : l.vacStepSelectDate,
                    style: isAplicada
                        ? theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.success,
                          )
                        : theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                  ),
                ),
                if (isAplicada)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    onPressed: onClearFechaAplicacion,
                    tooltip: l.vacStepRemoveDate,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
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

  Widget _buildEstadoCard(ThemeData theme, S l) {
    final isAplicada = fechaAplicacion != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAplicada
            ? AppColors.success.withValues(alpha: 0.08)
            : AppColors.warning.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: isAplicada
              ? AppColors.success.withValues(alpha: 0.2)
              : AppColors.warning.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAplicada ? l.vacStepVaccineApplied : l.vacStepScheduled,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isAplicada ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.gapXxxs,
                Text(
                  isAplicada ? l.vacStepAppliedNote : l.vacStepScheduledNote,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme, S l) {
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
            l.vacStepCalendarReminder,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _seleccionarFechaAplicacion(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaAplicacion ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
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
      onFechaAplicacionChanged(fecha);
    }
  }
}
