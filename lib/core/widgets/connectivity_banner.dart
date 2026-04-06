/// Banner que indica el estado de conectividad de la aplicación.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Banner que se muestra cuando no hay conexión a internet.
///
/// Se coloca típicamente en la parte superior de la pantalla,
/// debajo del AppBar o como parte del body del Scaffold.
class ConnectivityBanner extends ConsumerWidget {
  const ConnectivityBanner({
    super.key,
    this.showWhenOnline = false,
    this.showPendingWrites = true,
    this.animate = true,
  });

  /// Si debe mostrarse también cuando está online (con mensaje de sincronizado)
  final bool showWhenOnline;

  /// Si debe mostrar el indicador de escrituras pendientes
  final bool showPendingWrites;

  /// Si debe animar la aparición/desaparición
  final bool animate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityState = ref.watch(connectivityProvider);
    final theme = Theme.of(context);

    // No mostrar nada si está verificando
    if (connectivityState.isChecking) {
      return const SizedBox.shrink();
    }

    // Determinar si mostrar el banner
    final shouldShow =
        connectivityState.isOffline ||
        (showPendingWrites && connectivityState.hasPendingWrites) ||
        (showWhenOnline && connectivityState.isOnline);

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    // Determinar el contenido del banner
    final (color, icon, message) = _getBannerContent(
      context,
      connectivityState,
    );

    final banner = Material(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (connectivityState.hasPendingWrites) ...[
                const SizedBox(width: AppSpacing.sm),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (animate) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          );
        },
        child: shouldShow ? banner : const SizedBox.shrink(),
      );
    }

    return banner;
  }

  (Color, IconData, String) _getBannerContent(
    BuildContext context,
    AppConnectivityState state,
  ) {
    final l = S.of(context);
    if (state.isOffline) {
      if (state.hasPendingWrites) {
        return (
          AppColors.warning,
          Icons.cloud_off,
          l.connectivityOfflineBanner,
        );
      }
      return (
        AppColors.error.withValues(alpha: 0.9),
        Icons.wifi_off,
        l.connectivityOffline,
      );
    }

    if (state.hasPendingWrites) {
      return (AppColors.info, Icons.cloud_upload, 'Sincronizando datos...');
    }

    // Online y sincronizado
    return (
      AppColors.success,
      Icons.cloud_done,
      'Conectado • ${state.connectionDescription}',
    );
  }
}

/// Versión compacta del banner de conectividad.
/// Ideal para mostrar en AppBars o espacios reducidos.
class ConnectivityIndicator extends ConsumerWidget {
  const ConnectivityIndicator({
    super.key,
    this.size = 20,
    this.showTooltip = true,
  });

  final double size;
  final bool showTooltip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectivityProvider);

    if (state.isChecking) {
      return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final (color, icon) = state.isOffline
        ? (AppColors.error, Icons.cloud_off)
        : state.hasPendingWrites
        ? (AppColors.warning, Icons.cloud_upload)
        : (AppColors.success, Icons.cloud_done);

    final tooltip = state.isOffline
        ? S.of(context).connectivityOfflineShort
        : state.hasPendingWrites
        ? 'Sincronizando...'
        : 'Conectado';

    final indicator = Icon(icon, color: color, size: size);

    if (showTooltip) {
      return Tooltip(message: tooltip, child: indicator);
    }

    return indicator;
  }
}

/// Widget wrapper que muestra el banner de conectividad sobre el contenido.
class ConnectivityWrapper extends StatelessWidget {
  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.showBanner = true,
  });

  final Widget child;
  final bool showBanner;

  @override
  Widget build(BuildContext context) {
    if (!showBanner) return child;

    return Column(
      children: [
        const ConnectivityBanner(),
        Expanded(child: child),
      ],
    );
  }
}

/// Overlay global de conectividad para usar en el Builder de MaterialApp.
class ConnectivityOverlay extends ConsumerWidget {
  const ConnectivityOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final hasPendingWrites = ref.watch(hasPendingWritesProvider);

    return Stack(
      children: [
        child,
        // Banner en la parte superior
        if (isOffline || hasPendingWrites)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ConnectivityBanner(),
          ),
      ],
    );
  }
}
