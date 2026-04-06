/// Manejadores de acciones para la pantalla de detalle de lote.
///
/// Centraliza la lógica de acciones del menú y operaciones del lote.
library;

// ignore_for_file: unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../../core/widgets/app_snackbar.dart';
import '../../../application/providers/providers.dart';
import '../../../domain/entities/lote.dart';
import '../../../domain/enums/enums.dart';
import 'lote_detail_utils.dart';

/// Manejadores de acciones del detalle de lote.
class LoteDetailHandlers {
  const LoteDetailHandlers._();

  /// Obtiene el color según el estado del lote.
  static Color getEstadoColor(Lote lote) {
    return LoteEstadoInfo.getColor(lote.estado);
  }

  /// Maneja las acciones del menú principal.
  static Future<void> handleMenuAction(
    BuildContext context,
    WidgetRef ref,
    Lote lote,
    String granjaId,
    String action,
  ) async {
    switch (action) {
      case 'editar':
        unawaited(
          context.push(
            AppRoutes.loteEditarById(granjaId, lote.galponId, lote.id),
          ),
        );
      case 'cambiar_estado':
        await cambiarEstado(context, ref, lote);
      case 'cuarentena':
        await ponerEnCuarentena(context, ref, lote);
      case 'cerrar':
        await cerrarLote(context, ref, lote, granjaId);
      case 'registrar_peso':
        unawaited(
          context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-peso',
            extra: lote,
          ),
        );
      case 'registrar_mortalidad':
        unawaited(
          context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-mortalidad',
            extra: lote,
          ),
        );
      case 'registrar_consumo':
        unawaited(
          context.push(
            '/granjas/$granjaId/lotes/${lote.id}/registrar-consumo',
            extra: lote,
          ),
        );
      case 'historial':
        await mostrarHistorial(context, lote);
      case 'compartir':
      case 'share':
        compartirLote(context, lote);
      case 'eliminar':
      case 'delete':
        await eliminarLote(context, ref, lote);
    }
  }

  /// Cambia el estado del lote.
  static Future<void> cambiarEstado(
    BuildContext context,
    WidgetRef ref,
    Lote lote,
  ) async {
    final nuevoEstado = await _showCambiarEstadoDialog(context, lote);

    if (nuevoEstado == null || !context.mounted) return;

    String? motivo;
    if (nuevoEstado == EstadoLote.cuarentena ||
        nuevoEstado == EstadoLote.suspendido) {
      motivo = await _showMotivoDialog(
        context,
        S
            .of(context)
            .batchReasonForState(
              nuevoEstado.localizedDisplayName(S.of(context)).toLowerCase(),
            ),
      );
      if (motivo == null || !context.mounted) return;
    }

    // Actualizar estado usando el provider correspondiente
    await ref
        .read(loteNotifierProvider.notifier)
        .cambiarEstado(lote.id, nuevoEstado, motivo: motivo);

    if (context.mounted) {
      _showSnackBar(
        context,
        S
            .of(context)
            .batchStatusUpdatedTo(
              nuevoEstado.localizedDisplayName(S.of(context)),
            ),
        customColor: _getColorEstado(nuevoEstado),
      );
    }
  }

  /// Obtiene el color de un estado.
  static Color _getColorEstado(EstadoLote estado) {
    return switch (estado) {
      EstadoLote.activo => AppColors.success,
      EstadoLote.cerrado => AppColors.grey600,
      EstadoLote.cuarentena => AppColors.warning,
      EstadoLote.vendido => AppColors.info,
      EstadoLote.enTransferencia => AppColors.purple,
      EstadoLote.suspendido => AppColors.error,
    };
  }

  /// Pone el lote en cuarentena.
  static Future<void> ponerEnCuarentena(
    BuildContext context,
    WidgetRef ref,
    Lote lote,
  ) async {
    if (lote.estado == EstadoLote.cuarentena) {
      _showSnackBar(
        context,
        S.of(context).batchAlreadyInQuarantine,
        isError: true,
      );
      return;
    }

    final motivo = await _showMotivoDialog(
      context,
      S.of(context).batchQuarantineReason,
    );

    if (motivo == null || !context.mounted) return;

    await ref
        .read(loteNotifierProvider.notifier)
        .cambiarEstado(lote.id, EstadoLote.cuarentena, motivo: motivo);

    if (context.mounted) {
      _showSnackBar(context, S.of(context).batchPutInQuarantineSuccess);
    }
  }

  /// Cierra el lote.
  static Future<void> cerrarLote(
    BuildContext context,
    WidgetRef ref,
    Lote lote,
    String granjaId,
  ) async {
    if (lote.estado == EstadoLote.cerrado) {
      _showSnackBar(context, S.of(context).batchAlreadyClosed, isError: true);
      return;
    }

    // Navegar a la página de cierre de lote
    unawaited(
      context.push(AppRoutes.loteCerrarById(granjaId, lote.galponId, lote.id)),
    );
  }

  /// Muestra el historial del lote.
  static Future<void> mostrarHistorial(BuildContext context, Lote lote) async {
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _HistorialSheet(lote: lote),
      ),
    );
  }

  /// Comparte información del lote.
  static void compartirLote(BuildContext context, Lote lote) {
    final l = S.of(context);
    final birdsFormat = l.batchShareBirdsFormat(
      lote.avesActuales.toString(),
      lote.cantidadInicial.toString(),
    );

    final info =
        '''
📦 ${lote.displayName}
🏷️ ${l.batchShareCode}: ${lote.codigo}
🐔 ${l.batchShareType}: ${lote.tipoAve.localizedDisplayName(l)}
${lote.raza != null ? '🧬 ${l.batchShareBreed}: ${lote.raza}' : ''}
📊 ${l.batchShareStatus}: ${lote.estado.localizedDisplayName(l)}
🔢 ${l.batchShareBirds}: $birdsFormat
📅 ${l.batchShareEntry}: ${_formatDate(lote.fechaIngreso)}
⏳ ${l.batchShareAge}: ${l.batchAgeWeeks(lote.edadActualSemanas.toString())}
${lote.pesoPromedioActual != null ? '⚖️ ${l.batchShareWeight}: ${lote.pesoPromedioActual!.toStringAsFixed(2)} kg' : ''}
📉 ${l.batchShareMortality}: ${lote.porcentajeMortalidad.toStringAsFixed(1)}%
''';

    Clipboard.setData(ClipboardData(text: info.trim()));
    _showSnackBar(context, l.batchInfoCopied);
  }

  /// Elimina el lote con confirmación.
  static Future<void> eliminarLote(
    BuildContext context,
    WidgetRef ref,
    Lote lote,
  ) async {
    if (lote.estado == EstadoLote.activo) {
      _showSnackBar(
        context,
        S.of(context).batchCannotDeleteActive,
        isError: true,
      );
      return;
    }

    final confirmed = await _showEliminarDialog(context, lote.displayName);

    if (!confirmed || !context.mounted) return;

    final result = await ref
        .read(loteNotifierProvider.notifier)
        .eliminar(lote.id);

    if (context.mounted) {
      result.fold(
        (failure) {
          _showSnackBar(
            context,
            S.of(context).batchErrorDeletingDetail(failure.message),
            isError: true,
          );
        },
        (_) {
          _showSnackBar(context, S.of(context).batchDeletedCorrectly);
          context.pop();
        },
      );
    }
  }

  // ==================== DIÁLOGOS ====================

  static Future<EstadoLote?> _showCambiarEstadoDialog(
    BuildContext context,
    Lote lote,
  ) async {
    return showDialog<EstadoLote>(
      context: context,
      builder: (context) => _LoteCambiarEstadoDialog(lote: lote),
    );
  }

  static Future<String?> _showMotivoDialog(
    BuildContext context,
    String title,
  ) async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: S.of(context).batchDescribeReason,
            border: OutlineInputBorder(borderRadius: AppRadius.allMd),
          ),
          maxLines: 3,
          autofocus: true,
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
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(S.of(context).commonConfirm),
          ),
        ],
      ),
    );
  }

  static Future<bool> _showEliminarDialog(
    BuildContext context,
    String nombreLote,
  ) async {
    final result = await showAppConfirmDialog(
      context: context,
      title: S.of(context).batchDeleteConfirm,
      message: S.of(context).batchDeleteMessage(nombreLote),
      type: AppDialogType.danger,
    );

    return result;
  }

  // ==================== UTILIDADES ====================

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Muestra un SnackBar.
  static void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Color? customColor,
  }) {
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else if (customColor == AppColors.warning) {
      AppSnackBar.warning(context, message: message);
    } else if (customColor == AppColors.info) {
      AppSnackBar.info(context, message: message);
    } else {
      AppSnackBar.success(context, message: message);
    }
  }
}

