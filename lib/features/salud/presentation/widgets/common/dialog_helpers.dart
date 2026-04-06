/// Helpers para diálogos de confirmación y feedback
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_snackbar.dart';

/// Tipo de acción del diálogo
enum ConfirmDialogType { danger, warning, success, info }

/// Muestra un diálogo de confirmación con estilo consistente
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  ConfirmDialogType type = ConfirmDialogType.danger,
  IconData? icon,
}) async {
  unawaited(HapticFeedback.lightImpact());

  final l = S.of(context);
  final effectiveCancelText = cancelText ?? l.commonCancel;
  final Color color;

  switch (type) {
    case ConfirmDialogType.danger:
      color = AppColors.error;
    case ConfirmDialogType.warning:
      color = AppColors.warning;
    case ConfirmDialogType.success:
      color = AppColors.success;
    case ConfirmDialogType.info:
      color = AppColors.info;
  }

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(effectiveCancelText),
        ),
        FilledButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.pop(dialogContext, true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: color,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
          child: Text(confirmText ?? _getDefaultConfirmText(context, type)),
        ),
      ],
    ),
  );

  return result ?? false;
}

String _getDefaultConfirmText(BuildContext context, ConfirmDialogType type) {
  final l = S.of(context);
  switch (type) {
    case ConfirmDialogType.danger:
      return l.commonDelete;
    case ConfirmDialogType.warning:
      return l.commonContinue;
    case ConfirmDialogType.success:
      return l.commonConfirm;
    case ConfirmDialogType.info:
      return l.commonAccept;
  }
}

/// Muestra un SnackBar con estilo consistente
void showStyledSnackBar(
  BuildContext context, {
  required String message,
  bool isSuccess = true,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onAction,
  String? actionLabel,
}) {
  if (isSuccess) {
    AppSnackBar.success(
      context,
      message: message,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  } else {
    AppSnackBar.error(
      context,
      message: message,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Muestra un SnackBar informativo (no éxito ni error)
void showInfoSnackBar(
  BuildContext context, {
  required String message,
  IconData? icon,
  Duration duration = const Duration(seconds: 3),
}) {
  AppSnackBar.info(context, message: message, duration: duration);
}

/// Muestra un diálogo de carga mientras se procesa una acción
Future<T?> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() action,
  String? message,
}) async {
  final l = S.of(context);
  final effectiveMessage = message ?? l.commonProcessing;
  // Mostrar el diálogo de carga
  unawaited(
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              AppSpacing.hGapBase,
              Expanded(
                child: Text(
                  effectiveMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  try {
    final result = await action();
    if (context.mounted) {
      Navigator.of(context).pop(); // Cerrar diálogo de carga
    }
    return result;
  } on Exception {
    if (context.mounted) {
      Navigator.of(context).pop(); // Cerrar diálogo de carga
    }
    rethrow;
  }
}
