/// Sistema de dialogs unificado para el feature de galpones.
///
/// Proporciona dialogs consistentes con la misma apariencia visual
/// para todas las operaciones de confirmación.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../inventario/domain/entities/entities.dart';
import '../../../inventario/domain/enums/enums.dart';
import '../../../inventario/presentation/widgets/widgets.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';

/// Tipos de dialogs disponibles.
enum GalponDialogType { success, warning, error, info }

/// Configuración para un dialog de confirmación.
class GalponDialogConfig {
  const GalponDialogConfig({
    required this.title,
    required this.message,
    required this.type,
    this.confirmText,
    this.cancelText,
    this.infoText,
  });

  final String title;
  final String message;
  final GalponDialogType type;
  final String? confirmText;
  final String? cancelText;
  final String? infoText;

  /// Obtiene el color según el tipo.
  Color get color => switch (type) {
    GalponDialogType.success => AppColors.success,
    GalponDialogType.warning => AppColors.warning,
    GalponDialogType.error => AppColors.error,
    GalponDialogType.info => AppColors.primary,
  };
}

/// Datos de desinfección retornados por el dialogo.
class DatosDesinfeccion {
  const DatosDesinfeccion({
    required this.fecha,
    required this.productos,
    this.observaciones,
    this.itemsInventario,
  });

  final DateTime fecha;
  final List<String> productos;
  final String? observaciones;

  /// Items del inventario seleccionados (para descontar stock)
  final List<ItemInventario>? itemsInventario;
}

/// Datos de mantenimiento retornados por el dialogo.
class DatosMantenimiento {
  const DatosMantenimiento({
    required this.fechaInicio,
    required this.descripcion,
  });

  final DateTime fechaInicio;
  final String descripcion;
}

/// Sistema de dialogs unificados para galpones.
abstract class GalponDialogs {
  const GalponDialogs._();

  /// Muestra un dialog de confirmación genérico.
  static Future<bool> showConfirmDialog(
    BuildContext context,
    GalponDialogConfig config,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _GalponConfirmDialog(config: config),
    );
    return result ?? false;
  }

  /// Dialog para Activar galpón.
  static Future<bool> showActivarDialog(
    BuildContext context,
    String nombreGalpon,
  ) {
    return showConfirmDialog(
      context,
      GalponDialogConfig(
        title: S.of(context).shedActivateTitle,
        message: S.of(context).shedActivateConfirm(nombreGalpon),
        type: GalponDialogType.success,
        confirmText: S.of(context).shedActivateAction,
        infoText: S.of(context).shedActivateInfo,
      ),
    );
  }

  /// Dialog para Suspender galpón.
  static Future<bool> showSuspenderDialog(
    BuildContext context,
    String nombreGalpon,
  ) {
    return showConfirmDialog(
      context,
      GalponDialogConfig(
        title: S.of(context).shedSuspendTitle,
        message: S.of(context).shedSuspendConfirm(nombreGalpon),
        type: GalponDialogType.warning,
        confirmText: S.of(context).shedSuspendAction,
        infoText: S.of(context).shedSuspendInfo,
      ),
    );
  }

  /// Dialog para poner en mantenimiento.
  static Future<bool> showMantenimientoConfirmDialog(
    BuildContext context,
    String nombreGalpon,
  ) {
    return showConfirmDialog(
      context,
      GalponDialogConfig(
        title: S.of(context).shedMaintenanceTitle,
        message: S.of(context).shedMaintenanceConfirm(nombreGalpon),
        type: GalponDialogType.warning,
        confirmText: S.of(context).commonConfirm,
        infoText: S.of(context).shedMaintenanceInfo,
      ),
    );
  }

  /// Dialog para poner en desinfección.
  static Future<bool> showDesinfeccionConfirmDialog(
    BuildContext context,
    String nombreGalpon,
  ) {
    return showConfirmDialog(
      context,
      GalponDialogConfig(
        title: S.of(context).shedDisinfectionTitle,
        message: S.of(context).shedDisinfectionMessage(nombreGalpon),
        type: GalponDialogType.info,
        confirmText: S.of(context).commonConfirm,
        infoText: S.of(context).shedDisinfectionAvailInfo,
      ),
    );
  }

  /// Dialog para Eliminar galpón (con confirmación por nombre).
  static Future<bool> showEliminarDialog(
    BuildContext context,
    String nombreGalpon,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GalponDeleteDialog(nombreGalpon: nombreGalpon),
    );
    return result ?? false;
  }

  /// Dialog para Liberar galpón.
  static Future<bool> showLiberarDialog(
    BuildContext context,
    String nombreGalpon,
  ) {
    return showConfirmDialog(
      context,
      GalponDialogConfig(
        title: S.of(context).shedReleaseTitle,
        message: S.of(context).shedReleaseConfirm(nombreGalpon),
        type: GalponDialogType.warning,
        confirmText: S.of(context).shedReleaseAction,
        infoText: S.of(context).shedReleaseInfo,
      ),
    );
  }

  /// Dialog para toggle de estado (activar/suspender).
  static Future<bool> showToggleEstadoDialog(
    BuildContext context,
    String nombreGalpon, {
    required bool isActive,
  }) {
    if (isActive) {
      return showSuspenderDialog(context, nombreGalpon);
    } else {
      return showActivarDialog(context, nombreGalpon);
    }
  }

  /// Muestra dialogo para cambiar estado del galpon.
  static Future<EstadoGalpon?> showCambiarEstadoDialog(
    BuildContext context,
    Galpon galpon,
  ) async {
    return showDialog<EstadoGalpon>(
      context: context,
      builder: (context) => _CambiarEstadoDialog(galpon: galpon),
    );
  }

  /// Muestra dialogo para ingresar un motivo.
  static Future<String?> showMotivoDialog(
    BuildContext context,
    String titulo,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (context) => _MotivoDialog(titulo: titulo),
    );
  }

  /// Muestra dialogo para registrar desinfección.
  static Future<DatosDesinfeccion?> showDesinfeccionDialog(
    BuildContext context, {
    String? granjaId,
  }) async {
    return showDialog<DatosDesinfeccion>(
      context: context,
      builder: (context) => _DesinfeccionDialog(granjaId: granjaId),
    );
  }

  /// Muestra dialogo para programar mantenimiento.
  static Future<DatosMantenimiento?> showMantenimientoDialog(
    BuildContext context,
  ) async {
    return showDialog<DatosMantenimiento>(
      context: context,
      builder: (context) => const _MantenimientoDialog(),
    );
  }

  /// Muestra dialogo de filtros.
  static Future<Map<String, dynamic>?> showFiltrosDialog(
    BuildContext context, {
    EstadoGalpon? estadoActual,
  }) async {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _FiltrosDialog(estadoActual: estadoActual),
    );
  }
}

