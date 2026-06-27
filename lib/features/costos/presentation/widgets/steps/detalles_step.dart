/// Step 3: Detalles Adicionales del Gasto
/// Proveedor, número de factura y observaciones
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import 'package:smartgranjaavespro/core/utils/field_validators.dart';

import '../costo_form_field.dart';

/// Step de detalles adicionales (proveedor, factura, observaciones)
class DetallesStep extends StatelessWidget {
  const DetallesStep({
    super.key,
    required this.proveedorController,
    required this.numeroFacturaController,
    required this.observacionesController,
    this.autoValidate = false,
    this.loteSelector,
  });

  final TextEditingController proveedorController;
  final TextEditingController numeroFacturaController;
  final TextEditingController observacionesController;
  final bool autoValidate;

  /// Selector de lote opcional (solo para gastos directos: alimento/medicamento).
  final Widget? loteSelector;

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
            l.costoAdditionalDetails,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.costoAdditionalDetailsHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Selector de lote (solo para gastos directos)
          if (loteSelector != null) ...[
            loteSelector!,
            const SizedBox(height: 16),
          ],

          // Proveedor
          CostoFormField(
            controller: proveedorController,
            label: l.commonSupplier,
            hint: l.costoSupplierHint,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            maxLength: 100,
            required: true,
            autovalidateMode: autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            validator: FieldValidators.compose([
              FieldValidators.required(l.costoSupplierRequired),
              FieldValidators.minLength(l.costoSupplierMinLength, 3),
            ]),
          ),
          const SizedBox(height: 16),

          // Número de Factura
          CostoFormField(
            controller: numeroFacturaController,
            label: l.costoInvoiceLabel,
            hint: l.commonHintExample('F001-00001234'),
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            maxLength: 50,
          ),
          const SizedBox(height: 16),

          // Observaciones
          CostoFormField(
            controller: observacionesController,
            label: l.commonObservations,
            hint: l.costoObservationsHint,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            maxLines: 4,
            maxLength: 500,
          ),
        ],
      ),
    );
  }
}
