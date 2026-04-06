/// Página de lista de ventas de productos
///
/// Muestra todas las ventas registradas con:
/// - Card de resumen con total y estadísticas
/// - Filtros por tipo de producto
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para crear nueva venta
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/permission_guard.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/ventas_provider.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/enums/tipo_producto_venta.dart';
import '../../domain/enums/estado_venta.dart';
import '../widgets/ventas_list/venta_list_card.dart';
import '../widgets/ventas_list/ventas_error_state.dart';
import '../widgets/ventas_list/ventas_resumen_card.dart';

/// Página principal de gestión de ventas
class VentasListPage extends ConsumerStatefulWidget {
  const VentasListPage({super.key, this.loteId, this.granjaId});

  final String? loteId;
  final String? granjaId;

  @override
  ConsumerState<VentasListPage> createState() => _VentasListPageState();
}

class _VentasListPageState extends ConsumerState<VentasListPage> {
  S get l => S.of(context);

  TipoProductoVenta? _tipoFilter;
  EstadoVenta? _estadoFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Usar el stream correcto: por loteId > por granjaId > granja seleccionada
    final granjaActiva = ref.watch(granjaSeleccionadaProvider);
    final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
    final ventasAsync = widget.loteId != null
        ? ref.watch(streamVentasProductoPorLoteProvider(widget.loteId!))
        : granjaIdEfectivo != null
        ? ref.watch(streamVentasProductoPorGranjaProvider(granjaIdEfectivo))
        : const AsyncValue<List<VentaProducto>>.data([]);