/// Widget interno para dialog de confirmación.
class _GalponConfirmDialog extends StatelessWidget {
  const _GalponConfirmDialog({required this.config});

  final GalponDialogConfig config;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        config.title,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: config.type == GalponDialogType.error
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

/// Widget interno para dialog de eliminación con confirmación.
class _GalponDeleteDialog extends StatefulWidget {
  const _GalponDeleteDialog({required this.nombreGalpon});

  final String nombreGalpon;

  @override
  State<_GalponDeleteDialog> createState() => _GalponDeleteDialogState();
}

class _GalponDeleteDialogState extends State<_GalponDeleteDialog> {
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
    final matches = _confirmController.text == widget.nombreGalpon;
    if (matches != _isNameMatch) {
      setState(() => _isNameMatch = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).shedDeleteTitle,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(child: _buildContent()),
      actions: _buildActions(),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedDeleteConfirmMsg(widget.nombreGalpon),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.base),
        _buildWarningBox(),
        const SizedBox(height: AppSpacing.lg),
        _buildConfirmInput(),
      ],
    );
  }

  Widget _buildWarningBox() {
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
            S.of(context).shedDeleteIrreversible,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).shedDeleteConsequences,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedWriteNameToConfirm,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
          ),
          child: Text(
            widget.nombreGalpon,
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
            hintText: S.of(context).shedWriteHere,
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
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
        ),
        child: Text(S.of(context).commonCancel),
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
        child: Text(S.of(context).commonDelete),
      ),
    ];
  }
}

/// Widget interno para dialog de cambio de estado.
class _CambiarEstadoDialog extends StatelessWidget {
  const _CambiarEstadoDialog({required this.galpon});

  final Galpon galpon;

