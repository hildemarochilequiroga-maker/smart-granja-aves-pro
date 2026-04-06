/// Página de lista de costos de un lote
///
/// Muestra todos los costos registrados con:
/// - Card de resumen con total y estadísticas
/// - Filtros por tipo de gasto
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para crear nuevo costo
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
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/permission_guard.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/costos_provider.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';
import '../widgets/widgets.dart';

/// Página principal de gestión de costos
class CostosListPage extends ConsumerStatefulWidget {
  const CostosListPage({super.key, this.loteId, this.granjaId});

  final String? loteId;
  final String? granjaId;

  @override
  ConsumerState<CostosListPage> createState() => _CostosListPageState();
}

class _CostosListPageState extends ConsumerState<CostosListPage> {
  S get l => S.of(context);

  TipoGasto? _tipoFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Usar el stream correcto: por loteId > por granjaId > granja seleccionada
    final granjaActiva = ref.watch(granjaSeleccionadaProvider);
    final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
    final costosAsync = widget.loteId != null
        ? ref.watch(streamCostosPorLoteProvider(widget.loteId!))
        : granjaIdEfectivo != null
        ? ref.watch(streamCostosPorGranjaProvider(granjaIdEfectivo))
        : const AsyncValue<List<CostoGasto>>.data([]);

