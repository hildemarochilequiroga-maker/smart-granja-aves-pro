/// Widget de fondo para pantallas de autenticación
library;

import 'package:flutter/material.dart';

/// Fondo limpio para pantallas de auth - Estilo Wialon
class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.child,
    this.showPattern = false,
    this.showGradient = false,
  });

  /// Widget hijo
  final Widget child;

  /// Mostrar patrón decorativo (desactivado por defecto)
  final bool showPattern;

  /// Mostrar gradiente de fondo (desactivado por defecto)
  final bool showGradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surface;

    // Fondo limpio sin decoraciones
    return Container(color: backgroundColor, child: child);
  }
}
