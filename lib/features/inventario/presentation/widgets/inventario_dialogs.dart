/// Sistema de dialogs unificado para el feature de inventario.
///
/// Proporciona dialogs consistentes con la misma apariencia visual
/// para todas las operaciones de confirmación.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/providers.dart';
import '../../application/services/inventario_costos_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Tipos de dialogs disponibles.
enum InventarioDialogType { success, warning, error, info }

/// Configuración para un dialog de confirmación.
class InventarioDialogConfig {
  const InventarioDialogConfig({
    required this.title,
    required this.message,
    required this.type,
    this.confirmText,
    this.cancelText,
    this.infoText,
    this.icon,
  });

  final String title;
  final String message;
  final InventarioDialogType type;
  final String? confirmText;
  final String? cancelText;
  final String? infoText;
  final IconData? icon;

  /// Obtiene el color según el tipo.
  Color get color => switch (type) {
    InventarioDialogType.success => AppColors.success,
    InventarioDialogType.warning => AppColors.warning,
    InventarioDialogType.error => AppColors.error,
    InventarioDialogType.info => AppColors.primary,
  };

  /// Obtiene el icono según el tipo.
  IconData get defaultIcon =>
      icon ??
      switch (type) {
        InventarioDialogType.success => Icons.check_circle_outline,
        InventarioDialogType.warning => Icons.warning_amber_rounded,
        InventarioDialogType.error => Icons.error_outline,
        InventarioDialogType.info => Icons.info_outline,
      };
}

/// Sistema de dialogs unificados para inventario.
abstract class InventarioDialogs {
  const InventarioDialogs._();

  /// Muestra un dialog de confirmación genérico.
  static Future<bool> showConfirmDialog(
    BuildContext context,
    InventarioDialogConfig config,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _InventarioConfirmDialog(config: config),
    );
    return result ?? false;
  }

  /// Dialog para registrar entrada de inventario.
  static Future<bool> showRegistrarEntradaDialog(
    BuildContext context,
    WidgetRef ref,
    ItemInventario item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          _RegistrarMovimientoDialog(item: item, esEntrada: true, ref: ref),
    );
    return result ?? false;
  }

  /// Dialog para registrar salida de inventario.
  static Future<bool> showRegistrarSalidaDialog(
    BuildContext context,
    WidgetRef ref,
    ItemInventario item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          _RegistrarMovimientoDialog(item: item, esEntrada: false, ref: ref),
    );
    return result ?? false;
  }

  /// Dialog para ajustar stock.
  static Future<bool> showAjustarStockDialog(
    BuildContext context,
    WidgetRef ref,
    ItemInventario item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _AjustarStockDialog(item: item, ref: ref),
    );
    return result ?? false;
  }

  /// Dialog para eliminar item.
  static Future<bool> showEliminarItemDialog(
    BuildContext context,
    ItemInventario item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _EliminarItemDialog(item: item),
    );
    return result ?? false;
  }
}

/// Widget interno para dialog de confirmación.
class _InventarioConfirmDialog extends StatelessWidget {
  const _InventarioConfirmDialog({required this.config});

  final InventarioDialogConfig config;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        config.title,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: config.type == InventarioDialogType.error
              ? AppColors.error
              : AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: _buildContent(),
      actions: _buildActions(context),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          config.message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (config.infoText != null) ...[
          const SizedBox(height: AppSpacing.base),
          _buildInfoBox(),
        ],
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        config.infoText!,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
        ),
        child: Text(config.cancelText ?? S.of(context).commonCancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        style: FilledButton.styleFrom(
          backgroundColor: config.color,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
        child: Text(config.confirmText ?? S.of(context).commonConfirm),
      ),
    ];
  }
}

/// Widget interno para dialog de registrar movimiento (entrada/salida).
class _RegistrarMovimientoDialog extends StatefulWidget {
  const _RegistrarMovimientoDialog({
    required this.item,
    required this.esEntrada,
    required this.ref,
  });

  final ItemInventario item;
  final bool esEntrada;
  final WidgetRef ref;

  @override
  State<_RegistrarMovimientoDialog> createState() =>
      _RegistrarMovimientoDialogState();
}

