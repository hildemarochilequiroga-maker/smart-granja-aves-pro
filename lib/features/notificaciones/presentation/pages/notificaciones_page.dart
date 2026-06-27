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
import '../../../../core/widgets/app_action_sheet.dart';
import '../../../../core/widgets/app_button.dart';
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
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMenuSheet(context, ref),
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
              // Esperar el primer dato fresco para que el indicador permanezca
              // visible hasta que el stream reemita (evita parpadeo).
              await ref.read(notificacionesStreamProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = notificaciones[index];
                return NotificacionTile(
                  notificacion: notificacion,
                  index: index,
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
              AppButton.text(
                label: S.of(context).commonRetry,
                onPressed: () => ref.invalidate(notificacionesStreamProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMenuSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(notificacionesNotifierProvider.notifier);

    showAppActionSheet(
      context: context,
      title: S.of(context).notifPageTitle,
      actions: [
        AppActionSheetItem(
          label: S.of(context).notifMarkAllRead,
          icon: Icons.done_all,
          onTap: () async {
            await notifier.marcarTodasComoLeidas();
            if (!context.mounted) return;
            AppSnackBar.success(
              context,
              message: S.of(context).notifAllMarkedRead,
            );
          },
        ),
        AppActionSheetItem(
          label: S.of(context).notifDeleteRead,
          icon: Icons.delete_sweep_outlined,
          isDestructive: true,
          onTap: () => _confirmarEliminarLeidas(context, notifier),
        ),
      ],
    );
  }

  void _confirmarEliminarLeidas(
    BuildContext context,
    NotificacionesNotifier notifier,
  ) {
    // Capturamos el messenger del contexto de la página (no el del diálogo) para
    // poder mostrar el snackbar tras cerrar el diálogo.
    final messenger = ScaffoldMessenger.of(context);
    final mensajeOk = S.of(context).notifDeleted;
    final mensajeError = S.of(context).notifLoadError;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          S.of(dialogContext).notifDeleteTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          S.of(dialogContext).notifDeleteReadConfirm,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
            child: Text(S.of(dialogContext).commonCancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final ok = await notifier.eliminarLeidas();
              messenger.showSnackBar(
                SnackBar(content: Text(ok ? mensajeOk : mensajeError)),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(S.of(dialogContext).commonDelete),
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
    final ok = await notifier.eliminar(notificacion.id);
    if (!context.mounted) return;

    // Si la eliminación falló, el stream volverá a mostrar la notificación;
    // avisamos al usuario en lugar de fingir éxito.
    if (ok) {
      AppSnackBar.info(context, message: S.of(context).notifSingleDeleted);
    } else {
      AppSnackBar.error(context, message: S.of(context).notifLoadError);
    }
  }
}
