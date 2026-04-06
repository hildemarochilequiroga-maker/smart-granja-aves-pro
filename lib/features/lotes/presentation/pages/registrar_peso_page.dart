import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_peso.dart';
import '../../domain/enums/metodo_pesaje.dart';
import '../../application/providers/registro_providers.dart';
import '../../application/providers/lote_providers.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/storage/image_upload_service.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/peso_form_steps/informacion_pesaje_step.dart';
import '../widgets/peso_form_steps/rangos_peso_step.dart';
import '../widgets/peso_form_steps/observaciones_fotos_step.dart';

/// Página para registrar el peso del lote con evidencia fotográfica.
class RegistrarPesoPage extends ConsumerStatefulWidget {
  final Lote lote;

  const RegistrarPesoPage({super.key, required this.lote});

  @override
  ConsumerState<RegistrarPesoPage> createState() => _RegistrarPesoPageState();
}

class _RegistrarPesoPageState extends ConsumerState<RegistrarPesoPage> {
  final _formKey = GlobalKey<FormState>();
  final _pesoPromedioController = TextEditingController();
  final _cantidadAvesController = TextEditingController();
  final _pesoMinimoController = TextEditingController();
  final _pesoMaximoController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _pageController = PageController();

  DateTime _fechaSeleccionada = DateTime.now();
  MetodoPesaje _metodoSeleccionado = MetodoPesaje.manual;
  final List<XFile> _fotosSeleccionadas = [];
  bool _isUploadingPhotos = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;
  bool _autoValidate = false;
  bool _hasUnsavedChanges = false;

  int _currentStep = 0;
  Timer? _autoSaveTimer;
  late List<FormStepInfo> _steps;
  bool _stepsInitialized = false;

  double get _pesoPromedio =>
      double.tryParse(_pesoPromedioController.text) ?? 0;
  int get _cantidadAves => int.tryParse(_cantidadAvesController.text) ?? 0;
  double get _pesoMinimo => double.tryParse(_pesoMinimoController.text) ?? 0;
  double get _pesoMaximo => double.tryParse(_pesoMaximoController.text) ?? 0;

  int get _edadDias {
    return _fechaSeleccionada.difference(widget.lote.fechaIngreso).inDays +
        widget.lote.edadIngresoDias;
  }

