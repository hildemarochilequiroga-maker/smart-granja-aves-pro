/// Página de notificaciones.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/providers/notificaciones_providers.dart';
import '../../application/services/notificacion_navigation_helper.dart';
import '../../domain/entities/notificacion.dart';
import '../widgets/notificacion_tile.dart';
import '../widgets/notificaciones_empty.dart';

/// Página que muestra las notificaciones del usuario.
class NotificacionesPage extends ConsumerWidget {
  const NotificacionesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificacionesAsync = ref.watch(notificacionesStreamProvider);
    final notifier = ref.read(notificacionesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notifPageTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _handleMenuAction(context, ref, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'marcar_todas',
                child: Text(S.of(context).notifMarkAllRead),
              ),
              PopupMenuItem(
                value: 'eliminar_leidas',
                child: Text(S.of(context).notifDeleteRead),
              ),
            ],
          ),
        ],
      ),
      body: notificacionesAsync.when(
        data: (notificaciones) {
          if (notificaciones.isEmpty) {
            return const NotificacionesEmpty();
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(notificacionesStreamProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notificaciones.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final notificacion = notificaciones[index];
                return NotificacionTile(
                  notificacion: notificacion,
                  onTap: () => _onNotificacionTap(context, ref, notificacion),
                  onDismiss: () =>
                      _onNotificacionDismiss(context, notifier, notificacion),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              AppSpacing.gapBase,
              Text(S.of(context).notifLoadError),
              AppSpacing.gapSm,
              TextButton(
                onPressed: () => ref.invalidate(notificacionesStreamProvider),
                child: Text(S.of(context).commonRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final notifier = ref.read(notificacionesNotifierProvider.notifier);

    switch (action) {
      case 'marcar_todas':
        await notifier.marcarTodasComoLeidas();
        if (!context.mounted) return;
        AppSnackBar.success(context, message: S.of(context).notifAllMarkedRead);
        break;
      case 'eliminar_leidas':
        _confirmarEliminarLeidas(context, notifier);
        break;
    }
  }

  void _confirmarEliminarLeidas(
    BuildContext context,
    NotificacionesNotifier notifier,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          S.of(context).notifDeleteTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          S.of(context).notifDeleteReadConfirm,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
            child: Text(S.of(context).commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await notifier.eliminarLeidas();
              if (!context.mounted) return;
              AppSnackBar.success(context, message: S.of(context).notifDeleted);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(S.of(context).commonDelete),
          ),
        ],
      ),
    );
  }

  Future<void> _onNotificacionTap(
    BuildContext context,
    WidgetRef ref,
    Notificacion notificacion,
  ) async {
    // Marcar como leída
    if (!notificacion.leida) {
      await ref
          .read(notificacionesNotifierProvider.notifier)
          .marcarComoLeida(notificacion.id);
    }

    if (!context.mounted) return;

    // Navegar según accionUrl
    if (notificacion.accionUrl != null) {
      final navigated = NotificacionNavigationHelper.navigateFromActionUrl(
        GoRouter.of(context),
        notificacion.accionUrl,
      );

      if (!navigated) {
        AppSnackBar.info(context, message: S.of(context).notifNoDestination);
      }
    }
  }

  Future<void> _onNotificacionDismiss(
    BuildContext context,
    NotificacionesNotifier notifier,
    Notificacion notificacion,
  ) async {
    await notifier.eliminar(notificacion.id);
    if (!context.mounted) return;
    AppSnackBar.info(context, message: S.of(context).notifSingleDeleted);
  }
}
