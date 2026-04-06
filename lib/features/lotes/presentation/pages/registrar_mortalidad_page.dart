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
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/image_upload_service.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../notificaciones/application/providers/notificaciones_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_mortalidad.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';
import '../../application/providers/registro_providers.dart';
import '../widgets/mortalidad_form_steps/evento_info_step.dart';
import '../widgets/mortalidad_form_steps/detalles_descripcion_step.dart';
import '../widgets/mortalidad_form_steps/evidencia_fotografica_step.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';

/// Página para registrar un evento de mortalidad con evidencia fotográfica.
class RegistrarMortalidadPage extends ConsumerStatefulWidget {
  final Lote lote;

  const RegistrarMortalidadPage({super.key, required this.lote});

  @override
  ConsumerState<RegistrarMortalidadPage> createState() =>
      _RegistrarMortalidadPageState();
}

class _RegistrarMortalidadPageState
    extends ConsumerState<RegistrarMortalidadPage> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _pageController = PageController();

  CausaMortalidad? _causaSeleccionada;
  DateTime _fechaEvento = DateTime.now();
  final List<XFile> _fotosSeleccionadas = [];
  bool _isUploadingPhotos = false;
  bool _isSaving = false;
  bool _autoValidate = false;
  bool _hasUnsavedChanges = false;
  DateTime? _lastSaveTime;

  int _currentStep = 0;
  Timer? _autoSaveTimer;

  late List<FormStepInfo> _steps;
  bool _stepsInitialized = false;

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
        FormStepInfo(label: S.of(context).batchDescriptionStep),
        FormStepInfo(label: S.of(context).batchEvidenceStep),
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
    _cantidadController.removeListener(_onFieldChanged);
    _descripcionController.removeListener(_onFieldChanged);
    _cantidadController.dispose();
    _descripcionController.dispose();
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
    _cantidadController.addListener(_onFieldChanged);
    _descripcionController.addListener(_onFieldChanged);
  }

  Future<void> _saveDraft() async {
    try {
      setState(() => _isSaving = true);
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'loteId': widget.lote.id,
        'cantidad': _cantidadController.text,
        'causa': _causaSeleccionada?.name,
        'fecha': _fechaEvento.toIso8601String(),
        'descripcion': _descripcionController.text,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(
        'mortalidad_draft_${widget.lote.id}',
        jsonEncode(draft),
      );
      setState(() {
        _hasUnsavedChanges = false;
        _lastSaveTime = DateTime.now();
        _isSaving = false;
      });
    } on Exception catch (e) {
      debugPrint('Error guardando borrador: $e');
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString('mortalidad_draft_${widget.lote.id}');

      if (draftJson != null) {
        final draft = jsonDecode(draftJson) as Map<String, dynamic>;
        final timestamp = DateTime.parse(draft['timestamp'] as String);

        if (DateTime.now().difference(timestamp).inDays < 7) {
          final shouldRestore = await _showRestoreDialog();

          if (shouldRestore == true && mounted) {
            setState(() {
              _cantidadController.text = (draft['cantidad'] as String?) ?? '';
              if (draft['causa'] != null) {
                _causaSeleccionada = CausaMortalidad.values.firstWhere(
                  (c) => c.name == draft['causa'] as String,
                  orElse: () => CausaMortalidad.desconocida,
                );
              }
              _fechaEvento = DateTime.parse(draft['fecha'] as String);
              _descripcionController.text =
                  (draft['descripcion'] as String?) ?? '';
              _hasUnsavedChanges = false;
            });
          } else {
            await prefs.remove('mortalidad_draft_${widget.lote.id}');
          }
        }
      }
    } on Exception catch (e) {
      debugPrint('Error cargando borrador: $e');
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

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cantidadActual = widget.lote.avesDisponibles;
    final isProcessing = _isUploadingPhotos || _isSaving;

    return PopScope(
      canPop: !isProcessing && !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (isProcessing) {
          _showError(S.of(context).batchWaitForProcess);
          return;
        }

        if (_hasUnsavedChanges) {
          final navigator = Navigator.of(context);
          final shouldExit = await _showUnsavedChangesDialog();
          if (shouldExit == true) {
            if (!mounted) return;
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('mortalidad_draft_${widget.lote.id}');
            if (!mounted) return;
            navigator.pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).registerMortalityTitle,
                style: theme.textTheme.titleMedium,
              ),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? S.of(context).batchSaving
                      : S
                            .of(context)
                            .batchSavedTime(_formatSaveTime(_lastSaveTime!)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          leading: isProcessing
              ? null
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    if (_hasUnsavedChanges) {
                      final navigator = Navigator.of(context);
                      final shouldExit = await _showUnsavedChangesDialog();
                      if (shouldExit == true) {
                        if (!mounted) return;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove(
                          'mortalidad_draft_${widget.lote.id}',
                        );
                        if (!mounted) return;
                        navigator.pop();
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  tooltip: S.of(context).batchExit,
                ),
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
                    // Step 1: Información del Evento
                    EventoInfoStep(
                      cantidadController: _cantidadController,
                      causaSeleccionada: _causaSeleccionada,
                      fechaEvento: _fechaEvento,
                      cantidadActual: cantidadActual,
                      autoValidate: _autoValidate,
                      onCausaChanged: (value) {
                        setState(() {
                          _causaSeleccionada = value;
                          _hasUnsavedChanges = true;
                        });
                      },
                      onFechaChanged: (value) {
                        setState(() {
                          _fechaEvento = value;
                          _hasUnsavedChanges = true;
                        });
                      },
                      fechaIngreso: widget.lote.fechaIngreso,
                    ),

                    // Step 2: Detalles y Descripción
                    DetallesDescripcionStep(
                      descripcionController: _descripcionController,
                      causaSeleccionada: _causaSeleccionada,
                      autoValidate: _autoValidate,
                    ),

                    // Step 3: Evidencia Fotográfica
                    EvidenciaFotograficaStep(
                      fotosSeleccionadas: _fotosSeleccionadas,
                      onPickImage: _pickImage,
                      onRemovePhoto: (index) {
                        setState(() {
                          _fotosSeleccionadas.removeAt(index);
                          _hasUnsavedChanges = true;
                        });
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
    final isProcessing = _isUploadingPhotos || _isSaving;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                    onPressed: isProcessing ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isProcessing
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
                    backgroundColor: colorScheme.primary,
                    disabledBackgroundColor: colorScheme.primary.withValues(
                      alpha: 0.5,
                    ),
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
                              colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          _currentStep < _steps.length - 1
                              ? S.of(context).batchNext
                              : S.of(context).batchRegister,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
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

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    // Unfocus para ocultar teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep++;
      _autoValidate = false;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousStep() {
    // Unfocus para ocultar teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep--;
      _autoValidate = false;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Información del Evento
        final cantidad = int.tryParse(_cantidadController.text);
        final cantidadActual = widget.lote.avesDisponibles;

        // Validar campo cantidad
        if (_cantidadController.text.trim().isEmpty ||
            cantidad == null ||
            cantidad <= 0 ||
            cantidad > cantidadActual) {
          setState(() => _autoValidate = true);
          return false;
        }

        // Validar causa seleccionada
        if (_causaSeleccionada == null) {
          setState(() => _autoValidate = true);
          return false;
        }
        break;

      case 1: // Detalles y Descripción
        if (_descripcionController.text.trim().isEmpty ||
            _descripcionController.text.trim().length < 10) {
          setState(() => _autoValidate = true);
          return false;
        }
        break;

      case 2: // Evidencia Fotográfica - opcional
        break;
    }
    return true;
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  String _formatSaveTime(DateTime saveTime) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);
    final l = S.of(context);

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

  Future<bool?> _showUnsavedChangesDialog() async {
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

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showAppConfirmDialog(
      context: context,
      title: title,
      message: content,
      type: AppDialogType.info,
      confirmText: S.of(context).commonContinue,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: AppConstants.maxImageWidth.toDouble(),
        maxHeight: AppConstants.maxImageHeight.toDouble(),
        imageQuality: (AppConstants.imageQuality * 100).toInt(),
      );

      if (image != null && _fotosSeleccionadas.length < 5) {
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

        if (mounted) {
          AppSnackBar.info(
            context,
            message: S
                .of(context)
                .batchPhotoAdded(_fotosSeleccionadas.length, 5),
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

  Future<void> _submit() async {
    // Validación final
    if (!_validateCurrentStep()) return;

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
        _showError(S.of(context).batchNoPermissionMortality);
        return;
      }
    } on Exception catch (e) {
      _showError(S.of(context).batchErrorVerifyingPermissions(e.toString()));
      return;
    }

    // Unfocus teclado
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isSaving = true;
    });

    try {
      // Capturar localización antes de operaciones asíncronas
      final l = S.of(context);
      final causaLocalizada = _causaSeleccionada!.localizedName(l);

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

      // Validar fecha primero (antes de obtener recursos)
      if (_fechaEvento.isAfter(DateTime.now())) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(S.of(context).mortalityFutureDate);
      }

      if (_fechaEvento.isBefore(widget.lote.fechaIngreso)) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(S.of(context).mortalityBeforeEntryDate);
      }

      // Obtener usuario actual
      final usuario = ref.read(currentUserProvider);

      if (usuario == null) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(S.of(context).mortalityUserNotAuthenticated);
      }

      if (usuario.id.isEmpty) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(S.of(context).mortalityUserInvalid);
      }

      if (usuario.nombre == null || usuario.nombre!.isEmpty) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(S.of(context).mortalityUserRequired);
      }

      // Validar cantidad disponible justo antes de guardar (evitar race conditions)
      final cantidadDisponible = widget.lote.avesDisponibles;
      final cantidadARegistrar = int.parse(_cantidadController.text);

      if (cantidadARegistrar > cantidadDisponible) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(
          S
              .of(context)
              .mortalityExceedsAvailable(
                cantidadARegistrar.toString(),
                cantidadDisponible.toString(),
              ),
        );
      }

      // Calcular edad del lote en días usando la fecha del evento
      final edadDias =
          _fechaEvento.difference(widget.lote.fechaIngreso).inDays +
          widget.lote.edadIngresoDias;

      final registro = RegistroMortalidad(
        id: '', // Se generará en el repositorio
        loteId: widget.lote.id,
        granjaId: widget.lote.granjaId,
        galponId: widget.lote.galponId,
        fecha: _fechaEvento,
        cantidad: int.parse(_cantidadController.text),
        causa: _causaSeleccionada!,
        descripcion: _descripcionController.text.trim(),
        fotosUrls: fotosUrls,
        edadAvesDias: edadDias,
        cantidadAntesEvento: widget.lote.avesDisponibles,
        usuarioRegistro: usuario.id,
        nombreUsuario: usuario.nombreCompleto.isNotEmpty
            ? usuario.nombreCompleto
            : (usuario.nombre ?? l.commonUser),
        createdAt: DateTime.now(),
      );

      // Validar la entidad antes de guardar
      final errorValidacion = registro.validar();
      if (errorValidacion != null) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        throw Exception(errorValidacion);
      }

      // Preparar el lote actualizado
      final loteActualizado = widget.lote.copyWith(
        cantidadActual: cantidadDisponible - cantidadARegistrar,
        mortalidadAcumulada:
            widget.lote.mortalidadAcumulada + cantidadARegistrar,
      );

      // Crear registro y actualizar lote en transacción atómica
      final datasource = ref.read(registroMortalidadDatasourceProvider);
      await datasource.crearConActualizacionLote(
        registro: registro,
        loteActualizado: loteActualizado,
      );

      // Verificar si la mortalidad acumulada requiere notificación de alerta
      final alertasService = ref.read(alertasServiceProvider);
      final mortalidadTotal =
          widget.lote.mortalidadAcumulada + cantidadARegistrar;

      // 1. Notificar SIEMPRE que se registra mortalidad
      await alertasService.notificarMortalidadRegistrada(
        granjaId: widget.lote.granjaId,
        loteId: widget.lote.id,
        cantidadMuertos: cantidadARegistrar,
        mortalidadAcumulada: mortalidadTotal,
        cantidadTotal: widget.lote.cantidadInicial,
        causa: causaLocalizada,
      );

      // 2. Verificar si supera umbrales (>2% alta, >5% crítica)
      await alertasService.verificarMortalidadAlta(
        granjaId: widget.lote.granjaId,
        loteId: widget.lote.id,
        cantidadMuertos: mortalidadTotal,
        cantidadTotal: widget.lote.cantidadInicial,
      );

      // Eliminar borrador
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('mortalidad_draft_${widget.lote.id}');

      if (!mounted) return;

      setState(() => _isSaving = false);

      // Mostrar alerta si requiere atención
      if (registro.requiereAtencionInmediata) {
        await _showAlertDialog(registro);
      }

      if (!mounted) return;

      AppSnackBar.success(
        context,
        message: S.of(context).mortalityRegistered,
        detail: S
            .of(context)
            .mortalityRegisteredDetail(
              registro.cantidad.toString(),
              causaLocalizada,
            ),
      );

      // Navegar con delay para mostrar celebración
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } on FirebaseException catch (e) {
      debugPrint(
        '? Error Firebase en registro mortalidad: ${e.code} - ${e.message}',
      );
      if (!mounted) return;
      setState(() => _isSaving = false);

      String mensaje = S.of(context).batchFirebaseDbError;
      if (e.code == 'permission-denied') {
        mensaje = S.of(context).batchFirebasePermissionDetail;
      } else if (e.code == 'unavailable') {
        mensaje =
            '${S.of(context).batchFirebaseUnavailable}. ${S.of(context).batchFirebaseNetworkDetail}';
      } else if (e.message != null) {
        mensaje = e.message!;
      }

      AppSnackBar.error(
        context,
        message: S.of(context).batchFirebaseError,
        detail: mensaje,
      );
    } on Exception catch (e) {
      debugPrint('? Error Exception en registro mortalidad: $e');
      if (!mounted) return;
      setState(() => _isSaving = false);
      AppSnackBar.error(
        context,
        message: S.of(context).batchErrorCreatingRecord,
        detail: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<List<String>> _uploadPhotos() async {
    final imageService = ref.read(imageUploadServiceProvider);

    return imageService.uploadMultipleImages(
      files: _fotosSeleccionadas,
      type: ImageUploadType.mortalidad,
      granjaId: widget.lote.granjaId,
      entityId: widget.lote.id,
      metadata: {'loteId': widget.lote.id},
      onProgress: (uploaded, total) {
        debugPrint('? Foto $uploaded/$total subida');
      },
    );
  }

  Future<void> _showAlertDialog(RegistroMortalidad registro) async {
    if (!mounted) return;
    final l = S.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          l.mortalityAttentionRequired,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.mortalityImpactMessage(
                registro.impactoPorcentual.toStringAsFixed(1),
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapBase,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.mortalityCause(registro.causa.localizedName(l)),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    l.mortalitySeverity(
                      registro.causa.nivelGravedad.toString(),
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            if (registro.causa.esContagiosa) ...[
              AppSpacing.gapMd,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: AppRadius.allSm,
                ),
                child: Text(
                  l.mortalityContagiousWarning,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(l.commonUnderstood),
          ),
        ],
      ),
    );
  }
}
