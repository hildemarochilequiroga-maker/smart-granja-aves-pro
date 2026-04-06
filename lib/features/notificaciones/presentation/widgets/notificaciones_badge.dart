/// Widget de badge de notificaciones para AppBar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../application/providers/notificaciones_providers.dart';

/// Badge que muestra el conteo de notificaciones no leídas.
class NotificacionesBadge extends ConsumerWidget {
  const NotificacionesBadge({
    super.key,
    required this.child,
    this.showZero = false,
    this.offset = const Offset(0, 0),
  });

  /// Widget hijo (típicamente un IconButton).
  final Widget child;

  /// Si mostrar el badge cuando el conteo es 0.
  final bool showZero;

  /// Offset del badge.
  final Offset offset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conteoAsync = ref.watch(conteoNotificacionesNoLeidasProvider);

    return conteoAsync.when(
      data: (conteo) {
        if (conteo == 0 && !showZero) {
          return child;
        }

        return Badge(
          label: Text(conteo > 99 ? '99+' : conteo.toString()),
          offset: offset,
          isLabelVisible: conteo > 0 || showZero,
          child: child,
        );
      },
      loading: () => child,
      error: (_, __) => child,
    );
  }
}

/// IconButton con badge de notificaciones.
class NotificacionesIconButton extends ConsumerWidget {
  const NotificacionesIconButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  /// Callback cuando se presiona el botón.
  final VoidCallback onPressed;

  /// Color del icono.
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificacionesBadge(
      offset: const Offset(-4, 4),
      child: IconButton(
        icon: Icon(Icons.notifications_outlined, color: color),
        onPressed: onPressed,
        tooltip: S.of(context).notifTooltip,
      ),
    );
  }
}