    // Escuchar cambios en el estado de operaciones
    ref.listen<VentaProductoCrudState>(ventaProductoCrudProvider, (
      previous,
      next,
    ) {
      if (next.successMessage != null) {
        _mostrarSnackBar(next.successMessage!, esExito: true);
        ref.read(ventaProductoCrudProvider.notifier).clearMessages();
      } else if (next.errorMessage != null) {
        _mostrarSnackBar(next.errorMessage!, esExito: false);
        ref.read(ventaProductoCrudProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          widget.loteId != null
              ? S.of(context).ventasTitle
              : S.of(context).ventasTitle,
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: S.of(context).ventasFilter,
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: ventasAsync.when(
          data: (ventas) {
            final filteredVentas = _filterVentas(ventas);

            if (ventas.isEmpty) {
              return AppEmptyState(
                icon: Icons.storefront_outlined,
                title: S.of(context).ventasEmpty,
                description: S.of(context).ventasEmptyDescription,
                actionLabel: S.of(context).ventasNewSale,
                actionIcon: Icons.add_rounded,
                onAction: () => _navegarARegistrar(),
              );
            }

            if (filteredVentas.isEmpty) {
              return AppEmptyState(
                hasFilters: true,
                filterTitle: S.of(context).ventasNoResults,
                filterDescription: S.of(context).ventasNoFilterResults,
                onClearFilters: () {
                  setState(() {
                    _tipoFilter = null;
                    _estadoFilter = null;
                  });
                },
              );
            }

            return CustomScrollView(
              slivers: [
                // Resumen de ventas
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: VentasResumenCard(ventas: ventas),
                  ),
                ),

                // Chips de filtro
                if (_tipoFilter != null || _estadoFilter != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (_tipoFilter != null)
                            Chip(
                              label: Text(_tipoFilter!.displayName),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() => _tipoFilter = null);
                              },
                              backgroundColor: AppColors.info.withValues(
                                alpha: 0.1,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.info,
                              ),
                              deleteIconColor: AppColors.info,
                              side: BorderSide.none,
                            ),
                          if (_estadoFilter != null)
                            Chip(
                              label: Text(_estadoFilter!.displayName),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() => _estadoFilter = null);
                              },
                              backgroundColor: AppColors.info.withValues(
                                alpha: 0.1,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.info,
                              ),
                              deleteIconColor: AppColors.info,
                              side: BorderSide.none,
                            ),
                        ],
                      ),
                    ),
                  ),

                // Lista de ventas
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final venta = filteredVentas[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredVentas.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? 8 : 0,
                          bottom: isLast ? 100 : 12,
                        ),
                        child: VentaListCard(
                          venta: venta,
                          onTap: () => _showDetail(venta),
                          onEliminar: () => _confirmarEliminar(venta),
                        ),
                      );
                    }, childCount: filteredVentas.length),
                  ),
                ),
              ],
            );
          },
          loading: () =>
              const ListLoadingState(showResumen: true, itemCount: 4),
          error: (error, _) =>
              VentasErrorState(mensaje: error.toString(), onRetry: _onRefresh),
        ),
      ),
      floatingActionButton: widget.granjaId != null
          ? PermissionGuard(
              granjaId: widget.granjaId!,
              permiso: TipoPermiso.crearVentas,
              showAccessDenied: false,
              child: FloatingActionButton.extended(
                heroTag: 'ventas_list_fab',
                onPressed: () => _navegarARegistrar(),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  S.of(context).ventasNewSale,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                tooltip: S.of(context).ventasNewSaleTooltip,
              ),
            )
          : FloatingActionButton.extended(
              heroTag: 'ventas_list_fab',
              onPressed: () => _navegarARegistrar(),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                S.of(context).ventasNewSale,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              tooltip: S.of(context).ventasNewSaleTooltip,
            ),
    );
  }

  List<VentaProducto> _filterVentas(List<VentaProducto> ventas) {
    return ventas.where((v) {
      if (_tipoFilter != null && v.tipoProducto != _tipoFilter) return false;
      if (_estadoFilter != null && v.estado != _estadoFilter) return false;
      return true;
    }).toList();
  }

  Future<void> _onRefresh() async {
    if (widget.loteId != null) {
      ref.invalidate(streamVentasProductoPorLoteProvider(widget.loteId!));
    } else {
      final granjaActiva = ref.read(granjaSeleccionadaProvider);
      final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
      if (granjaIdEfectivo != null) {
        ref.invalidate(streamVentasProductoPorGranjaProvider(granjaIdEfectivo));
      }
    }
  }

  void _showDetail(VentaProducto venta) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VentaDetailSheet(
        venta: venta,
        tipoColor: _getTipoColor(venta.tipoProducto),
        onEditar: venta.estado.esModificable
            ? () {
                Navigator.pop(context);
                context.push(AppRoutes.ventaDetalleById(venta.id));
              }
            : null,
        onEliminar: () {
          Navigator.pop(context);
          _confirmarEliminar(venta);
        },
      ),
    );
  }

  void _navegarARegistrar() {
    HapticFeedback.mediumImpact();
    final queryParams = <String, String>{};
    if (widget.loteId != null) queryParams['loteId'] = widget.loteId!;
    if (widget.granjaId != null) queryParams['granjaId'] = widget.granjaId!;

    final query = queryParams.isNotEmpty
        ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    context.push('${AppRoutes.ventaRegistrar}$query');
  }

  Future<void> _confirmarEliminar(VentaProducto venta) async {
    unawaited(HapticFeedback.lightImpact());

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).ventaDeleteTitle,
      message: S.of(context).ventaDeleteMessage(venta.tipoProducto.displayName),
      type: AppDialogType.danger,
    );

    if (confirmed == true) {
      unawaited(HapticFeedback.heavyImpact());
      await ref
          .read(ventaProductoCrudProvider.notifier)
          .eliminarVenta(venta.id);

      if (mounted) {
        final ventaState = ref.read(ventaProductoCrudProvider);
        if (ventaState.errorMessage != null) {
          _mostrarSnackBar(
            S.of(context).ventaDeleteError(ventaState.errorMessage ?? ''),
            esExito: false,
          );
        } else {
          _mostrarSnackBar(S.of(context).ventaDeletedSuccess, esExito: true);
        }
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    HapticFeedback.lightImpact();

    // Variables temporales para el filtro
    TipoProductoVenta? tempTipoFilter = _tipoFilter;
    EstadoVenta? tempEstadoFilter = _estadoFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final hayFiltros = tempTipoFilter != null || tempEstadoFilter != null;

          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Header con título (sin icono)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Text(
                      S.of(context).ventasFilterTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Divider(
                    height: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),

                  // Contenido scrolleable
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sección: Tipo de producto
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).ventasProductType,
                          ),
                          AppSpacing.gapMd,

                          // Opción "Todos los tipos"
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildTipoOption(
                              theme: theme,
                              label: S.of(context).commonAllTypes,
                              isSelected: tempTipoFilter == null,
                              color: theme.colorScheme.primary,
                              onTap: () {
                                setModalState(() {
                                  tempTipoFilter = null;
                                });
                              },
                            ),
                          ),
                          AppSpacing.gapSm,

                          // Grid de tipos 2 columnas
                          GridView.count(
                            crossAxisCount: AppBreakpoints.of(
                              context,
                            ).gridColumns,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppSpacing.sm,
                            crossAxisSpacing: AppSpacing.sm,
                            childAspectRatio: 2.4,
                            children: TipoProductoVenta.values.map((tipo) {
                              return _buildTipoOption(
                                theme: theme,
                                label: tipo.displayName,
                                isSelected: tempTipoFilter == tipo,
                                color: _getTipoColor(tipo),
                                onTap: () {
                                  setModalState(() {
                                    tempTipoFilter = tipo;
                                  });
                                },
                              );
                            }).toList(),
                          ),

                          AppSpacing.gapXl,

                          // Sección: Estado
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: S.of(context).ventaFilterSaleState,
                          ),
                          AppSpacing.gapMd,

                          // Opción "Todos los estados"
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildTipoOption(
                              theme: theme,
                              label: S.of(context).ventaFilterAllStates,
                              isSelected: tempEstadoFilter == null,
                              color: theme.colorScheme.primary,
                              onTap: () {
                                setModalState(() {
                                  tempEstadoFilter = null;
                                });
                              },
                            ),
                          ),
                          AppSpacing.gapSm,

                          // Solo 3 estados: Pendiente, Confirmada, Vendida
                          Row(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 2.4,
                                  child: _buildTipoOption(
                                    theme: theme,
                                    label: S.of(context).statusPending,
                                    isSelected:
                                        tempEstadoFilter ==
                                        EstadoVenta.pendiente,
                                    color: AppColors.warning,
                                    onTap: () {
                                      setModalState(() {
                                        tempEstadoFilter =
                                            EstadoVenta.pendiente;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              AppSpacing.hGapSm,
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 2.4,
                                  child: _buildTipoOption(
                                    theme: theme,
                                    label: S.of(context).statusConfirmed,
                                    isSelected:
                                        tempEstadoFilter ==
                                        EstadoVenta.confirmada,
                                    color: AppColors.info,
                                    onTap: () {
                                      setModalState(() {
                                        tempEstadoFilter =
                                            EstadoVenta.confirmada;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapSm,
                          Row(
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 2.4,
                                  child: _buildTipoOption(
                                    theme: theme,
                                    label: S.of(context).statusSold,
                                    isSelected:
                                        tempEstadoFilter ==
                                        EstadoVenta.entregada,
                                    color: AppColors.success,
                                    onTap: () {
                                      setModalState(() {
                                        tempEstadoFilter =
                                            EstadoVenta.entregada;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              AppSpacing.hGapSm,
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Botón aplicar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _tipoFilter = tempTipoFilter;
                            _estadoFilter = tempEstadoFilter;
                          });
                          Navigator.pop(context);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.allMd,
                          ),
                        ),
                        child: Text(
                          hayFiltros
                              ? S.of(context).commonApplyFilters
                              : S.of(context).commonClose,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSectionHeader({
    required ThemeData theme,
    required String title,
  }) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTipoOption({
    required ThemeData theme,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.info.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
          borderRadius: AppRadius.allMd,
          border: Border.all(
            color: isSelected
                ? AppColors.info.withValues(alpha: 0.5)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.info
                      : theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTipoColor(TipoProductoVenta tipo) {
    switch (tipo) {
      case TipoProductoVenta.avesVivas:
        return AppColors.warning;
      case TipoProductoVenta.avesFaenadas:
        return AppColors.brown;
      case TipoProductoVenta.avesDescarte:
        return AppColors.outline;
      case TipoProductoVenta.huevos:
        return AppColors.warning;
      case TipoProductoVenta.pollinaza:
        return AppColors.success;
    }
  }

  void _mostrarSnackBar(String mensaje, {required bool esExito}) {
    if (esExito) {
      AppSnackBar.success(context, message: mensaje);
    } else {
      AppSnackBar.error(context, message: mensaje);
    }
  }
}

// =============================================================================
// SHEET DE DETALLE DE VENTA
// =============================================================================

class _VentaDetailSheet extends StatelessWidget {
  final VentaProducto venta;
  final Color tipoColor;
  final VoidCallback? onEditar;
  final VoidCallback? onEliminar;

  const _VentaDetailSheet({
    required this.venta,
    required this.tipoColor,
    this.onEditar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(venta.fechaVenta);
    final horaFormat = DateFormat('HH:mm', locale).format(venta.fechaVenta);

    // Estado
    final estadoColor = _parseColor(venta.estado.colorHex);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.85,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.paddingOf(context).bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
              const SizedBox(height: AppSpacing.lg),

              // Header con fecha y badge de total
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fechaFormat,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          horaFormat,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      Formatters.currencyValue(venta.totalFinal),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Información en formato tabla
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTableRow(
                      theme,
                      S.of(context).ventaListProductType,
                      venta.tipoProducto.displayName,
                      valueColor: tipoColor,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).commonStatus,
                      venta.estado.displayName,
                      valueColor: estadoColor,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).ventaSheetClient,
                      venta.cliente.nombre,
                    ),
                    if (venta.cliente.identificacion.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaListDocument,
                        '${venta.cliente.tipoDocumento}: ${venta.cliente.identificacion}',
                      ),
                    if (venta.cliente.contacto.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetPhone,
                        venta.cliente.contacto,
                      ),

                    // Detalles según tipo de producto
                    ..._buildProductDetails(context, theme),

                    if (venta.descuentoPorcentaje > 0) ...[
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetDiscount,
                        '${venta.descuentoPorcentaje.toStringAsFixed(1)}% (-${Formatters.currencyValue(venta.montoDescuento)})',
                        valueColor: AppColors.error,
                      ),
                    ],
                    if (venta.numeroFactura != null &&
                        venta.numeroFactura!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetInvoiceNumber,
                        venta.numeroFactura!,
                      ),
                    if (venta.transportista != null &&
                        venta.transportista!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetCarrier,
                        venta.transportista!,
                      ),
                    if (venta.numeroGuia != null &&
                        venta.numeroGuia!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetGuideNumber,
                        venta.numeroGuia!,
                      ),
                    if (venta.observaciones != null &&
                        venta.observaciones!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetObservations,
                        venta.observaciones!,
                        isLast: true,
                      ),
                    if (venta.observaciones == null ||
                        venta.observaciones!.isEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).ventaSheetRegistrationDate,
                        DateFormat(
                          'd MMM yyyy, HH:mm',
                          Localizations.localeOf(context).languageCode,
                        ).format(venta.fechaRegistro),
                        isLast: true,
                      ),
                  ],
                ),
              ),

              // Botones de acción
              if (onEditar != null || onEliminar != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    if (onEditar != null)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onEditar,
                          icon: const Icon(Icons.edit_rounded, size: 18),
                          label: Text(S.of(context).commonEdit),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.info,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allMd,
                            ),
                          ),
                        ),
                      ),
                    if (onEditar != null && onEliminar != null)
                      const SizedBox(width: 12),
                    if (onEliminar != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEliminar,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: Text(S.of(context).commonDelete),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allMd,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProductDetails(BuildContext context, ThemeData theme) {
    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
        return [
          if (venta.cantidadAves != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetBirdCount,
              '${venta.cantidadAves}',
            ),
          if (venta.pesoPromedioKg != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetAvgWeight,
              '${venta.pesoPromedioKg!.toStringAsFixed(2)} kg',
            ),
          if (venta.precioKg != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetPricePerKg,
              Formatters.currencyValue(venta.precioKg!),
            ),
          _buildTableRow(
            theme,
            S.of(context).ventaListSubtotal,
            Formatters.currencyValue(venta.subtotal),
          ),
        ];
      case TipoProductoVenta.avesFaenadas:
        return [
          if (venta.cantidadAves != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetBirdCount,
              '${venta.cantidadAves}',
            ),
          if (venta.pesoFaenado != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetFaenadoWeight,
              '${venta.pesoFaenado!.toStringAsFixed(2)} kg',
            ),
          if (venta.rendimientoCanal != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetYield,
              '${venta.rendimientoCanal!.toStringAsFixed(1)}%',
            ),
          if (venta.precioKg != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetPricePerKg,
              Formatters.currencyValue(venta.precioKg!),
            ),
          _buildTableRow(
            theme,
            S.of(context).ventaListSubtotal,
            Formatters.currencyValue(venta.subtotal),
          ),
        ];
      case TipoProductoVenta.huevos:
        final rows = <Widget>[];
        venta.huevosPorClasificacion?.forEach((clasif, cantidad) {
          final precioDocena = venta.preciosPorDocena?[clasif] ?? 0;
          rows.add(
            _buildTableRow(
              theme,
              clasif.displayName,
              S
                  .of(context)
                  .ventaEggClassifValue(
                    Formatters.currencySymbol,
                    cantidad.toString(),
                    precioDocena.toStringAsFixed(2),
                  ),
            ),
          );
        });
        rows.add(
          _buildTableRow(
            theme,
            S.of(context).ventaSheetTotalHuevos,
            '${venta.totalHuevos}',
          ),
        );
        rows.add(
          _buildTableRow(
            theme,
            S.of(context).ventaListSubtotal,
            Formatters.currencyValue(venta.subtotal),
          ),
        );
        return rows;
      case TipoProductoVenta.pollinaza:
        return [
          if (venta.cantidadPollinaza != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetPollinazaQty,
              '${venta.cantidadPollinaza!.toStringAsFixed(1)} ${venta.unidadPollinaza?.displayName ?? ''}',
            ),
          if (venta.precioUnitarioPollinaza != null)
            _buildTableRow(
              theme,
              S.of(context).ventaSheetUnitPrice,
              Formatters.currencyValue(venta.precioUnitarioPollinaza!),
            ),
          _buildTableRow(
            theme,
            S.of(context).ventaListSubtotal,
            Formatters.currencyValue(venta.subtotal),
          ),
        ];
    }
  }

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('FF');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget _buildTableRow(
    ThemeData theme,
    String label,
    String value, {
    Color? valueColor,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.5,
                  ),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
