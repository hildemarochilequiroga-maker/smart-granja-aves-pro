/// Manejadores de acciones para la pantalla de detalle de galpón.
///
/// Centraliza la lógica de acciones del menú y operaciones del galpón.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../inventario/application/services/inventario_integracion_service.dart';
import '../../../../lotes/application/providers/lote_providers.dart';
import '../../../../lotes/domain/entities/lote.dart';
import '../../../application/application.dart';
import '../../../domain/entities/galpon.dart';
import '../../../domain/enums/enums.dart';
import '../galpon_dialogs.dart';

/// Manejadores de acciones del detalle de galpón.
class GalponDetailHandlers {
  const GalponDetailHandlers._();

  /// Obtiene el color según el estado del galpón.
  static Color getEstadoColor(Galpon galpon) {
    return galpon.estado.color;
  }

  /// Maneja las acciones del menú principal.
  static Future<void> handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
    String granjaId,
    String action,
  ) async {
    switch (action) {
      case 'editar':
        unawaited(
          context.push(AppRoutes.galponEditarById(granjaId, galpon.id)),
        );
      case 'cambiar_estado':
        await cambiarEstado(context, ref, galpon);
      case 'asignar_lote':
        await asignarLote(context, ref, galpon);
      case 'liberar':
        await liberarGalpon(context, ref, galpon);
      case 'desinfeccion':
        await registrarDesinfeccion(context, ref, galpon);
      case 'mantenimiento':
        await programarMantenimiento(context, ref, galpon);
      case 'compartir':
      case 'share':
        compartirGalpon(context, galpon);
      case 'eliminar':
      case 'delete':
        await eliminarGalpon(context, ref, galpon);
    }
  }

  /// Cambia el estado del galpón.
  static Future<void> cambiarEstado(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    final nuevoEstado = await GalponDialogs.showCambiarEstadoDialog(
      context,
      galpon,
    );

    if (nuevoEstado == null || !context.mounted) return;

    String? motivo;
    if (nuevoEstado == EstadoGalpon.cuarentena) {
      motivo = await GalponDialogs.showMotivoDialog(
        context,
        S.of(context).shedQuarantineReason,
      );
      if (motivo == null || !context.mounted) return;
    }

    await ref
        .read(galponNotifierProvider.notifier)
        .cambiarEstado(galpon.id, nuevoEstado, motivo: motivo);
  }

  /// Asigna un lote al galpón.
  static Future<void> asignarLote(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    if (!galpon.estaDisponible) {
      _showSnackBar(
        context,
        S.of(context).shedNotAvailableForAssign,
        isError: true,
      );
      return;
    }

    // Mostrar selector de lotes disponibles
    final loteSeleccionado = await showModalBottomSheet<Lote>(
      context: context,
      builder: (context) => _LoteSelectorSheet(granjaId: galpon.granjaId),
    );

    if (loteSeleccionado == null || !context.mounted) return;

    // Asignar el lote al galpón
    await ref
        .read(galponNotifierProvider.notifier)
        .asignarLote(galpon.id, loteSeleccionado.id);

    if (context.mounted) {
      _showSnackBar(
        context,
        S.of(context).shedBatchAssignedMsg(loteSeleccionado.codigo),
      );
    }
  }

  /// Libera el galpón actual.
  static Future<void> liberarGalpon(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    if (galpon.loteActualId == null) {
      _showSnackBar(context, S.of(context).shedNoBatchAssigned, isError: true);
      return;
    }

    final confirmed = await GalponDialogs.showLiberarDialog(
      context,
      galpon.nombre,
    );

    if (!confirmed || !context.mounted) return;

    await ref.read(galponNotifierProvider.notifier).liberarGalpon(galpon.id);
  }

  /// Registra una desinfección.
  static Future<void> registrarDesinfeccion(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    final datos = await GalponDialogs.showDesinfeccionDialog(
      context,
      granjaId: galpon.granjaId,
    );

    if (datos == null || !context.mounted) return;

    // Registrar desinfección
    await ref
        .read(galponNotifierProvider.notifier)
        .registrarDesinfeccion(
          galpon.id,
          datos.fecha,
          datos.productos,
          observaciones: datos.observaciones,
        );

    // Descontar items del inventario si hay seleccionados
    if (datos.itemsInventario != null && datos.itemsInventario!.isNotEmpty) {
      try {
        final integracionService = ref.read(
          inventarioIntegracionServiceProvider,
        );
        for (final item in datos.itemsInventario!) {
          await integracionService.registrarSalidaDesdeDesinfeccion(
            granjaId: galpon.granjaId,
            itemId: item.id,
            cantidad: 1, // Por defecto 1 unidad
            galponId: galpon.id,
            registradoPor: '', // Se obtiene del contexto de auth
          );
        }
      } on Exception catch (e) {
        debugPrint('Error al descontar inventario de desinfección: $e');
      }
    }
  }

  /// Programa un mantenimiento.
  static Future<void> programarMantenimiento(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    final datos = await GalponDialogs.showMantenimientoDialog(context);

    if (datos == null || !context.mounted) return;

    await ref
        .read(galponNotifierProvider.notifier)
        .programarMantenimiento(
          galpon.id,
          datos.fechaInicio,
          datos.descripcion,
        );
  }

  /// Comparte información del galpón.
  static void compartirGalpon(BuildContext context, Galpon galpon) {
    final l = S.of(context);
    final info =
        '''
?? ${galpon.nombre}
 ${l.shedShareType(galpon.tipo.localizedDisplayName(S.of(context)))}
?? ${l.shedShareCapacity(galpon.capacidadMaxima)}
?? ${l.shedShareOccupation(galpon.porcentajeOcupacion.toStringAsFixed(1))}
${galpon.ubicacion != null ? '?? ${galpon.ubicacion}' : ''}
${galpon.descripcion != null ? '?? ${galpon.descripcion}' : ''}
''';

    Clipboard.setData(ClipboardData(text: info.trim()));
    _showSnackBar(context, S.of(context).shedInfoCopied);
  }

  /// Elimina el galpón con confirmación.
  static Future<void> eliminarGalpon(
    BuildContext context,
    WidgetRef ref,
    Galpon galpon,
  ) async {
    if (galpon.loteActualId != null) {
      _showSnackBar(
        context,
        S.of(context).shedCannotDeleteWithBatch,
        isError: true,
      );
      return;
    }

    final confirmed = await GalponDialogs.showEliminarDialog(
      context,
      galpon.nombre,
    );

    if (!confirmed || !context.mounted) return;

    await ref.read(galponNotifierProvider.notifier).eliminarGalpon(galpon.id);

    if (!context.mounted) return;
    final galponState = ref.read(galponNotifierProvider);
    if (galponState is GalponError) {
      _showSnackBar(
        context,
        S.of(context).shedDeleteErrorMsg(galponState.mensaje),
        isError: true,
      );
    } else {
      _showSnackBar(context, S.of(context).shedDeletedCorrectly);
      context.pop();
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

/// Sheet para seleccionar un lote disponible.
class _LoteSelectorSheet extends ConsumerWidget {
  const _LoteSelectorSheet({required this.granjaId});

  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lotesAsync = ref.watch(lotesStreamProvider(granjaId));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          AppSpacing.gapBase,
          Text(
            S.of(context).shedSelectBatch,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).shedSelectBatchForAssign,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapBase,
          Flexible(
            child: lotesAsync.when(
              data: (lotes) {
                // Filtrar solo lotes activos sin galpón asignado
                final lotesDisponibles = lotes
                    .where((l) => l.estaActivo && l.galponId.isEmpty)
                    .toList();

                if (lotesDisponibles.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          AppSpacing.gapBase,
                          Text(
                            S.of(context).shedNoBatchesAvailable,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppSpacing.gapSm,
                          Text(
                            S.of(context).shedCreateBatchFirst,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: lotesDisponibles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final lote = lotesDisponibles[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          Icons.inventory_2,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(lote.nombre ?? lote.codigo),
                      subtitle: Text(
                        S
                            .of(context)
                            .shedBirdsBullet(
                              lote.cantidadActual ?? 0,
                              lote.tipoAve.localizedDisplayName(S.of(context)),
                            ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.colorScheme.outline,
                      ),
                      onTap: () => Navigator.pop(context, lote),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    S.of(context).shedErrorLoadingBatches,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
