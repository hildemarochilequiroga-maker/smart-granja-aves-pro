/// Sección de configuración de sincronización offline.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/config/firestore_config.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/sync_status_indicator.dart';

/// Widget que muestra el estado de sincronización y opciones offline.
class SyncSettingsSection extends ConsumerWidget {
  const SyncSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final connectivityState = ref.watch(connectivityProvider);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSm,
                  ),
                  child: const Icon(
                    Icons.sync,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                AppSpacing.hGapMd,
                Text(
                  S.of(context).syncTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Estado actual
            const SyncStatusCard(),
            AppSpacing.gapBase,

            // Estado de conexión
            _buildInfoTile(
              context,
              icon: Icons.wifi,
              title: S.of(context).syncConnectionStatus,
              subtitle: connectivityState.connectionDescription,
              trailing: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: connectivityState.isOnline
                      ? AppColors.success
                      : AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Divider(height: 24),

            // Escrituras pendientes
            _buildInfoTile(
              context,
              icon: Icons.cloud_upload_outlined,
              title: S.of(context).syncPendingData,
              subtitle: connectivityState.hasPendingWrites
                  ? S.of(context).syncChangesPending
                  : S.of(context).syncAllSynced,
              trailing: connectivityState.hasPendingWrites
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
            ),
            const Divider(height: 24),

            // Última sincronización
            if (connectivityState.lastSyncTime != null)
              _buildInfoTile(
                context,
                icon: Icons.schedule,
                title: S.of(context).syncLastSync,
                subtitle: _formatLastSync(
                  context,
                  connectivityState.lastSyncTime!,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    ref.read(connectivityProvider.notifier).refresh();
                  },
                  tooltip: S.of(context).syncCheckConnection,
                ),
              ),
            AppSpacing.gapBase,

            // Acciones
            _buildActionsSection(context, ref, connectivityState),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        AppSpacing.hGapMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildActionsSection(
    BuildContext context,
    WidgetRef ref,
    AppConnectivityState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Botón para forzar sincronización
        if (state.hasPendingWrites && state.isOnline)
          FilledButton.icon(
            onPressed: () async {
              await FirestoreConfig.waitForPendingWrites();
              if (context.mounted) {
                AppSnackBar.success(
                  context,
                  message: S.of(context).syncCompleted,
                );
              }
            },
            icon: const Icon(Icons.cloud_sync),
            label: Text(S.of(context).syncForceSync),
          ),

        AppSpacing.gapSm,

        // Información sobre modo offline
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: AppRadius.allSm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppColors.info),
              AppSpacing.hGapSm,
              Expanded(
                child: Text(
                  S.of(context).syncOfflineInfo,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatLastSync(BuildContext context, DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return S.of(context).syncJustNow;
    if (diff.inMinutes < 60) {
      return S.of(context).syncMinutesAgo(diff.inMinutes.toString());
    }
    if (diff.inHours < 24) {
      return S.of(context).syncHoursAgo(diff.inHours.toString());
    }
    return S.of(context).syncDaysAgo(diff.inDays.toString());
  }
}

/// Widget compacto para mostrar en listas o AppBars.
class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key, this.showLabel = false});

  final bool showLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(connectivityProvider);

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
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ],
      ),
    );
  }
}
