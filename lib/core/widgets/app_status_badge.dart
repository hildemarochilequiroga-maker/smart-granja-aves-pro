/// Insignia (pill) de estado: texto sobre fondo de color.
///
/// Reemplaza el patrón `_buildStatusBadge` duplicado en las cards de lista
/// (galpón, granja, lote, inventario, home de lotes).
///
/// ```dart
/// AppStatusBadge(text: estado.label, color: estado.color);
/// AppStatusBadge(text: 'Activo', color: AppColors.success, compact: isSmallScreen);
/// ```
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Pill compacto de estado con texto en blanco sobre fondo de color.
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.textColor,
    this.compact = false,
  });

  /// Texto del estado.
  final String text;

  /// Color de fondo del pill.
  final Color color;

  /// Color del texto (por defecto blanco).
  final Color? textColor;

  /// Tamaño compacto (pantallas pequeñas).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor ?? AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: compact ? 10 : 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
