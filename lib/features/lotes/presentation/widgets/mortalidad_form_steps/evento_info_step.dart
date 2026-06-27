/// Step 1: Información del Evento de Mortalidad
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/presentation/widgets/registro_pickers.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../salud/domain/enums/causa_mortalidad.dart';

/// Step 1: Información del Evento
class EventoInfoStep extends StatelessWidget {
  const EventoInfoStep({
    super.key,
    required this.cantidadController,
    required this.causaSeleccionada,
    required this.fechaEvento,
    required this.cantidadActual,
    required this.autoValidate,
    required this.onCausaChanged,
    required this.onFechaChanged,
    required this.fechaIngreso,
  });

  final TextEditingController cantidadController;
  final CausaMortalidad? causaSeleccionada;
  final DateTime fechaEvento;
  final int cantidadActual;
  final bool autoValidate;
  final void Function(CausaMortalidad?) onCausaChanged;
  final void Function(DateTime) onFechaChanged;
  final DateTime fechaIngreso;

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
            S.of(context).batchFormMortalityEventInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormMortalityEventSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Cantidad de aves muertas
          RegistroFormField(
            controller: cantidadController,
            label: S.of(context).batchFormDeathCount,
            hint: S.of(context).batchFormDeathCountHint,
            required: true,
            keyboardType: TextInputType.number,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final cantidad = int.tryParse(value);
              if (cantidad == null || cantidad <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              if (cantidad > cantidadActual) {
                return S.of(context).batchExceedsCurrentBirds(cantidadActual);
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Causa de la mortalidad
          RegistroSelectorField<CausaMortalidad>(
            label: S.of(context).batchFormCause,
            value: causaSeleccionada,
            required: true,
            hint: S.of(context).batchFormCauseHint,
            options: CausaMortalidad.values,
            labelOf: (causa) => causa.localizedName(S.of(context)),
            subtitleOf: (causa) => causa.localizedDescripcion(S.of(context)),
            colorOf: _getCausaColor,
            onSelected: onCausaChanged,
          ),
          AppSpacing.gapBase,

          // Fecha del evento
          RegistroDateField(
            label: S.of(context).batchFormDate,
            value: fechaEvento,
            firstDate: fechaIngreso,
            lastDate: DateTime.now(),
            onChanged: onFechaChanged,
          ),
        ],
      ),
    );
  }

  Color _getCausaColor(CausaMortalidad causa) {
    switch (causa) {
      case CausaMortalidad.enfermedad:
        return AppColors.error;
      case CausaMortalidad.accidente:
        return AppColors.warning;
      case CausaMortalidad.estres:
        return AppColors.amber;
      case CausaMortalidad.desnutricion:
        return AppColors.brown;
      case CausaMortalidad.metabolica:
        return AppColors.purple;
      case CausaMortalidad.depredacion:
        return AppColors.deepOrange;
      case CausaMortalidad.sacrificio:
        return AppColors.outline;
      case CausaMortalidad.vejez:
        return AppColors.outline;
      case CausaMortalidad.desconocida:
        return AppColors.grey400;
    }
  }
}
