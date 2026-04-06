/// Página de lista de vacunaciones
///
/// Muestra todas las vacunaciones programadas con:
/// - Card de resumen con estadísticas
/// - Filtros por estado (aplicada/pendiente/vencida)
/// - Cards modernas con acciones
/// - Pull-to-refresh
/// - FAB para programar nueva vacunación
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/vacunacion_provider.dart';
import '../../domain/entities/vacunacion.dart';
import '../widgets/widgets.dart';

/// Enumeración para filtrar por estado de vacunación
enum EstadoVacunacion {
  todos,
  aplicadas,
  pendientes,
  vencidas,
  proximas;

  String nombre(BuildContext context) {
    switch (this) {
      case EstadoVacunacion.todos:
        return S.of(context).vacFilterAll;
      case EstadoVacunacion.aplicadas:
        return S.of(context).vacFilterApplied;
      case EstadoVacunacion.pendientes:
        return S.of(context).vacFilterPending;
      case EstadoVacunacion.vencidas:
        return S.of(context).vacFilterExpired;
      case EstadoVacunacion.proximas:
        return S.of(context).vacFilterUpcoming;
    }
  }
}

/// Página principal de gestión de vacunaciones
class VacunacionListPage extends ConsumerStatefulWidget {
  const VacunacionListPage({super.key, this.loteId, this.granjaId});

  final String? loteId;
  final String? granjaId;

  @override
  ConsumerState<VacunacionListPage> createState() => _VacunacionListPageState();
}

class _VacunacionListPageState extends ConsumerState<VacunacionListPage> {
  EstadoVacunacion _estadoFilter = EstadoVacunacion.todos;

  bool get _tieneLote => widget.loteId != null && widget.loteId!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Si hay loteId específico, mostrar vacunaciones de ese lote
    if (_tieneLote) {
      return _buildVacunacionesPorLote(theme);
    }

    // Si no hay loteId, usar la granja activa para mostrar TODAS las vacunaciones
    final granjaActiva = ref.watch(granjaSeleccionadaProvider);

    debugPrint(
      '?? VacunacionListPage: granjaActiva=${granjaActiva?.id}, nombre=${granjaActiva?.nombre}',
    );

    if (granjaActiva == null) {
      return _buildSinGranjaActiva(theme);
    }

