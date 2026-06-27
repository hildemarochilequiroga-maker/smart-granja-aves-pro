/// Botón unificado de la aplicación.
///
/// Reemplaza los ~240 usos dispersos de FilledButton/OutlinedButton/TextButton
/// con estados de carga e iconos reimplementados a mano, por una API única
/// que respeta el tema y soporta loading, icono, ancho y color personalizado.
///
/// ```dart
/// AppButton.primary(label: 'Guardar', onPressed: _guardar, isLoading: _isLoading);
/// AppButton.secondary(label: 'Cancelar', onPressed: () => context.pop());
/// AppButton.text(label: 'Omitir', onPressed: _omitir);
/// AppButton.danger(label: 'Eliminar', icon: Icons.delete_outline, onPressed: _eliminar);
/// ```
library;

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

/// Variantes visuales del botón.
enum AppButtonVariant { primary, secondary, text, danger }

/// Botón unificado con soporte de carga, icono y ancho configurable.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Botón primario sólido (acción principal).
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
  }) : variant = AppButtonVariant.primary;

  /// Botón secundario con borde (acción alternativa).
  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
  }) : variant = AppButtonVariant.secondary;

  /// Botón de texto (acción terciaria, sin fondo ni borde).
  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
  }) : variant = AppButtonVariant.text;

  /// Botón destructivo sólido (eliminar / acción irreversible).
  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.height = 48,
    this.backgroundColor,
    this.foregroundColor,
  }) : variant = AppButtonVariant.danger;

  /// Texto del botón.
  final String label;

  /// Acción al pulsar. `null` deshabilita el botón.
  final VoidCallback? onPressed;

  /// Variante visual.
  final AppButtonVariant variant;

  /// Muestra un spinner y deshabilita el botón mientras es `true`.
  final bool isLoading;

  /// Icono opcional a la izquierda del texto.
  final IconData? icon;

  /// Si ocupa todo el ancho disponible.
  final bool expanded;

  /// Altura fija del botón.
  final double height;

  /// Color de fondo personalizado (sólo primary/danger).
  final Color? backgroundColor;

  /// Color de contenido personalizado.
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(borderRadius: AppRadius.allSm);
    final effectiveOnPressed = isLoading ? null : onPressed;

    final Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: shape,
          ),
          child: _buildChild(foregroundColor ?? colors.onPrimary),
        );
      case AppButtonVariant.danger:
        button = FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? colors.error,
            foregroundColor: foregroundColor ?? colors.onError,
            shape: shape,
          ),
          child: _buildChild(foregroundColor ?? colors.onError),
        );
      case AppButtonVariant.secondary:
        // Borde y texto en color de contenido neutro (negro en claro,
        // blanco en oscuro) para unificar todos los botones secundarios
        // tipo "Anterior"/"Cancelar"/"Cerrar". Respeta foregroundColor
        // si se pasa explícitamente.
        final secondaryColor = foregroundColor ?? colors.onSurface;
        button = OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: secondaryColor,
            side: BorderSide(color: secondaryColor),
            shape: shape,
          ),
          child: _buildChild(secondaryColor),
        );
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(foregroundColor: foregroundColor),
          child: _buildChild(foregroundColor ?? colors.primary),
        );
    }

    final sized = SizedBox(
      width: expanded ? double.infinity : null,
      height: height,
      child: button,
    );
    return sized;
  }

  /// Estilo de texto estándar de todos los botones de la app.
  static const TextStyle _labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  Widget _buildChild(Color spinnerColor) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: spinnerColor),
      );
    }
    if (icon == null) return Text(label, style: _labelStyle);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label, style: _labelStyle),
      ],
    );
  }
}