  @override
  void initState() {
    super.initState();
    _validateUserAndInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stepsInitialized) {
      _stepsInitialized = true;
      _steps = [
        FormStepInfo(label: S.of(context).batchInfoStep),
        FormStepInfo(label: S.of(context).batchRangesStep),
        FormStepInfo(label: S.of(context).batchSummaryStep),
      ];
    }
  }

  void _validateUserAndInit() {
    final usuario = ref.read(currentUserProvider);
    if (usuario == null || usuario.id.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          AppSnackBar.error(
            context,
            message: S.of(context).batchSessionExpired,
          );
        }
      });
      return;
    }
    _loadDraft();
    _startAutoSave();
    _attachChangeListeners();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pesoPromedioController.removeListener(_onFieldChanged);
    _cantidadAvesController.removeListener(_onFieldChanged);
    _pesoMinimoController.removeListener(_onFieldChanged);
    _pesoMaximoController.removeListener(_onFieldChanged);
    _observacionesController.removeListener(_onFieldChanged);
    _pesoPromedioController.dispose();
    _cantidadAvesController.dispose();
    _pesoMinimoController.dispose();
    _pesoMaximoController.dispose();
    _observacionesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // ==================== AUTO-SAVE ====================

  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasUnsavedChanges && !_isSaving) {
        _saveDraft();
      }
    });
  }

  void _onFieldChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  void _attachChangeListeners() {
    _pesoPromedioController.addListener(_onFieldChanged);
    _cantidadAvesController.addListener(_onFieldChanged);
    _pesoMinimoController.addListener(_onFieldChanged);
    _pesoMaximoController.addListener(_onFieldChanged);
    _observacionesController.addListener(_onFieldChanged);
  }

  Future<void> _saveDraft() async {
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'loteId': widget.lote.id,
        'pesoPromedio': _pesoPromedioController.text,
        'cantidadAves': _cantidadAvesController.text,
        'pesoMinimo': _pesoMinimoController.text,
        'pesoMaximo': _pesoMaximoController.text,
        'fecha': _fechaSeleccionada.toIso8601String(),
        'metodo': _metodoSeleccionado.name,
        'observaciones': _observacionesController.text,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString('peso_draft_${widget.lote.id}', jsonEncode(draft));

      if (!mounted) return;
      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
        _lastSaveTime = DateTime.now();
      });
    } on Exception catch (e) {
      debugPrint('Error guardando borrador: $e');
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('peso_draft_${widget.lote.id}');

      if (draftJson == null) return;

      final draft = jsonDecode(draftJson) as Map<String, dynamic>;
      final timestamp = DateTime.parse(draft['timestamp'] as String);

      // Verificar que el borrador no sea muy antiguo (más de 7 días)
      if (DateTime.now().difference(timestamp).inDays >= 7) {
        await prefs.remove('peso_draft_${widget.lote.id}');
        return;
      }

      // Esperar a que el widget esté construido antes de mostrar el diálogo
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;

        final shouldRestore = await _showRestoreDialog();

        if (shouldRestore == true && mounted) {
          setState(() {
            // Restaurar campos de texto
            _pesoPromedioController.text =
                (draft['pesoPromedio'] as String?) ?? '';
            _cantidadAvesController.text =
                (draft['cantidadAves'] as String?) ?? '';
            _pesoMinimoController.text = (draft['pesoMinimo'] as String?) ?? '';
            _pesoMaximoController.text = (draft['pesoMaximo'] as String?) ?? '';
            _observacionesController.text =
                (draft['observaciones'] as String?) ?? '';

            // Restaurar fecha
            if (draft['fecha'] != null) {
              try {
                _fechaSeleccionada = DateTime.parse(draft['fecha'] as String);
              } on Exception catch (e) {
                debugPrint('Error parseando fecha del draft: $e');
              }
            }

            // Restaurar método
            if (draft['metodo'] != null) {
              try {
                _metodoSeleccionado = MetodoPesaje.values.firstWhere(
                  (m) => m.name == (draft['metodo'] as String),
                  orElse: () => MetodoPesaje.manual,
                );
              } on Exception catch (e) {
                debugPrint('Error parseando método del draft: $e');
              }
            }

            // No marcar como cambios no guardados al restaurar
            _hasUnsavedChanges = false;
          });

          debugPrint('? Borrador restaurado exitosamente');
        } else {
          // Usuario decidió no restaurar, eliminar el borrador
          await prefs.remove('peso_draft_${widget.lote.id}');
          debugPrint('??? Borrador descartado por el usuario');
        }
      });
    } on Exception catch (e) {
      debugPrint('? Error cargando borrador: $e');
      // En caso de error, intentar limpiar el borrador corrupto
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('peso_draft_${widget.lote.id}');
      } catch (_) {}
    }
  }

  Future<bool?> _showRestoreDialog() {
    final l = S.of(context);
    return showAppConfirmDialog(
      context: context,
      title: l.batchDraftFound,
      message: l.batchDraftFoundGeneric,
      type: AppDialogType.info,
      confirmText: l.batchDraftRestore,
      cancelText: l.batchDraftDiscard,
    );
  }

  Future<bool?> _showUnsavedChangesDialog() {
    final l = S.of(context);
    return showAppConfirmDialog(
      context: context,
      title: l.batchExitWithoutComplete,
      message: l.batchDataSafe,
      type: AppDialogType.warning,
      confirmText: l.batchExit,
      cancelText: l.commonContinue,
    );
  }

  // ==================== Helpers ====================

  Future<void> _onBackPressed() async {
    // Prevenir salida mientras se procesa
    if (_isUploadingPhotos || _isSaving) {
      _showError(S.of(context).batchWaitForProcess);
      return;
    }

    // Si no hay campos llenados, salir directamente sin preguntar
    final hasDatos =
        _pesoPromedioController.text.trim().isNotEmpty ||
        _cantidadAvesController.text.trim().isNotEmpty ||
        _pesoMinimoController.text.trim().isNotEmpty ||
        _pesoMaximoController.text.trim().isNotEmpty ||
        _observacionesController.text.trim().isNotEmpty ||
        _fotosSeleccionadas.isNotEmpty;

    if (!hasDatos) {
      // No hay datos ingresados, limpiar y salir silenciosamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('peso_draft_${widget.lote.id}');
      if (mounted) Navigator.of(context).pop();
      return;
    }

    // Si hay cambios recientes no guardados, intentar guardar primero
    if (_hasUnsavedChanges) {
      await _saveDraft();
    }

    // Mostrar diálogo explicando que los datos están seguros
    final shouldExit = await _showUnsavedChangesDialog();
    if (shouldExit == true) {
      // Usuario decide salir, mantener el borrador para restaurar después
      if (mounted) Navigator.of(context).pop();
    }
  }

  String _formatSaveTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    final l = S.of(context);

    if (diff.inSeconds < 10) return l.batchRightNow;
    if (diff.inSeconds < 60) return l.batchSecondsAgo(diff.inSeconds);
    if (diff.inMinutes < 60) return l.batchMinutesAgo(diff.inMinutes);
    return l.batchHoursAgo(diff.inHours);
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isProcessing = _isUploadingPhotos || _isSaving;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).registerWeightTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? S.of(context).batchSaving
                      : S
                            .of(context)
                            .batchSavedTime(_formatSaveTime(_lastSaveTime!)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          leading: isProcessing
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _onBackPressed,
                  tooltip: S.of(context).batchExit,
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
              onStepTapped: (index) {
                if (index < _currentStep) {
                  setState(() {
                    _currentStep = index;
                    _autoValidate = false;
                  });
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),

            // Contenido de los pasos
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Paso 1: Información del Pesaje
                    InformacionPesajeStep(
                      formKey: _formKey,
                      pesoPromedioController: _pesoPromedioController,
                      cantidadAvesController: _cantidadAvesController,
                      fechaSeleccionada: _fechaSeleccionada,
                      metodoSeleccionado: _metodoSeleccionado,
                      onSeleccionarFecha: _seleccionarFecha,
                      onMetodoChanged: (valor) {
                        if (valor != null) {
                          setState(() {
                            _metodoSeleccionado = valor;
                            _hasUnsavedChanges = true;
                          });
                        }
                      },
                      onPesoChanged: () => setState(() {}),
                      autoValidate: _autoValidate,
                    ),

                    // Paso 2: Rangos de Peso
                    RangosPesoStep(
                      formKey: _formKey,
                      pesoMinimoController: _pesoMinimoController,
                      pesoMaximoController: _pesoMaximoController,
                      observacionesController: _observacionesController,
                      onPesoChanged: () => setState(() {}),
                      autoValidate: _autoValidate,
                    ),

                    // Paso 3: Resumen y Fotos
                    ObservacionesFotosStep(
                      formKey: _formKey,
                      imagenes: _fotosSeleccionadas
                          .map((e) => File(e.path))
                          .toList(),
                      onPickImage: _pickImage,
                      onEliminarFoto: _eliminarImagen,
                      autoValidate: _autoValidate,
                      pesoPromedio: _pesoPromedio,
                      cantidadAves: _cantidadAves,
                      pesoMinimo: _pesoMinimo,
                      pesoMaximo: _pesoMaximo,
                      edadDias: _edadDias,
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
    final isProcessing = _isUploadingPhotos || _isSaving;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    onPressed: isProcessing ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isProcessing
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
                      S.of(context).batchPrevious,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) AppSpacing.hGapMd,

            // Botón Siguiente o Registrar
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: isProcessing ? null : _onNextOrSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor: theme.colorScheme.primary
                        .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.allSm,
                    ),
                  ),
                  child: isProcessing
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
                              ? S.of(context).batchNext
                              : S.of(context).batchRegister,
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

  void _onNextOrSubmit() {
    if (_currentStep < _steps.length - 1) {
      _nextStep();
    } else {
      _submit();
    }
  }

  void _nextStep() async {
    if (!await _validateCurrentStep()) return;

    // Unfocus para ocultar teclado
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep++;
      _autoValidate = false;
    });
    unawaited(
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> _previousStep() async {
    // Si estamos en el primer paso, el botón "Anterior" actúa como salir
    if (_currentStep == 0) {
      await _onBackPressed();
      return;
    }

    // Unfocus para ocultar teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep--;
      _autoValidate = false;
    });
    unawaited(
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<bool> _validateCurrentStep() async {
    switch (_currentStep) {
      case 0: // Información del Pesaje
        if (_pesoPromedioController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final pesoPromedio = double.tryParse(
          _pesoPromedioController.text.trim(),
        );
        if (pesoPromedio == null) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoPromedio <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoPromedio > 10000) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (_cantidadAvesController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final cantidadAves = int.tryParse(_cantidadAvesController.text.trim());
        if (cantidadAves == null) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (cantidadAves <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }
        final cantidadActual = widget.lote.avesDisponibles;
        if (cantidadAves > cantidadActual) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).weightCannotExceedAvailable(cantidadActual));
          return false;
        }
        break;

      case 1: // Rangos de Peso
        if (_pesoMinimoController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final pesoMinimo = double.tryParse(_pesoMinimoController.text.trim());
        if (pesoMinimo == null) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoMinimo <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoMinimo > 10000) {
          setState(() => _autoValidate = true);
          return false;
        }

        if (_pesoMaximoController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final pesoMaximo = double.tryParse(_pesoMaximoController.text.trim());
        if (pesoMaximo == null) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoMaximo <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }
        if (pesoMaximo > 10000) {
          setState(() => _autoValidate = true);
          return false;
        }

        if (pesoMinimo >= pesoMaximo) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).weightMinMustBeLessThanMax);
          return false;
        }

        // Validar uniformidad
        final pesoPromedio = _pesoPromedio;
        if (pesoPromedio <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }
        final rango = pesoMaximo - pesoMinimo;
        final cv = (rango / pesoPromedio) * 100;
        if (cv > 15) {
          final continuar = await _mostrarAlertaUniformidad(cv);
          if (continuar != true) {
            return false;
          }
        }
        break;

      case 2: // Observaciones y Fotos - opcional
        break;
    }
    return true;
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showAppConfirmDialog(
      context: context,
      title: title,
      message: content,
      type: AppDialogType.info,
      confirmText: S.of(context).commonContinue,
    );
  }

  // Método para seleccionar fecha
  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: widget.lote.fechaIngreso,
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _fechaSeleccionada) {
      setState(() {
        _fechaSeleccionada = picked;
        _hasUnsavedChanges = true;
      });
    }
  }

  // Método para seleccionar imagen
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
        imageQuality: (AppConstants.imageQuality * 100).toInt(),
      );

      if (image != null && _fotosSeleccionadas.length < 3) {
        // Validar tamaño del archivo
        final file = File(image.path);
        final bytes = await file.length();
        if (bytes > AppConstants.maxImageSizeBytes) {
          if (mounted) {
            _showError(S.of(context).batchPhotoExceeds5MB);
          }
          return;
        }

        setState(() {
          _fotosSeleccionadas.add(image);
          _hasUnsavedChanges = true;
        });

        // Feedback táctil
        if (mounted) {
          AppSnackBar.info(
            context,
            message: S
                .of(context)
                .batchPhotoAdded(_fotosSeleccionadas.length, 3),
            duration: const Duration(seconds: 1),
          );
        }
      }
    } on Exception {
      if (mounted) {
        _showError(S.of(context).batchPhotoSelectError);
      }
    }
  }

  // Método para eliminar imagen
  void _eliminarImagen(int index) {
    setState(() {
      _fotosSeleccionadas.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  // Mostrar alerta de uniformidad baja y pedir confirmación
  Future<bool?> _mostrarAlertaUniformidad(double cv) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          S.of(context).weightLowUniformityTitle,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              S.of(context).weightLowUniformityMessage(cv.toStringAsFixed(1)),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapBase,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).weightCvRecommendedTitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    S.of(context).weightCvRecommendedValues,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
            child: Text(S.of(context).commonReviewData),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(S.of(context).commonContinue),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // Validación final del step actual
    if (!await _validateCurrentStep()) return;
    if (!mounted) return;

    // Validar usuario
    final usuario = ref.read(currentUserProvider);
    if (usuario == null ||
        usuario.id.isEmpty ||
        usuario.nombre == null ||
        usuario.nombre!.isEmpty) {
      _showError(S.of(context).batchSessionExpired);
      return;
    }

    // Verificar permisos del usuario en esta granja
    try {
      final rol = await ref.read(
        rolUsuarioActualEnGranjaProvider(widget.lote.granjaId).future,
      );
      if (!mounted) return;
      if (rol == null) {
        _showError(S.of(context).batchNoAccessFarm);
        return;
      }
      if (!rol.canCreateRecords) {
        _showError(S.of(context).batchNoPermissionWeight);
        return;
      }
    } on Exception catch (e) {
      _showError(S.of(context).batchErrorVerifyingPermissions(e.toString()));
      return;
    }

    // Validar fecha
    if (_fechaSeleccionada.isAfter(DateTime.now())) {
      _showError(S.of(context).weightFutureDate);
      return;
    }
    if (_fechaSeleccionada.isBefore(widget.lote.fechaIngreso)) {
      _showError(S.of(context).weightBeforeEntryDate);
      return;
    }

    // Unfocus teclado
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      // Subir fotos a Firebase Storage
      List<String> fotosUrls = [];
      if (_fotosSeleccionadas.isNotEmpty) {
        setState(() {
          _isUploadingPhotos = true;
        });

        fotosUrls = await _uploadPhotos();

        setState(() {
          _isUploadingPhotos = false;
        });

        // Validar que al menos se subió alguna foto si había seleccionadas
        if (fotosUrls.isEmpty && _fotosSeleccionadas.isNotEmpty) {
          if (!mounted) return;
          setState(() => _isSaving = false);
          _showError(S.of(context).batchPhotoUploadFailed);
          final continuar = await _showConfirmDialog(
            S.of(context).batchContinueWithoutPhotos,
            S.of(context).batchPhotoUploadFailedDetail,
          );
          if (continuar != true) {
            setState(() => _isSaving = false);
            return;
          }
        }
      }

      // Calcular edad del lote en días
      final edadDias =
          _fechaSeleccionada.difference(widget.lote.fechaIngreso).inDays +
          widget.lote.edadIngresoDias;

      // Parsear valores numéricos de forma segura
      final pesoPromedio = double.tryParse(_pesoPromedioController.text) ?? 0.0;
      final cantidadAves = int.tryParse(_cantidadAvesController.text) ?? 0;

      // Calcular pesoTotal explícitamente
      final pesoTotalCalculado = pesoPromedio * cantidadAves;

      // Crear el registro de peso
      final registro = RegistroPeso(
        id: '', // Se generará en el repositorio
        loteId: widget.lote.id,
        granjaId: widget.lote.granjaId,
        galponId: widget.lote.galponId,
        fecha: _fechaSeleccionada,
        pesoPromedio: pesoPromedio,
        cantidadAvesPesadas: cantidadAves,
        pesoTotal: pesoTotalCalculado,
        pesoMinimo: _pesoMinimo,
        pesoMaximo: _pesoMaximo,
        edadDias: edadDias,
        metodoPesaje: _metodoSeleccionado,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
        fotosUrls: fotosUrls,
        usuarioRegistro: usuario.id,
        nombreUsuario: usuario.nombre!,
        createdAt: DateTime.now(),
      );

      // Validar entidad antes de guardar
      final validacionError = registro.validar();
      if (validacionError != null) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        _showError(validacionError);
        return;
      }

      debugPrint('?? Guardando registro de peso...');
      debugPrint('Lote: ${widget.lote.id}');
      debugPrint('Fecha: ${registro.fecha}');
      debugPrint('Peso promedio: ${registro.pesoPromedio}g');
      debugPrint('Cantidad aves: ${registro.cantidadAvesPesadas}');

      await ref.read(registroPesoDatasourceProvider).crear(registro);

      debugPrint('? Registro de peso guardado exitosamente');

      // Actualizar el peso promedio actual en el lote
      debugPrint(
        '?? Actualizando peso promedio del lote: ${registro.pesoPromedioKg} kg',
      );
      await ref.read(loteFirebaseDatasourceProvider).actualizarCampos(
        widget.lote.id,
        {'pesoPromedioActual': registro.pesoPromedioKg},
      );

      debugPrint('? Lote actualizado exitosamente');

      if (!mounted) return;

      // Limpiar borrador después de guardar exitosamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('peso_draft_${widget.lote.id}');

      if (!mounted) return;
      setState(() => _isSaving = false);

      // Celebración con animación
      AppSnackBar.success(
        context,
        message: S.of(context).weightRegistered,
        detail: S
            .of(context)
            .weightRegisteredDetail(
              registro.cantidadAvesPesadas.toString(),
              registro.pesoPromedioKg.toStringAsFixed(2),
            ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on FirebaseException catch (e) {
      debugPrint('? Error Firebase en registro peso: ${e.code} - ${e.message}');
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _isUploadingPhotos = false;
      });

      String mensajeError = S.of(context).batchFirebaseDbError;
      String detalle = '';

      switch (e.code) {
        case 'permission-denied':
          mensajeError = S.of(context).batchFirebasePermissionDenied;
          detalle = S.of(context).batchFirebasePermissionDetail;
          break;
        case 'network-request-failed':
          mensajeError = S.of(context).batchFirebaseNetworkError;
          detalle = S.of(context).batchFirebaseNetworkDetail;
          break;
        case 'unavailable':
          mensajeError = S.of(context).batchFirebaseUnavailable;
          detalle = S.of(context).batchFirebaseUnavailableDetail;
          break;
        default:
          detalle = e.message ?? '';
      }

      AppSnackBar.error(
        context,
        message: mensajeError,
        detail: detalle.isNotEmpty ? detalle : null,
        actionLabel: S.of(context).commonRetry,
        onAction: _submit,
      );
    } on Exception catch (e) {
      debugPrint('? Error Exception en registro peso: $e');
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _isUploadingPhotos = false;
      });
      _showError(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<List<String>> _uploadPhotos() async {
    final imageService = ref.read(imageUploadServiceProvider);

    return imageService.uploadMultipleImages(
      files: _fotosSeleccionadas,
      type: ImageUploadType.peso,
      granjaId: widget.lote.granjaId,
      entityId: widget.lote.id,
      metadata: {'loteId': widget.lote.id},
      onProgress: (uploaded, total) {
        debugPrint('? Foto $uploaded/$total subida');
      },
    );
  }
}
