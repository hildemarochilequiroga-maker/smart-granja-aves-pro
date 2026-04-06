/// Página de detalle de una venta de producto.
///
/// Muestra información completa de la venta con diseño moderno:
/// - AppBar con acciones
/// - Header con tipo y monto
/// - Secciones organizadas con cards
/// - Información del cliente
/// - Detalles del producto
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../application/providers/ventas_provider.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/enums/tipo_producto_venta.dart';
import '../../domain/enums/estado_venta.dart';

/// Página de detalle de venta.
class VentaDetailPage extends ConsumerWidget {
  const VentaDetailPage({required this.ventaId, super.key});

  final String ventaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final ventaAsync = ref.watch(ventaProductoPorIdProvider(ventaId));

    return ventaAsync.when(
      data: (venta) {
        if (venta == null) {
          return _buildNotFoundView(context, theme, l);
        }
        return _VentaDetailView(venta: venta, ventaId: ventaId);
      },
      loading: () => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Center(
          child: CircularProgressIndicator(color: theme.colorScheme.primary),
        ),
      ),
      error: (error, _) => _buildErrorView(context, theme, l, error.toString()),
    );
  }

  Widget _buildNotFoundView(BuildContext context, ThemeData theme, S l) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l.ventaNotFound)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.base),
            Text(l.ventaNotFound, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xl),
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

  Widget _buildErrorView(
    BuildContext context,
    ThemeData theme,
    S l,
    String error,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(l.commonError)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: AppSpacing.base),
            Text(
              l.commonErrorWithDetail(error.toString()),
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: Text(l.commonBack),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vista principal del detalle de venta.
class _VentaDetailView extends ConsumerWidget {
  const _VentaDetailView({required this.venta, required this.ventaId});

  final VentaProducto venta;
  final String ventaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final tipoInfo = _getTipoInfo(venta.tipoProducto);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.ventaDetailTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Indicador de sincronización
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: SyncStatusBadge(),
          ),
          if (venta.estado.esModificable)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push(
                  AppRoutes.ventaRegistrarConLote(venta.loteId, venta.granjaId),
                  extra: venta,
                );
              },
              tooltip: l.ventaEditTooltip,
            ),
          _buildMenuButton(context, ref, theme),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header con tipo y monto
            _buildHeaderCard(context, theme, tipoInfo),
            const SizedBox(height: AppSpacing.base),

            // Estado de la venta
            _buildEstadoCard(context, theme),
            const SizedBox(height: AppSpacing.base),

            // Ubicación (Granja y Lote)
            _buildUbicacionCard(context, ref, theme),
            const SizedBox(height: AppSpacing.base),

            // Información del cliente
            _buildClienteCard(context, theme),
            const SizedBox(height: AppSpacing.base),

            // Detalles del producto
            _buildProductoCard(context, theme),
            const SizedBox(height: AppSpacing.base),

            // Observaciones
            if (venta.observaciones != null &&
                venta.observaciones!.isNotEmpty) ...[
              _buildObservacionesCard(context, theme),
              const SizedBox(height: AppSpacing.base),
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
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venta.tipoProducto.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDateTimePretty(venta.fechaVenta, l),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: AppRadius.allMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.commonTotal,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    Formatters.currencyValue(venta.totalFinal),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.success,
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
    final estadoColor = _getEstadoColor(venta.estado);

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
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          Text(
            venta.estado.displayName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.white,
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
    final granjaAsync = ref.watch(granjaByIdProvider(venta.granjaId));
    final granjaNombre = granjaAsync.maybeWhen(
      data: (granja) => granja?.nombre ?? l.commonFarmNotFound,
      orElse: () => l.commonLoading,
    );

    // Obtener nombre del lote
    final loteAsync = ref.watch(loteByIdProvider(venta.loteId));
    final loteNombre = loteAsync.maybeWhen(
      data: (lote) => lote?.nombre ?? l.commonBatchNotFound,
      orElse: () => l.commonLoading,
    );

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

  Widget _buildClienteCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título fuera de la card
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.ventaClient,
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
                  _InfoRow(label: l.commonName, value: venta.cliente.nombre),
                ),
                _buildInfoRow(
                  theme,
                  _InfoRow(
                    label: l.ventaDocument,
                    value:
                        '${venta.cliente.tipoDocumento}: ${venta.cliente.identificacion}',
                  ),
                ),
                _buildInfoRow(
                  theme,
                  _InfoRow(label: l.ventaPhone, value: venta.cliente.contacto),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductoCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título fuera de la card
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.ventaProductDetails,
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
              children: [..._buildProductoDetails(theme, l)],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildProductoDetails(ThemeData theme, S l) {
    final rows = <_InfoRow>[];

    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
        rows.addAll([
          _InfoRow(
            label: l.ventaBirdQuantity,
            value: '${venta.cantidadAves ?? 0}',
          ),
          _InfoRow(
            label: l.ventaAverageWeight,
            value: '${(venta.pesoPromedioKg ?? 0).toStringAsFixed(2)} kg',
          ),
          _InfoRow(
            label: l.ventaPricePerKg(Formatters.currencySymbol),
            value: Formatters.currencyValue(venta.precioKg ?? 0),
          ),
          _InfoRow(
            label: l.ventaSubtotal,
            value: Formatters.currencyValue(venta.subtotal),
          ),
        ]);
        break;

      case TipoProductoVenta.huevos:
        if (venta.huevosPorClasificacion != null) {
          for (final entry in venta.huevosPorClasificacion!.entries) {
            final precio = venta.preciosPorDocena?[entry.key] ?? 0;
            rows.add(
              _InfoRow(
                label: ErrorMessages.format('ACT_HUEVOS_CLASIFICACION', {
                  'clasificacion': entry.key.displayName,
                  'cantidad': '${entry.value}',
                }),
                value: '${Formatters.currencyValue(precio)}/docena',
              ),
            );
          }
        }
        rows.add(
          _InfoRow(
            label: l.ventaSubtotal,
            value: Formatters.currencyValue(venta.subtotal),
          ),
        );
        break;

      case TipoProductoVenta.pollinaza:
        rows.addAll([
          _InfoRow(
            label: l.ventaQuantity,
            value:
                '${(venta.cantidadPollinaza ?? 0).toStringAsFixed(2)} ${venta.unidadPollinaza?.displayName ?? ''}',
          ),
          _InfoRow(
            label: l.ventaUnitPrice,
            value: Formatters.currencyValue(venta.precioUnitarioPollinaza ?? 0),
          ),
          _InfoRow(
            label: l.ventaSubtotal,
            value: Formatters.currencyValue(venta.subtotal),
          ),
        ]);
        break;

      case TipoProductoVenta.avesFaenadas:
        rows.addAll([
          _InfoRow(
            label: l.ventaBirdQuantity,
            value: '${venta.cantidadAves ?? 0}',
          ),
          _InfoRow(
            label: l.ventaSlaughterWeight,
            value: '${(venta.pesoFaenado ?? 0).toStringAsFixed(2)} kg',
          ),
          _InfoRow(
            label: l.ventaPricePerKg(Formatters.currencySymbol),
            value: Formatters.currencyValue(venta.precioKg ?? 0),
          ),
          if (venta.rendimientoCanal != null)
            _InfoRow(
              label: l.ventaCarcassYield,
              value: '${venta.rendimientoCanal!.toStringAsFixed(1)}%',
            ),
          _InfoRow(
            label: l.ventaSubtotal,
            value: Formatters.currencyValue(venta.subtotal),
          ),
        ]);
        break;
    }

    // Agregar descuento si aplica
    if (venta.descuentoPorcentaje > 0) {
      rows.add(
        _InfoRow(
          label: l.ventaDiscountPercent(
            venta.descuentoPorcentaje.toStringAsFixed(1),
          ),
          value: '- ${Formatters.currencyValue(venta.montoDescuento)}',
          valueColor: AppColors.warning,
        ),
      );
    }

    // Total final
    rows.add(
      _InfoRow(
        label: l.ventaTotalLabel,
        value: Formatters.currencyValue(venta.totalFinal),
        isBold: true,
        valueColor: AppColors.success,
      ),
    );

    return rows.map((row) => _buildInfoRow(theme, row)).toList();
  }

  Widget _buildObservacionesCard(BuildContext context, ThemeData theme) {
    final l = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título fuera de la card
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
                venta.observaciones ?? '',
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
    final usuariosAsync = ref.watch(usuariosGranjaProvider(venta.granjaId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título fuera de la card
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
                    .where((u) => u.usuarioId == venta.registradoPor)
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
                        value:
                            '${venta.fechaRegistro.day}/${venta.fechaRegistro.month}/${venta.fechaRegistro.year}',
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
                      value: venta.registradoPor,
                    ),
                  ),
                  _buildInfoRow(
                    theme,
                    _InfoRow(
                      label: l.commonRegistrationDate,
                      value:
                          '${venta.fechaRegistro.day}/${venta.fechaRegistro.month}/${venta.fechaRegistro.year}',
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
              fontWeight: info.isBold ? FontWeight.bold : null,
            ),
          ),
          Flexible(
            child: Text(
              info.value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: info.isBold ? FontWeight.bold : FontWeight.w500,
                color: info.valueColor,
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
      onSelected: (value) async {
        switch (value) {
          case 'delete':
            unawaited(HapticFeedback.lightImpact());
            final confirm = await showAppConfirmDialog(
              context: context,
              title: l.ventaDeleteTitle,
              message: l.ventaDeleteMessage(venta.tipoProducto.displayName),
              type: AppDialogType.danger,
            );

            if (confirm == true && context.mounted) {
              await ref
                  .read(ventaProductoCrudProvider.notifier)
                  .eliminarVenta(venta.id);
              if (context.mounted) {
                context.pop();
              }
            }
            break;
          case 'share':
            _compartirVenta(context, venta);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'share',
          height: 44,
          child: Text(
            l.ventaShare,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (venta.estado.esModificable) ...[
          const PopupMenuDivider(height: 8),
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
      ],
    );
  }

  Color _getEstadoColor(EstadoVenta estado) {
    switch (estado) {
      case EstadoVenta.pendiente:
        return AppColors.warning;
      case EstadoVenta.confirmada:
        return AppColors.info;
      case EstadoVenta.enPreparacion:
        return AppColors.info;
      case EstadoVenta.listaParaDespacho:
        return AppColors.success;
      case EstadoVenta.enTransito:
        return AppColors.purple;
      case EstadoVenta.entregada:
        return AppColors.success;
      case EstadoVenta.facturada:
        return AppColors.success;
      case EstadoVenta.cancelada:
        return AppColors.error;
      case EstadoVenta.devuelta:
        return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTimePretty(DateTime date, S l) {
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

  _TipoInfo _getTipoInfo(TipoProductoVenta tipo) {
    switch (tipo) {
      case TipoProductoVenta.avesVivas:
        return _TipoInfo(Icons.pets_rounded, AppColors.warning);
      case TipoProductoVenta.huevos:
        return _TipoInfo(Icons.egg_rounded, AppColors.amber);
      case TipoProductoVenta.pollinaza:
        return _TipoInfo(Icons.grass_rounded, AppColors.brown);
      case TipoProductoVenta.avesFaenadas:
        return _TipoInfo(Icons.restaurant_rounded, AppColors.error);
      case TipoProductoVenta.avesDescarte:
        return _TipoInfo(Icons.low_priority_rounded, AppColors.outline);
    }
  }

  void _compartirVenta(BuildContext context, VentaProducto venta) {
    final l = S.of(context);
    final buffer = StringBuffer();

    buffer.writeln('?? ${l.ventaReceiptTitle}');
    buffer.writeln('????????????????????????');
    buffer.writeln('');
    buffer.writeln(l.shareDateLine(_formatDate(venta.fechaVenta)));
    buffer.writeln(l.shareTypeLine(venta.tipoProducto.displayName));

    // Mostrar cantidad según tipo
    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesFaenadas:
      case TipoProductoVenta.avesDescarte:
        if (venta.cantidadAves != null) {
          buffer.writeln(l.shareQuantityBirdsLine('${venta.cantidadAves}'));
        }
        if (venta.precioKg != null) {
          buffer.writeln(
            l.sharePricePerKgLine(
              Formatters.currencySymbol,
              venta.precioKg!.toStringAsFixed(2),
            ),
          );
        }
        break;
      case TipoProductoVenta.huevos:
        buffer.writeln(l.shareEggsLine('${venta.totalHuevos}'));
        break;
      case TipoProductoVenta.pollinaza:
        if (venta.cantidadPollinaza != null) {
          buffer.writeln(
            l.shareQuantityLine(
              '${venta.cantidadPollinaza}',
              venta.unidadPollinaza?.displayName ?? l.bultosFallback,
            ),
          );
        }
        break;
    }

    buffer.writeln('');
    buffer.writeln(
      l.shareTotalLine(
        Formatters.currencySymbol,
        venta.totalFinal.toStringAsFixed(2),
      ),
    );
    buffer.writeln('');

    buffer.writeln(l.shareClientLine(venta.cliente.nombre));
    buffer.writeln(l.shareContactLine(venta.cliente.contacto));

    buffer.writeln('');
    buffer.writeln(l.shareStatusLine(venta.estado.displayName));
    buffer.writeln('');
    buffer.writeln('????????????????????????');
    buffer.writeln('Smart Granja Aves Pro');

    Share.share(
      buffer.toString(),
      subject: l.shareSubjectSale(venta.tipoProducto.displayName),
    );
  }
}

class _TipoInfo {
  final IconData icon;
  final Color color;

  _TipoInfo(this.icon, this.color);
}

class _InfoRow {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });
}
