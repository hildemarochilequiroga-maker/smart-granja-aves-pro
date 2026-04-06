/// Página de lista de lotes de una granja/galpón.
///
/// Muestra todos los lotes registrados con:
/// - Barra de búsqueda sticky
/// - Filtros por estado y tipo de ave
/// - Cards modernas con información del lote
/// - Pull-to-refresh
/// - FAB para crear nuevo lote
library;

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/widgets/permission_guard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/skeleton_loading.dart';
import '../../application/application.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/estado_lote.dart';
import '../../domain/enums/tipo_ave.dart';
import '../widgets/widgets.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página principal de gestión de lotes.
class LotesListPage extends ConsumerStatefulWidget {
  const LotesListPage({super.key, required this.granjaId, this.galponId});

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón (opcional, para filtrar).
  final String? galponId;

  @override
  ConsumerState<LotesListPage> createState() => _LotesListPageState();
}

class _LotesListPageState extends ConsumerState<LotesListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  EstadoLote? _estadoFilter;
  TipoAve? _tipoFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Seleccionar el provider correcto según si tenemos galponId
    final lotesAsync = widget.galponId != null
        ? ref.watch(lotesGalponStreamProvider(widget.galponId!))
        : ref.watch(lotesStreamProvider(widget.granjaId));

    // Escuchar cambios en el estado de operaciones
    ref.listen<LoteState>(loteNotifierProvider, (previous, next) {
      if (next is LoteSuccess) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).batchOperationSuccess,
          esExito: true,
        );
      } else if (next is LoteError) {
        _mostrarSnackBar(next.mensaje, esExito: false);
      } else if (next is LoteDeleted) {
        _mostrarSnackBar(
          next.mensaje ?? S.of(context).batchDeletedSuccess,
          esExito: true,
        );
      }
    });

    final title = widget.galponId != null
        ? S.of(context).batchShedBatches
        : S.of(context).batchTitle;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        edgeOffset: 110,
        child: CustomScrollView(
          slivers: [
            // Barra de búsqueda sticky
            SliverPersistentHeader(
              pinned: true,
              delegate: _LoteSearchBarDelegate(
                searchController: _searchController,
                searchQuery: _searchQuery,
                estadoFilter: _estadoFilter,
                tipoFilter: _tipoFilter,
                onSearchChanged: (value) {
                  setState(() => _searchQuery = value);
                },
                onClearSearch: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                onEstadoFilterChanged: (estado) {
                  setState(() => _estadoFilter = estado);
                },
                onTipoFilterChanged: (tipo) {
                  setState(() => _tipoFilter = tipo);
                },
              ),
            ),

            // Contenido principal
            lotesAsync.when(
              data: (lotes) {
                final filteredLotes = _filterLotes(lotes);
                final hasFilters =
                    _searchQuery.isNotEmpty ||
                    _estadoFilter != null ||
                    _tipoFilter != null;

                if (lotes.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      icon: Icons.egg_outlined,
                      title: S.of(context).batchNoRegistered,
                      description: S.of(context).batchRegisterFirst,
                      actionLabel: S.of(context).batchCreateBatch,
                      actionIcon: Icons.add_rounded,
                      onAction: _navigateToCreate,
                    ),
                  );
                }

                if (filteredLotes.isEmpty) {
                  return SliverFillRemaining(
                    child: AppEmptyState(
                      icon: Icons.egg_outlined,
                      hasFilters: hasFilters,
                      filterTitle: S.of(context).batchNotFoundFilter,
                      filterDescription: S.of(context).batchAdjustFilters,
                      onClearFilters: _clearFilters,
                    ),
                  );
                }

                final size = MediaQuery.sizeOf(context);
                final listPadding = size.width < 360 ? 12.0 : 16.0;
                final cardSpacing = size.width < 360 ? 12.0 : 16.0;

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: listPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final lote = filteredLotes[index];
                      final isFirst = index == 0;
                      final isLast = index == filteredLotes.length - 1;

                      return Padding(
                        padding: EdgeInsets.only(
                          top: isFirst ? cardSpacing : 0,
                          bottom: isLast ? 80 : cardSpacing,
                        ),
                        child: LoteListCard(
                          lote: lote,
                          onDetalles: () => _navigateToDetail(lote.id),
                          onEditar: () => _navigateToEdit(lote.id),
                          onCambiarEstado: () => _showCambiarEstadoDialog(lote),
                          onEliminar: () => _confirmDelete(lote),
                          onVerDashboard: () => _navigateToDashboard(lote.id),
                        ),
                      );
                    }, childCount: filteredLotes.length),
                  ),
                );
              },
              loading: () => const SliverSkeletonList(itemCount: 4),
              error: (error, _) => SliverFillRemaining(
                child: LotesErrorState(
                  mensaje: error.toString(),
                  onRetry: _onRefresh,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PermissionGuard(
        granjaId: widget.granjaId,
        permiso: TipoPermiso.crearLotes,
        showAccessDenied: false,
        child: FloatingActionButton.extended(
          heroTag: 'lotes_list_fab',
          onPressed: _navigateToCreate,
          icon: const Icon(Icons.add),
          label: Text(
            S.of(context).batchNewBatch,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          tooltip: S.of(context).batchCreateNewTooltip,
        ),
      ),
    );
  }

  /// Filtra los lotes según criterios activos.
  List<Lote> _filterLotes(List<Lote> lotes) {
    var filtered = lotes;

    // Filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      final searchLower = _searchQuery.toLowerCase();
      filtered = filtered.where((lote) {
        final codigo = lote.codigo.toLowerCase();
        final nombre = lote.nombre?.toLowerCase() ?? '';
        final proveedor = lote.proveedor?.toLowerCase() ?? '';
        return codigo.contains(searchLower) ||
            nombre.contains(searchLower) ||
            proveedor.contains(searchLower);
      }).toList();
    }

    // Filtro por estado
    if (_estadoFilter != null) {
      filtered = filtered.where((l) => l.estado == _estadoFilter).toList();
    }

    // Filtro por tipo de ave
    if (_tipoFilter != null) {
      filtered = filtered.where((l) => l.tipoAve == _tipoFilter).toList();
    }

    return filtered;
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _estadoFilter = null;
      _tipoFilter = null;
    });
  }

  Future<void> _onRefresh() async {
    if (widget.galponId != null) {
      ref.invalidate(lotesGalponStreamProvider(widget.galponId!));
    } else {
      ref.invalidate(lotesStreamProvider(widget.granjaId));
    }
  }

  /// Muestra diálogo para cambiar estado.
  Future<void> _showCambiarEstadoDialog(Lote lote) async {
    final nuevoEstado = await showDialog<EstadoLote>(
      context: context,
      builder: (context) => _CambiarEstadoDialog(lote: lote),
    );

    if (nuevoEstado != null && mounted) {
      await ref
          .read(loteNotifierProvider.notifier)
          .cambiarEstado(lote.id, nuevoEstado);

      if (mounted) {
        AppSnackBar.success(
          context,
          message: S
              .of(context)
              .batchStatusUpdatedTo(
                nuevoEstado.localizedDisplayName(S.of(context)),
              ),
        );
      }
      unawaited(_onRefresh());
    }
  }

  Future<void> _confirmDelete(Lote lote) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).batchDeleteBatch,
      message: S.of(context).batchDeleteMessage(lote.codigo),
      type: AppDialogType.danger,
    );

    if (confirmed == true && mounted) {
      final result = await ref
          .read(loteNotifierProvider.notifier)
          .eliminar(lote.id);
      result.fold(
        (failure) {
          if (mounted) {
            _mostrarSnackBar(
              S.of(context).batchErrorDeletingDetail(failure.message),
              esExito: false,
            );
          }
        },
        (_) {
          if (mounted) {
            _mostrarSnackBar(
              S.of(context).batchDeletedCorrectly,
              esExito: true,
            );
          }
          unawaited(_onRefresh());
        },
      );
    }
  }

  // ==================== NAVEGACIÓN ====================

  void _navigateToCreate() {
    if (widget.galponId == null) {
      _mostrarSnackBar(
        S.of(context).batchCannotCreateWithoutShed,
        esExito: false,
      );
      return;
    }
    context
        .push(AppRoutes.loteCrearEnGalpon(widget.granjaId, widget.galponId!))
        .then((_) => _onRefresh());
  }

  void _navigateToDetail(String loteId) {
    if (widget.galponId == null) {
      _mostrarSnackBar(
        S.of(context).batchCannotViewWithoutShed,
        esExito: false,
      );
      return;
    }
    context.push(
      AppRoutes.loteDetalleById(widget.granjaId, widget.galponId!, loteId),
    );
  }

  void _navigateToEdit(String loteId) {
    if (widget.galponId == null) {
      _mostrarSnackBar(
        S.of(context).batchCannotEditWithoutShed,
        esExito: false,
      );
      return;
    }
    context
        .push(
          AppRoutes.loteEditarById(widget.granjaId, widget.galponId!, loteId),
        )
        .then((_) => _onRefresh());
  }

  void _navigateToDashboard(String loteId) {
    context.push('/granjas/${widget.granjaId}/lotes/$loteId/dashboard');
  }

  void _mostrarSnackBar(String mensaje, {required bool esExito}) {
    if (esExito) {
      AppSnackBar.success(context, message: mensaje);
    } else {
      AppSnackBar.error(context, message: mensaje);
    }
  }
}

