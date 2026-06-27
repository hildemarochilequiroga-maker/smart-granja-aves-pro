/// Step 2: Monto y Fecha del Gasto
/// Captura del concepto, el monto y la fecha del gasto.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/presentation/widgets/registro_pickers.dart';
import '../../../../../core/utils/field_validators.dart';
import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../lotes/domain/enums/tipo_alimento.dart';
import '../../../domain/enums/tipo_gasto.dart';
import '../costo_form_field.dart';

/// Step de monto y fecha del gasto.
class MontoStep extends StatelessWidget {
  const MontoStep({
    super.key,
    required this.conceptoController,
    required this.montoController,
    required this.fecha,
    required this.onFechaChanged,
    this.autoValidate = false,
    this.esCompraAves = false,
    this.cantidadAves,
    this.costoPorAveController,
    this.onMontoTotalChanged,
    this.onCostoPorAveChanged,
    this.tipoGasto,
    this.tipoAlimento,
    this.onTipoAlimentoChanged,
  });

  final TextEditingController conceptoController;
  final TextEditingController montoController;
  final DateTime fecha;
  final ValueChanged<DateTime> onFechaChanged;
  final bool autoValidate;

  /// Si el gasto es de compra de aves: muestra el campo "costo por ave"
  /// enlazado con el monto total usando [cantidadAves].
  final bool esCompraAves;

  /// Cantidad de aves del lote asignado (para enlazar total ↔ por ave).
  final int? cantidadAves;

  /// Controller del costo por ave (solo compra de aves).
  final TextEditingController? costoPorAveController;

  /// Llamado cuando el usuario edita el monto TOTAL (para recalcular por ave).
  final VoidCallback? onMontoTotalChanged;

  /// Llamado cuando el usuario edita el costo POR AVE (para recalcular total).
  final VoidCallback? onCostoPorAveChanged;

  /// Tipo de gasto seleccionado (para el hint dinámico del concepto).
  final TipoGasto? tipoGasto;

  /// Tipo de alimento seleccionado (solo cuando [tipoGasto] es alimento). Para
  /// alimento, el selector reemplaza al campo de texto libre del concepto.
  final TipoAlimento? tipoAlimento;

  /// Llamado al elegir un tipo de alimento en el bottom sheet.
  final ValueChanged<TipoAlimento>? onTipoAlimentoChanged;

  static String _conceptoHint(TipoGasto? tipo) {
    return switch (tipo) {
      TipoGasto.compraAves => 'Ej: Compra de 500 pollitos Ross 308',
      TipoGasto.alimento => 'Ej: Compra de alimento balanceado iniciador',
      TipoGasto.medicamento => 'Ej: Vacuna Newcastle + Gumboro',
      TipoGasto.cama => 'Ej: Viruta de pino para galpón 1',
      TipoGasto.manoDeObra => 'Ej: Jornales semana del 01/06',
      TipoGasto.energia => 'Ej: Factura eléctrica junio',
      TipoGasto.agua => 'Ej: Consumo de agua junio',
      TipoGasto.mantenimiento => 'Ej: Reparación de bebederos',
      TipoGasto.transporte => 'Ej: Flete de aves al mercado',
      TipoGasto.administrativo => 'Ej: Útiles de oficina',
      TipoGasto.depreciacion => 'Ej: Depreciación mensual galpón',
      TipoGasto.financiero => 'Ej: Intereses préstamo junio',
      TipoGasto.otros => 'Ej: Gasto varios',
      null => 'Ej: Compra de alimento balanceado',
    };
  }

