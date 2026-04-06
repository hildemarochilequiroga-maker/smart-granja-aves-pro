/// Sección de información de venta para cerrar lote.
///
/// Widget modular para capturar datos de venta
/// del lote al momento del cierre.
library;

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Widget para capturar información de venta
class SaleInfoSection extends StatelessWidget {
  const SaleInfoSection({
    super.key,
    required this.pesoFinalController,
    required this.precioVentaController,
    required this.compradorController,
    required this.fechaCierre,
    required this.onFechaCierreChanged,
    required this.autoValidate,
    required this.cantidadActual,
  });

  final TextEditingController pesoFinalController;
  final TextEditingController precioVentaController;
  final TextEditingController compradorController;
  final DateTime fechaCierre;
  final void Function(DateTime) onFechaCierreChanged;
  final bool autoValidate;
  final int cantidadActual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calcular valor total
    final precioKg = double.tryParse(precioVentaController.text) ?? 0;
    final pesoGramos = double.tryParse(pesoFinalController.text) ?? 0;
    final pesoKg = pesoGramos / 1000;
    final valorTotal = cantidadActual * pesoKg * precioKg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha de cierre
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: fechaCierre,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              locale: const Locale('es', 'ES'),
            );
            if (picked != null) {
              onFechaCierreChanged(picked);
            }
          },
          borderRadius: AppRadius.allMd,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: S.of(context).batchCloseDate,
              prefixIcon: Icon(
                Icons.calendar_today,
                color: colorScheme.onSurface,
              ),
              helperText: S.of(context).batchCloseDateHelper,
              helperMaxLines: 2,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allMd,
                borderSide: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(fechaCierre),
                  style: theme.textTheme.bodyLarge,
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Peso final promedio
        TextFormField(
          controller: pesoFinalController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          decoration: InputDecoration(
            labelText: S.of(context).batchCloseFinalWeightLabel,
            hintText: '2500',
            helperText: S.of(context).batchCloseWeightHelper,
            helperMaxLines: 2,
            prefixIcon: Icon(Icons.scale, color: colorScheme.onSurface),
            suffixText: S.of(context).batchCloseGrams,
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.info, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return S.of(context).batchCloseWeightRequired;
            }
            final peso = double.tryParse(value);
            if (peso == null) {
              return S.of(context).batchCloseEnterValidNumber;
            }
            if (peso <= 0) {
              return S.of(context).batchCloseWeightMustBePositive;
            }
            if (peso > 10000) {
              return S.of(context).batchCloseWeightTooHigh;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Precio de venta por kg (opcional)
        TextFormField(
          controller: precioVentaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
          ],
          decoration: InputDecoration(
            labelText: S.of(context).batchCloseSalePriceLabel,
            hintText: '3.50',
            helperText: S.of(context).batchCloseSalePriceHelper,
            helperMaxLines: 2,
            prefixIcon: Icon(Icons.attach_money, color: colorScheme.onSurface),
            suffixText: '\$/kg',
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.info, width: 2),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        // Valor total calculado
        if (precioKg > 0 && pesoGramos > 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).batchCloseBirdsToSell,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '$cantidadActual ${S.of(context).batchCloseBirdsUnit}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).batchCloseEstimatedWeight,
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${(cantidadActual * pesoKg).toStringAsFixed(1)} kg',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).batchCloseEstimatedValue,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${valorTotal.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),

        // Comprador (opcional)
        TextFormField(
          controller: compradorController,
          decoration: InputDecoration(
            labelText: S.of(context).batchCloseBuyerLabel,
            hintText: S.of(context).batchCloseBuyerHint,
            prefixIcon: Icon(Icons.person, color: colorScheme.onSurface),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: const BorderSide(color: AppColors.info, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