    final vacunacionesAsync = ref.watch(
      streamVacunacionesPorGranjaProvider(granjaActiva.id),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).vacTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: S.of(context).commonFilter,
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefreshGranja(granjaActiva.id),
        color: theme.colorScheme.primary,
        child: vacunacionesAsync.when(
          data: (vacunaciones) =>
              _buildVacunacionesList(theme, vacunaciones, granjaActiva.id),
          loading: () => const VacunacionLoadingState(),
          error: (error, _) => VacunacionErrorState(
            mensaje: error.toString(),
            onRetry: () => _onRefreshGranja(granjaActiva.id),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'vacunacion_list_fab',
        onPressed: () => _navegarAProgramar(granjaActiva.id),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          S.of(context).vacProgramLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        tooltip: S.of(context).vacProgramNewTooltip,
      ),
    );
  }

  Widget _buildVacunacionesPorLote(ThemeData theme) {
    final vacunacionesAsync = ref.watch(
      streamVacunacionesPorLoteProvider(widget.loteId!),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).vacTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: S.of(context).commonFilter,
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: theme.colorScheme.primary,
        child: vacunacionesAsync.when(
          data: (vacunaciones) =>
              _buildVacunacionesList(theme, vacunaciones, widget.granjaId),
          loading: () => const VacunacionLoadingState(),
          error: (error, _) => VacunacionErrorState(
            mensaje: error.toString(),
            onRetry: _onRefresh,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'vacunacion_list_fab',
        onPressed: () => _navegarAProgramar(widget.granjaId),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          S.of(context).vacProgramLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        tooltip: S.of(context).vacProgramNewTooltip,
      ),
    );
  }

  Widget _buildVacunacionesList(
    ThemeData theme,
    List<Vacunacion> vacunaciones,
    String? granjaId,
  ) {
    final filteredVacunaciones = _filterVacunaciones(vacunaciones);

    if (vacunaciones.isEmpty) {
      return AppEmptyState(
        icon: Icons.vaccines_outlined,
        title: S.of(context).vacEmptyTitle,
        description: S.of(context).vacEmptyDesc,
        actionLabel: S.of(context).healthScheduleVaccination,
        actionIcon: Icons.add_rounded,
        onAction: () => _navegarAProgramar(granjaId),
      );
    }

    if (filteredVacunaciones.isEmpty) {
      return AppEmptyState(
        hasFilters: true,
        filterTitle: S.of(context).vacNoResults,
        filterDescription: S.of(context).vacNoFilterResults,
        onClearFilters: () {
          setState(() => _estadoFilter = EstadoVacunacion.todos);
        },
      );
    }

    return CustomScrollView(
      slivers: [
        // Resumen de vacunaciones
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: VacunacionResumenCard(vacunaciones: vacunaciones),
          ),
        ),

        // Chips de filtro
        if (_estadoFilter != EstadoVacunacion.todos)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Chip(
                    label: Text(switch (_estadoFilter) {
                      EstadoVacunacion.todos => S.of(context).vacFilterAll,
                      EstadoVacunacion.aplicadas =>
                        S.of(context).vacFilterApplied,
                      EstadoVacunacion.pendientes =>
                        S.of(context).vacFilterPending,
                      EstadoVacunacion.vencidas =>
                        S.of(context).vacFilterExpired,
                      EstadoVacunacion.proximas =>
                        S.of(context).vacFilterUpcoming,
                    }),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      setState(() => _estadoFilter = EstadoVacunacion.todos);
                    },
                    backgroundColor: theme.colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    labelStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryDark,
                    ),
                    deleteIconColor: AppColors.primaryDark,
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),
          ),

        // Lista de vacunaciones
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final vacunacion = filteredVacunaciones[index];
              final isFirst = index == 0;
              final isLast = index == filteredVacunaciones.length - 1;

              return Padding(
                padding: EdgeInsets.only(
                  top: isFirst ? 8 : 0,
                  bottom: isLast ? 100 : 12,
                ),
                child: VacunacionListCard(
                  vacunacion: vacunacion,
                  onTap: () => _showDetail(vacunacion),
                  onAplicar: !vacunacion.fueAplicada
                      ? () => _showMarcarAplicadaDialog(vacunacion)
                      : null,
                  onEliminar: () => _confirmarEliminar(vacunacion),
                ),
              );
            }, childCount: filteredVacunaciones.length),
          ),
        ),
      ],
    );
  }

  Widget _buildSinGranjaActiva(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(S.of(context).vacTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.agriculture_rounded,
                size: 80,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.5,
                ),
              ),
              AppSpacing.gapBase,
              Text(
                S.of(context).commonNoFarmSelected,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapSm,
              Text(
                S.of(context).vacNoFarmDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapXl,
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.home_rounded),
                label: Text(S.of(context).commonGoHome),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Vacunacion> _filterVacunaciones(List<Vacunacion> vacunaciones) {
    switch (_estadoFilter) {
      case EstadoVacunacion.todos:
        return vacunaciones;
      case EstadoVacunacion.aplicadas:
        return vacunaciones.where((v) => v.fueAplicada).toList();
      case EstadoVacunacion.pendientes:
        return vacunaciones
            .where((v) => v.estaPendiente && !v.estaVencida)
            .toList();
      case EstadoVacunacion.vencidas:
        return vacunaciones.where((v) => v.estaVencida).toList();
      case EstadoVacunacion.proximas:
        return vacunaciones.where((v) => v.esProxima).toList();
    }
  }

  Future<void> _onRefresh() async {
    if (_tieneLote) {
      ref.invalidate(streamVacunacionesPorLoteProvider(widget.loteId!));
    }
  }

  Future<void> _onRefreshGranja(String granjaId) async {
    ref.invalidate(streamVacunacionesPorGranjaProvider(granjaId));
  }

  void _showDetail(Vacunacion vacunacion) {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VacunacionDetailSheet(
        vacunacion: vacunacion,
        onAplicar: !vacunacion.fueAplicada
            ? () {
                Navigator.pop(ctx);
                _showMarcarAplicadaDialog(vacunacion);
              }
            : null,
        onEliminar: () {
          Navigator.pop(ctx);
          _confirmarEliminar(vacunacion);
        },
      ),
    );
  }

  void _navegarAProgramar(String? granjaId) {
    HapticFeedback.mediumImpact();
    if (_tieneLote && widget.granjaId != null) {
      context.push(
        AppRoutes.programarVacunacionConLote(widget.loteId!, widget.granjaId!),
      );
    } else if (granjaId != null && granjaId.isNotEmpty) {
      // Navegar a programar vacunación con granjaId (sin lote específico)
      context.push('${AppRoutes.programarVacunacion}?granjaId=$granjaId');
    } else {
      // Fallback sin parámetros
      context.push(AppRoutes.programarVacunacion);
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    HapticFeedback.lightImpact();

    // Variable temporal para el filtro
    EstadoVacunacion tempEstadoFilter = _estadoFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final hayFiltros = tempEstadoFilter != EstadoVacunacion.todos;

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
                      S.of(context).vacFilterTitle,
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

                  // Contenido
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sección: Estado
                        _buildFilterSectionHeader(
                          theme: theme,
                          title: S.of(context).vacVaccinationStatus,
                        ),
                        AppSpacing.gapMd,

                        // Opción "Todos"
                        AspectRatio(
                          aspectRatio: 4.8,
                          child: _buildEstadoOption(
                            theme: theme,
                            label: S.of(context).vacAllStatuses,
                            isSelected:
                                tempEstadoFilter == EstadoVacunacion.todos,
                            color: theme.colorScheme.primary,
                            onTap: () {
                              setModalState(() {
                                tempEstadoFilter = EstadoVacunacion.todos;
                              });
                            },
                          ),
                        ),
                        AppSpacing.gapSm,

                        // Grid de estados 2 columnas
                        GridView.count(
                          crossAxisCount: AppBreakpoints.of(
                            context,
                          ).gridColumns,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 2.4,
                          children: [
                            _buildEstadoOption(
                              theme: theme,
                              label: S.of(context).vacFilterApplied,
                              isSelected:
                                  tempEstadoFilter ==
                                  EstadoVacunacion.aplicadas,
                              color: AppColors.success,
                              onTap: () {
                                setModalState(() {
                                  tempEstadoFilter = EstadoVacunacion.aplicadas;
                                });
                              },
                            ),
                            _buildEstadoOption(
                              theme: theme,
                              label: S.of(context).vacFilterPending,
                              isSelected:
                                  tempEstadoFilter ==
                                  EstadoVacunacion.pendientes,
                              color: AppColors.warning,
                              onTap: () {
                                setModalState(() {
                                  tempEstadoFilter =
                                      EstadoVacunacion.pendientes;
                                });
                              },
                            ),
                            _buildEstadoOption(
                              theme: theme,
                              label: S.of(context).vacFilterExpired,
                              isSelected:
                                  tempEstadoFilter == EstadoVacunacion.vencidas,
                              color: AppColors.error,
                              onTap: () {
                                setModalState(() {
                                  tempEstadoFilter = EstadoVacunacion.vencidas;
                                });
                              },
                            ),
                            _buildEstadoOption(
                              theme: theme,
                              label: S.of(context).vacFilterUpcoming,
                              isSelected:
                                  tempEstadoFilter == EstadoVacunacion.proximas,
                              color: AppColors.info,
                              onTap: () {
                                setModalState(() {
                                  tempEstadoFilter = EstadoVacunacion.proximas;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
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
                          foregroundColor: theme.colorScheme.surface,
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

  Widget _buildEstadoOption({
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

  Future<void> _confirmarEliminar(Vacunacion vacunacion) async {
    unawaited(HapticFeedback.lightImpact());

    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).vacDetailDeleteTitle,
      message: S.of(context).vacDetailDeleteMessage(vacunacion.nombreVacuna),
      type: AppDialogType.danger,
    );

    if (confirmed == true) {
      try {
        unawaited(HapticFeedback.heavyImpact());
        await ref
            .read(vacunacionNotifierProvider.notifier)
            .eliminar(vacunacion.id);
        if (mounted) {
          _mostrarSnackBar(S.of(context).vacDeletedSuccess, esExito: true);
        }
      } on Exception catch (e) {
        if (mounted) {
          _mostrarSnackBar(
            S
                .of(context)
                .commonErrorDeleting(ErrorHandler.getUserFriendlyMessage(e)),
            esExito: false,
          );
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

  void _showMarcarAplicadaDialog(Vacunacion vacunacion) {
    final dosisController = TextEditingController();
    final viaController = TextEditingController();
    final edadController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

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
              AppSpacing.hGapMd,
              Expanded(child: Text(S.of(context).vacMarkAppliedTitle)),
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
                    S.of(context).vacApplyDetails,
                    style: Theme.of(dialogContext).textTheme.bodyMedium
                        ?.copyWith(
                          color: Theme.of(
                            dialogContext,
                          ).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  AppSpacing.gapBase,
                  TextFormField(
                    controller: edadController,
                    decoration: InputDecoration(
                      labelText: S.of(context).vacAgeWeeksLabel,
                      hintText: S.of(context).vacAgeHint,
                      border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                      prefixIcon: const Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).vacAgeRequired;
                      }
                      final edad = int.tryParse(value.trim());
                      if (edad == null || edad <= 0) {
                        return S.of(context).vacAgeInvalid;
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapMd,
                  TextFormField(
                    controller: dosisController,
                    decoration: InputDecoration(
                      labelText: S.of(context).vacDoseLabel,
                      hintText: S.of(context).vacDoseHint,
                      border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                      prefixIcon: const Icon(Icons.science),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).vacDoseRequired;
                      }
                      return null;
                    },
                  ),
                  AppSpacing.gapMd,
                  TextFormField(
                    controller: viaController,
                    decoration: InputDecoration(
                      labelText: S.of(context).vacRouteLabel,
                      hintText: S.of(context).vacRouteHint,
                      border: OutlineInputBorder(borderRadius: AppRadius.allMd),
                      prefixIcon: const Icon(Icons.medical_services),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).vacRouteRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
              child: Text(S.of(context).commonCancel),
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
                            .read(vacunacionNotifierProvider.notifier)
                            .marcar(
                              vacunacionId: vacunacion.id,
                              fechaAplicacion: DateTime.now(),
                              aplicadoPor: S.of(context).vacCurrentUser,
                              edadAplicacionSemanas: int.parse(
                                edadController.text.trim(),
                              ),
                              dosis: dosisController.text.trim(),
                              via: viaController.text.trim(),
                            );

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }
                        if (mounted) {
                          _mostrarSnackBar(
                            S.of(context).healthVaccinationApplied,
                            esExito: true,
                          );
                        }
                      } on Exception catch (e) {
                        setDialogState(() => isLoading = false);
                        if (mounted) {
                          _mostrarSnackBar(
                            S
                                .of(context)
                                .commonErrorApplying(
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
                isLoading
                    ? S.of(context).commonSaving
                    : S.of(context).commonApply,
              ),
            ),
          ],
        ),
      ),
    ).then((_) {
      dosisController.dispose();
      viaController.dispose();
      edadController.dispose();
    });
  }
}

// =============================================================================
// SHEET DE DETALLE DE VACUNACIÓN
// =============================================================================

class _VacunacionDetailSheet extends StatelessWidget {
  final Vacunacion vacunacion;
  final VoidCallback? onAplicar;
  final VoidCallback? onEliminar;

  const _VacunacionDetailSheet({
    required this.vacunacion,
    this.onAplicar,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fechaFormat = DateFormat(
      'EEEE, d MMMM yyyy',
      locale,
    ).format(vacunacion.fechaProgramada);
    final horaFormat = DateFormat(
      'HH:mm',
      locale,
    ).format(vacunacion.fechaProgramada);

    // Estado y color
    String estadoTexto;
    Color estadoColor;
    if (vacunacion.fueAplicada) {
      estadoTexto = S.of(context).healthApplied;
      estadoColor = AppColors.success;
    } else if (vacunacion.estaVencida) {
      estadoTexto = S.of(context).healthExpired;
      estadoColor = AppColors.error;
    } else if (vacunacion.esProxima) {
      estadoTexto = S.of(context).healthUpcoming;
      estadoColor = AppColors.info;
    } else {
      estadoTexto = S.of(context).healthPending;
      estadoColor = AppColors.warning;
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

              // Header con fecha y badge de estado
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vacunacion.nombreVacuna,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$fechaFormat • $horaFormat',
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
                      S.of(context).vacVaccineLabel,
                      vacunacion.nombreVacuna,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).vacScheduledDate,
                      DateFormat(
                        'd MMM yyyy',
                        Localizations.localeOf(context).toString(),
                      ).format(vacunacion.fechaProgramada),
                    ),
                    if (vacunacion.fueAplicada &&
                        vacunacion.fechaAplicacion != null)
                      _buildTableRow(
                        theme,
                        S.of(context).vacAppliedDate,
                        DateFormat(
                          'd MMM yyyy, HH:mm',
                          Localizations.localeOf(context).toString(),
                        ).format(vacunacion.fechaAplicacion!),
                        valueColor: AppColors.success,
                      ),
                    if (vacunacion.edadAplicacionSemanas != null)
                      _buildTableRow(
                        theme,
                        S.of(context).vacAgeApplication,
                        S
                            .of(context)
                            .commonWeeks(
                              vacunacion.edadAplicacionSemanas.toString(),
                            ),
                      ),
                    if (vacunacion.dosis != null &&
                        vacunacion.dosis!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).vacDoseLabel,
                        vacunacion.dosis!,
                      ),
                    if (vacunacion.via != null && vacunacion.via!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).vacRouteShort,
                        vacunacion.via!,
                      ),
                    if (vacunacion.laboratorio != null &&
                        vacunacion.laboratorio!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).vacLaboratory,
                        vacunacion.laboratorio!,
                      ),
                    if (vacunacion.loteVacuna != null &&
                        vacunacion.loteVacuna!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).vacBatchVaccineLabel,
                        vacunacion.loteVacuna!,
                      ),
                    if (vacunacion.responsable != null &&
                        vacunacion.responsable!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).vacResponsible,
                        vacunacion.responsable!,
                      ),
                    if (vacunacion.proximaAplicacion != null)
                      _buildTableRow(
                        theme,
                        S.of(context).vacNextApplicationLabel,
                        DateFormat(
                          'd MMM yyyy',
                          Localizations.localeOf(context).toString(),
                        ).format(vacunacion.proximaAplicacion!),
                      ),
                    _buildTableRow(
                      theme,
                      S.of(context).vacScheduledBy,
                      vacunacion.programadoPor,
                    ),
                    _buildTableRow(
                      theme,
                      S.of(context).commonRegistrationDate,
                      DateFormat(
                        'd MMM yyyy, HH:mm',
                        Localizations.localeOf(context).toString(),
                      ).format(vacunacion.fechaCreacion),
                      isLast: !(vacunacion.observaciones?.isNotEmpty ?? false),
                    ),
                    if (vacunacion.observaciones != null &&
                        vacunacion.observaciones!.isNotEmpty)
                      _buildTableRow(
                        theme,
                        S.of(context).commonObservations,
                        vacunacion.observaciones!,
                        isLast: true,
                      ),
                  ],
                ),
              ),

              // Botones de acción
              if (onAplicar != null || onEliminar != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    if (onAplicar != null)
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: onAplicar,
                          icon: const Icon(Icons.vaccines_rounded, size: 18),
                          label: Text(S.of(context).vacDetailMenuMarkApplied),
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
                    if (onAplicar != null && onEliminar != null)
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
