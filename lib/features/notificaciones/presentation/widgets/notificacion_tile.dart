/// Widget de tile de notificación.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/notificacion.dart';
import '../../domain/enums/prioridad_notificacion.dart';

/// Tile para mostrar una notificación en la lista.
class NotificacionTile extends StatelessWidget {
  const NotificacionTile({
    super.key,
    required this.notificacion,
    required this.onTap,
    required this.onDismiss,
  });

  /// La notificación a mostrar.
  final Notificacion notificacion;

  /// Callback cuando se toca la notificación.
  final VoidCallback onTap;

  /// Callback cuando se desliza para eliminar.
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(notificacion.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: AppColors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notificacion.leida
              ? null
              : colorScheme.primaryContainer.withValues(alpha: 0.1),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título con indicador de no leída
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacion.titulo,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: notificacion.leida
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notificacion.leida)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: AppSpacing.sm),
                            decoration: BoxDecoration(
                              borderRadius: AppRadius.allXs,
                              color: colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    AppSpacing.gapXxs,

                    // Mensaje
                    Text(
                      notificacion.mensaje,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,

                    // Tiempo y granja
                    Row(
                      children: [
                        // Tiempo transcurrido
                        Text(
                          notificacion.tiempoTranscurrido,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        // Granja
                        if (notificacion.granjaName != null) ...[
                          AppSpacing.hGapSm,
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppSpacing.hGapSm,
                          Flexible(
                            child: Text(
                              notificacion.granjaName!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],

                        // Badge de prioridad
                        if (notificacion.prioridad ==
                                PrioridadNotificacion.alta ||
                            notificacion.prioridad ==
                                PrioridadNotificacion.urgente) ...[
                          const Spacer(),
                          _buildPrioridadBadge(context, theme),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrioridadBadge(BuildContext context, ThemeData theme) {
    final isUrgente = notificacion.prioridad == PrioridadNotificacion.urgente;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isUrgente
            ? AppColors.error.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.15),
        borderRadius: AppRadius.allMd,
      ),
      child: Text(
        isUrgente
            ? S.of(context).notifPriorityUrgent
            : S.of(context).notifPriorityHigh,
        style: theme.textTheme.labelSmall?.copyWith(
          color: isUrgente ? AppColors.error : AppColors.warning,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