  String _getDescripcionEstado(BuildContext context, EstadoGalpon estado) {
    final l = S.of(context);
    return switch (estado) {
      EstadoGalpon.activo => l.shedStatusActiveDesc,
      EstadoGalpon.inactivo => l.shedStatusInactiveDesc,
      EstadoGalpon.mantenimiento => l.shedStatusMaintenanceDesc,
      EstadoGalpon.cuarentena => l.shedStatusQuarantineDesc,
      EstadoGalpon.desinfeccion => l.shedStatusDisinfectionDesc,
    };
  }

  Widget _buildColorDot(Color color, {double size = 12}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estadosDisponibles = EstadoGalpon.values
        .where((e) => e != galpon.estado)
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      title: Text(
        S.of(context).shedChangeStatus,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label estado actual
          Text(
            S.of(context).shedCurrentState,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Card estado actual
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildColorDot(galpon.estado.color),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        galpon.estado.localizedDisplayName(S.of(context)),
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        _getDescripcionEstado(context, galpon.estado),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            S.of(context).shedSelectNewState,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Opciones de estado como tarjetas
          ...estadosDisponibles.map((estado) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context, estado),
                  borderRadius: AppRadius.allSm,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: AppRadius.allSm,
                      border: Border.all(
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildColorDot(estado.color),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                estado.localizedDisplayName(S.of(context)),
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                _getDescripcionEstado(context, estado),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(S.of(context).commonCancel),
        ),
      ],
    );
  }
}

/// Widget interno para dialog de motivo.
class _MotivoDialog extends StatefulWidget {
  const _MotivoDialog({required this.titulo});

  final String titulo;

  @override
  State<_MotivoDialog> createState() => _MotivoDialogState();
}

class _MotivoDialogState extends State<_MotivoDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        widget.titulo,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).commonReason,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: S.of(context).shedEnterReason,
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            maxLines: 3,
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(S.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              Navigator.pop(context, _controller.text.trim());
            }
          },
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
          child: Text(S.of(context).commonConfirm),
        ),
      ],
    );
  }
}

/// Widget interno para dialog de desinfección.
class _DesinfeccionDialog extends ConsumerStatefulWidget {
  const _DesinfeccionDialog({this.granjaId});

  final String? granjaId;

  @override
  ConsumerState<_DesinfeccionDialog> createState() =>
      _DesinfeccionDialogState();
}

class _DesinfeccionDialogState extends ConsumerState<_DesinfeccionDialog> {
  final _productosController = TextEditingController();
  final _observacionesController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  final List<ItemInventario> _itemsSeleccionados = [];

  @override
  void dispose() {
    _productosController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).shedRegisterDisinfectionTitle,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFechaSelector(),
              const SizedBox(height: AppSpacing.lg),
              // Selector de inventario (si hay granjaId)
              if (widget.granjaId != null) ...[
                _buildInventarioSelector(),
                const SizedBox(height: AppSpacing.base),
              ],
              _buildProductosInput(),
              const SizedBox(height: AppSpacing.base),
              _buildObservacionesInput(),
            ],
          ),
        ),
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildInventarioSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedSelectProductsDesc,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).shedSelectProductsFromInventory,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              InventarioSelector(
                granjaId: widget.granjaId!,
                tipoFiltro: TipoItem.limpieza,
                itemSeleccionado: null,
                onItemSelected: (item) {
                  if (item != null &&
                      !_itemsSeleccionados.any((i) => i.id == item.id)) {
                    setState(() {
                      _itemsSeleccionados.add(item);
                    });
                  }
                },
                label: S.of(context).shedAddProduct,
                hint: S.of(context).shedSearchInventory,
              ),
              if (_itemsSeleccionados.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _itemsSeleccionados.map((item) {
                    return Chip(
                      label: Text(item.nombre),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _itemsSeleccionados.removeWhere(
                            (i) => i.id == item.id,
                          );
                        });
                      },
                      backgroundColor: AppColors.info.withValues(alpha: 0.1),
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFechaSelector() {
    return InkWell(
      onTap: () async {
        final fecha = await showDatePicker(
          context: context,
          initialDate: _fechaSeleccionada,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
        );
        if (fecha != null) {
          setState(() => _fechaSeleccionada = fecha);
        }
      },
      borderRadius: AppRadius.allSm,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.allSm,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).shedDateLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedProductsUsed,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _productosController,
          decoration: InputDecoration(
            hintText: S.of(context).shedProductsHint,
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
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          S.of(context).shedSeparateWithCommas,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildObservacionesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedAdditionalObservations,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _observacionesController,
          decoration: InputDecoration(
            hintText: S.of(context).shedObservationsHint,
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
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
        ),
        child: Text(S.of(context).commonCancel),
      ),
      FilledButton(
        onPressed: () {
          if (_productosController.text.trim().isEmpty) {
            AppSnackBar.error(
              context,
              message: S.of(context).shedEnterAtLeastOneProduct,
            );
            return;
          }

          final productos = _productosController.text
              .split(',')
              .map((p) => p.trim())
              .where((p) => p.isNotEmpty)
              .toList();

          // Agregar nombres de items del inventario a la lista de productos
          final productosConInventario = [
            ...productos,
            ..._itemsSeleccionados.map((i) => i.nombre),
          ];

          Navigator.pop(
            context,
            DatosDesinfeccion(
              fecha: _fechaSeleccionada,
              productos: productosConInventario,
              observaciones: _observacionesController.text.trim().isEmpty
                  ? null
                  : _observacionesController.text.trim(),
              itemsInventario: _itemsSeleccionados.isNotEmpty
                  ? _itemsSeleccionados
                  : null,
            ),
          );
        },
        style: FilledButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
        child: Text(S.of(context).commonRegister),
      ),
    ];
  }
}

