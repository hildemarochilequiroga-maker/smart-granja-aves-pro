/// Página para editar un lote existente
/// Implementa el mismo formulario multi-paso que CrearLotePage
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_states.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/enums.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/lote_form_steps/lote_form_steps.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página para editar un lote existente usando formulario multi-paso
class EditarLotePage extends ConsumerStatefulWidget {
  const EditarLotePage({
    super.key,
    required this.granjaId,
    required this.loteId,
  });

  final String granjaId;
  final String loteId;

  @override
  ConsumerState<EditarLotePage> createState() => _EditarLotePageState();
}

class _EditarLotePageState extends ConsumerState<EditarLotePage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _autoValidate = false;

  // Controllers para Paso 1: Información Básica
  final _codigoController = TextEditingController();
  final _cantidadInicialController = TextEditingController();
  final _edadIngresoController = TextEditingController();
  TipoAve? _selectedTipoAve;
  DateTime _selectedFechaIngreso = DateTime.now();

  // Controllers para Paso 2: Ubicación
  final _observacionesController = TextEditingController();
  String? _selectedGalponId;

  bool _isLoading = false;
  bool _inicializado = false;
  Lote? _loteOriginal;
  TipoAve? _tipoAveOriginal;

  // Definición de los pasos del formulario
  late List<FormStepInfo> _steps;

  @override
  void dispose() {
    _pageController.dispose();
    _codigoController.dispose();
    _cantidadInicialController.dispose();
    _edadIngresoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _cargarDatosLote(Lote lote) {
    if (_inicializado) return;

    _loteOriginal = lote;

    // Información Básica
    _codigoController.text = lote.codigo;
    _cantidadInicialController.text = lote.cantidadInicial.toString();
    _edadIngresoController.text = lote.edadIngresoDias.toString();
    _selectedTipoAve = lote.tipoAve;
    _tipoAveOriginal = lote.tipoAve;
    _selectedFechaIngreso = lote.fechaIngreso;

    // Ubicación
    _selectedGalponId = lote.galponId;
    _observacionesController.text = lote.observaciones ?? '';

    _inicializado = true;
  }

  bool _tieneCambios() {
    if (_loteOriginal == null) return false;

    // Comparar información básica
    if (_codigoController.text.trim() != _loteOriginal!.codigo) {
      return true;
    }
    if (_cantidadInicialController.text !=
        _loteOriginal!.cantidadInicial.toString()) {
      return true;
    }
    if (_edadIngresoController.text !=
        _loteOriginal!.edadIngresoDias.toString()) {
      return true;
    }
    if (_selectedTipoAve != _tipoAveOriginal) {
      return true;
    }
    if (_selectedFechaIngreso != _loteOriginal!.fechaIngreso) {
      return true;
    }

    // Comparar ubicación
    if (_selectedGalponId != _loteOriginal!.galponId) {
      return true;
    }
    if (_observacionesController.text.trim() !=
        (_loteOriginal!.observaciones ?? '')) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final loteAsync = ref.watch(loteByIdProvider(widget.loteId));

    return loteAsync.when(
      data: (lote) {
        if (lote == null) {
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).commonError)),
            body: Center(child: Text(S.of(context).batchNotFoundMessage)),
          );
        }

        _cargarDatosLote(lote);
        return _buildEditForm(lote);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(S.of(context).batchEditCode(''))),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: Text(S.of(context).batchEditCode(''))),
        body: ErrorState(
          message: S.of(context).batchCouldNotLoad,
          onRetry: () => ref.invalidate(loteByIdProvider(widget.loteId)),
        ),
      ),
    );
  }

  Widget _buildEditForm(Lote lote) {
    _steps = [
      FormStepInfo(label: S.of(context).batchFormStepBasicInfo),
      FormStepInfo(label: S.of(context).batchFormStepDetails),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).batchEditCode(lote.codigo)),
              if (_tieneCambios())
                Text(
                  S.of(context).batchUnsavedChanges,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: S.of(context).batchLeave,
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
              steps: _steps,
              onStepTapped: _goToStep,
            ),

            // Contenido del formulario
            Expanded(
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    LoteBasicInfoStep(
                      granjaId: widget.granjaId,
                      codigoController: _codigoController,
                      cantidadInicialController: _cantidadInicialController,
                      edadIngresoController: _edadIngresoController,
                      selectedTipoAve: _selectedTipoAve,
                      fechaIngreso: _selectedFechaIngreso,
                      galponId: _selectedGalponId,
                      onTipoAveChanged: (value) {
                        setState(() => _selectedTipoAve = value);
                      },
                      onFechaIngresoChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedFechaIngreso = value);
                        }
                      },
                      autoValidate: _autoValidate,
                      isEditing: true,
                    ),
                    LoteDetallesStep(
                      granjaId: widget.granjaId,
                      cantidadInicialController: _cantidadInicialController,
                      edadIngresoController: _edadIngresoController,
                      observacionesController: _observacionesController,
                      galponId: _selectedGalponId,
                      autoValidate: _autoValidate,
                      isEditing: true,
                    ),
                  ],
                ),
              ),
            ),

            // Botones de navegación
            _buildNavigationButtons(),
          ],
        ),
      ),
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

            // Botón Siguiente o Actualizar
            Expanded(
              flex: _currentStep > 0 ? 1 : 1,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _onNextOrSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor: theme.colorScheme.primary
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
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          _currentStep < _steps.length - 1
                              ? S.of(context).commonNext
                              : S.of(context).batchUpdateBatch,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
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

  void _goToStep(int step) {
    if (step < _currentStep) {
      setState(() => _currentStep = step);
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onNextOrSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      setState(() => _autoValidate = true);
      return;
    }

    if (_currentStep < _steps.length - 1) {
      // Avanzar al siguiente paso
      setState(() {
        _currentStep++;
        _autoValidate = false;
      });
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Último paso: enviar formulario
      unawaited(_actualizarLote());
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Información Básica: código, tipo de ave, fecha
        if (_codigoController.text.trim().isEmpty) {
          _showError(S.of(context).batchCodeRequired);
          return false;
        }
        if (_selectedTipoAve == null) {
          _showError(S.of(context).batchSelectBirdType);
          return false;
        }
        if (_selectedGalponId == null || _selectedGalponId!.isEmpty) {
          _showError(S.of(context).batchSelectShed);
          return false;
        }
        return true;
      case 1: // Detalles: cantidad, edad, observaciones
        if (_cantidadInicialController.text.trim().isEmpty) {
          _showError(S.of(context).batchInitialCountRequired);
          return false;
        }
        final cantidad = int.tryParse(_cantidadInicialController.text);
        if (cantidad == null || cantidad <= 0) {
          _showError(S.of(context).batchQuantityValidation);
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  Future<void> _actualizarLote() async {
    // Cerrar teclado antes de enviar formulario
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      setState(() => _autoValidate = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loteActualizado = _loteOriginal!.copyWith(
        codigo: _codigoController.text.trim(),
        tipoAve: _selectedTipoAve!,
        cantidadInicial: int.parse(_cantidadInicialController.text),
        fechaIngreso: _selectedFechaIngreso,
        edadIngresoDias: int.tryParse(_edadIngresoController.text) ?? 0,
        galponId: _selectedGalponId!,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
        ultimaActualizacion: DateTime.now(),
      );

      final notifier = ref.read(loteNotifierProvider.notifier);
      final result = await notifier.actualizar(loteActualizado);

      if (!mounted) return;

      unawaited(
        result.fold(
          (failure) async {
            setState(() => _isLoading = false);
            AppSnackBar.error(
              context,
              message: S.of(context).batchErrorUpdating,
              detail: failure.message,
            );
          },
          (_) async {
            if (!mounted) return;

            // Mostrar mensaje de éxito
            AppSnackBar.success(
              context,
              message: S.of(context).batchUpdateSuccess,
              detail: S.of(context).batchChangesSaved,
            );

            // Navegar de vuelta con delay para mostrar mensaje
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted) {
                context.pop();
              }
            });
          },
        ),
      );
    } on Exception catch (e) {
      setState(() => _isLoading = false);
      AppSnackBar.error(
        context,
        message: S.of(context).batchErrorDetail(e.toString()),
      );
    }
  }

  Future<void> _onBackPressed() async {
    if (!_tieneCambios()) {
      context.pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: S.of(context).batchExitWithoutSaving,
      message: S.of(context).batchChangesWillBeLost,
      type: AppDialogType.warning,
      confirmText: S.of(context).batchLeave,
      cancelText: S.of(context).batchStay,
    );

    if (shouldExit == true && mounted) {
      context.pop();
    }
  }
}
