/// SnackBar unificado para toda la aplicación.
///
/// Reemplaza los ~180 SnackBars inline con diseño inconsistente
/// por 4 métodos estáticos con estilo cohesivo:
///
/// ```dart
/// AppSnackBar.success(context, message: 'Granja creada exitosamente');
/// AppSnackBar.error(context, message: 'Error al guardar', detail: 'Verifica tu conexión');
/// AppSnackBar.warning(context, message: 'Sin conexión', actionLabel: 'Reintentar', onAction: retry);
/// AppSnackBar.info(context, message: 'Sincronizando datos...');
/// ```
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Tipos de feedback visual.
enum AppSnackBarType { success, error, warning, info }

/// API unificada de SnackBars para la aplicación.
abstract final class AppSnackBar {
  const AppSnackBar._();

  // =========================================================================
  // API PÚBLICA
  // =========================================================================

  /// Feedback de éxito (verde).
  static void success(
    BuildContext context, {
    required String message,
    String? detail,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    type: AppSnackBarType.success,
    message: message,
    detail: detail,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Feedback de error (rojo).
  static void error(
    BuildContext context, {
    required String message,
    String? detail,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    type: AppSnackBarType.error,
    message: message,
    detail: detail,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Feedback de advertencia (naranja).
  static void warning(
    BuildContext context, {
    required String message,
    String? detail,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    type: AppSnackBarType.warning,
    message: message,
    detail: detail,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  /// Feedback informativo (azul).
  static void info(
    BuildContext context, {
    required String message,
    String? detail,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) => _show(
    context,
    type: AppSnackBarType.info,
    message: message,
    detail: detail,
    duration: duration,
    actionLabel: actionLabel,
    onAction: onAction,
  );

  // =========================================================================
  // IMPLEMENTACIÓN INTERNA
  // =========================================================================

  static void _show(
    BuildContext context, {
    required AppSnackBarType type,
    required String message,
    String? detail,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    final config = _ConfigFor(type);

    messenger.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 2),
              Text(
                detail,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
        backgroundColor: config.color,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        action: onAction != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}

/// Configuración visual por tipo.
class _ConfigFor {
  _ConfigFor(AppSnackBarType type)
    : color = switch (type) {
        AppSnackBarType.success => AppColors.success,
        AppSnackBarType.error => AppColors.error,
        AppSnackBarType.warning => AppColors.warning,
        AppSnackBarType.info => AppColors.info,
      };

  final Color color;
}
