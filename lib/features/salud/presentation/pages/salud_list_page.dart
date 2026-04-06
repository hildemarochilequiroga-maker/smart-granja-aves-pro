/// Página de lista de registros de salud
///
/// Muestra todos los registros de salud del lote con:
/// - Card de resumen con estadísticas
/// - Filtros por estado (abierto/cerrado)
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para crear nuevo tratamiento
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/routes/app_routes.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/permission_guard.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/salud_provider.dart';
import '../../domain/entities/salud_registro.dart';
import '../widgets/widgets.dart';

/// Enumeración para filtrar por estado
enum EstadoSalud {
  todos,
  abiertos,
  cerrados;

  String localizedName(S l) {
    switch (this) {
      case EstadoSalud.todos:
        return l.saludFilterAll;
      case EstadoSalud.abiertos:
        return l.saludFilterInTreatment;
      case EstadoSalud.cerrados:
        return l.saludFilterClosed;
    }
  }
}

/// Página principal de gestión de salud del lote
class SaludListPage extends ConsumerStatefulWidget {
  const SaludListPage({super.key, this.loteId, this.granjaId});

  final String? loteId;
  final String? granjaId;

  @override
  ConsumerState<SaludListPage> createState() => _SaludListPageState();
}

class _SaludListPageState extends ConsumerState<SaludListPage> {
  S get l => S.of(context);

