/// Ítem de estadística compacto: icono + valor + etiqueta.
///
/// Reemplaza el patrón repetido `Column[Icon, value, label]` usado en las
/// filas de estadísticas de los detalles de galpón, lote, etc.
///
/// ```dart
/// AppStatItem(icon: Icons.egg, value: '1.250', label: 'Aves', color: AppColors.info);
/// ```
library;

import 'package:flutter/material.dart';

/// Bloque vertical compacto de estadística (icono, valor destacado, etiqueta).
class AppStatItem extends StatelessWidget {
  const AppStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.iconSize = 24,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: iconSize),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
