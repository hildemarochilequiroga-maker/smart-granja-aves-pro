/// Step 1: Información del Pesaje
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/presentation/widgets/registro_pickers.dart';
import '../../../../../core/utils/field_validators.dart';
import '../../../domain/enums/metodo_pesaje.dart';

/// Step 1: Información del Pesaje
class InformacionPesajeStep extends StatelessWidget {
  const InformacionPesajeStep({
    super.key,
    required this.formKey,
    required this.pesoPromedioController,
    required this.cantidadAvesController,
    required this.fechaSeleccionada,
    required this.fechaIngreso,
    required this.metodoSeleccionado,
    required this.onFechaChanged,
    required this.onMetodoChanged,
    required this.onPesoChanged,
    required this.autoValidate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController pesoPromedioController;
  final TextEditingController cantidadAvesController;
  final DateTime fechaSeleccionada;
  final DateTime fechaIngreso;
  final MetodoPesaje metodoSeleccionado;
  final ValueChanged<DateTime> onFechaChanged;
  final ValueChanged<MetodoPesaje?> onMetodoChanged;
  final VoidCallback onPesoChanged;
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
            S.of(context).batchFormWeightInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batchFormWeightSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Peso promedio
          RegistroFormField(
            controller: pesoPromedioController,
            label: S.of(context).batchFormWeight,
            hint: S.of(context).batchFormWeightHint,
            suffixText: 'g',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onPesoChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: FieldValidators.positiveNumber(
              requiredMessage: S.of(context).batchRequiredField,
              invalidMessage: S.of(context).batchMustBeGreaterThanZero,
            ),
          ),
          const SizedBox(height: 16),

          // Cantidad de aves pesadas
          RegistroFormField(
            controller: cantidadAvesController,
            label: S.of(context).batchFormSampleSize,
            hint: S.of(context).batchFormSampleSizeHint,
            suffixText: S.of(context).commonBirdsUnit,
            required: true,
            keyboardType: TextInputType.number,
            onChanged: (_) => onPesoChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: FieldValidators.intRange(
              requiredMessage: S.of(context).batchRequiredField,
              invalidMessage: S.of(context).batchMustBeGreaterThanZero,
              min: 1,
            ),
          ),
          const SizedBox(height: 16),

          // Método de pesaje
          RegistroSelectorField<MetodoPesaje>(
            label: S.of(context).batchFormWeightMethod,
            value: metodoSeleccionado,
            required: true,
            options: MetodoPesaje.values,
            labelOf: (metodo) => metodo.localizedDescripcion(S.of(context)),
            subtitleOf: (metodo) =>
                metodo.localizedDescripcionDetallada(S.of(context)),
            colorOf: (metodo) => metodo.color,
            onSelected: onMetodoChanged,
          ),
          const SizedBox(height: 16),

          // Fecha del pesaje
          RegistroDateField(
            label: S.of(context).batchFormDate,
            value: fechaSeleccionada,
            firstDate: fechaIngreso,
            lastDate: DateTime.now(),
            onChanged: onFechaChanged,
          ),
        ],
      ),
    );
  }
}
