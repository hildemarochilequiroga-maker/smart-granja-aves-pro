/// Sistema de dialogs unificado para el feature de granjas.
///
/// Proporciona dialogs consistentes con la misma apariencia visual
/// para todas las operaciones de confirmación.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/granja.dart';
import '../../domain/enums/enums.dart';

/// Tipos de dialogs disponibles.
enum GranjaDialogType { success, warning, error, info }

/// Configuración para un dialog de confirmación.
class GranjaDialogConfig {
  const GranjaDialogConfig({
    required this.title,
    required this.message,
    required this.type,
    this.confirmText,
    this.cancelText,
    this.infoText,
  });

  final String title;
  final String message;
  final GranjaDialogType type;
  final String? confirmText;
  final String? cancelText;
  final String? infoText;

  /// Obtiene el color según el tipo.
  Color get color => switch (type) {
    GranjaDialogType.success => AppColors.success,
    GranjaDialogType.warning => AppColors.warning,
    GranjaDialogType.error => AppColors.error,
    GranjaDialogType.info => AppColors.primary,
  };
}

/// Sistema de dialogs unificados para granjas.
abstract class GranjaDialogs {
  const GranjaDialogs._();

  /// Muestra un dialog de confirmación genérico.
  static Future<bool> showConfirmDialog(
    BuildContext context,
    GranjaDialogConfig config,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _GranjaConfirmDialog(config: config),
    );
    return result ?? false;
  }

  /// Dialog para activar granja.
  static Future<bool> showActivarDialog(
    BuildContext context,
    String nombreGranja,
  ) {
    final l = S.of(context);
    return showConfirmDialog(
      context,
      GranjaDialogConfig(
        title: l.farmActivateFarm,
        message: l.farmActivateConfirmMsg(nombreGranja),
        type: GranjaDialogType.success,
        confirmText: l.farmActivate,
        infoText: l.farmActivateInfo,
      ),
    );
  }

  /// Dialog para suspender granja.
  static Future<bool> showSuspenderDialog(
    BuildContext context,
    String nombreGranja,
  ) {
    final l = S.of(context);
    return showConfirmDialog(
      context,
      GranjaDialogConfig(
        title: l.farmSuspendFarm,
        message: l.farmSuspendConfirmMsg(nombreGranja),
        type: GranjaDialogType.warning,
        confirmText: l.farmSuspend,
        infoText: l.farmSuspendInfo,
      ),
    );
  }

  /// Dialog para poner en mantenimiento.
  static Future<bool> showMantenimientoDialog(
    BuildContext context,
    String nombreGranja,
  ) {
    final l = S.of(context);
    return showConfirmDialog(
      context,
      GranjaDialogConfig(
        title: l.farmMaintenanceFarm,
        message: l.farmMaintenanceConfirmMsg(nombreGranja),
        type: GranjaDialogType.warning,
        confirmText: l.commonConfirm,
        infoText: l.farmMaintenanceInfo,
      ),
    );
  }

  /// Dialog para eliminar granja (con confirmación por nombre).
  static Future<bool> showEliminarDialog(
    BuildContext context,
    String nombreGranja,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _GranjaDeleteDialog(nombreGranja: nombreGranja),
    );
    return result ?? false;
  }

  /// Dialog para toggle de estado (activar/suspender).
  static Future<bool> showToggleEstadoDialog(
    BuildContext context,
    String nombreGranja, {
    required bool isActive,
  }) {
    if (isActive) {
      return showSuspenderDialog(context, nombreGranja);
    } else {
      return showActivarDialog(context, nombreGranja);
    }
  }

  /// Muestra diálogo para cambiar estado de la granja.
  static Future<EstadoGranja?> showCambiarEstadoDialog(
    BuildContext context,
    Granja granja,
  ) async {
    return showDialog<EstadoGranja>(
      context: context,
      builder: (context) => _GranjaCambiarEstadoDialog(granja: granja),
    );
  }
}

/// Widget interno para dialog de confirmación.
class _GranjaConfirmDialog extends StatelessWidget {
  const _GranjaConfirmDialog({required this.config});

  final GranjaDialogConfig config;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        config.title,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: config.type == GranjaDialogType.error
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          config.message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (config.infoText != null) ...[AppSpacing.gapBase, _buildInfoBox()],
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
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
class _GranjaDeleteDialog extends StatefulWidget {
  const _GranjaDeleteDialog({required this.nombreGranja});

  final String nombreGranja;

  @override
  State<_GranjaDeleteDialog> createState() => _GranjaDeleteDialogState();
}

class _GranjaDeleteDialogState extends State<_GranjaDeleteDialog> {
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
    final matches = _confirmController.text == widget.nombreGranja;
    if (matches != _isNameMatch) {
      setState(() => _isNameMatch = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        S.of(context).farmDeleteFarm,
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
          S.of(context).farmDeleteConfirmName(widget.nombreGranja),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        AppSpacing.gapBase,
        _buildWarningBox(),
        AppSpacing.gapLg,
        _buildConfirmInput(),
      ],
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.allSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).farmDeleteIrreversible,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).farmDeleteWillRemoveShedsAll,
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
          S.of(context).farmWriteNameToConfirm,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapSm,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            borderRadius: AppRadius.allSm,
          ),
          child: Text(
            widget.nombreGranja,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
        AppSpacing.gapMd,
        TextField(
          controller: _confirmController,
          decoration: InputDecoration(
            hintText: S.of(context).farmWriteHere,
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
class _GranjaCambiarEstadoDialog extends StatelessWidget {
  const _GranjaCambiarEstadoDialog({required this.granja});

  final Granja granja;

  String _getDescripcionEstado(BuildContext context, EstadoGranja estado) {
    final l = S.of(context);
    return switch (estado) {
      EstadoGranja.activo => l.farmStatusActiveDesc,
      EstadoGranja.inactivo => l.farmStatusInactiveDesc,
      EstadoGranja.mantenimiento => l.farmStatusMaintenanceDesc,
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
    final l = S.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final estadosDisponibles = EstadoGranja.values
        .where((e) => e != granja.estado)
        .toList();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      title: Text(
        l.commonChangeStatus,
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
            l.commonCurrentStatus,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.gapSm,
          // Card estado actual
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildColorDot(granja.estado.color),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        granja.estado.localizedDisplayName(S.of(context)),
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      AppSpacing.gapXxxs,
                      Text(
                        _getDescripcionEstado(context, granja.estado),
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
          AppSpacing.gapBase,
          Text(
            l.commonSelectNewStatus,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.gapSm,
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
                    padding: const EdgeInsets.all(12),
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
                          color: colorScheme.onSurface.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildColorDot(estado.color),
                        AppSpacing.hGapMd,
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
                              AppSpacing.gapXxxs,
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
          child: Text(l.commonCancel),
        ),
      ],
    );
  }
}