class _RegistrarMovimientoDialogState
    extends State<_RegistrarMovimientoDialog> {
  S get l => S.of(context);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cantidadController;
  late TextEditingController _motivoController;
  late TextEditingController _costoController;
  late TextEditingController _proveedorController;
  late TipoMovimiento _tipoSeleccionado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController();
    _motivoController = TextEditingController();
    _costoController = TextEditingController();
    _proveedorController = TextEditingController(
      text: widget.item.proveedor ?? '',
    );
    _tipoSeleccionado = widget.esEntrada
        ? TipoMovimiento.compra
        : TipoMovimiento.consumoLote;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _motivoController.dispose();
    _costoController.dispose();
    _proveedorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l = S.of(context);
    final color = widget.esEntrada ? AppColors.success : AppColors.warning;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
      backgroundColor: colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header con título
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.esEntrada
                                  ? l.invDialogRegisterEntry
                                  : l.invDialogRegisterExit,
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxxs),
                            Text(
                              widget.item.nombre,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, false),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                          foregroundColor: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Info del item actual
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.onSurface.withValues(alpha: 0.05),
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          color: AppColors.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            S
                                .of(context)
                                .invStockInfoFormat(
                                  widget.item.stockActual.toString(),
                                  widget.item.unidad.simbolo,
                                ),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Tipo de movimiento
                  _buildFormField(
                    label: l.invDialogMovementType,
                    isRequired: true,
                    child: DropdownButtonFormField<TipoMovimiento>(
                      initialValue: _tipoSeleccionado,
                      decoration: _inputDecoration(hint: l.invSelectType),
                      items: TipoMovimiento.values
                          .where((t) => t.esEntrada == widget.esEntrada)
                          .map(
                            (t) => DropdownMenuItem(
                              value: t,
                              child: Text(t.displayName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _tipoSeleccionado = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),

                  // Cantidad
                  _buildFormField(
                    label: S
                        .of(context)
                        .invQuantityLabel(widget.item.unidad.simbolo),
                    isRequired: true,
                    child: TextFormField(
                      controller: _cantidadController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: _inputDecoration(hint: '0'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l.invEnterQuantity;
                        }
                        final cantidad = double.tryParse(value);
                        if (cantidad == null || cantidad <= 0) {
                          return l.invEnterValidNumberGt0;
                        }
                        if (!widget.esEntrada &&
                            cantidad > widget.item.stockActual) {
                          return l.invQuantityExceedsStock;
                        }
                        return null;
                      },
                    ),
                  ),

                  // Campos adicionales solo para entradas
                  if (widget.esEntrada) ...[
                    const SizedBox(height: AppSpacing.base),
                    _buildFormField(
                      label: l.invTotalCost,
                      child: TextFormField(
                        controller: _costoController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _inputDecoration(
                          hint: '0.00',
                          prefixText: Formatters.currencyPrefix,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    _buildFormField(
                      label: l.commonSupplier,
                      child: TextFormField(
                        controller: _proveedorController,
                        decoration: _inputDecoration(hint: l.invSupplierName),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.base),
                  _buildFormField(
                    label: l.invObservation,
                    child: TextFormField(
                      controller: _motivoController,
                      maxLines: 2,
                      decoration: _inputDecoration(
                        hint: l.invReasonOrObservation,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onSurface,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allSm,
                            ),
                            side: BorderSide(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Text(l.commonCancel),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading ? null : _guardar,
                          style: FilledButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allSm,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: AppSpacing.lg,
                                  height: AppSpacing.lg,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      AppColors.white,
                                    ),
                                  ),
                                )
                              : Text(l.commonSave),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, String? prefixText}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.normal,
      ),
      prefixText: prefixText,
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: BorderSide(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: BorderSide(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
        height: 1.2,
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cantidad = double.tryParse(_cantidadController.text);
    if (cantidad == null || cantidad <= 0) {
      return;
    }

    final currentUser = widget.ref.read(currentUserProvider);
    if (currentUser == null) return;

    final entryError = S.of(context).invEntryError;
    final exitError = S.of(context).invExitError;

    setState(() => _isLoading = true);

    try {
      final notifier = widget.ref.read(
        inventarioMovimientoNotifierProvider.notifier,
      );

      if (widget.esEntrada) {
        final costoTotal = double.tryParse(_costoController.text);
        final proveedor = _proveedorController.text.trim().isEmpty
            ? null
            : _proveedorController.text.trim();

        final movimiento = await notifier.registrarEntrada(
          itemId: widget.item.id,
          granjaId: widget.item.granjaId,
          tipo: _tipoSeleccionado,
          cantidad: cantidad,
          registradoPor: currentUser.id,
          motivo: _motivoController.text.trim().isEmpty
              ? null
              : _motivoController.text.trim(),
          costoTotal: costoTotal,
          proveedor: proveedor,
        );

        if (movimiento == null) {
          throw Exception(entryError);
        }

        // Generar costo automáticamente si hay monto
        if (costoTotal != null && costoTotal > 0) {
          final costosService = widget.ref.read(
            inventarioCostosServiceProvider,
          );
          await costosService.generarCostoDesdeMovimientoEntrada(
            movimiento: movimiento,
            item: widget.item,
            registradoPor: currentUser.id,
          );
        }
      } else {
        final movimiento = await notifier.registrarSalida(
          itemId: widget.item.id,
          granjaId: widget.item.granjaId,
          tipo: _tipoSeleccionado,
          cantidad: cantidad,
          registradoPor: currentUser.id,
          motivo: _motivoController.text.trim().isEmpty
              ? null
              : _motivoController.text.trim(),
        );

        if (movimiento == null) {
          throw Exception(exitError);
        }
      }

      if (!mounted) return;
      AppSnackBar.success(
        context,
        message: widget.esEntrada ? l.invEntryRegistered : l.invExitRegistered,
      );
      Navigator.pop(context, true);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).commonError,
        detail: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Widget interno para dialog de ajustar stock.
class _AjustarStockDialog extends StatefulWidget {
  const _AjustarStockDialog({required this.item, required this.ref});

  final ItemInventario item;
  final WidgetRef ref;

  @override
  State<_AjustarStockDialog> createState() => _AjustarStockDialogState();
}

class _AjustarStockDialogState extends State<_AjustarStockDialog> {
  S get l => S.of(context);

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _stockController;
  late TextEditingController _motivoController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController(
      text: widget.item.stockActual.toString(),
    );
    _motivoController = TextEditingController();
  }

  @override
  void dispose() {
    _stockController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l = S.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      backgroundColor: colorScheme.surface,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.invDialogAdjustStock,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxxs),
                          Text(
                            widget.item.nombre,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context, false),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        foregroundColor: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Info del item
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.onSurface.withValues(alpha: 0.05),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          S
                              .of(context)
                              .invStockInfoFormat(
                                widget.item.stockActual.toString(),
                                widget.item.unidad.simbolo,
                              ),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Nuevo stock
                _buildFormField(
                  label: S.of(context).invNewStock(widget.item.unidad.simbolo),
                  isRequired: true,
                  child: TextFormField(
                    controller: _stockController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: _inputDecoration(hint: '0'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.invEnterNewStock;
                      }
                      final stock = double.tryParse(value);
                      if (stock == null || stock < 0) {
                        return l.invEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.base),

                // Motivo
                _buildFormField(
                  label: l.invAdjustmentReason,
                  isRequired: true,
                  child: TextFormField(
                    controller: _motivoController,
                    maxLines: 2,
                    decoration: _inputDecoration(
                      hint: S.of(context).invMotiveHint,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.invReasonRequired;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Botones
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.onSurface,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allSm,
                          ),
                          side: BorderSide(
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        child: Text(l.commonCancel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isLoading ? null : _ajustar,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.info,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allSm,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: AppSpacing.lg,
                                height: AppSpacing.lg,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : Text(l.invAdjust),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isRequired ? '$label *' : label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.normal,
      ),
      filled: true,
      fillColor: colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: BorderSide(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: BorderSide(
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.allSm,
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: AppTextStyles.bodySmall.copyWith(
        color: AppColors.error,
        height: 1.2,
      ),
    );
  }

  Future<void> _ajustar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nuevoStock = double.tryParse(_stockController.text);
    if (nuevoStock == null || nuevoStock < 0) {
      return;
    }

    final currentUser = widget.ref.read(currentUserProvider);
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    try {
      final notifier = widget.ref.read(
        inventarioMovimientoNotifierProvider.notifier,
      );

      await notifier.ajustarStock(
        itemId: widget.item.id,
        granjaId: widget.item.granjaId,
        nuevoStock: nuevoStock,
        registradoPor: currentUser.id,
        motivo: _motivoController.text.trim(),
      );

      if (!mounted) return;
      AppSnackBar.success(context, message: l.invStockAdjustedSuccess);
      Navigator.pop(context, true);
    } on Exception catch (e) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).commonError,
        detail: e.toString(),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Widget interno para dialog de eliminar item.
class _EliminarItemDialog extends StatefulWidget {
  const _EliminarItemDialog({required this.item});

  final ItemInventario item;

  @override
  State<_EliminarItemDialog> createState() => _EliminarItemDialogState();
}

class _EliminarItemDialogState extends State<_EliminarItemDialog> {
  S get l => S.of(context);

  final _confirmController = TextEditingController();
  bool _isNameMatch = false;

  @override
  void initState() {
    super.initState();
    _confirmController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final matches = _confirmController.text == widget.item.nombre;
    if (matches != _isNameMatch) {
      setState(() => _isNameMatch = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        l.invDeleteItem,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(child: _buildContent(l)),
      actions: _buildActions(l),
    );
  }

  Widget _buildContent(S l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.invConfirmDeleteItemName(widget.item.nombre),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        _buildWarningBox(l),
        const SizedBox(height: AppSpacing.lg),
        _buildConfirmInput(l),
      ],
    );
  }

  Widget _buildWarningBox(S l) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.invActionIrreversible,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.invDeleteWarningDetails,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmInput(S l) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.invTypeNameToConfirm,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
          ),
          child: Text(
            widget.item.nombre,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _confirmController,
          decoration: InputDecoration(
            hintText: l.invTypeHere,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.onSurface.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: _isNameMatch
                    ? AppColors.error
                    : AppColors.onSurfaceVariant,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(S l) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
        ),
        child: Text(l.commonCancel),
      ),
      FilledButton(
        onPressed: _isNameMatch ? () => Navigator.pop(context, true) : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.onSurfaceVariant.withValues(
            alpha: 0.3,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
        child: Text(l.commonDelete),
      ),
    ];
  }
}