  Future<void> _selectDate(BuildContext context) async {
    unawaited(HapticFeedback.selectionClick());
    final DateTime? picked = await showRegistroDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != fecha) {
      onFechaChanged(picked);
    }
  }

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
            l.costoAmountTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.costoAmountHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Campo concepto: para alimento, un selector de tipo de alimento
          // reemplaza el texto libre; para el resto, campo de texto normal.
          if (tipoGasto == TipoGasto.alimento)
            _SelectorTipoAlimento(
              seleccionado: tipoAlimento,
              autoValidate: autoValidate,
              mensajeRequerido: l.costoFeedTypeRequired,
              onSelected: (tipo) {
                conceptoController.text = tipo.displayName;
                onTipoAlimentoChanged?.call(tipo);
              },
            )
          else
            CostoFormField(
              controller: conceptoController,
              label: l.costoConceptLabel,
              hint: _conceptoHint(tipoGasto),
              required: true,
              maxLines: 2,
              maxLength: 200,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              autovalidateMode: autoValidate
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction,
              validator: FieldValidators.compose([
                FieldValidators.required(l.costoConceptRequired),
                FieldValidators.minLength(l.costoConceptMinLength, 5),
              ]),
            ),
          AppSpacing.gapBase,

          // Campo de monto (total)
          CostoFormField(
            controller: montoController,
            label: esCompraAves ? l.costoTotalPurchaseLabel : l.costoAmountLabel,
            hint: l.commonHintExample('0.00'),
            required: true,
            prefixText: Formatters.currencyPrefix,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: esCompraAves ? (_) => onMontoTotalChanged?.call() : null,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: FieldValidators.positiveNumber(
              requiredMessage: l.costoAmountRequired,
              invalidMessage: l.costoAmountInvalid,
            ),
          ),

          // Campo costo por ave (solo compra de aves, enlazado con el total)
          if (esCompraAves) ...[
            AppSpacing.gapBase,
            CostoFormField(
              controller: costoPorAveController!,
              label: l.costoPerBirdLabel,
              hint: l.commonHintExample('0.00'),
              prefixText: Formatters.currencyPrefix,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
              ],
              textInputAction: TextInputAction.done,
              onChanged: (_) => onCostoPorAveChanged?.call(),
            ),
            AppSpacing.gapSm,
            Text(
              cantidadAves != null && cantidadAves! > 0
                  ? l.costoPurchaseBirdsBasis(cantidadAves.toString())
                  : l.costoPurchaseNoBatch,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          AppSpacing.gapXl,

          // Fecha del gasto
          Text(
            l.costoDateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.gapSm,
          InkWell(
            onTap: () => _selectDate(context),
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
                      DateFormat('dd/MM/yyyy').format(fecha),
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
      ),
    );
  }

}

/// Selector de tipo de alimento que reemplaza el campo de concepto cuando el
/// gasto es de tipo alimento. Es un [FormField] para integrarse con la
/// validación del formulario (obligatorio). Abre un bottom sheet con los
/// tipos de alimento y, al elegir, fija el concepto del costo.
class _SelectorTipoAlimento extends FormField<TipoAlimento> {
  _SelectorTipoAlimento({
    required TipoAlimento? seleccionado,
    required ValueChanged<TipoAlimento> onSelected,
    required bool autoValidate,
    required String mensajeRequerido,
  }) : super(
          initialValue: seleccionado,
          autovalidateMode: autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          validator: (value) => value == null ? mensajeRequerido : null,
          builder: (state) {
            final context = state.context;
            final theme = Theme.of(context);
            final l = S.of(context);
            final value = state.value;
            final tieneError = state.hasError;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.costoFeedTypeLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                AppSpacing.gapSm,
                InkWell(
                  borderRadius: AppRadius.allSm,
                  onTap: () async {
                    final elegido = await _mostrarSheet(context, value);
                    if (elegido != null) {
                      state.didChange(elegido);
                      onSelected(elegido);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      errorText: tieneError ? state.errorText : null,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.allSm,
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.allSm,
                        borderSide: BorderSide(
                          color: tieneError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outline.withValues(alpha: 0.4),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (value != null) ...[
                          Text(value.icono,
                              style: const TextStyle(fontSize: 20)),
                          AppSpacing.hGapMd,
                        ],
                        Expanded(
                          child: Text(
                            value?.localizedDisplayName(l) ??
                                l.costoFeedTypeHint,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: value == null
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );

  static Future<TipoAlimento?> _mostrarSheet(
    BuildContext context,
    TipoAlimento? actual,
  ) {
    final l = S.of(context);
    return showAppBottomSheet<TipoAlimento>(
      context: context,
      title: l.costoFeedTypeLabel,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tipo in TipoAlimento.values)
            AppSheetOptionTile(
              leading: Text(tipo.icono, style: const TextStyle(fontSize: 22)),
              label: tipo.localizedDisplayName(l),
              subtitle: tipo.localizedRangoEdadDescripcion(l),
              selected: tipo == actual,
              onTap: () => Navigator.of(ctx).pop(tipo),
            ),
        ],
      ),
    );
  }
}
