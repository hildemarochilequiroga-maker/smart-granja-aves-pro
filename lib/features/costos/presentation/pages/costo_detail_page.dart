/// Página de detalle de un costo específico.
///
/// Muestra información completa del costo con diseño moderno:
/// - AppBar con acciones
/// - Header con tipo y monto
/// - Secciones organizadas con cards
/// - Acciones de aprobación/rechazo
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../application/providers/costos_provider.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';

/// Página de detalle de costo.
class CostoDetailPage extends ConsumerWidget {
  const CostoDetailPage({required this.costoId, super.key});

  final String costoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final costoAsync = ref.watch(costoByIdProvider(costoId));

    return costoAsync.when(
      loading: () => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: Text(l.commonError)),
        body: ErrorState(
          message: l.costoDetailLoadError,
          onRetry: () => ref.invalidate(costoByIdProvider(costoId)),
        ),
      ),
      data: (costo) {
        if (costo == null) {
          return _buildNotFoundView(context, theme);
        }
        return _CostoDetailView(costo: costo, costoId: costoId);
      },
    );
  }

  Widget _buildNotFoundView(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l.costoDetailNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.error,
            ),
            AppSpacing.gapBase,
            Text(l.costoDetailNotFound, style: theme.textTheme.titleLarge),
            AppSpacing.gapXl,
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: Text(l.commonBack),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista principal del detalle de costo.
class _CostoDetailView extends ConsumerWidget {
  const _CostoDetailView({required this.costo, required this.costoId});

