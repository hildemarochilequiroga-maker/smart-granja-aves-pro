/// Step 1: Información del Consumo
/// Incluye cantidad, tipo, costo, fecha y selección de alimento del inventario
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/form_widgets.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../inventario/domain/entities/item_inventario.dart';
import '../../../domain/enums/tipo_alimento.dart';
import 'selector_alimento_inventario.dart';

/// Step 1: Información del Consumo
class InformacionConsumoStep extends StatelessWidget {
  const InformacionConsumoStep({
    super.key,
    required this.formKey,
    required this.cantidadKgController,
    required this.fechaSeleccionada,
    required this.tipoSeleccionado,
    required this.onSeleccionarFecha,
    required this.onTipoChanged,
    required this.onCantidadChanged,
    required this.autoValidate,
    required this.edadDias,
    required this.tipoRecomendado,
    required this.costoPorKgController,
    required this.onCostoPorKgChanged,
    required this.granjaId,
    this.itemInventarioSeleccionado,
    this.onItemInventarioChanged,
    this.stockDisponible,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController cantidadKgController;
  final DateTime fechaSeleccionada;
  final TipoAlimento tipoSeleccionado;
  final VoidCallback onSeleccionarFecha;
  final ValueChanged<TipoAlimento?> onTipoChanged;
  final VoidCallback onCantidadChanged;
  final bool autoValidate;
  final int edadDias;
  final TipoAlimento tipoRecomendado;
  final TextEditingController costoPorKgController;
  final VoidCallback onCostoPorKgChanged;
  final String granjaId;
  final ItemInventario? itemInventarioSeleccionado;
  final void Function(ItemInventario?)? onItemInventarioChanged;

  /// Stock disponible del item seleccionado (null si no hay item seleccionado)
  final double? stockDisponible;

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

          // Selector de alimento del inventario
          if (onItemInventarioChanged != null) ...[
            SelectorAlimentoInventario(
              granjaId: granjaId,
              itemSeleccionado: itemInventarioSeleccionado,
              onItemSelected: onItemInventarioChanged!,
            ),
            AppSpacing.gapLg,
          ],

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
              // Validar stock disponible si hay un item de inventario seleccionado
              if (stockDisponible != null && cantidad > stockDisponible!) {
                return S
                    .of(context)
                    .insufficientStock(stockDisponible!.toStringAsFixed(1));
              }
              return null;
            },
          ),
          // Mostrar advertencia de stock si se acerca al límite
          if (itemInventarioSeleccionado != null &&
              stockDisponible != null) ...[
            AppSpacing.gapSm,
            Builder(
              builder: (context) {
                final cantidad =
                    double.tryParse(cantidadKgController.text) ?? 0;
                final porcentajeUso = stockDisponible! > 0
                    ? (cantidad / stockDisponible! * 100)
                    : 0.0;

                if (cantidad > stockDisponible!) {
                  return FormInfoRow(
                    text: S
                        .of(context)
                        .feedExceedsStock(stockDisponible!.toStringAsFixed(1)),
                    type: InfoCardType.error,
                  );
                } else if (porcentajeUso >= 80) {
                  return FormInfoRow(
                    text: S
                        .of(context)
                        .feedStockPercentUsage(
                          porcentajeUso.toStringAsFixed(0),
                        ),
                    type: InfoCardType.warning,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
          AppSpacing.gapBase,

          // Tipo de alimento
          RegistroDropdownField<TipoAlimento>(
            label: S.of(context).batchFormFoodType,
            value: tipoSeleccionado,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            selectedItemBuilder: (context) {
              return TipoAlimento.values.map((tipo) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getTipoAlimentoColor(tipo),
                          shape: BoxShape.circle,
                        ),
                      ),
                      AppSpacing.hGapSm,
                      Text(tipo.localizedDescripcion(S.of(context))),
                    ],
                  ),
                );
              }).toList();
            },
            items: TipoAlimento.values.map((tipo) {
              final esRecomendado = tipo.esApropiado(edadDias);
              return DropdownMenuItem(
                value: tipo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getTipoAlimentoColor(tipo),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tipo.localizedDescripcion(S.of(context)),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              tipo.localizedRangoEdadDescripcion(S.of(context)),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (esRecomendado) ...[
                        AppSpacing.hGapSm,
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: onTipoChanged,
            validator: (value) => null,
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
          _FechaConsumoField(
            fechaSeleccionada: fechaSeleccionada,
            onTap: onSeleccionarFecha,
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

/// Campo de fecha con estilo consistente
class _FechaConsumoField extends StatelessWidget {
  const _FechaConsumoField({
    required this.fechaSeleccionada,
    required this.onTap,
  });

  final DateTime fechaSeleccionada;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).feedConsumptionDate,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allSm,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.base,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
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
}