/// Widget interno para dialog de mantenimiento.
class _MantenimientoDialog extends StatefulWidget {
  const _MantenimientoDialog();

  @override
  State<_MantenimientoDialog> createState() => _MantenimientoDialogState();
}

class _MantenimientoDialogState extends State<_MantenimientoDialog> {
  final _descripcionController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void dispose() {
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).shedScheduleMaintenance,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFechaSelector(),
            const SizedBox(height: AppSpacing.lg),
            _buildDescripcionInput(),
          ],
        ),
      ),
      actions: _buildActions(context),
    );
  }

  Widget _buildFechaSelector() {
    return InkWell(
      onTap: () async {
        final fecha = await showDatePicker(
          context: context,
          initialDate: _fechaSeleccionada,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (fecha != null) {
          setState(() => _fechaSeleccionada = fecha);
        }
      },
      borderRadius: AppRadius.allSm,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.onSurface.withValues(alpha: 0.05),
          borderRadius: AppRadius.allSm,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).shedStartDateLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescripcionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).shedMaintenanceDescriptionLabel,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _descripcionController,
          decoration: InputDecoration(
            hintText: S.of(context).shedMaintenanceDescriptionHint,
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
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          maxLines: 3,
          autofocus: true,
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.onSurfaceVariant,
        ),
        child: Text(S.of(context).commonCancel),
      ),
      FilledButton(
        onPressed: () {
          if (_descripcionController.text.trim().isEmpty) {
            AppSnackBar.error(
              context,
              message: S.of(context).shedEnterDescription,
            );
            return;
          }

          Navigator.pop(
            context,
            DatosMantenimiento(
              fechaInicio: _fechaSeleccionada,
              descripcion: _descripcionController.text.trim(),
            ),
          );
        },
        style: FilledButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
        ),
        child: Text(S.of(context).commonSchedule),
      ),
    ];
  }
}

/// Widget interno para dialog de filtros.
class _FiltrosDialog extends StatefulWidget {
  const _FiltrosDialog({this.estadoActual});

  final EstadoGalpon? estadoActual;

  @override
  State<_FiltrosDialog> createState() => _FiltrosDialogState();
}

class _FiltrosDialogState extends State<_FiltrosDialog> {
  EstadoGalpon? _estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    _estadoSeleccionado = widget.estadoActual;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).shedFilterSheds,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).shedByStatus,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: Text(S.of(context).commonAll),
                selected: _estadoSeleccionado == null,
                onSelected: (selected) {
                  setState(() => _estadoSeleccionado = null);
                },
              ),
              ...EstadoGalpon.values.map((estado) {
                return FilterChip(
                  avatar: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _estadoSeleccionado == estado
                          ? Theme.of(context).colorScheme.surface
                          : estado.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  label: Text(estado.localizedDisplayName(S.of(context))),
                  selected: _estadoSeleccionado == estado,
                  selectedColor: estado.color,
                  onSelected: (selected) {
                    setState(() {
                      _estadoSeleccionado = selected ? estado : null;
                    });
                  },
                );
              }),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(S.of(context).commonCancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {'estado': null});
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(S.of(context).commonClear),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, {'estado': _estadoSeleccionado});
          },
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
          child: Text(S.of(context).commonApply),
        ),
      ],
    );
  }
}
