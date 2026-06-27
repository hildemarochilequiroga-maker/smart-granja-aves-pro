/// Estructura base unificada para los bottom sheets de la app.
///
/// Encapsula el diseño del sheet de referencia (cambiar foto de perfil):
/// container `surface` con borde superior `AppRadius.xxl`, handle centrado,
/// título alineado a la izquierda en `titleLarge` bold y un slot para el
/// contenido. Aplica `FormTextScale` y `SafeArea` inferior por defecto.
///
/// Se usa de dos formas:
///
/// 1. Como helper que muestra el sheet directamente:
/// ```dart
/// showAppBottomSheet(
///   context: context,
///   title: 'Cambiar foto de perfil',
///   builder: (ctx) => Column(children: [...]),
/// );
/// ```
///
/// 2. Como widget envolvente cuando ya tienes un `showModalBottomSheet`
///    propio (p. ej. sheets con estado o `DraggableScrollableSheet`):
/// ```dart
/// AppBottomSheetScaffold(
///   title: 'Opciones',
///   child: Column(children: [...]),
/// );
/// ```
///
/// Para opciones tipo card (ícono en contenedor tenue + label + chevron),
/// igual que cámara/galería del sheet de referencia, usa [AppSheetOptionTile].
library;

import 'package:flutter/material.dart';

import '../presentation/widgets/form_text_scale.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Muestra un bottom sheet con la estructura base de la app.
///
/// [title] se muestra alineado a la izquierda; si es `null` solo se muestra el
/// handle. [builder] construye el contenido (típicamente una `Column` con
/// `mainAxisSize: MainAxisSize.min`). Para sheets desplazables o de altura
/// completa, pasa [isScrollControlled] y usa un contenido `Flexible`/scrollable.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  String? subtitle,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool scrollable = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    useSafeArea: true,
    builder: (ctx) => AppBottomSheetScaffold(
      title: title,
      subtitle: subtitle,
      scrollable: scrollable,
      child: Builder(builder: builder),
    ),
  );
}

/// Estructura visual base de un bottom sheet (handle + título + contenido).
///
/// Úsalo directamente como `builder` de un `showModalBottomSheet` cuando
/// necesites control total del sheet (estado, `DraggableScrollableSheet`,
/// `isScrollControlled`, etc.).
class AppBottomSheetScaffold extends StatelessWidget {
  const AppBottomSheetScaffold({
    required this.child,
    this.title,
    this.subtitle,
    this.trailing,
    this.scrollable = false,
    super.key,
  });

  /// Contenido del sheet (debajo del título).
  final Widget child;

  /// Título opcional, alineado a la izquierda.
  final String? title;

  /// Subtítulo opcional bajo el título.
  final String? subtitle;

  /// Acción opcional a la derecha del título (p. ej. botón cerrar).
  final Widget? trailing;

  /// Si el contenido debe envolverse en `Flexible` (sheets desplazables).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: AppSpacing.md),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant,
            borderRadius: AppRadius.allFull,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (scrollable) Flexible(child: child) else child,
      ],
    );

    return FormTextScale(
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
        ),
        child: SafeArea(top: false, child: content),
      ),
    );
  }
}

/// Opción tipo card de un bottom sheet (ícono en contenedor tenue + label +
/// chevron), igual que las opciones cámara/galería del sheet de referencia.
///
/// Si [icon] es `null`, no se muestra el contenedor de ícono (para sheets que
/// no usan íconos).
class AppSheetOptionTile extends StatelessWidget {
  const AppSheetOptionTile({
    required this.label,
    required this.onTap,
    this.icon,
    this.leading,
    this.color,
    this.subtitle,
    this.trailing,
    this.selected = false,
    super.key,
  });

  /// Texto principal de la opción.
  final String label;

  /// Subtítulo opcional bajo el label.
  final String? subtitle;

  /// Ícono opcional a la izquierda (en contenedor de color tenue).
  final IconData? icon;

  /// Leading personalizado (p. ej. una bandera emoji). Tiene prioridad sobre
  /// [icon] y se muestra dentro del mismo contenedor tenue.
  final Widget? leading;

  /// Color del ícono y su fondo tenue. Por defecto `primary`.
  final Color? color;

  /// Callback al tocar la opción.
  final VoidCallback onTap;

  /// Widget a la derecha. Si es `null` y [selected] es `false`, se muestra un
  /// chevron. Si [selected] es `true`, se muestra un check verde relleno.
  /// Pasa `SizedBox.shrink()` para ocultarlo.
  final Widget? trailing;

  /// Si la opción está seleccionada → borde resaltado y check verde con ícono
  /// blanco a la derecha.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final iconColor = color ?? colorScheme.primary;

    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: AppRadius.allSm,
        ),
        child: leading,
      );
    } else if (icon != null) {
      leadingWidget = Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: AppRadius.allSm,
        ),
        child: Icon(icon, color: iconColor, size: 26),
      );
    }

    final Widget trailingWidget =
        trailing ??
        (selected
            ? Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 18,
                ),
              )
            : Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: 22,
              ));

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.allMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.allMd,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.success.withValues(alpha: 0.06)
                  : colorScheme.surface,
              borderRadius: AppRadius.allMd,
              border: Border.all(
                color: selected
                    ? AppColors.success
                    : colorScheme.outlineVariant,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                if (leadingWidget != null) ...[
                  leadingWidget,
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xxxs),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                trailingWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
