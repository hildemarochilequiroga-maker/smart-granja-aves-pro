/// Página para programar una nueva vacunación
/// Implementa un formulario multi-paso con auto-save - Estilo Wialon
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../inventario/inventario.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../domain/usecases/usecases.dart';
import '../../application/providers/vacunacion_provider.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/vacunacion_form_steps/vacuna_info_step.dart';
import '../widgets/vacunacion_form_steps/aplicacion_observaciones_step.dart';

/// Página modularizada para programar una nueva vacunación.
///
/// Implementa un formulario multi-paso con:
/// - Información de la vacuna
/// - Aplicación y observaciones
class ProgramarVacunacionPage extends ConsumerStatefulWidget {
  final String loteId;
  final String granjaId;

  const ProgramarVacunacionPage({
    super.key,
    required this.loteId,
    required this.granjaId,
  });

  @override
  ConsumerState<ProgramarVacunacionPage> createState() =>
      _ProgramarVacunacionPageState();
}

class _ProgramarVacunacionPageState
    extends ConsumerState<ProgramarVacunacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false];

  // Controllers
  final _nombreVacunaController = TextEditingController();
  final _loteVacunaController = TextEditingController();
  final _observacionesController = TextEditingController();

  DateTime _fechaProgramada = DateTime.now();
  DateTime? _fechaAplicacion;
  bool _isLoading = false;
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  // Item de inventario seleccionado (vacuna)
  ItemInventario? _itemInventarioSeleccionado;

  // Lote seleccionado (cuando no viene de la ruta)
  Lote? _loteSeleccionado;

  static const _draftKey = 'vacunacion_draft';

  // Definición de los pasos del formulario
  late final List<FormStepInfo> _steps;
  bool _stepsInitialized = false;

  /// Indica si necesitamos mostrar el selector de lote
  bool get _necesitaSelectorLote => widget.loteId.isEmpty;

  /// Obtiene el loteId efectivo (de la ruta o del selector)
  String get _loteIdEfectivo =>
      widget.loteId.isNotEmpty ? widget.loteId : (_loteSeleccionado?.id ?? '');

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _startAutoSave();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stepsInitialized) {
      final l = S.of(context);
      _steps = [
        FormStepInfo(label: l.vacStepVaccine),
        FormStepInfo(label: l.vacStepApplication),
      ];
      _stepsInitialized = true;
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pageController.dispose();
    _nombreVacunaController.dispose();
    _loteVacunaController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _autoSave();
    });
  }

  Future<void> _autoSave() async {
    if (!_hasUnsavedChanges()) return;

    setState(() => _isSaving = true);
    final prefs = await SharedPreferences.getInstance();
    final draft = {
      'loteId': widget.loteId,
      'granjaId': widget.granjaId,
      'nombreVacuna': _nombreVacunaController.text,
      'loteVacuna': _loteVacunaController.text,
      'observaciones': _observacionesController.text,
      'fechaProgramada': _fechaProgramada.toIso8601String(),
      'fechaAplicacion': _fechaAplicacion?.toIso8601String(),
      'step': _currentStep,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString(_draftKey, jsonEncode(draft));
    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString(_draftKey);
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;

    // Solo cargar si el draft es para el mismo lote
    if (draft['loteId'] != widget.loteId) return;

    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove(_draftKey);
      return;
    }

    // Preguntar al usuario si desea restaurar
    if (!mounted) return;
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonDraftFound,
      message: S.of(context).vacDraftFoundMsg(_formatDate(timestamp)),
      type: AppDialogType.info,
      confirmText: S.of(context).commonRestore,
      cancelText: S.of(context).commonDiscard,
    );

    if (!shouldRestore) {
      await prefs.remove(_draftKey);
    }

    if (shouldRestore && mounted) {
      setState(() {
        _nombreVacunaController.text = draft['nombreVacuna'] ?? '';
        _loteVacunaController.text = draft['loteVacuna'] ?? '';
        _observacionesController.text = draft['observaciones'] ?? '';
        if (draft['fechaProgramada'] != null) {
          _fechaProgramada =
              DateTime.tryParse(draft['fechaProgramada']) ?? DateTime.now();
        }
        if (draft['fechaAplicacion'] != null) {
          _fechaAplicacion = DateTime.tryParse(draft['fechaAplicacion']);
        }
        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return S
          .of(context)
          .commonTodayAt(
            '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          );
    } else if (difference.inDays == 1) {
      return S.of(context).commonYesterday;
    } else {
      return S.of(context).commonDaysAgo(difference.inDays.toString());
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    if (difference.inSeconds < 10) {
      return S.of(context).commonTimeRightNow;
    } else if (difference.inSeconds < 60) {
      return S
          .of(context)
          .commonTimeSecondsAgo(difference.inSeconds.toString());
    } else if (difference.inMinutes < 60) {
      return S
          .of(context)
          .commonTimeMinutesAgo(difference.inMinutes.toString());
    } else {
      return S.of(context).commonTimeHoursAgo(difference.inHours.toString());
    }
  }

  bool _hasUnsavedChanges() {
    return _nombreVacunaController.text.isNotEmpty ||
        _loteVacunaController.text.isNotEmpty ||
        _observacionesController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Obtener lotes si necesitamos el selector
    final lotesAsync = _necesitaSelectorLote && widget.granjaId.isNotEmpty
        ? ref.watch(lotesStreamProvider(widget.granjaId))
        : null;

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
              Text(S.of(context).healthScheduleVaccination),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? S.of(context).commonSaving
                      : S
                            .of(context)
                            .commonSavedAt(_formatSaveTime(_lastSaveTime!)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: S.of(context).commonExit,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          actions: [
            // Indicador de sincronización
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: SyncStatusBadge(),
            ),
            if (_isSaving)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
          ],
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
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    VacunaInfoStep(
                      nombreVacunaController: _nombreVacunaController,
                      loteVacunaController: _loteVacunaController,
                      fechaProgramada: _fechaProgramada,
                      autoValidate: _autoValidatePerStep[0],
                      onFechaChanged: (fecha) {
                        setState(() => _fechaProgramada = fecha);
                      },
                      granjaId: widget.granjaId.isNotEmpty
                          ? widget.granjaId
                          : null,
                      itemInventarioSeleccionado: _itemInventarioSeleccionado,
                      onItemInventarioChanged: (item) {
                        setState(() => _itemInventarioSeleccionado = item);
                      },
                      mostrarSelectorLote: _necesitaSelectorLote,
                      lotes: lotesAsync?.valueOrNull,
                      loteSeleccionado: _loteSeleccionado,
                      onLoteChanged: (lote) {
                        setState(() => _loteSeleccionado = lote);
                      },
                    ),
                    AplicacionObservacionesStep(
                      observacionesController: _observacionesController,
                      fechaAplicacion: _fechaAplicacion,
                      autoValidate: _autoValidatePerStep[1],
                      onFechaAplicacionChanged: (fecha) {
                        setState(() => _fechaAplicacion = fecha);
                      },
                      onClearFechaAplicacion: () {
                        setState(() => _fechaAplicacion = null);
                      },
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
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              flex: _currentStep > 0 ? 1 : 1,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isLoading ? null : _onNextOrSubmit,
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
                          width: 20,
                          height: 20,
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
                              : S.of(context).vacScheduleTitle,
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

  void _goToStep(int step) {
    if (step < _currentStep) {
      FocusScope.of(context).unfocus();
      setState(() {
        _currentStep = step;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onNextOrSubmit() {
    if (_currentStep < _steps.length - 1) {
      _nextStep();
    } else {
      _submitForm();
    }
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep++;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  void _previousStep() {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep--;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  bool _validateCurrentStep() {
    // Activar validación automática solo para el step actual
    setState(() => _autoValidatePerStep[_currentStep] = true);

    // Dar feedback háptico al intentar avanzar
    HapticFeedback.lightImpact();

    switch (_currentStep) {
      case 0: // Información de la Vacuna
        if (_nombreVacunaController.text.trim().isEmpty ||
            _nombreVacunaController.text.trim().length < 3) {
          return false;
        }
        // Si necesitamos selector de lote, validar que esté seleccionado
        if (_necesitaSelectorLote && _loteSeleccionado == null) {
          return false;
        }
        break;
      case 1: // Aplicación y Observaciones - todos opcionales
        break;
    }
    return true;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validar que tengamos un loteId
    if (_loteIdEfectivo.isEmpty) {
      AppSnackBar.error(context, message: S.of(context).vacSelectLote);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final params = ProgramarVacunacionParams(
        loteId: _loteIdEfectivo,
        granjaId: widget.granjaId,
        nombreVacuna: _nombreVacunaController.text.trim(),
        fechaProgramada: _fechaProgramada,
        observaciones: _observacionesController.text.trim().isNotEmpty
            ? _observacionesController.text.trim()
            : null,
        programadoPor:
            ref.read(currentUserProvider)?.nombreCompleto ??
            S.of(context).commonUser,
      );

      await ref.read(vacunacionNotifierProvider.notifier).programar(params);

      // Verificar si la operación falló (el notifier no lanza excepciones)
      final vacunacionState = ref.read(vacunacionNotifierProvider);
      if (vacunacionState.errorMessage != null) {
        setState(() => _isLoading = false);
        if (mounted) {
          unawaited(HapticFeedback.heavyImpact());
          AppSnackBar.error(
            context,
            message: S.of(context).vacErrorScheduling,
            detail: vacunacionState.errorMessage,
          );
        }
        return;
      }

      // Descontar del inventario si se seleccionó una vacuna
      if (_itemInventarioSeleccionado != null) {
        try {
          final usuario = ref.read(currentUserProvider);
          final integracionService = ref.read(
            inventarioIntegracionServiceProvider,
          );
          await integracionService.registrarSalidaDesdeVacunacion(
            itemId: _itemInventarioSeleccionado!.id,
            granjaId: widget.granjaId,
            dosis: 1,
            loteId: _loteIdEfectivo,
            registradoPor: usuario?.id ?? 'unknown',
          );
        } on Exception catch (e) {
          debugPrint('Error al descontar inventario: $e');
          if (mounted) {
            AppSnackBar.warning(
              context,
              message: S.of(context).vacRegisteredInventoryError,
              detail: e.toString().replaceFirst('Exception: ', ''),
            );
          }
        }
      }

      // Limpiar el borrador después de guardar exitosamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);

      if (!mounted) return;

      // Feedback háptico de éxito
      unawaited(HapticFeedback.mediumImpact());

      AppSnackBar.success(context, message: S.of(context).vacScheduledSuccess);

      Navigator.of(context).pop(true);
    } on Exception catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.error(
          context,
          message: S.of(context).vacErrorSchedulingDetail,
          detail: e.toString(),
          actionLabel: S.of(context).commonRetry,
          onAction: _submitForm,
        );
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (!_hasUnsavedChanges()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
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
      await _autoSave();
      if (mounted) Navigator.of(context).pop();
    }
  }
}
