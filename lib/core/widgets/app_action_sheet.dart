/// Bottom sheet de acciones contextuales.
///
/// Reemplaza los `PopupMenuButton` de 3 puntos de las cards (lotes, galpones,
/// granjas…) por un bottom sheet con el mismo estilo neutro de los selectores de
/// registro: handle, título, opciones tipo tile y botón "Cerrar" en color error.
///
/// ```dart
/// showAppActionSheet(
///   context: context,
///   title: 'Opciones del lote',
///   actions: [
///     AppActionSheetItem(label: 'Detalles', icon: Icons.info_outline, onTap: onDetalles),
///     AppActionSheetItem(label: 'Editar', icon: Icons.edit_outlined, onTap: onEditar),
///     AppActionSheetItem(
///       label: 'Eliminar',
///       icon: Icons.delete_outline,
///       isDestructive: true,
///       onTap: onEliminar,
///     ),
///   ],
/// );
/// ```
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'app_bottom_sheet.dart';
import 'app_button.dart';

/// Una acción dentro de [showAppActionSheet].
class AppActionSheetItem {
  const AppActionSheetItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.isDestructive = false,
  });

  /// Texto visible de la acción.
  final String label;

  /// Callback ejecutado al elegir la acción (tras cerrar el sheet).
  final VoidCallback? onTap;

  /// Icono opcional a la izquierda.
  final IconData? icon;

  /// Si la acción es destructiva (eliminar) → texto/icono en color error.
  final bool isDestructive;
}

/// Muestra un bottom sheet con [actions] y un botón "Cerrar".
Future<void> showAppActionSheet({
  required BuildContext context,
  required List<AppActionSheetItem> actions,
  String? title,
}) {
  final theme = Theme.of(context);
  return showAppBottomSheet<void>(
    context: context,
    title: title,
    isScrollControlled: true,
    scrollable: true,
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            children: [
              for (final action in actions)
                AppSheetOptionTile(
                  icon: action.icon,
                  color: action.isDestructive
                      ? AppColors.error
                      : theme.colorScheme.onSurface,
                  label: action.label,
                  trailing: const SizedBox.shrink(),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    action.onTap?.call();
                  },
                ),
            ],
          ),
        ),
        // Botón cerrar
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.base,
          ),
          child: AppButton.primary(
            label: S.of(sheetContext).commonClose,
            onPressed: () => Navigator.pop(sheetContext),
            expanded: true,
            backgroundColor: AppColors.error,
            foregroundColor: AppColors.white,
          ),
        ),
      ],
    ),
  );
}
