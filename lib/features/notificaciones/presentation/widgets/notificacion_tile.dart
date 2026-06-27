/// Widget de tile de notificación.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/enums/prioridad_notificacion.dart';

/// Tile para mostrar una notificación en la lista.
///
/// Diseño de card: esquinas redondeadas, barra de acento de color a la izquierda,
/// título en el color del tipo, textos completos y un badge de prioridad sólido a
/// la derecha del título. Se elimina deslizando hacia la izquierda.
///
/// Diferencia leídas vs no leídas:
/// - No leída → fondo tenue del color de acento, punto indicador, título en
///   negrita y barra de acento más gruesa.
/// - Leída → fondo de superficie normal, sin punto, título seminegrita y la card
///   con menor opacidad.
class NotificacionTile extends StatelessWidget {
  const NotificacionTile({
    super.key,
    required this.notificacion,
    required this.onTap,
    required this.onDismiss,
    this.index = 0,
  });

  /// La notificación a mostrar.
  final Notificacion notificacion;

  /// Posición en la lista — usada para escalonar la animación de entrada.
  final int index;

  /// Callback cuando se toca la notificación.
  final VoidCallback onTap;

  /// Callback cuando se desliza para eliminar.
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = notificacion.tipo.color;
    final noLeida = !notificacion.leida;

    return _buildDismissible(
      context,
      theme,
      colorScheme,
      accentColor,
      noLeida,
    ).staggeredEntrance(index: index);
  }

  Widget _buildDismissible(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color accentColor,
    bool noLeida,
  ) {
    return Dismissible(
      key: Key(notificacion.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.xs,
        ),
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.allMd,
        ),
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      child: Opacity(
        opacity: noLeida ? 1 : 0.72,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            // No leída → fondo tenue del color de acento; leída → superficie.
            color: noLeida
                ? accentColor.withValues(alpha: 0.08)
                : colorScheme.surface,
            borderRadius: AppRadius.allMd,
            border: Border(
              left: BorderSide(color: accentColor, width: noLeida ? 6 : 4),
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.onSurface.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppRadius.allMd,
            child: InkWell(
              onTap: onTap,
              borderRadius: AppRadius.allMd,
              splashColor: accentColor.withValues(alpha: 0.1),
              highlightColor: accentColor.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título + badge de prioridad en la misma fila
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Punto indicador de no leída
                        if (noLeida) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          AppSpacing.hGapSm,
                        ],
                        Expanded(
                          child: Text(
                            notificacion.titulo,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: accentColor,
                              fontWeight: noLeida
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        // Badge de prioridad sólido (lado derecho del título)
                        if (notificacion.prioridad !=
                            PrioridadNotificacion.normal) ...[
                          AppSpacing.hGapSm,
                          _buildPrioridadBadge(theme),
                        ],
                      ],
                    ),
                    AppSpacing.gapXs,

                    // Mensaje completo
                    Text(
                      notificacion.mensaje,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.35,
                      ),
                    ),
                    AppSpacing.gapSm,

                    // Pie: tiempo y granja (texto, sin íconos)
                    Text(
                      notificacion.granjaName != null
                          ? '${notificacion.tiempoTranscurrido} • ${notificacion.granjaName}'
                          : notificacion.tiempoTranscurrido,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Badge sólido rectangular con bordes redondeados y texto blanco para la
  /// prioridad de la notificación.
  Widget _buildPrioridadBadge(ThemeData theme) {
    final color = _prioridadColor(notificacion.prioridad);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        notificacion.prioridad.displayLabel,
        style: theme.textTheme.labelSmall?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Color _prioridadColor(PrioridadNotificacion prioridad) {
    return switch (prioridad) {
      PrioridadNotificacion.urgente => AppColors.error,
      PrioridadNotificacion.alta => AppColors.warning,
      PrioridadNotificacion.normal => AppColors.info,
      PrioridadNotificacion.baja => AppColors.success,
    };
  }
}