    // Escuchar cambios en el estado de operaciones
    ref.listen<CostoCrudState>(costoCrudProvider, (previous, next) {
      if (next.successMessage != null) {
        _mostrarSnackBar(next.successMessage!, esExito: true);
        ref.read(costoCrudProvider.notifier).clearMessages();
      } else if (next.errorMessage != null) {
        _mostrarSnackBar(next.errorMessage!, esExito: false);
        ref.read(costoCrudProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(widget.loteId != null ? l.costoLoteTitle : l.costoAllTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: l.costoFilterTooltip,
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: costosAsync.when(
          data: (costos) {
            final filteredCostos = _filterCostos(costos);

            if (costos.isEmpty) {
              return AppEmptyState(
                icon: Icons.receipt_long_outlined,
                title: l.costoEmptyTitle,
                description: l.costoEmptyDescription,
                actionLabel: l.costoEmptyAction,
                actionIcon: Icons.add_rounded,
                onAction: () => _navegarARegistrar(),
              );
            }

            if (filteredCostos.isEmpty) {
              return AppEmptyState(
                hasFilters: true,
                filterTitle: l.costoFilterEmptyTitle,
                filterDescription: l.costoFilterEmptyDescription,
                onClearFilters: () {
                  setState(() => _tipoFilter = null);
                },
              );
            }

            return CustomScrollView(
              slivers: [
                // Resumen de costos
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: CostosResumenCard(costos: costos),
                  ),
                ),

                // Chips de filtro
                if (_tipoFilter != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Chip(
                            label: Text(_tipoFilter!.displayName),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              setState(() => _tipoFilter = null);
                            },
                            backgroundColor: AppColors.info.withValues(
                              alpha: 0.1,
                            ),
                            labelStyle: const TextStyle(color: AppColors.info),
                            deleteIconColor: AppColors.info,
                            side: BorderSide.none,
                          ),
                        ],
                      ),
                    ),
                  ),

                // Lista de costos
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final costo = filteredCostos[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredCostos.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? 8 : 0,
                          bottom: isLast ? 100 : 12,
                        ),
                        child: CostoListCard(
                          costo: costo,
                          onTap: () => _showDetail(costo),
                          onEdit: () => _navegarAEditar(costo),
                          onAprobar: () => _aprobarCosto(costo),
                          onRechazar: () => _showRechazarDialog(costo),
                          onEliminar: () => _confirmarEliminar(costo),
                        ),
                      );
                    }, childCount: filteredCostos.length),
                  ),
                ),
              ],
            );
          },
          loading: () => const CostosLoadingState(),
          error: (error, _) =>
              CostosErrorState(mensaje: error.toString(), onRetry: _onRefresh),
        ),
      ),
      floatingActionButton: widget.granjaId != null
          ? PermissionGuard(
              granjaId: widget.granjaId!,
              permiso: TipoPermiso.crearRegistros,
              showAccessDenied: false,
              child: FloatingActionButton.extended(
                heroTag: 'costos_list_fab',
                onPressed: () => _navegarARegistrar(),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  l.costoNewButton,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                tooltip: l.costoNewTooltip,
              ),
            )
          : FloatingActionButton.extended(
              heroTag: 'costos_list_fab',
              onPressed: () => _navegarARegistrar(),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                l.costoNewButton,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              tooltip: l.costoNewTooltip,
            ),
    );
  }

  List<CostoGasto> _filterCostos(List<CostoGasto> costos) {
    if (_tipoFilter == null) return costos;
    return costos.where((c) => c.tipo == _tipoFilter).toList();
  }

  Future<void> _onRefresh() async {
    if (widget.loteId != null) {
      ref.invalidate(streamCostosPorLoteProvider(widget.loteId!));
    } else {
      final granjaActiva = ref.read(granjaSeleccionadaProvider);
      final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
      if (granjaIdEfectivo != null) {
        ref.invalidate(streamCostosPorGranjaProvider(granjaIdEfectivo));
      }
    }
  }

  void _showDetail(CostoGasto costo) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _CostoDetailSheet(costo: costo, tipoColor: _getTipoColor(costo.tipo)),
    );
  }

  void _navegarAEditar(CostoGasto costo) {
    HapticFeedback.lightImpact();
    // Usar el loteId del costo si no tenemos uno en la página
    final loteIdParaEditar = widget.loteId ?? costo.loteId;
    if (loteIdParaEditar != null) {
      context.push(
        AppRoutes.costoRegistrarConLote(loteIdParaEditar, costo.granjaId),
        extra: costo,
      );
    } else {
      // Si no hay loteId, navegar a editar sin lote
      context.push(
        '${AppRoutes.costoRegistrar}?granjaId=${costo.granjaId}',
        extra: costo,
      );
    }
  }

  void _navegarARegistrar() {
    HapticFeedback.mediumImpact();
    if (widget.loteId != null && widget.granjaId != null) {
      context.push(
        AppRoutes.costoRegistrarConLote(widget.loteId!, widget.granjaId!),
      );
    } else if (widget.loteId != null) {
      // Fallback si no hay granjaId
      context.push('${AppRoutes.costoRegistrar}?loteId=${widget.loteId}');
    } else {
      // Sin loteId, navegar a registrar sin lote específico
      context.push(AppRoutes.costoRegistrar);
    }
  }

  Future<void> _aprobarCosto(CostoGasto costo) async {
    unawaited(HapticFeedback.mediumImpact());
    try {
      final usuario = ref.read(currentUserProvider);
      if (usuario == null) {
        _mostrarSnackBar(
          S.of(context).errorUserNotAuthenticated,
          esExito: false,
        );
        return;
      }
      await ref
          .read(costoCrudProvider.notifier)
          .aprobarCosto(costo.id, usuario.id);
    } on Exception catch (e) {
      if (!mounted) return;
      _mostrarSnackBar(
        S.of(context).costoApproveError(e.toString()),
        esExito: false,
      );
    }
  }

  Future<void> _showRechazarDialog(CostoGasto costo) async {
    final motivoController = TextEditingController();
    final l = S.of(context);

    unawaited(HapticFeedback.lightImpact());

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
                Icons.cancel_outlined,
                color: AppColors.error,
                size: 24,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(child: Text(l.costoRejectTitle)),
          ],
        ),
        content: TextField(
          controller: motivoController,
          decoration: InputDecoration(
            labelText: l.costoRejectReasonLabel,
            hintText: l.costoRejectReasonHint,
            border: OutlineInputBorder(borderRadius: AppRadius.allMd),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () {
              if (motivoController.text.trim().isEmpty) {
                AppSnackBar.warning(
                  dialogContext,
                  message: l.costoRejectReasonRequired,
                );
                return;
              }
              Navigator.pop(dialogContext, true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(l.costoRejectButton),
          ),
        ],
      ),
    );

    if (confirmed == true && motivoController.text.trim().isNotEmpty) {
      try {
        unawaited(HapticFeedback.mediumImpact());
        await ref
            .read(costoCrudProvider.notifier)
            .rechazarCosto(costo.id, motivoController.text.trim());
      } on Exception catch (e) {
        _mostrarSnackBar(l.costoRejectError(e.toString()), esExito: false);
      }
    }
  }

  Future<void> _confirmarEliminar(CostoGasto costo) async {
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
        content: Text(l.costoDeleteConfirm(costo.concepto)),
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
      await ref.read(costoCrudProvider.notifier).eliminarCosto(costo.id);

      if (mounted) {
        final costoState = ref.read(costoCrudProvider);
        if (costoState.errorMessage != null) {
          _mostrarSnackBar(
            l.costoDeleteError2(costoState.errorMessage ?? ''),
            esExito: false,
          );
        } else {
          _mostrarSnackBar(l.costoDeleteSuccess, esExito: true);
        }
      }
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    HapticFeedback.lightImpact();

    // Variable temporal para el filtro
    TipoGasto? tempTipoFilter = _tipoFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final hayFiltros = tempTipoFilter != null;

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

                  // Header con título
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Text(
                      l.costoFilterTitle,
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
                          // Sección: Tipo de gasto
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: l.costoFilterExpenseType,
                          ),
                          AppSpacing.gapMd,

                          // Opción "Todos los tipos"
                          AspectRatio(
                            aspectRatio: 4.8,
                            child: _buildTipoOption(
                              theme: theme,
                              label: l.commonAllTypes,
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
                            children: TipoGasto.values.map((tipo) {
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
                          hayFiltros ? l.commonApplyFilters : l.commonClose,
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

  Color _getTipoColor(TipoGasto tipo) {
    switch (tipo) {
      case TipoGasto.alimento:
        return AppColors.warning;
      case TipoGasto.manoDeObra:
        return AppColors.info;
      case TipoGasto.energia:
        return AppColors.amber;
      case TipoGasto.medicamento:
        return AppColors.error;
      case TipoGasto.mantenimiento:
        return AppColors.outline;
      case TipoGasto.agua:
        return AppColors.infoLight;
      case TipoGasto.transporte:
        return AppColors.indigo;
      case TipoGasto.administrativo:
        return AppColors.purple;
      case TipoGasto.depreciacion:
        return AppColors.brown;
      case TipoGasto.financiero:
        return AppColors.teal;
      case TipoGasto.otros:
        return AppColors.outline;
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
// SHEET DE DETALLE DE COSTO
// =============================================================================

class _CostoDetailSheet extends StatelessWidget {
  final CostoGasto costo;
  final Color tipoColor;

  const _CostoDetailSheet({required this.costo, required this.tipoColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(costo.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(costo.fecha);

    final l = S.of(context);

    // Estado
    String? estadoTexto;
    Color? estadoColor;
    if (costo.requiereAprobacion) {
      if (costo.estaPendiente) {
        estadoTexto = l.statusPending;
        estadoColor = AppColors.warning;
      } else if (costo.estaRechazado) {
        estadoTexto = l.statusRejected;
        estadoColor = AppColors.error;
      } else if (costo.aprobado) {
        estadoTexto = l.statusApproved;
        estadoColor = AppColors.success;
      }
    }

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

              // Header con fecha y badge de monto
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
                      color: tipoColor,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      Formatters.currencyValue(costo.monto),
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
                      S.of(context).costExpenseType,
                      costo.tipo.displayName,
                      valueColor: tipoColor,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).costConcept,
                      costo.concepto,
                    ),
                    if (costo.proveedor != null && costo.proveedor!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).costProvider,
                        costo.proveedor!,
                      ),
                    if (costo.numeroFactura != null &&
                        costo.numeroFactura!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).costInvoiceNumber,
                        costo.numeroFactura!,
                      ),
                    if (estadoTexto != null)
                      _buildTableRow(
                        theme,
                        S.of(context).commonStatus,
                        estadoTexto,
                        valueColor: estadoColor,
                      ),
                    if (costo.estaRechazado && costo.motivoRechazo != null)
                      _buildTableRow(
                        theme,
                        S.of(context).costRejectionReason,
                        costo.motivoRechazo!,
                        valueColor: AppColors.error,
                      ),
                    _buildTableRow(
                      theme,
                      S.of(context).commonRegistrationDate,
                      DateFormat(
                        'd MMM yyyy, HH:mm',
                        Localizations.localeOf(context).languageCode,
                      ).format(costo.fechaRegistro),
                      isLast: !(costo.observaciones?.isNotEmpty ?? false),
                    ),
                    if (costo.observaciones != null &&
                        costo.observaciones!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).commonObservations,
                        costo.observaciones!,
                        isLast: true,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
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
