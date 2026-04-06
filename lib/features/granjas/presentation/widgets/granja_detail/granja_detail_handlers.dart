/// Manejadores de acciones para la pantalla de detalle de granja.
///
/// Utiliza el sistema de dialogs unificado para mantener
/// consistencia visual en todas las confirmaciones.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../application/application.dart';
import '../../../domain/entities/granja.dart';
import '../../../domain/enums/enums.dart';
import '../granja_dialogs.dart';

/// Manejadores de acciones del detalle de granja.
class GranjaDetailHandlers {
  const GranjaDetailHandlers._();

  /// Obtiene el color según el estado de la granja.
  static Color getEstadoColor(Granja granja) {
    return switch (granja.estado) {
      EstadoGranja.activo => AppColors.success,
      EstadoGranja.inactivo => AppColors.grey600,
      EstadoGranja.mantenimiento => AppColors.warning,
    };
  }

  /// Maneja las acciones del menú principal.
  static Future<void> handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        unawaited(context.push(AppRoutes.granjaEditarById(granja.id)));
      case 'colaboradores':
        unawaited(
          context.push(
            AppRoutes.granjaColaboradoresById(granja.id),
            extra: {'granjaNombre': granja.nombre},
          ),
        );
      case 'compartir':
      case 'share':
        shareGranja(context, granja);
      case 'activar':
        await activarGranja(context, ref, granja);
      case 'suspender':
        await suspenderGranja(context, ref, granja);
      case 'toggle':
      case 'cambiar_estado':
        await cambiarEstado(context, ref, granja);
      case 'mantenimiento':
        await ponerEnMantenimiento(context, ref, granja);
      case 'eliminar':
      case 'delete':
        await deleteGranja(context, ref, granja);
    }
  }

  /// Activa la granja.
  static Future<void> activarGranja(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    if (granja.estaActiva) {
      _showSnackBar(context, S.of(context).farmAlreadyActive, isError: true);
      return;
    }

    final confirmed = await GranjaDialogs.showActivarDialog(
      context,
      granja.nombre,
    );

    if (!confirmed || !context.mounted) return;

    await ref.read(granjaNotifierProvider.notifier).activarGranja(granja.id);

    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaSuccess) {
      _showSnackBar(
        context,
        state.mensaje ?? S.of(context).farmActivatedSuccess,
      );
    } else if (state is GranjaError) {
      _showSnackBar(context, state.mensaje, isError: true);
    }
  }

  /// Suspende la granja.
  static Future<void> suspenderGranja(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    if (granja.estaSuspendida) {
      _showSnackBar(context, S.of(context).farmAlreadySuspended, isError: true);
      return;
    }

    final confirmed = await GranjaDialogs.showSuspenderDialog(
      context,
      granja.nombre,
    );

    if (!confirmed || !context.mounted) return;

    await ref.read(granjaNotifierProvider.notifier).suspenderGranja(granja.id);

    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaSuccess) {
      _showSnackBar(
        context,
        state.mensaje ?? S.of(context).farmSuspendedSuccess,
      );
    } else if (state is GranjaError) {
      _showSnackBar(context, state.mensaje, isError: true);
    }
  }

  /// Alterna el estado de la granja (activar/suspender).
  static Future<void> toggleEstadoGranja(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    final isActive = granja.estaActiva;

    final confirmed = await GranjaDialogs.showToggleEstadoDialog(
      context,
      granja.nombre,
      isActive: isActive,
    );

    if (!confirmed || !context.mounted) return;

    final notifier = ref.read(granjaNotifierProvider.notifier);

    if (isActive) {
      await notifier.suspenderGranja(granja.id);
    } else {
      await notifier.activarGranja(granja.id);
    }

    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaSuccess) {
      _showSnackBar(
        context,
        state.mensaje ??
            (isActive
                ? S.of(context).farmSuspendedSuccess
                : S.of(context).farmActivatedSuccess),
      );
    } else if (state is GranjaError) {
      _showSnackBar(context, state.mensaje, isError: true);
    }
  }

  /// Cambia el estado de la granja mostrando un diálogo de selección.
  static Future<void> cambiarEstado(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    final nuevoEstado = await GranjaDialogs.showCambiarEstadoDialog(
      context,
      granja,
    );

    if (nuevoEstado == null || !context.mounted) return;

    final notifier = ref.read(granjaNotifierProvider.notifier);

    switch (nuevoEstado) {
      case EstadoGranja.activo:
        await notifier.activarGranja(granja.id);
      case EstadoGranja.inactivo:
        await notifier.suspenderGranja(granja.id);
      case EstadoGranja.mantenimiento:
        await notifier.ponerEnMantenimiento(granja.id);
    }

    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaSuccess) {
      _showSnackBar(
        context,
        state.mensaje ??
            S
                .of(context)
                .farmStatusUpdated(
                  nuevoEstado.localizedDisplayName(S.of(context)),
                ),
      );
    } else if (state is GranjaError) {
      _showSnackBar(context, state.mensaje, isError: true);
    }
  }

  /// Pone una granja en mantenimiento.
  static Future<void> ponerEnMantenimiento(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    if (!granja.estaActiva) {
      _showSnackBar(
        context,
        S.of(context).farmOnlyActiveCanMaintenance,
        isError: true,
      );
      return;
    }

    final confirmed = await GranjaDialogs.showMantenimientoDialog(
      context,
      granja.nombre,
    );

    if (!confirmed || !context.mounted) return;

    await ref
        .read(granjaNotifierProvider.notifier)
        .ponerEnMantenimiento(granja.id);

    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaSuccess) {
      _showSnackBar(context, S.of(context).farmMaintenanceSuccess);
    } else if (state is GranjaError) {
      _showSnackBar(context, state.mensaje, isError: true);
    }
  }

  /// Comparte información de la granja.
  static void shareGranja(BuildContext context, Granja granja) {
    final info =
        '''
🏭 ${granja.nombre}
👤 Propietario: ${granja.propietarioNombre}
📍 ${granja.direccion.direccionCompleta}
${granja.telefono != null ? '📞 ${granja.telefono}' : ''}
${granja.correo != null ? '✉️ ${granja.correo}' : ''}
''';

    Clipboard.setData(ClipboardData(text: info.trim()));
    _showSnackBar(context, S.of(context).farmInfoCopiedToClipboard);
  }

  /// Elimina la granja con confirmación.
  static Future<void> deleteGranja(
    BuildContext context,
    WidgetRef ref,
    Granja granja,
  ) async {
    final confirmed = await GranjaDialogs.showEliminarDialog(
      context,
      granja.nombre,
    );

    if (!confirmed || !context.mounted) return;

    // Ejecutar eliminación
    await ref.read(granjaNotifierProvider.notifier).eliminarGranja(granja.id);

    // Escuchar el resultado
    if (!context.mounted) return;

    final state = ref.read(granjaNotifierProvider);

    if (state is GranjaDeleted) {
      // Éxito: navegar de vuelta y mostrar confirmación
      if (context.mounted) {
        context.go(AppRoutes.granjas);

        // Mostrar SnackBar después de navegar
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            _showSnackBar(
              context,
              state.mensaje ?? S.of(context).farmDeletedSuccess,
            );
          }
        });
      }
    } else if (state is GranjaError) {
      // Error: mostrar mensaje
      if (context.mounted) {
        _showSnackBar(context, state.mensaje, isError: true);
      }
    }
  }

  /// Muestra un SnackBar.
  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
  }
}