  EstadoSalud _estadoFilter = EstadoSalud.todos;
  String? _selectedLoteId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    // Usar el stream correcto: por loteId > por lote seleccionado > por granjaId > granja seleccionada
    final granjaActiva = ref.watch(granjaSeleccionadaProvider);
    final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
    final registrosAsync = widget.loteId != null
        ? ref.watch(streamSaludPorLoteProvider(widget.loteId!))
        : _selectedLoteId != null
        ? ref.watch(streamSaludPorLoteProvider(_selectedLoteId!))
        : granjaIdEfectivo != null
        ? ref.watch(streamSaludPorGranjaProvider(granjaIdEfectivo))
        : const AsyncValue<List<SaludRegistro>>.data([]);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.saludRecordsTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: l.saludFilterTooltip,
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Selector de lote cuando hay granja pero no lote fijo
          if (widget.granjaId != null && widget.loteId == null)
            _buildLoteSelectorBar(theme),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: theme.colorScheme.primary,
              child: registrosAsync.when(
                data: (registros) {
                  final filteredRegistros = _filterRegistros(registros);

                  if (registros.isEmpty) {
                    return AppEmptyState(
                      icon: Icons.medical_services_outlined,
                      title: l.saludEmptyTitle,
                      description: l.saludEmptyDescription,
                      actionLabel: l.saludRegisterTreatment,
                      actionIcon: Icons.add_rounded,
                      onAction: () => _navegarARegistrar(),
                    );
                  }

                  if (filteredRegistros.isEmpty) {
                    return AppEmptyState(
                      hasFilters: true,
                      filterTitle: l.saludNoRecordsFound,
                      filterDescription: l.saludNoFilterResults,
                      onClearFilters: () {
                        setState(() => _estadoFilter = EstadoSalud.todos);
                      },
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      // Resumen de salud
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: SaludResumenCard(registros: registros),
                        ),
                      ),

                      // Chips de filtro
                      if (_estadoFilter != EstadoSalud.todos)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Chip(
                                  label: Text(_estadoFilter.localizedName(l)),
                                  deleteIcon: const Icon(Icons.close, size: 18),
                                  onDeleted: () {
                                    setState(
                                      () => _estadoFilter = EstadoSalud.todos,
                                    );
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

                      // Lista de registros
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final registro = filteredRegistros[index];
                            final isFirst = index == 0;
                            final isLast =
                                index == filteredRegistros.length - 1;

                            return Padding(
                              padding: EdgeInsets.only(
                                top: isFirst ? 8 : 0,
                                bottom: isLast ? 100 : 12,
                              ),
                              child: SaludListCard(
                                registro: registro,
                                onTap: () => _showDetail(registro),
                                onCerrar: registro.estaAbierto
                                    ? () => _showCerrarDialog(registro.id)
                                    : null,
                                onEliminar: () => _confirmarEliminar(registro),
                              ),
                            );
                          }, childCount: filteredRegistros.length),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SaludLoadingState(),
                error: (error, _) => SaludErrorState(
                  mensaje: error.toString(),
                  onRetry: _onRefresh,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: widget.granjaId != null
          ? PermissionGuard(
              granjaId: widget.granjaId!,
              permiso: TipoPermiso.crearRegistros,
              showAccessDenied: false,
              child: FloatingActionButton.extended(
                heroTag: 'salud_list_fab',
                onPressed: () => _navegarARegistrar(),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  l.saludNewTreatment,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                tooltip: l.saludNewTreatmentTooltip,
              ),
            )
          : FloatingActionButton.extended(
              heroTag: 'salud_list_fab',
              onPressed: () => _navegarARegistrar(),
              icon: const Icon(Icons.add_rounded),
              label: Text(
                l.saludNewTreatment,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              tooltip: l.saludNewTreatmentTooltip,
            ),
    );
  }

  Widget _buildLoteSelectorBar(ThemeData theme) {
    final lotesAsync = ref.watch(lotesStreamProvider(widget.granjaId!));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: lotesAsync.when(
        data: (lotes) {
          final lotesActivos = lotes.where((l) => l.estaActivo).toList();

          if (lotesActivos.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.saludFilterByBatch,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AppSpacing.gapXs,
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(l.saludAllBatches),
                      selected: _selectedLoteId == null,
                      onSelected: (_) => setState(() => _selectedLoteId = null),
                    ),
                    ...lotesActivos.map(
                      (lote) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: Text(lote.nombre ?? lote.codigo),
                          selected: _selectedLoteId == lote.id,
                          onSelected: (_) =>
                              setState(() => _selectedLoteId = lote.id),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  List<SaludRegistro> _filterRegistros(List<SaludRegistro> registros) {
    switch (_estadoFilter) {
      case EstadoSalud.todos:
        return registros;
      case EstadoSalud.abiertos:
        return registros.where((r) => r.estaAbierto).toList();
      case EstadoSalud.cerrados:
        return registros.where((r) => r.estaCerrado).toList();
    }
  }

  Future<void> _onRefresh() async {
    if (widget.loteId != null) {
      ref.invalidate(streamSaludPorLoteProvider(widget.loteId!));
    } else if (_selectedLoteId != null) {
      ref.invalidate(streamSaludPorLoteProvider(_selectedLoteId!));
    } else {
      final granjaActiva = ref.read(granjaSeleccionadaProvider);
      final granjaIdEfectivo = widget.granjaId ?? granjaActiva?.id;
      if (granjaIdEfectivo != null) {
        ref.invalidate(streamSaludPorGranjaProvider(granjaIdEfectivo));
      }
    }
  }

  void _showDetail(SaludRegistro registro) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SaludDetailSheet(
        registro: registro,
        onCerrar: registro.estaAbierto
            ? () {
                Navigator.pop(ctx);
                _showCerrarDialog(registro.id);
              }
            : null,
        onEliminar: () {
          Navigator.pop(ctx);
          _confirmarEliminar(registro);
        },
      ),
    );
  }

  void _navegarARegistrar() {
    HapticFeedback.mediumImpact();
    if (widget.loteId != null && widget.granjaId != null) {
      context.push(
        AppRoutes.registrarTratamientoConLote(widget.loteId!, widget.granjaId!),
      );
    } else if (widget.granjaId != null) {
      // Pasar granjaId para que el formulario muestre selector de lote
      context.push(
        '${AppRoutes.registrarTratamiento}?granjaId=${widget.granjaId}',
      );
    } else {
      context.push(AppRoutes.registrarTratamiento);
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    HapticFeedback.lightImpact();

    // Variable temporal para el filtro
    EstadoSalud tempEstadoFilter = _estadoFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final hayFiltros = tempEstadoFilter != EstadoSalud.todos;

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
                      l.saludFilterRecords,
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
                          // Sección: Estado
                          _buildFilterSectionHeader(
                            theme: theme,
                            title: l.saludTreatmentStatus,
                          ),
                          const SizedBox(height: 12),

                          // Grid de estados
                          GridView.count(
                            crossAxisCount: AppBreakpoints.of(
                              context,
                            ).gridColumns,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.4,
                            children: EstadoSalud.values.map((estado) {
                              return _buildTipoOption(
                                theme: theme,
                                label: estado.localizedName(l),
                                isSelected: tempEstadoFilter == estado,
                                color: _getEstadoColor(estado),
                                onTap: () {
                                  setModalState(() {
                                    tempEstadoFilter = estado;
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

  Color _getEstadoColor(EstadoSalud estado) {
    switch (estado) {
      case EstadoSalud.todos:
        return AppColors.blueGrey;
      case EstadoSalud.abiertos:
        return AppColors.warning;
      case EstadoSalud.cerrados:
        return AppColors.success;
    }
  }

  Future<void> _confirmarEliminar(SaludRegistro registro) async {
    unawaited(HapticFeedback.lightImpact());

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: l.saludDeleteRecordTitle,
      message: l.saludDeleteRecordMessage(registro.diagnostico),
      type: AppDialogType.danger,
    );

    if (confirmed == true) {
      unawaited(HapticFeedback.heavyImpact());
      await ref.read(saludNotifierProvider.notifier).eliminar(registro.id);

      if (mounted) {
        final saludState = ref.read(saludNotifierProvider);
        if (saludState.errorMessage != null) {
          _mostrarSnackBar(
            l.errorDeletingGeneric(saludState.errorMessage!),
            esExito: false,
          );
        } else {
          _mostrarSnackBar(l.saludRecordDeleted, esExito: true);
        }
      }
    }
  }

  void _mostrarSnackBar(String mensaje, {required bool esExito}) {
    if (esExito) {
      AppSnackBar.success(context, message: mensaje);
    } else {
      AppSnackBar.error(context, message: mensaje);
    }
  }

  void _showCerrarDialog(String id) {
    final resultadoController = TextEditingController();
    final observacionesController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    final l = S.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.allLg),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: AppRadius.allSm,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.successDark,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(l.saludCloseTreatmentTitle)),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.saludDescribeResult,
                    style: Theme.of(dialogContext).textTheme.bodyMedium
                        ?.copyWith(
                          color: Theme.of(
                            dialogContext,
                          ).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  TextFormField(
                    controller: resultadoController,
                    decoration: InputDecoration(
                      labelText: l.saludResultRequired,
                      hintText: l.saludResultHint,
                      border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                      prefixIcon: const Icon(Icons.description),
                      counterText: '',
                    ),
                    maxLines: 2,
                    maxLength: 200,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l.saludResultValidation;
                      }
                      if (value.trim().length < 10) {
                        return l.saludResultMinLength;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: observacionesController,
                    decoration: InputDecoration(
                      labelText: l.saludFinalObservations,
                      hintText: l.saludAdditionalNotesOptional,
                      border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                      prefixIcon: const Icon(Icons.note),
                      counterText: '',
                    ),
                    maxLines: 3,
                    maxLength: 300,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: Text(l.commonCancel),
            ),
            FilledButton.icon(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      unawaited(HapticFeedback.lightImpact());
                      setDialogState(() => isLoading = true);

                      try {
                        await ref
                            .read(saludNotifierProvider.notifier)
                            .cerrar(
                              registroId: id,
                              resultado: resultadoController.text.trim(),
                              observacionesFinales:
                                  observacionesController.text.trim().isNotEmpty
                                  ? observacionesController.text.trim()
                                  : null,
                            );

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (mounted) {
                          _mostrarSnackBar(
                            l.saludTreatmentClosedSuccess,
                            esExito: true,
                          );
                        }
                      } on Exception catch (e) {
                        setDialogState(() => isLoading = false);
                        if (mounted) {
                          _mostrarSnackBar(
                            l.errorClosingTreatment(
                              ErrorHandler.getUserFriendlyMessage(e),
                            ),
                            esExito: false,
                          );
                        }
                      }
                    },
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              icon: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.onSuccess,
                        ),
                      ),
                    )
                  : const Icon(Icons.check),
              label: Text(
                isLoading ? l.commonSaving : l.saludCloseTreatmentTitle,
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      resultadoController.dispose();
      observacionesController.dispose();
    });
  }
}

// =============================================================================
// SHEET DE DETALLE DE SALUD
// =============================================================================

class _SaludDetailSheet extends StatelessWidget {
  final SaludRegistro registro;
  final VoidCallback? onCerrar;
  final VoidCallback? onEliminar;

  const _SaludDetailSheet({
    required this.registro,
    this.onCerrar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(registro.fecha);
    final horaFormat = DateFormat('HH:mm', locale).format(registro.fecha);
    final estadoColor = registro.estaAbierto
        ? AppColors.warning
        : AppColors.success;
    final estadoTexto = registro.estaAbierto
        ? l.saludStatusInTreatment
        : l.saludStatusClosed;

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

              // Header con fecha y badge de estado
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
                      color: estadoColor,
                      borderRadius: AppRadius.allSm,
                    ),
                    child: Text(
                      estadoTexto,
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
                      l.saludDiagnosis,
                      registro.diagnostico,
                    ),
                    if (registro.sintomas != null &&
                        registro.sintomas!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        l.saludSymptoms,
                        registro.sintomas!,
                      ),
                    if (registro.tratamiento != null &&
                        registro.tratamiento!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        l.saludTreatment,
                        registro.tratamiento!,
                      ),
                    if (registro.medicamentos != null &&
                        registro.medicamentos!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        l.saludMedications,
                        registro.medicamentos!,
                      ),
                    if (registro.dosis != null && registro.dosis!.isNotEmpty)
                      _buildTableRow(theme, l.saludDosage, registro.dosis!),
                    if (registro.duracionDias != null)
                      _buildTableRow(
                        theme,
                        l.saludDuration,
                        '${registro.duracionDias} ${l.saludDays}',
                      ),
                    if (registro.veterinario != null &&
                        registro.veterinario!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        l.saludVeterinarian,
                        registro.veterinario!,
                      ),
                    if (registro.estaCerrado && registro.resultado != null)
                      _buildTableRow(
                        theme,
                        l.saludResult,
                        registro.resultado!,
                        valueColor: AppColors.success,
                      ),
                    if (registro.estaCerrado && registro.fechaCierre != null)
                      _buildTableRow(
                        theme,
                        l.saludCloseDate,
                        DateFormat(
                          'd MMM yyyy, HH:mm',
                          Localizations.localeOf(context).languageCode,
                        ).format(registro.fechaCierre!),
                      ),
                    if (registro.estaCerrado &&
                        registro.diasTratamiento != null)
                      _buildTableRow(
                        theme,
                        l.saludTreatmentDays,
                        '${registro.diasTratamiento}',
                      ),
                    _buildTableRow(
                      theme,
                      l.commonRegisteredBy,
                      registro.registradoPor,
                    ),
                    _buildTableRow(
                      theme,
                      l.commonRegistrationDate,
                      DateFormat(
                        'd MMM yyyy, HH:mm',
                        Localizations.localeOf(context).languageCode,
                      ).format(registro.fechaCreacion),
                      isLast: !(registro.observaciones?.isNotEmpty ?? false),
                    ),
                    if (registro.observaciones != null &&
                        registro.observaciones!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        l.commonObservations,
                        registro.observaciones!,
                        isLast: true,
                      ),
                  ],
                ),
              ),

              // Botones de acción
              if (onCerrar != null || onEliminar != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    if (onCerrar != null)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onCerrar,
                          icon: const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                          ),
                          label: Text(l.saludCloseTreatmentTitle),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.allMd,
                            ),
                          ),
                        ),
                      ),
                    if (onCerrar != null && onEliminar != null)
                      const SizedBox(width: 12),
                    if (onEliminar != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onEliminar,
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 18,
                          ),
                          label: Text(l.commonDelete),
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
