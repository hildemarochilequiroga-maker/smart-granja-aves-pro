/// Página para registrar un nuevo tratamiento de salud
/// Implementa un formulario multi-paso con auto-save
/// Diseño consistente con CrearGranjaPage
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../inventario/inventario.dart';
import '../../domain/usecases/usecases.dart';
import '../../application/providers/salud_provider.dart';
import '../widgets/tratamiento_form_steps/diagnostico_info_step.dart';
import '../widgets/tratamiento_form_steps/seleccion_granja_lote_step.dart';
import '../widgets/tratamiento_form_steps/tratamiento_detalles_step.dart';
import '../widgets/tratamiento_form_steps/informacion_adicional_step.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';

/// Página para registrar tratamientos de salud con formulario multi-paso
class RegistrarTratamientoPage extends ConsumerStatefulWidget {
  final String? loteId;
  final String? granjaId;

  const RegistrarTratamientoPage({super.key, this.loteId, this.granjaId});

  @override
  ConsumerState<RegistrarTratamientoPage> createState() =>
      _RegistrarTratamientoPageState();
}

class _RegistrarTratamientoPageState
    extends ConsumerState<RegistrarTratamientoPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  final _diagnosticoController = TextEditingController();
  final _sintomasController = TextEditingController();
  final _tratamientoController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _dosisController = TextEditingController();
  final _duracionDiasController = TextEditingController();
  final _veterinarioController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime _fechaRegistro = DateTime.now();
  bool _isLoading = false;
  int _currentStep = 0;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  // AutoValidate por step para que errores solo afecten el step actual
  late final List<bool> _autoValidatePerStep;

  // Si necesitamos mostrar el step de selección de granja/lote
  bool get _necesitaSeleccion => widget.loteId == null;

  // Granja y lote seleccionados (si no se proporcionan en el widget)
  String? _selectedGranjaId;
  String? _selectedLoteId;

  // Item del inventario seleccionado (medicamento)
  ItemInventario? _itemInventarioSeleccionado;

  // Timer para auto-guardado
  Timer? _autoSaveTimer;
  static const _draftKey = 'tratamiento_draft';

  // Definición dinámica de los pasos del formulario
  List<FormStepInfo> get _steps => [
    if (_necesitaSeleccion)
      FormStepInfo(
        label: S.of(context).treatStepLocation,
        description: S.of(context).treatStepSelectFarmLotDesc,
        icon: Icons.location_on,
      ),
    FormStepInfo(
      label: S.of(context).treatStepDiagnosis,
      description: S.of(context).treatStepDiagnosisInfoDesc,
      icon: Icons.medical_services,
    ),
    FormStepInfo(
      label: S.of(context).treatStepTreatment,
      description: S.of(context).treatStepTreatmentDetailsDesc,
      icon: Icons.healing,
    ),
    FormStepInfo(
      label: S.of(context).treatStepInfo,
      description: S.of(context).treatStepVetObsDesc,
      icon: Icons.description,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Inicializar con los valores del widget si se proporcionan
    _selectedGranjaId = widget.granjaId;
    _selectedLoteId = widget.loteId;

    // Inicializar autoValidate según cantidad de pasos
    _autoValidatePerStep = List.filled(_necesitaSeleccion ? 4 : 3, false);

    _checkForDraft();
    _startAutoSave();

    // Listeners para detectar cambios
    _diagnosticoController.addListener(_onFormChanged);
    _sintomasController.addListener(_onFormChanged);
    _tratamientoController.addListener(_onFormChanged);
    _medicamentosController.addListener(_onFormChanged);
    _dosisController.addListener(_onFormChanged);
    _duracionDiasController.addListener(_onFormChanged);
    _veterinarioController.addListener(_onFormChanged);
    _observacionesController.addListener(_onFormChanged);
  }

  void _startAutoSave() {
    // Configurar auto-guardado cada 30 segundos
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasUnsavedChanges) {
        _saveDraft();
      }
    });
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  Future<void> _checkForDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftKey);

      if (draftJson != null && mounted) {
        final draft = jsonDecode(draftJson) as Map<String, dynamic>;

        // Verificar que el borrador sea para el mismo lote (o si no hay lote seleccionado)
        if (_selectedLoteId == null || draft['loteId'] == _selectedLoteId) {
          unawaited(_showDraftRestoreDialog(draft));
        }
      }
    } on Exception catch (e) {
      debugPrint('Error al cargar borrador: $e');
    }
  }

  Future<void> _showDraftRestoreDialog(Map<String, dynamic> draft) async {
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonDraftFound,
      message: S.of(context).treatDraftMessage,
      type: AppDialogType.info,
      confirmText: S.of(context).commonRestore,
      cancelText: S.of(context).commonDiscard,
    );

    if (!shouldRestore) {
      unawaited(_clearDraft());
    }

    if (shouldRestore && mounted) {
      _restoreDraft(draft);
    }
  }

  void _restoreDraft(Map<String, dynamic> draft) {
    setState(() {
      _diagnosticoController.text = draft['diagnostico'] ?? '';
      _sintomasController.text = draft['sintomas'] ?? '';
      _tratamientoController.text = draft['tratamiento'] ?? '';
      _medicamentosController.text = draft['medicamentos'] ?? '';
      _dosisController.text = draft['dosis'] ?? '';
      _duracionDiasController.text = draft['duracionDias'] ?? '';
      _veterinarioController.text = draft['veterinario'] ?? '';
      _observacionesController.text = draft['observaciones'] ?? '';
      if (draft['fecha'] != null) {
        _fechaRegistro = DateTime.tryParse(draft['fecha']) ?? DateTime.now();
      }
    });
    _hasUnsavedChanges = false;
  }

  Future<void> _saveDraft() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'loteId': _selectedLoteId,
        'granjaId': _selectedGranjaId,
        'diagnostico': _diagnosticoController.text,
        'sintomas': _sintomasController.text,
        'tratamiento': _tratamientoController.text,
        'medicamentos': _medicamentosController.text,
        'dosis': _dosisController.text,
        'duracionDias': _duracionDiasController.text,
        'veterinario': _veterinarioController.text,
        'observaciones': _observacionesController.text,
        'fecha': _fechaRegistro.toIso8601String(),
        'savedAt': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_draftKey, jsonEncode(draft));
      debugPrint('Borrador de tratamiento guardado automáticamente');
      if (mounted) {
        setState(() {
          _lastSaveTime = DateTime.now();
          _hasUnsavedChanges = false;
        });
      }
    } on Exception catch (e) {
      debugPrint('Error al guardar borrador: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _formatSaveTime(DateTime time, S l) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inSeconds < 60) return l.savedMomentAgo;
    if (diff.inMinutes < 60) return l.savedMinutesAgo(diff.inMinutes);
    return l.savedAtTime(
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
    );
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } on Exception catch (e) {
      debugPrint('Error al limpiar borrador: $e');
    }
  }

  Future<void> _onBackPressed() async {
    if (_isLoading) return;

    if (!_hasUnsavedChanges) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonExitWithoutComplete,
      message: S.of(context).commonDontWorryDataSafe,
      type: AppDialogType.warning,
      confirmText: S.of(context).commonExit,
      cancelText: S.of(context).commonContinue,
    );

    if (shouldExit == true) {
      await _saveDraft();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();

    // Remover listeners antes de dispose
    _diagnosticoController.removeListener(_onFormChanged);
    _sintomasController.removeListener(_onFormChanged);
    _tratamientoController.removeListener(_onFormChanged);
    _medicamentosController.removeListener(_onFormChanged);
    _dosisController.removeListener(_onFormChanged);
    _duracionDiasController.removeListener(_onFormChanged);
    _veterinarioController.removeListener(_onFormChanged);
    _observacionesController.removeListener(_onFormChanged);

    // Dispose controllers
    _pageController.dispose();
    _diagnosticoController.dispose();
    _sintomasController.dispose();
    _tratamientoController.dispose();
    _medicamentosController.dispose();
    _dosisController.dispose();
    _duracionDiasController.dispose();
    _veterinarioController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _saveTratamiento();
    }
  }

  void _previousStep() {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    }
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

  bool _validateCurrentStep() {
    // Activar validación automática solo para el step actual
    setState(() => _autoValidatePerStep[_currentStep] = true);

    // Dar feedback háptico al intentar avanzar
    HapticFeedback.lightImpact();

    // Forzar validación del formulario para mostrar errores inline
    _formKey.currentState?.validate();

    // Offset para mapear step visual al step lógico
    final offset = _necesitaSeleccion ? 1 : 0;

    // Step de selección de granja/lote
    if (_necesitaSeleccion && _currentStep == 0) {
      if (_selectedGranjaId == null || _selectedLoteId == null) {
        _showError(S.of(context).pleaseSelectFarmAndBatch);
        return false;
      }
      return true;
    }

    switch (_currentStep - offset) {
      case 0: // Diagnóstico
        if (_selectedGranjaId == null || _selectedLoteId == null) {
          _showError(S.of(context).pleaseSelectFarmAndBatch);
          return false;
        }
        if (_diagnosticoController.text.trim().isEmpty ||
            _diagnosticoController.text.trim().length < 5) {
          return false;
        }
        return true;
      case 1: // Tratamiento
        if (_tratamientoController.text.trim().isEmpty ||
            _tratamientoController.text.trim().length < 5) {
          return false;
        }
        // Validar duración si se ingresó
        if (_duracionDiasController.text.trim().isNotEmpty) {
          final dias = int.tryParse(_duracionDiasController.text.trim());
          if (dias == null || dias <= 0 || dias > 365) {
            _showError(S.of(context).treatDurationValidation);
            return false;
          }
        }
        return true;
      case 2: // Información adicional - todos opcionales
        // Validar que la fecha no sea futura
        if (_fechaRegistro.isAfter(DateTime.now())) {
          _showError(S.of(context).commonDateCannotBeFuture);
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  void _saveTratamiento() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      AppSnackBar.warning(context, message: S.of(context).treatFillRequired);
      return;
    }

    // Validar que se haya seleccionado granja y lote
    if (_selectedGranjaId == null || _selectedLoteId == null) {
      AppSnackBar.warning(context, message: S.of(context).treatSelectFarmBatch);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final params = RegistrarTratamientoParams(
        loteId: _selectedLoteId!,
        granjaId: _selectedGranjaId!,
        diagnostico: _diagnosticoController.text.trim(),
        sintomas: _sintomasController.text.trim().isNotEmpty
            ? _sintomasController.text.trim()
            : null,
        tratamiento: _tratamientoController.text.trim(),
        medicamentos: _medicamentosController.text.trim().isNotEmpty
            ? _medicamentosController.text.trim()
            : null,
        dosis: _dosisController.text.trim().isNotEmpty
            ? _dosisController.text.trim()
            : null,
        duracionDias: _duracionDiasController.text.trim().isNotEmpty
            ? int.tryParse(_duracionDiasController.text.trim())
            : null,
        veterinario: _veterinarioController.text.trim().isNotEmpty
            ? _veterinarioController.text.trim()
            : null,
        observaciones: _observacionesController.text.trim().isNotEmpty
            ? _observacionesController.text.trim()
            : null,
        fechaInicio: _fechaRegistro,
        registradoPor:
            ref.read(currentUserProvider)?.nombreCompleto ??
            S.of(context).commonUser,
      );

      await ref
          .read(saludNotifierProvider.notifier)
          .registrarNuevoTratamiento(params);

      if (!mounted) return;

      // Verificar si hubo error en el guardado
      final saludState = ref.read(saludNotifierProvider);
      if (saludState.errorMessage != null) {
        _showError(saludState.errorMessage!);
        return;
      }

      // Descontar del inventario si se seleccionó un medicamento
      if (_itemInventarioSeleccionado != null && _selectedGranjaId != null) {
        try {
          final usuario = ref.read(currentUserProvider);
          final integracionService = ref.read(
            inventarioIntegracionServiceProvider,
          );

          // Usar la dosis como cantidad si está disponible, sino usar 1 unidad
          final cantidad = _dosisController.text.trim().isNotEmpty
              ? double.tryParse(
                      _dosisController.text.replaceAll(RegExp(r'[^0-9.]'), ''),
                    ) ??
                    1.0
              : 1.0;

          await integracionService.registrarSalidaDesdeTratamiento(
            itemId: _itemInventarioSeleccionado!.id,
            granjaId: _selectedGranjaId!,
            cantidad: cantidad,
            loteId: _selectedLoteId!,
            registradoPor: usuario?.id ?? 'unknown',
          );
          debugPrint('✅ Inventario actualizado por tratamiento');
        } on Exception catch (e) {
          debugPrint('⚠️ Error al actualizar inventario: $e');
          if (mounted) {
            AppSnackBar.warning(
              context,
              message: S.of(context).treatRegisteredInventoryError,
              detail: e.toString().replaceFirst('Exception: ', ''),
            );
          }
        }
      }

      // Limpiar el borrador después de guardar exitosamente
      await _clearDraft();
      _hasUnsavedChanges = false;

      if (mounted) {
        AppSnackBar.success(
          context,
          message: S.of(context).treatRegisteredSuccess,
        );
        Navigator.of(context).pop(true);
      }
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).treatErrorRegistering,
          detail: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
          ),
          title: Column(
            children: [
              Text(
                S.of(context).treatNewTreatment,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_lastSaveTime != null)
                Text(
                  _formatSaveTime(_lastSaveTime!, S.of(context)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
          actions: [
            // Indicador de sincronización
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: SyncStatusBadge(),
            ),
            if (_isSaving)
              Container(
                margin: const EdgeInsets.only(right: AppSpacing.base),
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onPrimary,
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            FormProgressIndicator(
              currentStep: _currentStep,
              steps: _steps,
              onStepTapped: (step) {
                if (step < _currentStep) {
                  _goToStep(step);
                }
              },
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                  },
                  children: [
                    // Paso 0 (condicional): Selección de granja y lote
                    if (_necesitaSeleccion)
                      SeleccionGranjaLoteStep(
                        selectedGranjaId: _selectedGranjaId,
                        selectedLoteId: _selectedLoteId,
                        onGranjaChanged: (granjaId) {
                          setState(() {
                            _selectedGranjaId = granjaId;
                            _selectedLoteId = null;
                            _hasUnsavedChanges = true;
                          });
                        },
                        onLoteChanged: (loteId) {
                          setState(() {
                            _selectedLoteId = loteId;
                            _hasUnsavedChanges = true;
                          });
                        },
                        autoValidate: _autoValidatePerStep[0],
                        soloLote: widget.granjaId != null,
                      ),
                    // Diagnóstico
                    DiagnosticoInfoStep(
                      diagnosticoController: _diagnosticoController,
                      sintomasController: _sintomasController,
                      fechaTratamiento: _fechaRegistro,
                      autoValidate:
                          _autoValidatePerStep[_necesitaSeleccion ? 1 : 0],
                      onFechaChanged: (fecha) {
                        setState(() {
                          _fechaRegistro = fecha;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    // Tratamiento
                    TratamientoDetallesStep(
                      tratamientoController: _tratamientoController,
                      medicamentosController: _medicamentosController,
                      dosisController: _dosisController,
                      duracionController: _duracionDiasController,
                      autoValidate:
                          _autoValidatePerStep[_necesitaSeleccion ? 2 : 1],
                      granjaId: _selectedGranjaId,
                      itemInventarioSeleccionado: _itemInventarioSeleccionado,
                      onItemInventarioChanged: (item) {
                        setState(() {
                          _itemInventarioSeleccionado = item;
                          _hasUnsavedChanges = true;
                        });
                      },
                    ),
                    // Información adicional
                    InformacionAdicionalStep(
                      veterinarioController: _veterinarioController,
                      observacionesController: _observacionesController,
                      autoValidate:
                          _autoValidatePerStep[_necesitaSeleccion ? 3 : 2],
                    ),
                  ],
                ),
              ),
            ),
            _buildNavigationButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
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
                            ? colorScheme.outline.withValues(alpha: 0.4)
                            : colorScheme.outline.withValues(alpha: 0.6),
                        width: 1,
                      ),
                      foregroundColor: colorScheme.onSurface,
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
              flex: _currentStep > 0 ? 1 : 1,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          HapticFeedback.lightImpact();
                          if (_validateCurrentStep()) {
                            _nextStep();
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: AppSpacing.lg,
                          height: AppSpacing.lg,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          _currentStep < _steps.length - 1
                              ? S.of(context).commonNext
                              : S.of(context).commonSaveAction,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: AppColors.onPrimary,
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
}
