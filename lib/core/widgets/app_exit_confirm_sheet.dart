/// Bottom sheet de confirmación para salir de la aplicación.
///
/// Se muestra al presionar el botón "atrás" estando en la raíz de la navegación.
/// Devuelve `true` si el usuario confirma que quiere salir.
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';

/// Muestra el bottom sheet de confirmación de salida.
///
/// Retorna `true` si el usuario confirma salir, `false`/`null` si cancela.
Future<bool> showAppExitConfirmSheet(BuildContext context) async {
  final theme = Theme.of(context);
  final l = S.of(context);

  final result = await showAppBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.exit_to_app,
                      color: AppColors.error,
                      size: 30,
                    ),
                  ),
                ),
                AppSpacing.gapMd,
                // Título
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l.appExitTitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                AppSpacing.gapSm,
                // Mensaje
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l.appExitMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppSpacing.gapLg,
                // Botones
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton.secondary(
                          label: l.commonCancel,
                          onPressed: () => Navigator.pop(sheetContext, false),
                          expanded: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton.primary(
                          label: l.appExitConfirm,
                          onPressed: () => Navigator.pop(sheetContext, true),
                          expanded: true,
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
    },
  );

  return result ?? false;
}