// ==================== SEARCH BAR DELEGATE ====================

class _LoteSearchBarDelegate extends SliverPersistentHeaderDelegate {
  const _LoteSearchBarDelegate({
    required this.searchController,
    required this.searchQuery,
    required this.estadoFilter,
    required this.tipoFilter,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onEstadoFilterChanged,
    required this.onTipoFilterChanged,
  });

  final TextEditingController searchController;
  final String searchQuery;
  final EstadoLote? estadoFilter;
  final TipoAve? tipoFilter;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<EstadoLote?> onEstadoFilterChanged;
  final ValueChanged<TipoAve?> onTipoFilterChanged;

  @override
  double get minExtent => 116;

  @override
  double get maxExtent => 116;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: maxExtent,
      alignment: Alignment.topCenter,
      child: AppSearchBar(
        controller: searchController,
        searchQuery: searchQuery,
        hintText: S.of(context).batchSearchHint,
        onSearchChanged: onSearchChanged,
        onClearSearch: onClearSearch,
        filterBuilder: (theme) => AppFilterTabRow(
          tabs: [
            AppFilterTab(
              label: S.of(context).batchAll,
              isSelected: estadoFilter == null,
              onTap: () => onEstadoFilterChanged(null),
            ),
            AppFilterTab(
              label: S.of(context).batchActive,
              isSelected: estadoFilter == EstadoLote.activo,
              color: AppColors.success,
              onTap: () => onEstadoFilterChanged(
                estadoFilter == EstadoLote.activo ? null : EstadoLote.activo,
              ),
            ),
            AppFilterTab(
              label: S.of(context).batchClosed,
              isSelected: estadoFilter == EstadoLote.cerrado,
              color: AppColors.grey600,
              onTap: () => onEstadoFilterChanged(
                estadoFilter == EstadoLote.cerrado ? null : EstadoLote.cerrado,
              ),
            ),
            AppFilterTab(
              label: S.of(context).batchInQuarantine,
              isSelected: estadoFilter == EstadoLote.cuarentena,
              color: AppColors.warning,
              onTap: () => onEstadoFilterChanged(
                estadoFilter == EstadoLote.cuarentena
                    ? null
                    : EstadoLote.cuarentena,
              ),
            ),
            AppFilterTab(
              label: S.of(context).batchSold,
              isSelected: estadoFilter == EstadoLote.vendido,
              color: AppColors.info,
              onTap: () => onEstadoFilterChanged(
                estadoFilter == EstadoLote.vendido ? null : EstadoLote.vendido,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_LoteSearchBarDelegate oldDelegate) {
    return searchQuery != oldDelegate.searchQuery ||
        estadoFilter != oldDelegate.estadoFilter ||
        tipoFilter != oldDelegate.tipoFilter;
  }
}

// ==================== DIÁLOGOS ====================

/// Diálogo para cambiar estado del lote.
class _CambiarEstadoDialog extends StatelessWidget {
  const _CambiarEstadoDialog({required this.lote});

  final Lote lote;

  Color _getColorEstado(EstadoLote estado) {
    return switch (estado) {
      EstadoLote.activo => AppColors.active,
      EstadoLote.cerrado => AppColors.inactive,
      EstadoLote.cuarentena => AppColors.pending,
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
        S.of(context).batchSelectNewStatus,
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
            padding: const EdgeInsets.all(12),
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
              S.of(context).batchSelectNewStatus,
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
                padding: const EdgeInsets.only(bottom: 8),
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
                                  .batchConfirmStateChange(
                                    estado.localizedDisplayName(S.of(context)),
                                  ),
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              S.of(context).batchPermanentStateWarning,
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
                      padding: const EdgeInsets.all(12),
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
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      S.of(context).batchPermanentState,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(S.of(context).commonCancel),
        ),
      ],
    );
  }
}
