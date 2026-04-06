/// Página para crear un nuevo lote.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/enums/enums.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/lote_form_steps/lote_form_steps.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página para crear un nuevo lote usando wizard de pasos.
class CrearLotePage extends ConsumerStatefulWidget {
  const CrearLotePage({
    required this.granjaId,
    required this.galponId,
    super.key,
  });

  final String granjaId;
  final String galponId;

  @override
  ConsumerState<CrearLotePage> createState() => _CrearLotePageState();
}

class _CrearLotePageState extends ConsumerState<CrearLotePage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers para Paso 1: Información Básica
  final _codigoController = TextEditingController();
  final _cantidadInicialController = TextEditingController();
  final _edadIngresoController = TextEditingController(text: '0');
  TipoAve? _selectedTipoAve;
  DateTime _selectedFechaIngreso = DateTime.now();

  // Controllers para Paso 1 (observaciones movido aquí)
  final _observacionesController = TextEditingController();
  String? _selectedGalponId;

  // Estado de validación por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false];

  // Timer para autoguardado
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  // Definición de los pasos del formulario
  late final List<FormStepInfo> _steps;

  @override
  void initState() {
    super.initState();
    _generarCodigo();
    // Preseleccionar el galpón si viene de parámetro
    _selectedGalponId = widget.galponId;
    _validateUserAndInit();
  }

  void _validateUserAndInit() {
    final usuario = ref.read(currentUserProvider);
    if (usuario == null || usuario.id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppSnackBar.error(
            context,
            message: S.of(context).batchSessionExpired,
          );
          context.pop();
        }
      });
      return;
    }
    _startAutoSave();
    _loadDraft();
  }

  void _generarCodigo() {
    final ahora = DateTime.now();
    _codigoController.text =
        'LOT-${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.millisecondsSinceEpoch.toString().substring(8)}';
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pageController.dispose();
    _codigoController.dispose();
    _cantidadInicialController.dispose();
    _edadIngresoController.dispose();
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
      'codigo': _codigoController.text,
      'cantidadInicial': _cantidadInicialController.text,
      'edadIngreso': _edadIngresoController.text,
      'tipoAve': _selectedTipoAve?.toJson(),
      'fechaIngreso': _selectedFechaIngreso.toIso8601String(),
      'galponId': _selectedGalponId,
      'observaciones': _observacionesController.text,
      'step': _currentStep,
      'granjaId': widget.granjaId,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString(
      'lote_draft_${widget.granjaId}_${widget.galponId}',
      jsonEncode(draft),
    );
    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  String _formatSaveTime(DateTime saveTime, S l) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    if (difference.inSeconds < 10) {
      return l.batchRightNow;
    } else if (difference.inSeconds < 60) {
      return l.batchSecondsAgo(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return l.batchMinutesAgo(difference.inMinutes);
    } else {
      return l.batchHoursAgo(difference.inHours);
    }
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString(
      'lote_draft_${widget.granjaId}_${widget.galponId}',
    );
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;
    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove('lote_draft_${widget.granjaId}_${widget.galponId}');
      return;
    }

    // Preguntar al usuario si desea restaurar
    if (!mounted) return;
    final l = S.of(context);
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: l.batchDraftFound,
      message: l.batchDraftMessage(_formatDate(timestamp, l)),
      type: AppDialogType.info,
      confirmText: l.batchDraftRestore,
      cancelText: l.batchDraftDiscard,
    );

    if (shouldRestore == true) {
      setState(() {
        _codigoController.text = draft['codigo'] ?? '';
        _cantidadInicialController.text = draft['cantidadInicial'] ?? '';
        _edadIngresoController.text = draft['edadIngreso'] ?? '0';

        if (draft['tipoAve'] != null) {
          _selectedTipoAve = TipoAve.tryFromJson(draft['tipoAve'] as String?);
        }

        if (draft['fechaIngreso'] != null) {
          _selectedFechaIngreso = DateTime.parse(
            draft['fechaIngreso'] as String,
          );
        }

        _selectedGalponId = draft['galponId'] as String?;
        _observacionesController.text = draft['observaciones'] ?? '';
        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
  }

  String _formatDate(DateTime date, S l) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l.batchTodayAt(
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
      );
    } else if (difference.inDays == 1) {
      return l.batchYesterday;
    } else {
      return l.batchDaysAgo(difference.inDays);
    }
  }

  bool _hasUnsavedChanges() {
    return _codigoController.text.isNotEmpty ||
        _cantidadInicialController.text.isNotEmpty ||
        _selectedTipoAve != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);

    _steps = [
      FormStepInfo(label: l.batchBasicStep),
      FormStepInfo(label: l.batchDetailsStep),
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
              Text(l.batchNewBatch),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? l.batchSaving
                      : l.batchSavedTime(_formatSaveTime(_lastSaveTime!, l)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: l.batchExit,
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          actions: [
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
                      autoValidate: _autoValidatePerStep[0],
                      isEditing: false,
                    ),
                    LoteDetallesStep(
                      granjaId: widget.granjaId,
                      cantidadInicialController: _cantidadInicialController,
                      edadIngresoController: _edadIngresoController,
                      observacionesController: _observacionesController,
                      galponId: _selectedGalponId,
                      autoValidate: _autoValidatePerStep[1],
                      isEditing: false,
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
    final l = S.of(context);
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
                      l.batchPrevious,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),

            // Botón Siguiente o Crear
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
                              ? l.batchNext
                              : l.batchCreateBatch,
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
      HapticFeedback.lightImpact();
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

  void _previousStep() {
    // Cerrar teclado antes de cambiar de paso
    FocusScope.of(context).unfocus();

    if (_currentStep > 0) {
      HapticFeedback.lightImpact();
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onNextOrSubmit() {
    if (_currentStep < _steps.length - 1) {
      // Validar paso actual antes de avanzar
      if (_validateCurrentStep()) {
        HapticFeedback.lightImpact();
        // Cerrar teclado antes de cambiar de paso
        FocusScope.of(context).unfocus();

        setState(() {
          _currentStep++;
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // Activar validación automática solo para el step actual
        setState(() => _autoValidatePerStep[_currentStep] = true);
      }
    } else {
      // Último paso: enviar formulario
      _guardarLote();
    }
  }

  bool _validateCurrentStep() {
    // Activar validación automática solo para el step actual
    setState(() => _autoValidatePerStep[_currentStep] = true);

    // Dar feedback háptico al intentar avanzar
    HapticFeedback.lightImpact();

    switch (_currentStep) {
      case 0: // Información Básica: código, tipo de ave, fecha
        if (_codigoController.text.trim().isEmpty) {
          return false;
        }
        if (_selectedTipoAve == null) {
          return false;
        }
        // Validación de fecha de ingreso no futura
        if (_selectedFechaIngreso.isAfter(DateTime.now())) {
          return false;
        }
        // Validación de galpón seleccionado
        if (_selectedGalponId == null || _selectedGalponId!.isEmpty) {
          return false;
        }
        return true;
      case 1: // Detalles: cantidad, edad, observaciones
        if (_cantidadInicialController.text.trim().isEmpty) {
          return false;
        }
        final cantidad = int.tryParse(_cantidadInicialController.text);
        if (cantidad == null || cantidad <= 0 || cantidad > 500000) {
          return false;
        }
        // Validación de edad de ingreso razonable
        final edadIngreso = int.tryParse(_edadIngresoController.text) ?? 0;
        if (edadIngreso < 0 || edadIngreso > 730) {
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _guardarLote() async {
    // Cerrar teclado antes de enviar formulario
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      setState(() => _autoValidatePerStep[_currentStep] = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final lote = Lote.nuevo(
        granjaId: widget.granjaId,
        galponId: _selectedGalponId!,
        codigo: _codigoController.text.trim(),
        tipoAve: _selectedTipoAve!,
        cantidadInicial: int.parse(_cantidadInicialController.text),
        fechaIngreso: _selectedFechaIngreso,
        edadIngresoDias: int.tryParse(_edadIngresoController.text) ?? 0,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
      );

      final notifier = ref.read(loteNotifierProvider.notifier);
      final result = await notifier.crear(lote);

      if (!mounted) return;

      unawaited(
        result.fold(
          (failure) async {
            setState(() => _isLoading = false);
            AppSnackBar.error(
              context,
              message: S.of(context).batchErrorCreating,
              detail: failure.message,
            );
          },
          (loteCreado) async {
            // Limpiar el draft después de crear exitosamente
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove(
              'lote_draft_${widget.granjaId}_${widget.galponId}',
            );

            if (!mounted) return;

            // Feedback háptico de éxito
            unawaited(HapticFeedback.mediumImpact());

            // Mostrar mensaje de éxito
            AppSnackBar.success(
              context,
              message: S.of(context).batchCreateSuccess,
              detail: S.of(context).batchCreateSuccessDetail(loteCreado.codigo),
            );

            // Navegar de vuelta con delay para mostrar celebración
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted) {
                context.pop(loteCreado);
              }
            });
          },
        ),
      );
    } on Exception {
      if (mounted) {
        setState(() => _isLoading = false);
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.error(
          context,
          message: S.of(context).batchUnexpectedError,
          detail: S.of(context).batchCheckConnection,
        );
      }
    }
  }

  Future<void> _onBackPressed() async {
    // Verificar si hay cambios sin guardar
    if (!_hasUnsavedChanges()) {
      // Limpiar draft si existe
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('lote_draft_${widget.granjaId}_${widget.galponId}');
      if (mounted) context.pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: S.of(context).batchExitWithoutComplete,
      message: S.of(context).batchDataSafe,
      type: AppDialogType.warning,
      confirmText: S.of(context).batchExit,
      cancelText: S.of(context).commonContinue,
    );

    if (shouldExit == true) {
      await _autoSave(); // Guardar antes de salir
      if (mounted) context.pop();
    }
  }
}
