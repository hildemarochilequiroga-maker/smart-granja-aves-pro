/// Página de Inspección de Bioseguridad
/// Implementa un formulario multi-paso siguiendo el diseño de CrearGranjaPage
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../galpones/domain/entities/galpon.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../granjas/domain/entities/granja.dart';
import '../../../notificaciones/application/providers/notificaciones_providers.dart';
import '../../application/providers/inspeccion_bioseguridad_provider.dart';
import '../../domain/entities/inspeccion_bioseguridad.dart';
import '../../domain/enums/enums.dart';
import '../widgets/bioseguridad_form_steps/checklist_bioseguridad_step.dart';
import '../widgets/bioseguridad_form_steps/granja_galpon_step.dart';
import '../widgets/bioseguridad_form_steps/observaciones_firma_step.dart';

/// Página para realizar inspección de bioseguridad con formulario multi-paso.
class InspeccionBioseguridadPage extends ConsumerStatefulWidget {
  final String granjaId;
  final String inspectorId;
  final String inspectorNombre;
  final String? galponId;

  const InspeccionBioseguridadPage({
    super.key,
    required this.granjaId,
    required this.inspectorId,
    required this.inspectorNombre,
    this.galponId,
  });

  @override
  ConsumerState<InspeccionBioseguridadPage> createState() =>
      _InspeccionBioseguridadPageState();
}

