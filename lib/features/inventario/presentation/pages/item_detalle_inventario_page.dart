/// Página de detalle de un item de inventario.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_states.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../widgets/widgets.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página de detalle de un item de inventario.
class ItemDetalleInventarioPage extends ConsumerStatefulWidget {
  const ItemDetalleInventarioPage({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<ItemDetalleInventarioPage> createState() =>
      _ItemDetalleInventarioPageState();
}

class _ItemDetalleInventarioPageState
    extends ConsumerState<ItemDetalleInventarioPage> {
  S get l => S.of(context);

  late final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final itemAsync = ref.watch(inventarioItemPorIdProvider(widget.itemId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.invItemDetail),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          // Indicador de sincronización
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: SyncStatusBadge(showLabel: true),
          ),
          itemAsync.when(
            data: (item) => item != null
                ? PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                    color: theme.colorScheme.surface,
                    elevation: 3,
                    offset: const Offset(0, 40),
                    tooltip: l.commonMoreOptions,
                    onSelected: (value) => _onMenuSelected(value, item),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'editar',
                        child: ListTile(
                          leading: const Icon(Icons.edit),
                          title: Text(l.commonEdit),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'entrada',
                        child: ListTile(
                          leading: const Icon(Icons.add_circle_outline),
                          title: Text(l.invRegisterEntry),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'salida',
                        child: ListTile(
                          leading: const Icon(Icons.remove_circle_outline),
                          title: Text(l.invRegisterExit),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'ajustar',
                        child: ListTile(
                          leading: const Icon(Icons.sync),
                          title: Text(l.invAdjustStock),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'eliminar',
                        child: ListTile(
                          leading: const Icon(
                            Icons.delete,
                            color: AppColors.error,
                          ),
                          title: Text(
                            l.commonDelete,
                            style: const TextStyle(color: AppColors.error),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  AppSpacing.gapBase,
                  Text(l.invItemNotFound),
                  AppSpacing.gapBase,
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text(l.commonBack),
                  ),
                ],
              ),
            );
          }
          return _buildContent(theme, item);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorState(
          message: l.invErrorLoadingItem,
          onRetry: () =>
              ref.invalidate(inventarioItemPorIdProvider(widget.itemId)),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ItemInventario item) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con stock
          _buildStockHeader(theme, item),
          AppSpacing.gapXl,

          // Ubicación (Granja)
          _buildUbicacionCard(theme, item),
          AppSpacing.gapBase,

          // Información del item
          _buildInfoCard(theme, item),
          AppSpacing.gapBase,

          // Alertas
          if (item.stockBajo ||
              item.agotado ||
              item.proximoVencer ||
              item.vencido) ...[
            _buildAlertasCard(theme, item),
            AppSpacing.gapBase,
          ],

          // Historial de movimientos
          _buildMovimientosSection(theme),
          AppSpacing.gapBase,

          // Información de Registro
          _buildRegistroCard(theme, item),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildStockHeader(ThemeData theme, ItemInventario item) {
    Color stockColor;
    String estadoText;

    if (item.agotado) {
      stockColor = AppColors.error;
      estadoText = l.invStockDepleted;
    } else if (item.stockBajo) {
      stockColor = AppColors.warning;
      estadoText = l.invStockLow;
    } else {
      stockColor = AppColors.success;
      estadoText = l.invStockAvailable;
    }

    final tipoColor = Color(int.parse('0xFF${item.tipo.colorHex}'));

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
                // Punto de color del tipo
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: tipoColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: tipoColor.withValues(alpha: 0.4),
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
                        item.nombre,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.tipo.displayName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge de estado a la derecha
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: stockColor,
                    borderRadius: AppRadius.allSm,
                  ),
                  child: Text(
                    estadoText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapLg,
            // Indicadores de stock sin iconos
            Row(
              children: [
                Expanded(
                  child: _buildStockIndicator(
                    l.invStockCurrent,
                    '${item.stockActual.toStringAsFixed(item.stockActual.truncateToDouble() == item.stockActual ? 0 : 2)} ${item.unidad.simbolo}',
                    stockColor,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
                Expanded(
                  child: _buildStockIndicator(
                    l.invStockMinimum,
                    '${item.stockMinimo.toStringAsFixed(item.stockMinimo.truncateToDouble() == item.stockMinimo ? 0 : 2)} ${item.unidad.simbolo}',
                    theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (item.precioUnitario != null) ...[
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  Expanded(
                    child: _buildStockIndicator(
                      l.invTotalValue,
                      Formatters.currency(item.valorTotal ?? 0),
                      AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockIndicator(String label, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        AppSpacing.gapXxs,
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(ThemeData theme, ItemInventario item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            l.invInformation,
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
                if (item.codigo != null) _buildInfoRow(l.invCode, item.codigo!),
                if (item.descripcion != null)
                  _buildInfoRow(l.invDescription, item.descripcion!),
                _buildInfoRow(l.invUnit, item.unidad.displayName),
                if (item.precioUnitario != null)
                  _buildInfoRow(
                    l.invUnitPrice,
                    Formatters.currency(item.precioUnitario),
                  ),
                if (item.proveedor != null)
                  _buildInfoRow(l.commonSupplier, item.proveedor!),
                if (item.ubicacion != null)
                  _buildInfoRow(l.commonLocation, item.ubicacion!),
                if (item.fechaVencimiento != null)
                  _buildInfoRow(
                    l.invExpiration,
                    _dateFormat.format(item.fechaVencimiento!),
                  ),
                if (item.loteProveedor != null)
                  _buildInfoRow(l.invSupplierBatch, item.loteProveedor!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
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

  Widget _buildUbicacionCard(ThemeData theme, ItemInventario item) {
    // Obtener nombre de la granja
    final granjaAsync = ref.watch(granjaByIdProvider(item.granjaId));
    final granjaNombre = granjaAsync.maybeWhen(
      data: (granja) => granja?.nombre ?? l.commonFarmNotFound,
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
                _buildInfoRow(l.commonFarm, granjaNombre),
                if (item.ubicacion != null && item.ubicacion!.isNotEmpty)
                  _buildInfoRow(l.invWarehouse, item.ubicacion!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistroCard(ThemeData theme, ItemInventario item) {
    final usuariosAsync = ref.watch(usuariosGranjaProvider(item.granjaId));

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
                    .where((u) => u.usuarioId == item.registradoPor)
                    .firstOrNull;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      l.commonRegisteredBy,
                      registrador?.nombreCompleto ?? S.of(context).commonUser,
                    ),
                    if (registrador != null)
                      _buildInfoRow(
                        l.commonRole,
                        registrador.rol.localizedDisplayName(S.of(context)),
                      ),
                    _buildInfoRow(
                      l.commonRegistrationDate,
                      _formatDateTimePretty(item.fechaCreacion),
                    ),
                    if (item.fechaActualizacion != null)
                      _buildInfoRow(
                        l.commonLastUpdate,
                        _formatDateTimePretty(item.fechaActualizacion!),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(l.commonRegisteredBy, item.registradoPor),
                  _buildInfoRow(
                    l.commonRegistrationDate,
                    _formatDateTimePretty(item.fechaCreacion),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTimePretty(DateTime date) {
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

  Widget _buildAlertasCard(ThemeData theme, ItemInventario item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber,
                color: AppColors.warning,
                size: 20,
              ),
              AppSpacing.hGapSm,
              Text(
                l.invAlerts,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: AppColors.warning.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.agotado)
                  _buildAlertItem(
                    l.invAlertStockDepleted,
                    Icons.error,
                    AppColors.error,
                  ),
                if (item.stockBajo && !item.agotado)
                  _buildAlertItem(
                    S
                        .of(context)
                        .invStockBajoMinimo(
                          item.stockMinimo.toString(),
                          item.unidad.simbolo,
                        ),
                    Icons.trending_down,
                    AppColors.warning,
                  ),
                if (item.vencido)
                  _buildAlertItem(
                    l.invAlertProductExpired,
                    Icons.event_busy,
                    AppColors.error,
                  ),
                if (item.proximoVencer && !item.vencido)
                  _buildAlertItem(
                    S
                        .of(context)
                        .invExpiresInDays(item.diasParaVencer.toString()),
                    Icons.event,
                    AppColors.warning,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertItem(String text, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          AppSpacing.hGapSm,
          Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildMovimientosSection(ThemeData theme) {
    final movimientosAsync = ref.watch(
      inventarioMovimientosStreamProvider(widget.itemId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.invLastMovements,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    AppRoutes.inventarioHistorialMovimientosById(widget.itemId),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.secondary,
                ),
                child: Text(l.invViewAll),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: movimientosAsync.when(
              data: (movimientos) {
                if (movimientos.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        l.invNoMovementsRegistered,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children: movimientos.take(5).map((m) {
                    return MovimientoInventarioCard(
                      movimiento: m,
                      compact: true,
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                l.invCouldNotLoadMovements,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onMenuSelected(String value, ItemInventario item) {
    switch (value) {
      case 'editar':
        context.push(AppRoutes.inventarioEditarItemById(item.id), extra: item);
        break;
      case 'entrada':
        _mostrarDialogoMovimiento(item, esEntrada: true);
        break;
      case 'salida':
        _mostrarDialogoMovimiento(item, esEntrada: false);
        break;
      case 'ajustar':
        _mostrarDialogoAjuste(item);
        break;
      case 'eliminar':
        _confirmarEliminar(item);
        break;
    }
  }

  Future<void> _mostrarDialogoMovimiento(
    ItemInventario item, {
    required bool esEntrada,
  }) async {
    if (!mounted) return;

    final bool success;
    if (esEntrada) {
      // ignore: use_build_context_synchronously
      success = await InventarioDialogs.showRegistrarEntradaDialog(
        context,
        ref,
        item,
      );
    } else {
      // ignore: use_build_context_synchronously
      success = await InventarioDialogs.showRegistrarSalidaDialog(
        context,
        ref,
        item,
      );
    }

    if (success && context.mounted) {
      ref.invalidate(inventarioItemPorIdProvider(widget.itemId));
    }
  }

  Future<void> _mostrarDialogoAjuste(ItemInventario item) async {
    if (!mounted) return;

    // ignore: use_build_context_synchronously - El context se usa para mostrar un Dialog
    final success = await InventarioDialogs.showAjustarStockDialog(
      context,
      ref,
      item,
    );

    if (success && context.mounted) {
      ref.invalidate(inventarioItemPorIdProvider(widget.itemId));
    }
  }

  Future<void> _confirmarEliminar(ItemInventario item) async {
    if (!mounted) return;

    // ignore: use_build_context_synchronously - El context se usa para mostrar un Dialog
    final confirmed = await InventarioDialogs.showEliminarItemDialog(
      context,
      item,
    );

    if (confirmed && context.mounted) {
      final notifier = ref.read(inventarioItemNotifierProvider.notifier);
      await notifier.eliminarItem(item.id);

      if (!context.mounted) return;
      // ignore: use_build_context_synchronously - Verificamos context.mounted antes
      context.pop();
      // ignore: use_build_context_synchronously - Verificamos context.mounted antes
      AppSnackBar.success(context, message: l.invItemDeleted);
    }
  }
}