  final CostoGasto costo;
  final String costoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final tipoInfo = _getTipoInfo(context, costo.tipo);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.costoDetailTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(
                AppRoutes.costoRegistrarConLote(
                  costo.loteId ?? '',
                  costo.granjaId,
                ),
                extra: costo,
              );
            },
            tooltip: l.costoDetailEditTooltip,
          ),
          _buildMenuButton(context, ref, theme),
          AppSpacing.hGapSm,
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header con tipo y monto
            _buildHeaderCard(context, theme, tipoInfo),
            AppSpacing.gapBase,

            // Estado (si requiere aprobación)
            if (costo.requiereAprobacion) ...[
              _buildEstadoCard(context, theme),
              AppSpacing.gapBase,
            ],

            // Ubicación (Granja y Lote)
            _buildUbicacionCard(context, ref, theme),
            AppSpacing.gapBase,

            // Información General
            _buildInfoGeneralCard(context, theme),
            AppSpacing.gapBase,

            // Proveedor (si existe)
            if (costo.proveedor != null && costo.proveedor!.isNotEmpty) ...[
              _buildProveedorCard(context, theme),
              AppSpacing.gapBase,
            ],

            // Observaciones (si existen)
            if (costo.observaciones != null &&
                costo.observaciones!.isNotEmpty) ...[
              _buildObservacionesCard(context, theme),
              AppSpacing.gapBase,
            ],

            // Información de Registro
            _buildRegistroCard(context, ref, theme),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ThemeData theme,
    _TipoInfo tipoInfo,
  ) {
    final l = S.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allLg,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Punto de color en lugar de icono
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: tipoInfo.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: tipoInfo.color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tipoInfo.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTimePretty(context, costo.fecha),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: tipoInfo.color.withValues(alpha: 0.1),
                borderRadius: AppRadius.allMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.commonAmount,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    Formatters.currencyValue(costo.monto),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: tipoInfo.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    Color estadoColor;
    String estadoNombre;

    if (costo.estaPendiente) {
      estadoColor = AppColors.warning;
      estadoNombre = l.costoDetailPending;
    } else if (costo.estaRechazado) {
      estadoColor = AppColors.error;
      estadoNombre = l.costoDetailRejected;
    } else if (costo.aprobado) {
      estadoColor = AppColors.success;
      estadoNombre = l.costoDetailApproved;
    } else {
      estadoColor = AppColors.info;
      estadoNombre = l.costoDetailNoStatus;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: estadoColor,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: estadoColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l.commonStatus,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
            ),
          ),
          Text(
            estadoNombre,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUbicacionCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final l = S.of(context);
    // Obtener nombre de la granja
    final granjaAsync = ref.watch(granjaByIdProvider(costo.granjaId));
    final granjaNombre = granjaAsync.maybeWhen(
      data: (granja) => granja?.nombre ?? l.commonFarmNotFound,
      orElse: () => l.commonLoading,
    );

    // Obtener nombre del lote si existe
    String? loteNombre;
    if (costo.loteId != null && costo.loteId!.isNotEmpty) {
      final loteAsync = ref.watch(loteByIdProvider(costo.loteId!));
      loteNombre = loteAsync.maybeWhen(
        data: (lote) => lote?.nombre ?? l.commonBatchNotFound,
        orElse: () => l.commonLoading,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.commonLocation,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  theme,
                  _InfoRow(label: l.commonFarm, value: granjaNombre),
                ),
                if (loteNombre != null)
                  _buildInfoRow(
                    theme,
                    _InfoRow(label: l.commonBatch, value: loteNombre),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGeneralCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.costoDetailGeneralInfo,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  theme,
                  _InfoRow(label: l.costoDetailConcept, value: costo.concepto),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProveedorCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.commonSupplier,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  theme,
                  _InfoRow(label: l.commonName, value: costo.proveedor!),
                ),
                if (costo.numeroFactura != null)
                  _buildInfoRow(
                    theme,
                    _InfoRow(
                      label: l.costoDetailInvoiceNo,
                      value: costo.numeroFactura!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObservacionesCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.commonObservations,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                costo.observaciones ?? '',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistroCard(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final l = S.of(context);
    final usuariosAsync = ref.watch(usuariosGranjaProvider(costo.granjaId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.commonRegistrationInfo,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: usuariosAsync.when(
              data: (usuarios) {
                final registrador = usuarios
                    .where((u) => u.usuarioId == costo.registradoPor)
                    .firstOrNull;

                return Column(
                  children: [
                    _buildInfoRow(
                      theme,
                      _InfoRow(
                        label: l.commonRegisteredBy,
                        value: registrador?.nombreCompleto ?? l.commonUser,
                      ),
                    ),
                    if (registrador != null)
                      _buildInfoRow(
                        theme,
                        _InfoRow(
                          label: l.commonRole,
                          value: registrador.rol.localizedDisplayName(
                            S.of(context),
                          ),
                        ),
                      ),
                    _buildInfoRow(
                      theme,
                      _InfoRow(
                        label: l.commonRegistrationDate,
                        value: _formatDateTimePretty(
                          context,
                          costo.fechaRegistro,
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (_, __) => Column(
                children: [
                  _buildInfoRow(
                    theme,
                    _InfoRow(
                      label: l.commonRegisteredBy,
                      value: costo.registradoPor,
                    ),
                  ),
                  _buildInfoRow(
                    theme,
                    _InfoRow(
                      label: l.commonRegistrationDate,
                      value: _formatDateTimePretty(
                        context,
                        costo.fechaRegistro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ThemeData theme, _InfoRow info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            info.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
  ) {
    final l = S.of(context);
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
      color: theme.colorScheme.surface,
      elevation: 3,
      offset: const Offset(0, 40),
      tooltip: l.commonMoreOptions,
      onSelected: (value) {
        switch (value) {
          case 'delete':
            _showDeleteDialog(context, ref);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'delete',
          height: 44,
          child: Text(
            l.commonDelete,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, WidgetRef ref) async {
    unawaited(HapticFeedback.lightImpact());
    final l = S.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: AppColors.error,
                size: 24,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(child: Text(l.costoDeleteTitle)),
          ],
        ),
        content: Text(
          '${l.costoDetailDeleteConfirm}\n\n'
          '${l.costoDetailDeleteWarning}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(l.commonDelete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      unawaited(HapticFeedback.heavyImpact());
      await ref.read(costoCrudProvider.notifier).eliminarCosto(costoId);

      if (context.mounted) {
        final costoState = ref.read(costoCrudProvider);
        if (costoState.errorMessage != null) {
          unawaited(HapticFeedback.vibrate());
          AppSnackBar.error(
            context,
            message: l.costoDetailDeleteError,
            detail: costoState.errorMessage,
          );
        } else {
          AppSnackBar.success(context, message: l.costoDetailDeleteSuccess);
          context.pop();
        }
      }
    }
  }

  _TipoInfo _getTipoInfo(BuildContext context, TipoGasto tipo) {
    final l = S.of(context);
    switch (tipo) {
      case TipoGasto.alimento:
        return _TipoInfo(
          label: l.costoTypeAlimento,
          icon: Icons.restaurant_rounded,
          color: AppColors.warning,
        );
      case TipoGasto.manoDeObra:
        return _TipoInfo(
          label: l.costoTypeManoObra,
          icon: Icons.people_rounded,
          color: AppColors.info,
        );
      case TipoGasto.energia:
        return _TipoInfo(
          label: l.costoTypeEnergia,
          icon: Icons.bolt_rounded,
          color: AppColors.amber,
        );
      case TipoGasto.medicamento:
        return _TipoInfo(
          label: l.costoTypeMedicamento,
          icon: Icons.medical_services_rounded,
          color: AppColors.error,
        );
      case TipoGasto.mantenimiento:
        return _TipoInfo(
          label: l.costoTypeMantenimiento,
          icon: Icons.build_rounded,
          color: AppColors.purple,
        );
      case TipoGasto.agua:
        return _TipoInfo(
          label: l.costoTypeAgua,
          icon: Icons.water_drop_rounded,
          color: AppColors.cyan,
        );
      case TipoGasto.transporte:
        return _TipoInfo(
          label: l.costoTypeTransporte,
          icon: Icons.local_shipping_rounded,
          color: AppColors.success,
        );
      case TipoGasto.administrativo:
        return _TipoInfo(
          label: l.costoTypeAdministrativo,
          icon: Icons.business_rounded,
          color: AppColors.outline,
        );
      case TipoGasto.depreciacion:
        return _TipoInfo(
          label: l.costoTypeDepreciacion,
          icon: Icons.trending_down_rounded,
          color: AppColors.brown,
        );
      case TipoGasto.financiero:
        return _TipoInfo(
          label: l.costoTypeFinanciero,
          icon: Icons.account_balance_rounded,
          color: AppColors.indigo,
        );
      case TipoGasto.otros:
        return _TipoInfo(
          label: l.costoTypeOtros,
          icon: Icons.more_horiz_rounded,
          color: AppColors.outline,
        );
    }
  }

  String _formatDateTimePretty(BuildContext context, DateTime date) {
    final l = S.of(context);
    final meses = [
      l.monthJanuary,
      l.monthFebruary,
      l.monthMarch,
      l.monthApril,
      l.monthMay,
      l.monthJune,
      l.monthJuly,
      l.monthAugust,
      l.monthSeptember,
      l.monthOctober,
      l.monthNovember,
      l.monthDecember,
    ];
    final hora = date.hour.toString().padLeft(2, '0');
    final minuto = date.minute.toString().padLeft(2, '0');
    return l.dateFormatDayOfMonthYearTime(
      '${date.day}',
      meses[date.month - 1],
      '${date.year}',
      '$hora:$minuto',
    );
  }
}

class _TipoInfo {
  final String label;
  final IconData icon;
  final Color color;

  _TipoInfo({required this.label, required this.icon, required this.color});
}

class _InfoRow {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});
}
