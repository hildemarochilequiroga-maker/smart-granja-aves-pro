/// Step 3: Observaciones del consumo.
///
/// Widget modular para capturar notas y observaciones
/// adicionales sobre el consumo de alimento.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import 'package:smartgranjaavespro/core/theme/app_radius.dart';

/// Step 3: Observaciones del Consumo
class ObservacionesConsumoStep extends StatelessWidget {
  const ObservacionesConsumoStep({
    super.key,
    required this.observacionesController,
    required this.autoValidate,
    required this.resumenConsumo,
  });

  final TextEditingController observacionesController;
  final bool autoValidate;
  final Map<String, String> resumenConsumo;

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
            S.of(context).batchFormObservations,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            S.of(context).batchFormObservationsSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),

          // Resumen del consumo
          _ResumenCard(theme: theme, resumenConsumo: resumenConsumo),
          const SizedBox(height: 16),

          // Observaciones
          RegistroFormField(
            controller: observacionesController,
            label: S.of(context).batchFormObservations,
            hint: S.of(context).batchFormObservationsHint,
            maxLines: 6,
            maxLength: 500,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) => null,
          ),
          const SizedBox(height: 24),

          // Info card
          FormInfoRow(
            text: S.of(context).batchFormConsumptionSaveNote,
            type: InfoCardType.info,
          ),
        ],
      ),
    );
  }
}

/// Card de resumen del registro
class _ResumenCard extends StatelessWidget {
  const _ResumenCard({required this.theme, required this.resumenConsumo});

  final ThemeData theme;
  final Map<String, String> resumenConsumo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).batchFormCalculatedMetrics,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...resumenConsumo.entries.map((entry) {
            return _ResumenRow(
              label: entry.key,
              value: entry.value,
              theme: theme,
            );
          }),
        ],
      ),
    );
  }
}

/// Fila de resumen individual
class _ResumenRow extends StatelessWidget {
  const _ResumenRow({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
