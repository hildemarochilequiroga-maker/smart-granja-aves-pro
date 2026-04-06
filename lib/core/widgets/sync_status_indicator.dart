/// Indicador de estado de sincronización para datos individuales.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/error_messages.dart';
import '../network/connectivity_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Indica el origen de los datos (caché o servidor).
enum DataSource {
  /// Datos del servidor (frescos)
  server,

  /// Datos del caché local
  cache,

  /// Estado desconocido
  unknown,
}

/// Widget que muestra un indicador visual del estado de sincronización.
///
/// Útil para mostrar si los datos vienen del caché o del servidor.
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({
    super.key,
    required this.fromCache,
    this.hasPendingWrites = false,
    this.size = 16,
    this.showLabel = false,
  });

  /// Si los datos vienen del caché
  final bool fromCache;

  /// Si hay escrituras pendientes
  final bool hasPendingWrites;

  /// Tamaño del indicador
  final double size;

  /// Si mostrar etiqueta de texto
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determinar estado y apariencia
    final (color, icon, label) = _getIndicatorStyle();

    final indicator = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.allXs,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size, color: color),
          if (showLabel) ...[
            AppSpacing.hGapXxs,
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );

    return Tooltip(message: _getTooltipMessage(), child: indicator);
  }

  (Color, IconData, String) _getIndicatorStyle() {
    if (hasPendingWrites) {
      return (
        AppColors.warning,
        Icons.cloud_upload_outlined,
        ErrorMessages.get('SYNC_PENDING'),
      );
    }

    if (fromCache) {
      return (
        AppColors.info,
        Icons.cloud_off_outlined,
        ErrorMessages.get('SYNC_LOCAL'),
      );
    }

    return (
      AppColors.success,
      Icons.cloud_done_outlined,
      ErrorMessages.get('SYNC_SYNCED'),
    );
  }

  String _getTooltipMessage() {
    if (hasPendingWrites) {
      return ErrorMessages.get('SYNC_TOOLTIP_PENDING');
    }

    if (fromCache) {
      return ErrorMessages.get('SYNC_TOOLTIP_CACHE');
    }

    return ErrorMessages.get('SYNC_TOOLTIP_SYNCED');
  }
}

/// Chip que muestra el estado de sincronización con más detalle.
class SyncStatusChip extends StatelessWidget {
  const SyncStatusChip({
    super.key,
    required this.fromCache,
    this.hasPendingWrites = false,
    this.lastSyncTime,
    this.compact = false,
  });

  final bool fromCache;
  final bool hasPendingWrites;
  final DateTime? lastSyncTime;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (color, icon, label) = _getChipStyle();

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        compact ? label : _getFullLabel(label),
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  (Color, IconData, String) _getChipStyle() {
    if (hasPendingWrites) {
      return (AppColors.warning, Icons.sync, ErrorMessages.get('SYNC_PENDING'));
    }

    if (fromCache) {
      return (AppColors.info, Icons.storage, ErrorMessages.get('SYNC_LOCAL'));
    }

    return (
      AppColors.success,
      Icons.cloud_done,
      ErrorMessages.get('SYNC_SYNCED'),
    );
  }

  String _getFullLabel(String baseLabel) {
    if (lastSyncTime == null) return baseLabel;

    final now = DateTime.now();
    final diff = now.difference(lastSyncTime!);

    String timeAgo;
    if (diff.inMinutes < 1) {
      timeAgo = ErrorMessages.get('SYNC_NOW');
    } else if (diff.inMinutes < 60) {
      timeAgo = ErrorMessages.format('SYNC_AGO_M', {
        'min': '${diff.inMinutes}',
      });
    } else if (diff.inHours < 24) {
      timeAgo = ErrorMessages.format('SYNC_AGO_H', {
        'hours': '${diff.inHours}',
      });
    } else {
      timeAgo = ErrorMessages.format('SYNC_AGO_D', {'days': '${diff.inDays}'});
    }

    return '$baseLabel ($timeAgo)';
  }
}

/// Card que muestra información completa del estado de sincronización.
class SyncStatusCard extends ConsumerWidget {
  const SyncStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    final (color, icon, title, subtitle) = _getCardContent(state);

    return Card(
      elevation: 0,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allMd,
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            AppSpacing.hGapBase,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasPendingWrites)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
          ],
        ),
      ),
    );
  }

  (Color, IconData, String, String) _getCardContent(
    AppConnectivityState state,
  ) {
    if (state.isOffline) {
      if (state.hasPendingWrites) {
        return (
          AppColors.warning,
          Icons.cloud_off,
          ErrorMessages.get('SYNC_OFFLINE_MODE'),
          ErrorMessages.get('SYNC_OFFLINE_MSG'),
        );
      }
      return (
        AppColors.error,
        Icons.wifi_off,
        ErrorMessages.get('SYNC_NO_CONNECTION'),
        ErrorMessages.get('SYNC_NO_CONNECTION_MSG'),
      );
    }

    if (state.hasPendingWrites) {
      return (
        AppColors.info,
        Icons.cloud_upload,
        ErrorMessages.get('SYNC_SYNCING'),
        ErrorMessages.get('SYNC_SYNCING_MSG'),
      );
    }

    final lastSync = state.lastSyncTime;
    final syncText = lastSync != null
        ? ErrorMessages.format('SYNC_LAST_SYNC', {
            'time': _formatTime(lastSync),
          })
        : ErrorMessages.format('SYNC_CONNECTED_VIA', {
            'type': state.connectionDescription,
          });

    return (
      AppColors.success,
      Icons.cloud_done,
      ErrorMessages.get('SYNC_ALL_SYNCED'),
      syncText,
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return ErrorMessages.get('SYNC_JUST_NOW');
    if (diff.inMinutes < 60) {
      return ErrorMessages.format('SYNC_MINUTES_AGO', {
        'min': '${diff.inMinutes}',
      });
    }
    if (diff.inHours < 24) {
      return ErrorMessages.format('SYNC_HOURS_AGO', {
        'hours': '${diff.inHours}',
      });
    }
    return ErrorMessages.format('SYNC_DAYS_AGO', {'days': '${diff.inDays}'});
  }
}

/// Wrapper que agrega un indicador de sincronización a cualquier widget.
class WithSyncIndicator extends StatelessWidget {
  const WithSyncIndicator({
    super.key,
    required this.child,
    required this.fromCache,
    this.hasPendingWrites = false,
    this.alignment = Alignment.topRight,
    this.padding = const EdgeInsets.all(4),
  });

  final Widget child;
  final bool fromCache;
  final bool hasPendingWrites;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Solo mostrar indicador si hay algo que indicar
    if (!fromCache && !hasPendingWrites) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Padding(
              padding: padding,
              child: SyncStatusIndicator(
                fromCache: fromCache,
                hasPendingWrites: hasPendingWrites,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget compacto para mostrar en AppBars o listas.
///
/// Solo se muestra cuando hay un estado que reportar (offline o pendiente).
class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key, this.showLabel = false});

  /// Si mostrar la etiqueta de texto junto al icono.
  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectivityProvider);

    // No mostrar nada si todo está bien
    if (state.isOnline && !state.hasPendingWrites) {
      return const SizedBox.shrink();
    }

    final (color, icon, label) = state.isOffline
        ? (AppColors.error, Icons.cloud_off, 'Offline')
        : (AppColors.warning, Icons.sync, 'Sincronizando');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadius.allMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          if (showLabel) ...[
            AppSpacing.hGapXxs,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