class _InspeccionBioseguridadPageState
    extends ConsumerState<InspeccionBioseguridadPage> {
  S get l => S.of(context);

  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _observacionesController = TextEditingController();
  final _accionesCorrectivasController = TextEditingController();

  // Selecciones
  Granja? _granjaSeleccionada;
  Galpon? _galponSeleccionado;

  // AutoValidate por step
  final List<bool> _autoValidatePerStep = [false, false, false];

  // Definición de los pasos del formulario
  static const _totalSteps = 3;

  List<FormStepInfo> _getSteps(S l) => [
    FormStepInfo(label: S.of(context).bioInspectionStepLocation),
    FormStepInfo(label: S.of(context).bioInspectionStepChecklist),
    FormStepInfo(label: S.of(context).bioInspectionStepSummary),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeInspection();
    });
  }

  void _initializeInspection() {
    final usuario = ref.read(currentUserProvider);
    ref
        .read(inspeccionesBioseguridadProvider.notifier)
        .iniciarNuevaInspeccion(
          granjaId: widget.granjaId,
          inspectorId: widget.inspectorId.isNotEmpty
              ? widget.inspectorId
              : (usuario?.id ?? 'unknown'),
          inspectorNombre: widget.inspectorNombre.isNotEmpty
              ? widget.inspectorNombre
              : (usuario?.nombreCompleto ?? S.of(context).inspectorFallback),
          galponId: widget.galponId,
        );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _observacionesController.dispose();
    _accionesCorrectivasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final state = ref.watch(inspeccionesBioseguridadProvider);
    final itemsPorCategoria = ref.watch(itemsPorCategoriaProvider);
    final progreso = ref.watch(progresoInspeccionProvider);
    final granjasAsync = ref.watch(granjasStreamProvider);

    if (state.inspeccionEnProgreso == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).bioInspectionTitle),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).bioNewInspection),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleBackPress,
            tooltip: S.of(context).commonExit,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Indicador de progreso
            FormProgressIndicator(
              currentStep: _currentStep,
              steps: _getSteps(l),
              onStepTapped: _goToStep,
            ),

            // Contenido del formulario
            Expanded(
              child: granjasAsync.when(
                data: (granjas) => _buildFormContent(
                  state,
                  itemsPorCategoria,
                  progreso,
                  granjas,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    _buildErrorState(S.of(context).bioInspectionLoadError),
              ),
            ),

            // Botones de navegación
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(
    InspeccionesBioseguridadState state,
    Map<CategoriaBioseguridad, List<ItemInspeccion>> itemsPorCategoria,
    double progreso,
    List<Granja> granjas,
  ) {
    final inspeccion = state.inspeccionEnProgreso!;

    // Seleccionar granja automáticamente si viene en widget
    if (_granjaSeleccionada == null && widget.granjaId.isNotEmpty) {
      final granjaPorDefecto = granjas
          .where((g) => g.id == widget.granjaId)
          .firstOrNull;
      if (granjaPorDefecto != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _granjaSeleccionada = granjaPorDefecto);
            _actualizarUbicacionSeleccionada();
          }
        });
      }
    }

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        setState(() => _currentStep = index);
      },
      children: [
        // Step 1: Selección de galpón (granja ya viene del route)
        GranjaGalponStep(
          granjas: granjas,
          granjaSeleccionada: _granjaSeleccionada,
          galponSeleccionado: _galponSeleccionado,
          onGranjaChanged: (granja) {
            setState(() {
              _granjaSeleccionada = granja;
              _galponSeleccionado = null;
            });
            _actualizarUbicacionSeleccionada();
          },
          onGalponChanged: (galpon) {
            setState(() => _galponSeleccionado = galpon);
            _actualizarUbicacionSeleccionada();
          },
          inspectorNombre: inspeccion.inspectorNombre,
          fechaInspeccion: inspeccion.fecha,
          autoValidate: _autoValidatePerStep[0],
        ),

        // Step 2: Checklist de bioseguridad
        ChecklistBioseguridadStep(
          itemsPorCategoria: itemsPorCategoria,
          onItemChanged: (codigo, estado) {
            HapticFeedback.lightImpact();
            ref
                .read(inspeccionesBioseguridadProvider.notifier)
                .actualizarItem(codigo, estado);
          },
          onObservacionAdded: (codigo, obs) {
            ref
                .read(inspeccionesBioseguridadProvider.notifier)
                .agregarObservacionItem(codigo, obs);
          },
          progresoGeneral: progreso,
          itemsCumplen: inspeccion.itemsCumplen,
          itemsNoCumplen: inspeccion.itemsNoCumplen,
          itemsParciales: inspeccion.itemsParciales,
        ),

        // Step 3: Observaciones y firma
        ObservacionesFirmaStep(
          inspeccion: inspeccion,
          observacionesController: _observacionesController,
          accionesCorrectivasController: _accionesCorrectivasController,
          autoValidate: _autoValidatePerStep[2],
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Botón Anterior
            if (_currentStep > 0)
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isLoading
                            ? theme.colorScheme.outline.withValues(alpha: 0.4)
                            : theme.colorScheme.outline.withValues(alpha: 0.6),
                        width: 1,
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allSm,
                      ),
                    ),
                    child: Text(
                      S.of(context).commonPrevious,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) AppSpacing.hGapMd,

            // Botón Siguiente o Guardar
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _onNextOrSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: _currentStep < _totalSteps - 1
                        ? AppColors.primary
                        : AppColors.success,
                    foregroundColor: _currentStep < _totalSteps - 1
                        ? AppColors.onPrimary
                        : AppColors.white,
                    disabledBackgroundColor:
                        (_currentStep < _totalSteps - 1
                                ? AppColors.primary
                                : AppColors.success)
                            .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _currentStep < _totalSteps - 1
                                  ? AppColors.onPrimary
                                  : AppColors.white,
                            ),
                          ),
                        )
                      : Text(
                          _currentStep < _totalSteps - 1
                              ? S.of(context).commonNext
                              : S.of(context).bioInspectionSaveButton,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: _currentStep < _totalSteps - 1
                                ? AppColors.onPrimary
                                : AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).commonErrorLoadingData,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _goToStep(int step) {
    if (step < _currentStep) {
      FocusScope.of(context).unfocus();
      setState(() => _currentStep = step);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onNextOrSubmit() {
    if (_currentStep < _totalSteps - 1) {
      _nextStep();
    } else {
      _guardarInspeccion();
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) {
      setState(() => _autoValidatePerStep[_currentStep] = true);
      return;
    }

    FocusScope.of(context).unfocus();
    HapticFeedback.lightImpact();

    setState(() => _currentStep++);
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  void _previousStep() {
    if (_currentStep > 0) {
      FocusScope.of(context).unfocus();
      HapticFeedback.lightImpact();

      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_granjaSeleccionada == null) {
          _showSnackBar(S.of(context).bioInspectionLoadingFarm);
          return false;
        }
        _actualizarUbicacionSeleccionada();
        return true;
      case 1:
        final progreso = ref.read(progresoInspeccionProvider);
        if (progreso < 0.5) {
          _showSnackBar(
            S.of(context).bioInspectionMinEvaluation,
            isError: true,
          );
          return false;
        }
        return true;
      case 2:
        return true;
      default:
        return true;
    }
  }

  Future<void> _handleBackPress() async {
    final progreso = ref.read(progresoInspeccionProvider);

    if (progreso > 0) {
      final shouldDiscard = await showAppConfirmDialog(
        context: context,
        title: S.of(context).commonExitWithoutComplete,
        message: S.of(context).bioExitInProgress,
        type: AppDialogType.warning,
        confirmText: S.of(context).commonExit,
        cancelText: S.of(context).commonContinue,
      );

      if (shouldDiscard && mounted) {
        ref
            .read(inspeccionesBioseguridadProvider.notifier)
            .cancelarInspeccion();
        context.pop();
      }
    } else {
      ref.read(inspeccionesBioseguridadProvider.notifier).cancelarInspeccion();
      context.pop();
    }
  }

  Future<void> _guardarInspeccion() async {
    _actualizarUbicacionSeleccionada();

    // Actualizar observaciones y acciones en el provider
    ref
        .read(inspeccionesBioseguridadProvider.notifier)
        .setObservacionesGenerales(_observacionesController.text);
    ref
        .read(inspeccionesBioseguridadProvider.notifier)
        .setAccionesCorrectivas(_accionesCorrectivasController.text);

    // Mostrar diálogo de confirmación
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonSave,
      message: S.of(context).saludInspectionSaveMsg,
      type: AppDialogType.success,
      confirmText: S.of(context).commonSave,
    );

    if (!confirmed || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final inspeccionGuardada = await ref
          .read(inspeccionesBioseguridadProvider.notifier)
          .guardarInspeccion();

      await _notificarInspeccionGuardada(inspeccionGuardada);

      if (!mounted) return;

      unawaited(HapticFeedback.mediumImpact());

      AppSnackBar.success(context, message: S.of(context).bioSavedSuccess);

      context.pop();
    } on Exception catch (e) {
      _showSnackBar(
        S.of(context).errorSavingGeneric(e.toString()),
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _actualizarUbicacionSeleccionada() {
    final granja = _granjaSeleccionada;
    if (granja == null) return;

    ref
        .read(inspeccionesBioseguridadProvider.notifier)
        .actualizarUbicacion(
          granjaId: granja.id,
          galponId: _galponSeleccionado?.id,
        );
  }

  Future<void> _notificarInspeccionGuardada(
    InspeccionBioseguridad inspeccion,
  ) async {
    try {
      final tipoInspeccion = inspeccion.galponId == null
          ? S.of(context).saludInspGeneralDesc
          : S.of(context).saludInspShedDesc;

      await ref
          .read(alertasServiceProvider)
          .notificarInspeccionCompletada(
            granjaId: inspeccion.granjaId,
            inspeccionId: inspeccion.id,
            tipoInspeccion: tipoInspeccion,
            puntaje: inspeccion.porcentajeCumplimiento,
          );
    } catch (_) {
      // La inspección ya fue guardada; no se bloquea el flujo por la notificación.
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (isError) {
      AppSnackBar.error(context, message: message);
    } else {
      AppSnackBar.info(context, message: message);
    }
  }
}
