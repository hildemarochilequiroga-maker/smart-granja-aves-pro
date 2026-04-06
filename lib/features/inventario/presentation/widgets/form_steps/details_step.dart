/// Step 3: Detalles adicionales del Item de Inventario
/// Precio, proveedor, ubicación, vencimiento, imagen
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/utils/formatters.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../granjas/presentation/widgets/granja_form_field.dart';
import '../../../domain/enums/enums.dart';
import 'imagen_producto_section.dart';

/// Step de detalles adicionales del item
class InventarioDetailsStep extends StatelessWidget {
  const InventarioDetailsStep({
    super.key,
    required this.precioController,
    required this.proveedorController,
    required this.ubicacionController,
    required this.loteProveedorController,
    required this.tipoSeleccionado,
    required this.fechaVencimiento,
    required this.onFechaVencimientoChanged,
    required this.imagenSeleccionada,
    required this.imagenUrlExistente,
    required this.onPickImage,
    required this.onRemoveImage,
    this.autoValidate = false,
  });

  final TextEditingController precioController;
  final TextEditingController proveedorController;
  final TextEditingController ubicacionController;
  final TextEditingController loteProveedorController;
  final TipoItem tipoSeleccionado;
  final DateTime? fechaVencimiento;
  final void Function(DateTime?) onFechaVencimientoChanged;
  final XFile? imagenSeleccionada;
  final String? imagenUrlExistente;
  final Future<void> Function(ImageSource) onPickImage;
  final VoidCallback onRemoveImage;
  final bool autoValidate;

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
            l.invAdditionalDetails,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            l.invOptionalDetails,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          AppSpacing.gapXl,

          // Precio
          GranjaFormField(
            controller: precioController,
            label: l.invUnitPriceLabel,
            hint: '0.00',
            prefixText: Formatters.currencyPrefix,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
          ),
          AppSpacing.gapBase,

          // Proveedor
          GranjaFormField(
            controller: proveedorController,
            label: l.commonSupplier,
            hint: l.invSupplierNameLabel,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          AppSpacing.gapBase,

          // Ubicación
          GranjaFormField(
            controller: ubicacionController,
            label: l.invLocationWarehouse,
            hint: l.invWarehouseExample,
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
          ),

          // Vencimiento (solo si el tipo lo permite)
          if (tipoSeleccionado.tieneVencimiento) ...[
            AppSpacing.gapXl,
            _buildVencimientoSection(context, theme),
          ],

          AppSpacing.gapXl,

          // Sección de imagen del producto
          ImagenProductoSection(
            imagenSeleccionada: imagenSeleccionada,
            imagenUrlExistente: imagenUrlExistente,
            onPickImage: onPickImage,
            onRemoveImage: onRemoveImage,
          ),

          AppSpacing.gapXl,

          // Card informativa
          _buildInfoCard(context),
        ],
      ),
    );
  }

  Widget _buildVencimientoSection(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.inventoryExpiration,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapMd,

        // Fecha de vencimiento
        _buildFechaVencimientoTile(context, theme),
        AppSpacing.gapBase,

        // Lote del proveedor
        GranjaFormField(
          controller: loteProveedorController,
          label: l.invSupplierBatchLabel,
          hint: l.invSupplierBatchNumber,
          maxLength: 50,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildFechaVencimientoTile(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.invExpirationDate,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        AppSpacing.gapSm,
        InkWell(
          onTap: () => _seleccionarFecha(context),
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
                    fechaVencimiento != null
                        ? DateFormat('dd/MM/yyyy').format(fechaVencimiento!)
                        : l.inventorySelectDate,
                    style: fechaVencimiento != null
                        ? theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                          )
                        : theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                  ),
                ),
                if (fechaVencimiento != null)
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.colorScheme.outline,
                      size: 20,
                    ),
                    onPressed: () => onFechaVencimientoChanged(null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
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
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate:
          fechaVencimiento ?? DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      onFechaVencimientoChanged(fecha);
    }
  }

  Widget _buildInfoCard(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: AppRadius.allSm,
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.commonImportantInfo,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            l.invOptionalDetailsInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
