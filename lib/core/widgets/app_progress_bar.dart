/// Barra de progreso lineal unificada de la aplicación.
///
/// Reemplaza el patrón repetido `ClipRRect(child: LinearProgressIndicator(...))`
/// usado en ocupación de galpones/granjas, edad de lote, fuerza de contraseña,
/// checklists de bioseguridad, etc.
///
/// ```dart
/// AppProgressBar(value: ocupacion / 100, color: AppColors.success);
/// AppProgressBar(value: progreso, color: c, height: 6, borderRadius: AppRadius.allFull);
/// ```
library;

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

/// Barra de progreso lineal con esquinas redondeadas y color configurable.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius,
  });

  /// Progreso entre 0.0 y 1.0. Se limita automáticamente a ese rango.
  final double value;

  /// Color de la porción completada. Por defecto, el color primario del tema.
  final Color? color;

  /// Color de fondo (porción restante). Por defecto, una versión tenue de [color].
  final Color? backgroundColor;

  /// Alto de la barra.
  final double height;

  /// Radio de las esquinas. Por defecto `AppRadius.allSm`.
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;
    return ClipRRect(
      borderRadius: borderRadius ?? AppRadius.allSm,
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: height,
        backgroundColor:
            backgroundColor ?? effectiveColor.withValues(alpha: 0.12),
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
      ),
    );
  }
}
