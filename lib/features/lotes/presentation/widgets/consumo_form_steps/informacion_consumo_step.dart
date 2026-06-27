/// Step 1: Información del Consumo
/// Incluye cantidad, tipo, costo y fecha
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/presentation/widgets/registro_pickers.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/enums/tipo_alimento.dart';

/// Step 1: Información del Consumo
class InformacionConsumoStep extends StatelessWidget {
  const InformacionConsumoStep({
    super.key,
    required this.formKey,
    required this.cantidadKgController,
    required this.fechaSeleccionada,
    required this.fechaIngreso,
    required this.tipoSeleccionado,
    required this.onFechaChanged,
    required this.onTipoChanged,
    required this.onCantidadChanged,
    required this.autoValidate,
    required this.edadDias,
    required this.tipoRecomendado,
    required this.costoPorKgController,
    required this.onCostoPorKgChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController cantidadKgController;
  final DateTime fechaSeleccionada;
  final DateTime fechaIngreso;
  final TipoAlimento tipoSeleccionado;
  final ValueChanged<DateTime> onFechaChanged;
  final ValueChanged<TipoAlimento?> onTipoChanged;
  final VoidCallback onCantidadChanged;
  final bool autoValidate;
  final int edadDias;
  final TipoAlimento tipoRecomendado;
  final TextEditingController costoPorKgController;
  final VoidCallback onCostoPorKgChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noEsRecomendado = !tipoSeleccionado.esApropiado(edadDias);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.base,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchFormConsumptionInfo,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchFormConsumptionSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Cantidad de alimento
          RegistroFormField(
            controller: cantidadKgController,
            label: S.of(context).batchFormQuantityKg,
            hint: S.of(context).batchFormQuantityHint,
            suffixText: 'kg',
            required: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onCantidadChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchRequiredField;
              }
              final cantidad = double.tryParse(value);
              if (cantidad == null || cantidad <= 0) {
                return S.of(context).batchMustBeGreaterThanZero;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Tipo de alimento
          RegistroSelectorField<TipoAlimento>(
            label: S.of(context).batchFormFoodType,
            value: tipoSeleccionado,
            required: true,
            options: TipoAlimento.values,
            labelOf: (tipo) => tipo.localizedDescripcion(S.of(context)),
            subtitleOf: (tipo) =>
                tipo.localizedRangoEdadDescripcion(S.of(context)),
            colorOf: _getTipoAlimentoColor,
            trailingOf: (tipo) => tipo.esApropiado(edadDias)
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  )
                : null,
            onSelected: onTipoChanged,
          ),

          // Advertencia si no es el tipo recomendado
          if (noEsRecomendado) ...[
            AppSpacing.gapMd,
            FormInfoRow(
              text: S
                  .of(context)
                  .feedRecommendedForDays(
                    edadDias.toString(),
                    tipoRecomendado.localizedDescripcion(S.of(context)),
                  ),
              type: InfoCardType.warning,
            ),
          ],
          AppSpacing.gapBase,

          // Costo por kg (opcional)
          RegistroFormField(
            controller: costoPorKgController,
            label:
                '${S.of(context).batchFormCostPerKg} (${S.of(context).batchFormOptional})',
            hint: S.of(context).batchFormCostHint,
            suffixText: '\$/kg',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onCostoPorKgChanged(),
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  double.tryParse(value) == null) {
                return S.of(context).batchInvalidNumber;
              }
              return null;
            },
          ),
          AppSpacing.gapBase,

          // Fecha del registro
          RegistroDateField(
            label: S.of(context).feedConsumptionDate,
            value: fechaSeleccionada,
            firstDate: fechaIngreso,
            lastDate: DateTime.now(),
            onChanged: onFechaChanged,
          ),
        ],
      ),
    );
  }

  Color _getTipoAlimentoColor(TipoAlimento tipo) {
    switch (tipo) {
      case TipoAlimento.preIniciador:
        return AppColors.amber;
      case TipoAlimento.iniciador:
        return AppColors.lightGreen;
      case TipoAlimento.crecimiento:
        return AppColors.info;
      case TipoAlimento.finalizador:
        return AppColors.deepOrange;
      case TipoAlimento.postura:
        return AppColors.pink;
      case TipoAlimento.levante:
        return AppColors.cyan;
      case TipoAlimento.medicado:
        return AppColors.error;
      case TipoAlimento.concentrado:
        return AppColors.purple;
      case TipoAlimento.otro:
        return AppColors.outline;
    }
  }
}
