/// Diálogos de confirmación unificados para toda la aplicación
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Tipo de acción del diálogo de confirmación
enum AppDialogType {
  /// Acciones destructivas (eliminar, cerrar cuenta)
  danger,

  /// Acciones que requieren precaución (salir sin guardar)
  warning,

  /// Confirmaciones positivas (completar, enviar)
  success,

  /// Confirmaciones informativas (restaurar borrador)
  info,
}

/// Muestra un diálogo de confirmación con estilo consistente.
///
/// Reemplaza las 20+ copias inline de `showDialog<bool> + AlertDialog`
/// distribuidas por todo el proyecto, y promueve el helper que estaba
/// solo en el módulo de salud a `core/`.
///
/// ```dart
/// final confirmed = await showAppConfirmDialog(
///   context: context,
///   title: '¿Eliminar registro?',
///   message: 'Esta acción no se puede deshacer.',
///   type: AppDialogType.danger,
/// );
/// if (confirmed) { ... }
/// ```
Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  AppDialogType type = AppDialogType.danger,
  IconData? icon,
  bool barrierDismissible = false,
}) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final l = S.of(context);

  unawaited(HapticFeedback.lightImpact());

  final Color actionColor = switch (type) {
    AppDialogType.danger => colorScheme.error,
    AppDialogType.warning => AppColors.warning,
    AppDialogType.success => AppColors.success,
    AppDialogType.info => colorScheme.primary,
  };

  final String defaultConfirmText = switch (type) {
    AppDialogType.danger => l.commonDelete,
    AppDialogType.warning => l.commonContinue,
    AppDialogType.success => l.commonConfirm,
    AppDialogType.info => l.commonAccept,
  };

  final String effectiveCancelText = cancelText ?? l.commonCancel;

  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      final dialogTheme = Theme.of(dialogContext);
      final dialogColorScheme = dialogTheme.colorScheme;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
        backgroundColor: dialogColorScheme.surface,
        surfaceTintColor: Colors.transparent,
        title: _buildTitle(dialogTheme, title, icon, actionColor),
        content: Text(
          message,
          style: dialogTheme.textTheme.bodyMedium?.copyWith(
            color: dialogColorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.base,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            style: TextButton.styleFrom(
              foregroundColor: dialogColorScheme.onSurfaceVariant,
            ),
            child: Text(effectiveCancelText),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: actionColor,
              foregroundColor: _foregroundFor(actionColor),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(confirmText ?? defaultConfirmText),
          ),
        ],
      );
    },
  );

  return result ?? false;
}

Widget _buildTitle(
  ThemeData theme,
  String title,
  IconData? icon,
  Color actionColor,
) {
  if (icon != null) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: actionColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: actionColor, size: 24),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  return Text(
    title,
    style: theme.textTheme.titleLarge?.copyWith(
      color: theme.colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    ),
    textAlign: TextAlign.center,
  );
}

/// Devuelve foreground blanco u oscuro según el brillo del color
Color _foregroundFor(Color bg) {
  return bg.computeLuminance() > 0.5 ? AppColors.onPrimary : AppColors.white;
}