// ==================== HISTORIAL SHEET ====================

class _HistorialSheet extends StatelessWidget {
  const _HistorialSheet({required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.75,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Row(
              children: [
                const Icon(Icons.history, color: AppColors.info),
                AppSpacing.hGapMd,
                Text(
                  S.of(context).batchBatchHistory,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: colorScheme.outline),
                  AppSpacing.gapBase,
                  Text(
                    S.of(context).batchHistoryComingSoon,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== CAMBIAR ESTADO DIALOG ====================

/// Diálogo para cambiar estado del lote.
class _LoteCambiarEstadoDialog extends StatelessWidget {
  const _LoteCambiarEstadoDialog({required this.lote});

  final Lote lote;

  Color _getColorEstado(EstadoLote estado) {
    return switch (estado) {
      EstadoLote.activo => AppColors.success,
      EstadoLote.cerrado => AppColors.grey600,
      EstadoLote.cuarentena => AppColors.warning,
      EstadoLote.vendido => AppColors.info,
      EstadoLote.enTransferencia => AppColors.purple,
      EstadoLote.suspendido => AppColors.error,
    };
  }

  String _getDescripcionEstado(BuildContext context, EstadoLote estado) {
    return switch (estado) {
      EstadoLote.activo => S.of(context).batchStatusDescActive,
      EstadoLote.cerrado => S.of(context).batchStatusDescClosed,
      EstadoLote.cuarentena => S.of(context).batchStatusDescQuarantine,
      EstadoLote.vendido => S.of(context).batchStatusDescSold,
      EstadoLote.enTransferencia => S.of(context).batchStatusDescTransfer,
      EstadoLote.suspendido => S.of(context).batchStatusDescSuspended,
    };
  }

  Widget _buildColorDot(Color color, {double size = 12}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final estadosPermitidos = lote.estado.transicionesPermitidas;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      title: Text(
        S.of(context).batchChangeStatus,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Label estado actual
          Text(
            S.of(context).batchCurrentStatus,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          AppSpacing.gapSm,
          // Card estado actual
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: AppRadius.allSm,
              border: Border.all(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onSurface.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildColorDot(_getColorEstado(lote.estado)),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lote.estado.localizedDisplayName(S.of(context)),
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      AppSpacing.gapXxxs,
                      Text(
                        _getDescripcionEstado(context, lote.estado),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapBase,
          if (estadosPermitidos.isEmpty)
            Text(
              S.of(context).batchNoTransitions,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            )
          else ...[
            Text(
              S.of(context).batchSelectNewStatusLabel,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            AppSpacing.gapSm,
            // Opciones de estado como tarjetas
            ...estadosPermitidos.map((estado) {
              final esEstadoFinal =
                  estado == EstadoLote.cerrado || estado == EstadoLote.vendido;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (esEstadoFinal) {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allMd,
                            ),
                            title: Text(
                              S
                                  .of(context)
                                  .batchConfirmStatusChange(
                                    estado.localizedDisplayName(S.of(context)),
                                  ),
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              S.of(context).batchPermanentStatusWarning,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.onSurfaceVariant,
                                ),
                                child: Text(S.of(context).commonCancel),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.allSm,
                                  ),
                                ),
                                child: Text(S.of(context).commonConfirm),
                              ),
                            ],
                          ),
                        );
                        if (confirmar == true && context.mounted) {
                          Navigator.pop(context, estado);
                        }
                      } else {
                        Navigator.pop(context, estado);
                      }
                    },
                    borderRadius: AppRadius.allSm,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: AppRadius.allSm,
                        border: Border.all(
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.onSurface.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildColorDot(_getColorEstado(estado)),
                          AppSpacing.hGapMd,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  estado.localizedDisplayName(S.of(context)),
                                  style: AppTextStyles.titleSmall.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                AppSpacing.gapXxxs,
                                Text(
                                  _getDescripcionEstado(context, estado),
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                                if (esEstadoFinal)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.xxs,
                                    ),
                                    child: Text(
                                      S.of(context).batchPermanentStatus,
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.md,
            ),
          ),
          child: Text(S.of(context).commonCancel),
        ),
      ],
    );
  }
}
