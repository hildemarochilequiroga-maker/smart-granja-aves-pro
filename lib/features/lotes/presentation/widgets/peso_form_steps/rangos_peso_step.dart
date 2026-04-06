/// Step 2: Rangos de Peso
/// Diseño consistente con crear_granja y crear_galpon
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';

/// Step 2: Rangos de Peso
class RangosPesoStep extends StatelessWidget {
  const RangosPesoStep({
    super.key,
    required this.formKey,
    required this.pesoMinimoController,
    required this.pesoMaximoController,
    required this.observacionesController,
    required this.onPesoChanged,
    required this.autoValidate,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController pesoMinimoController;
  final TextEditingController pesoMaximoController;
  final TextEditingController observacionesController;
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
            S.of(context).batchFormWeightRanges,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batchFormWeightRangesSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Peso mínimo
          RegistroFormField(
            controller: pesoMinimoController,
            label: S.of(context).batchFormWeightMin,
            hint: S.of(context).commonHintExample('2200'),
            suffixText: 'g',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onPesoChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final peso = double.tryParse(value);
              if (peso == null || peso <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Peso máximo
          RegistroFormField(
            controller: pesoMaximoController,
            label: S.of(context).batchFormWeightMax,
            hint: S.of(context).commonHintExample('2800'),
            suffixText: 'g',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onPesoChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final peso = double.tryParse(value);
              if (peso == null || peso <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Observaciones
          RegistroFormField(
            controller: observacionesController,
            label:
                '${S.of(context).batchFormObservations} (${S.of(context).batchFormOptional})',
            hint: S.of(context).batchFormWeightObsHint,
            maxLines: 4,
            maxLength: 500,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: (value) => null,
          ),
        ],
      ),
    );
  }
}
