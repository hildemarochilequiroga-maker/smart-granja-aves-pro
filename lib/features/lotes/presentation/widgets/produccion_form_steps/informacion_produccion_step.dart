import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Step 1: Información de la Producción
class InformacionProduccionStep extends StatelessWidget {
  const InformacionProduccionStep({
    super.key,
    required this.huevosRecolectadosController,
    required this.huevosBuenosController,
    required this.fechaSeleccionada,
    required this.onSeleccionarFecha,
    required this.autoValidate,
    required this.cantidadAves,
    required this.onHuevosBuenosChanged,
  });

  final TextEditingController huevosRecolectadosController;
  final TextEditingController huevosBuenosController;
  final DateTime fechaSeleccionada;
  final VoidCallback onSeleccionarFecha;
  final bool autoValidate;
  final int cantidadAves;
  final VoidCallback onHuevosBuenosChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calcular porcentaje de postura estimado
    double porcentajePostura = 0;
    final huevosRecolect = int.tryParse(huevosRecolectadosController.text) ?? 0;
    if (cantidadAves > 0 && huevosRecolect > 0) {
      porcentajePostura = (huevosRecolect / cantidadAves) * 100;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormProductionInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormProductionInfoSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Huevos recolectados
          RegistroFormField(
            controller: huevosRecolectadosController,
            label: S.of(context).batchFormEggsCollected,
            hint: S.of(context).commonHintExample('850'),
            suffixText: S.of(context).batchFormUnits,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final cantidad = int.tryParse(value);
              if (cantidad == null || cantidad < 0) {
                return S.of(context).batchFormInvalidNumber;
              }
              return null;
            },
            onChanged: (_) => onHuevosBuenosChanged(),
          ),
          AppSpacing.gapBase,

          // Huevos buenos
          RegistroFormField(
            controller: huevosBuenosController,
            label: S.of(context).batchFormGoodEggs,
            hint: S.of(context).commonHintExample('830'),
            suffixText: S.of(context).batchFormUnits,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final buenos = int.tryParse(value);
              final recolectados =
                  int.tryParse(huevosRecolectadosController.text) ?? 0;

              if (buenos == null || buenos < 0) {
                return S.of(context).batchFormInvalidNumber;
              }
              if (buenos > recolectados) {
                return S.of(context).batchFormCannotExceedCollected;
              }
              return null;
            },
            onChanged: (_) => onHuevosBuenosChanged(),
          ),
          AppSpacing.gapBase,

          // Fecha
          RegistroFormField(
            label: S.of(context).batchFormDate,
            hint: DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
            readOnly: true,
            onTap: onSeleccionarFecha,
            initialValue: DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
          ),

          // Tarjeta informativa con porcentaje de postura
          if (huevosRecolect > 0) ...[
            AppSpacing.gapXl,
            _buildIndicadorPostura(context, theme, porcentajePostura),
          ],
        ],
      ),
    );
  }

  Widget _buildIndicadorPostura(
    BuildContext context,
    ThemeData theme,
    double porcentajePostura,
  ) {
    final colorIndicador = porcentajePostura >= 70
        ? theme.colorScheme.primary
        : porcentajePostura >= 50
        ? theme.colorScheme.tertiary
        : theme.colorScheme.error;

    final mensaje = porcentajePostura >= 70
        ? S.of(context).batchFormExcellentPerformance
        : porcentajePostura >= 50
        ? S.of(context).batchFormAcceptablePerformance
        : S.of(context).batchFormBelowExpectedPerformance;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorIndicador.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: colorIndicador.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchFormLayingIndicator,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorIndicador,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapSm,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).batchFormLayingPercentage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${porcentajePostura.toStringAsFixed(1)}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorIndicador,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.gapXxs,
          Text(
            mensaje,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
