import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../../core/storage/image_upload_service.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_produccion.dart';
import '../../application/providers/registro_providers.dart';
import '../../application/providers/lote_providers.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/produccion_form_steps/informacion_produccion_step.dart';
import '../widgets/produccion_form_steps/clasificacion_huevos_step.dart';
import '../widgets/produccion_form_steps/observaciones_fotos_step.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

class RegistrarProduccionPage extends ConsumerStatefulWidget {
  final Lote lote;

  const RegistrarProduccionPage({super.key, required this.lote});

  @override
  ConsumerState<RegistrarProduccionPage> createState() =>
      _RegistrarProduccionPageState();
}

class _RegistrarProduccionPageState
    extends ConsumerState<RegistrarProduccionPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _autoValidate = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;
  bool _isUploadingPhotos = false;
  bool _hasUnsavedChanges = false;
  Timer? _autoSaveTimer;

  late final List<FormStepInfo> _steps;

  // Controllers para Step 1
  final _huevosRecolectadosController = TextEditingController();
  final _huevosBuenosController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();

  // Controllers para Step 2
  final _huevosRotosController = TextEditingController();
  final _huevosSuciosController = TextEditingController();
  final _huevosPequenosController = TextEditingController();
  final _huevosMedianosController = TextEditingController();
  final _huevosGrandesController = TextEditingController();
  final _huevosExtraGrandesController = TextEditingController();
  final _pesoPromedioController = TextEditingController();

  // Controllers para Step 3
  final _observacionesController = TextEditingController();
  final List<XFile> _fotosSeleccionadas = [];

  // Cálculo automático del peso promedio basado en clasificación
  double get _pesoPromedioCalculado {
    final pequenos = int.tryParse(_huevosPequenosController.text) ?? 0;
    final medianos = int.tryParse(_huevosMedianosController.text) ?? 0;
    final grandes = int.tryParse(_huevosGrandesController.text) ?? 0;
    final extraGrandes = int.tryParse(_huevosExtraGrandesController.text) ?? 0;
    final total = pequenos + medianos + grandes + extraGrandes;

    if (total == 0) return 0;

    // Pesos promedio por categoría
    const pesoPequeno = 48.0;
    const pesoMediano = 58.0;
    const pesoGrande = 68.0;
    const pesoExtraGrande = 78.0;

    final pesoTotal =
        (pequenos * pesoPequeno) +
        (medianos * pesoMediano) +
        (grandes * pesoGrande) +
        (extraGrandes * pesoExtraGrande);

    return pesoTotal / total;
  }

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
      _steps = [
        FormStepInfo(label: S.of(context).batchInfoStep),
        FormStepInfo(label: S.of(context).batchClassificationStep),
        FormStepInfo(label: S.of(context).batchObservationsStep),
      ];
      _stepsInitialized = true;
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
    _huevosRecolectadosController.removeListener(_onFieldChanged);
    _huevosBuenosController.removeListener(_onFieldChanged);
    _huevosRotosController.removeListener(_onFieldChanged);
    _huevosSuciosController.removeListener(_onFieldChanged);
    _huevosPequenosController.removeListener(_onFieldChanged);
    _huevosMedianosController.removeListener(_onFieldChanged);
    _huevosGrandesController.removeListener(_onFieldChanged);
    _huevosExtraGrandesController.removeListener(_onFieldChanged);
    _observacionesController.removeListener(_onFieldChanged);
    _pageController.dispose();
    _huevosRecolectadosController.dispose();
    _huevosBuenosController.dispose();
    _huevosRotosController.dispose();
    _huevosSuciosController.dispose();
    _huevosPequenosController.dispose();
    _huevosMedianosController.dispose();
    _huevosGrandesController.dispose();
    _huevosExtraGrandesController.dispose();
    _pesoPromedioController.dispose();
    _observacionesController.dispose();
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
    _huevosRecolectadosController.addListener(_onFieldChanged);
    _huevosBuenosController.addListener(_onFieldChanged);
    _huevosRotosController.addListener(_onFieldChanged);
    _huevosSuciosController.addListener(_onFieldChanged);
    _huevosPequenosController.addListener(_onFieldChanged);
    _huevosMedianosController.addListener(_onFieldChanged);
    _huevosGrandesController.addListener(_onFieldChanged);
    _huevosExtraGrandesController.addListener(_onFieldChanged);
    _observacionesController.addListener(_onFieldChanged);
  }

  Future<void> _saveDraft() async {
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = jsonEncode({
        'huevosRecolectados': _huevosRecolectadosController.text,
        'huevosBuenos': _huevosBuenosController.text,
        'huevosRotos': _huevosRotosController.text,
        'huevosSucios': _huevosSuciosController.text,
        'huevosPequenos': _huevosPequenosController.text,
        'huevosMedianos': _huevosMedianosController.text,
        'huevosGrandes': _huevosGrandesController.text,
        'huevosExtraGrandes': _huevosExtraGrandesController.text,
        'observaciones': _observacionesController.text,
        'fecha': _fechaSeleccionada.toIso8601String(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      await prefs.setString('produccion_draft_${widget.lote.id}', draft);

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
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('produccion_draft_${widget.lote.id}');
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;

    // Verificar antigüedad del borrador (máximo 7 días)
    if (draft['timestamp'] != null) {
      final timestamp = DateTime.parse(draft['timestamp'] as String);
      if (DateTime.now().difference(timestamp).inDays > 7) {
        await prefs.remove('produccion_draft_${widget.lote.id}');
        return;
      }
    }

    if (!mounted) return;
    final l = S.of(context);
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: l.batchDraftFound,
      message: l.batchDraftFoundGeneric,
      type: AppDialogType.info,
      confirmText: l.batchDraftRestore,
      cancelText: l.batchDraftDiscard,
    );

    if (shouldRestore == true) {
      setState(() {
        _huevosRecolectadosController.text =
            (draft['huevosRecolectados'] as String?) ?? '';
        _huevosBuenosController.text = (draft['huevosBuenos'] as String?) ?? '';
        _huevosRotosController.text = (draft['huevosRotos'] as String?) ?? '';
        _huevosSuciosController.text = (draft['huevosSucios'] as String?) ?? '';
        _huevosPequenosController.text =
            (draft['huevosPequenos'] as String?) ?? '';
        _huevosMedianosController.text =
            (draft['huevosMedianos'] as String?) ?? '';
        _huevosGrandesController.text =
            (draft['huevosGrandes'] as String?) ?? '';
        _huevosExtraGrandesController.text =
            (draft['huevosExtraGrandes'] as String?) ?? '';
        _observacionesController.text =
            (draft['observaciones'] as String?) ?? '';
        _fechaSeleccionada = DateTime.parse(draft['fecha'] as String);
        _hasUnsavedChanges = false;
      });
    } else {
      await prefs.remove('produccion_draft_${widget.lote.id}');
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final l = S.of(context);
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

  // ==================== VALIDACIÓN ====================

  Future<bool> _validateCurrentStep() async {
    switch (_currentStep) {
      case 0: // Información de Producción
        if (_huevosRecolectadosController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final huevosRecolectados = int.tryParse(
          _huevosRecolectadosController.text,
        );
        if (huevosRecolectados == null || huevosRecolectados <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }

        if (_huevosBuenosController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final huevosBuenos = int.tryParse(_huevosBuenosController.text);
        if (huevosBuenos == null || huevosBuenos < 0) {
          setState(() => _autoValidate = true);
          return false;
        }

        if (huevosBuenos > huevosRecolectados) {
          setState(() => _autoValidate = true);
          _showError(
            S
                .of(context)
                .productionGoodEggsExceedCollected(
                  huevosBuenos.toString(),
                  huevosRecolectados.toString(),
                ),
          );
          return false;
        }

        final cantidadAves = widget.lote.avesDisponibles;

        if (cantidadAves <= 0) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).productionNoAvailableBirds);
          return false;
        }

        final porcentajePostura = (huevosRecolectados / cantidadAves) * 100;
        if (porcentajePostura > 100) {
          setState(() => _autoValidate = true);
          _showError(
            S
                .of(context)
                .productionHighLayingPercent(
                  porcentajePostura.toStringAsFixed(1),
                ),
          );
          return false;
        }

        // Confirmación para porcentaje de postura muy alto
        if (porcentajePostura > 95) {
          final continuar = await _showConfirmacionPosturaAlta(
            porcentajePostura,
          );
          if (continuar != true) return false;
        }
        break;

      case 1: // Clasificación de Huevos
        // Validar que la suma de clasificación no exceda huevos buenos
        final huevosBuenos = int.tryParse(_huevosBuenosController.text) ?? 0;
        final pequenos = int.tryParse(_huevosPequenosController.text) ?? 0;
        final medianos = int.tryParse(_huevosMedianosController.text) ?? 0;
        final grandes = int.tryParse(_huevosGrandesController.text) ?? 0;
        final extraGrandes =
            int.tryParse(_huevosExtraGrandesController.text) ?? 0;
        final totalClasificados = pequenos + medianos + grandes + extraGrandes;

        if (totalClasificados > huevosBuenos) {
          setState(() => _autoValidate = true);
          _showError(
            S
                .of(context)
                .productionClassifiedExceedGood(
                  totalClasificados.toString(),
                  huevosBuenos.toString(),
                ),
          );
          return false;
        }

        // Validar números negativos
        final rotos = int.tryParse(_huevosRotosController.text) ?? 0;
        final sucios = int.tryParse(_huevosSuciosController.text) ?? 0;
        if (rotos < 0 ||
            sucios < 0 ||
            pequenos < 0 ||
            medianos < 0 ||
            grandes < 0 ||
            extraGrandes < 0) {
          setState(() => _autoValidate = true);
          return false;
        }

        // Confirmación para porcentaje de rotura alto
        final huevosRecolectados =
            int.tryParse(_huevosRecolectadosController.text) ?? 0;
        if (huevosRecolectados > 0 && rotos > 0) {
          final porcentajeRotura = (rotos / huevosRecolectados) * 100;
          if (porcentajeRotura > 5) {
            final continuar = await _showConfirmacionRoturaAlta(
              porcentajeRotura,
              rotos,
            );
            if (continuar != true) return false;
          }
        }
        break;

      case 2: // Observaciones y Fotos - opcional, sin validación
        break;
    }
    return true;
  }

  Future<bool?> _showConfirmacionPosturaAlta(double porcentaje) {
    final l = S.of(context);
    return showAppConfirmDialog(
      context: context,
      title: l.batchHighLayingTitle,
      message: l.batchHighLayingMessage(porcentaje.toStringAsFixed(1)),
      type: AppDialogType.warning,
      confirmText: l.commonContinue,
      cancelText: l.commonReviewData,
    );
  }

  Future<bool?> _showConfirmacionRoturaAlta(double porcentaje, int rotos) {
    final l = S.of(context);
    return showAppConfirmDialog(
      context: context,
      title: l.batchHighBreakageTitle,
      message: l.batchHighBreakageMessage(porcentaje.toStringAsFixed(1), rotos),
      type: AppDialogType.warning,
      confirmText: l.commonContinue,
      cancelText: l.commonReviewData,
    );
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  void _nextStep() async {
    if (!await _validateCurrentStep()) {
      setState(() {
        _autoValidate = true;
      });
      return;
    }

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

  Future<void> _agregarFoto(ImageSource source) async {
    if (_fotosSeleccionadas.length >= 3) {
      _showError(S.of(context).batchMaxPhotosAllowed);
      return;
    }

    final picker = ImagePicker();
    final foto = await picker.pickImage(
      source: source,
      maxWidth: AppConstants.maxImageWidth.toDouble(),
      maxHeight: AppConstants.maxImageHeight.toDouble(),
      imageQuality: (AppConstants.imageQuality * 100).toInt(),
    );

    if (foto != null) {
      // Validar tamaño del archivo
      final file = File(foto.path);
      final bytes = await file.length();
      if (!mounted) return;
      if (bytes > AppConstants.maxImageSizeBytes) {
        _showError(S.of(context).batchPhotoExceeds5MB);
        return;
      }

      setState(() {
        _fotosSeleccionadas.add(foto);
        _hasUnsavedChanges = true;
      });
    }
  }

  void _eliminarFoto(int index) {
    setState(() {
      _fotosSeleccionadas.removeAt(index);
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _guardarRegistro() async {
    // Validación final del step actual
    if (!await _validateCurrentStep()) {
      setState(() {
        _autoValidate = true;
      });
      return;
    }
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
        _showError(S.of(context).batchNoPermissionProduction);
        return;
      }
    } on Exception catch (e) {
      _showError(S.of(context).batchErrorVerifyingPermissions(e.toString()));
      return;
    }

    // Validar fecha
    if (_fechaSeleccionada.isAfter(DateTime.now())) {
      _showError(S.of(context).productionFutureDate);
      return;
    }
    if (_fechaSeleccionada.isBefore(widget.lote.fechaIngreso)) {
      _showError(S.of(context).productionBeforeEntryDate);
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Subir fotos a Firebase Storage si hay
      List<String> fotosUrls = [];
      if (_fotosSeleccionadas.isNotEmpty) {
        setState(() => _isUploadingPhotos = true);
        fotosUrls = await _uploadPhotos();
        setState(() => _isUploadingPhotos = false);
      }

      // Parsear valores
      final huevosRecolectados =
          int.tryParse(_huevosRecolectadosController.text) ?? 0;
      final huevosBuenos = int.tryParse(_huevosBuenosController.text) ?? 0;
      final huevosRotos = int.tryParse(_huevosRotosController.text);
      final huevosSucios = int.tryParse(_huevosSuciosController.text);
      final huevosPequenos = int.tryParse(_huevosPequenosController.text);
      final huevosMedianos = int.tryParse(_huevosMedianosController.text);
      final huevosGrandes = int.tryParse(_huevosGrandesController.text);
      final huevosExtraGrandes = int.tryParse(
        _huevosExtraGrandesController.text,
      );

      // Usar el peso promedio calculado si hay clasificación, sino null
      final pesoPromedio = _pesoPromedioCalculado > 0
          ? _pesoPromedioCalculado
          : null;

      // Calcular edad en días desde fechaIngreso usando fecha seleccionada
      final edadDias =
          _fechaSeleccionada.difference(widget.lote.fechaIngreso).inDays +
          widget.lote.edadIngresoDias;

      // Crear entity
      final registro = RegistroProduccion(
        id: '', // El ID se genera en el repositorio
        loteId: widget.lote.id,
        granjaId: widget.lote.granjaId,
        galponId: widget.lote.galponId,
        fecha: _fechaSeleccionada,
        huevosRecolectados: huevosRecolectados,
        huevosBuenos: huevosBuenos,
        huevosRotos: huevosRotos,
        huevosSucios: huevosSucios,
        huevosDobleYema: 0, // No lo capturamos en este formulario
        huevosPequenos: huevosPequenos,
        huevosMedianos: huevosMedianos,
        huevosGrandes: huevosGrandes,
        huevosExtraGrandes: huevosExtraGrandes,
        pesoPromedioHuevoGramos: pesoPromedio,
        cantidadAvesActual: widget.lote.avesDisponibles,
        edadDias: edadDias,
        observaciones: _observacionesController.text.trim().isNotEmpty
            ? _observacionesController.text.trim()
            : null,
        fotosUrls: fotosUrls,
        usuarioRegistro: usuario.id,
        nombreUsuario: usuario.nombre!,
        createdAt: DateTime.now(),
      );

      // Validar entidad antes de guardar
      final validacionError = registro.validar();
      if (validacionError != null) {
        if (!mounted) return;
        setState(() {
          _isSaving = false;
          _isUploadingPhotos = false;
        });
        _showError(validacionError);
        return;
      }

      debugPrint('🥚 Guardando registro de producción...');
      debugPrint('Lote: ${widget.lote.id}');
      debugPrint('Fecha: ${registro.fecha}');
      debugPrint('Huevos recolectados: ${registro.huevosRecolectados}');
      debugPrint('Huevos buenos: ${registro.huevosBuenos}');

      // Crear registro usando datasource
      await ref.read(registroProduccionDatasourceProvider).crear(registro);

      debugPrint('✅ Registro de producción guardado exitosamente');

      // Actualizar acumulado de huevos en el lote
      final nuevoTotalHuevos =
          (widget.lote.huevosProducidos ?? 0) + registro.huevosRecolectados;
      final actualizaciones = <String, dynamic>{
        'huevosProducidos': nuevoTotalHuevos,
      };

      // Si es el primer registro de producción, marcar fechaPrimerHuevo
      if (widget.lote.fechaPrimerHuevo == null) {
        actualizaciones['fechaPrimerHuevo'] = registro.fecha;
        debugPrint('📅 Primer huevo registrado: ${registro.fecha}');
      }

      debugPrint(
        '🔄 Actualizando huevos producidos del lote: $nuevoTotalHuevos',
      );
      await ref
          .read(loteFirebaseDatasourceProvider)
          .actualizarCampos(widget.lote.id, actualizaciones);

      debugPrint('✅ Lote actualizado exitosamente');

      // Limpiar borrador al completar exitosamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('produccion_draft_${widget.lote.id}');

      if (!mounted) return;
      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
      });

      // Celebración con animación
      AppSnackBar.success(
        context,
        message: S.of(context).productionRegistered,
        detail: S
            .of(context)
            .productionRegisteredDetail(
              registro.huevosRecolectados.toString(),
              registro.huevosBuenos.toString(),
            ),
      );

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) Navigator.of(context).pop(true);
      }
    } on FirebaseException catch (e) {
      debugPrint(
        '❌ Error Firebase en registro producción: ${e.code} - ${e.message}',
      );
      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _isUploadingPhotos = false;
      });

      String mensaje = S.of(context).batchFirebaseDbError;
      String? detalle;

      if (e.code == 'permission-denied') {
        mensaje = S.of(context).batchFirebasePermissionDenied;
        detalle = S.of(context).batchFirebasePermissionDetail;
      } else if (e.code == 'unavailable') {
        mensaje = S.of(context).batchFirebaseUnavailable;
        detalle = S.of(context).batchFirebaseUnavailableDetail;
      } else if (e.code == 'unauthenticated') {
        mensaje = S.of(context).batchFirebaseSessionExpired;
        detalle = S.of(context).batchFirebaseSessionDetail;
      } else if (e.message != null) {
        mensaje = e.message!;
      }

      AppSnackBar.error(context, message: mensaje, detail: detalle);
    } on Exception catch (e) {
      debugPrint('❌ Error Exception en registro producción: $e');
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
      type: ImageUploadType.produccion,
      granjaId: widget.lote.granjaId,
      entityId: widget.lote.id,
      metadata: {'loteId': widget.lote.id},
      onProgress: (uploaded, total) {
        debugPrint('✅ Foto $uploaded/$total subida');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (_isSaving) {
          _showError(S.of(context).batchWaitForProcess);
          return;
        }

        if (_hasUnsavedChanges) {
          final navigator = Navigator.of(context);
          final shouldExit = await _showUnsavedChangesDialog();
          if (shouldExit == true) {
            if (!mounted) return;
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('produccion_draft_${widget.lote.id}');
            if (!mounted) return;
            navigator.pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).registerProductionTitle,
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
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _isSaving
                ? null
                : () async {
                    if (_hasUnsavedChanges) {
                      final navigator = Navigator.of(context);
                      final shouldExit = await _showUnsavedChangesDialog();
                      if (shouldExit == true) {
                        if (!mounted) return;
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove(
                          'produccion_draft_${widget.lote.id}',
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
            if (_isSaving || _isUploadingPhotos)
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
                    // Step 1: Información básica
                    InformacionProduccionStep(
                      huevosRecolectadosController:
                          _huevosRecolectadosController,
                      huevosBuenosController: _huevosBuenosController,
                      fechaSeleccionada: _fechaSeleccionada,
                      onSeleccionarFecha: () async {
                        final fecha = await showDatePicker(
                          context: context,
                          initialDate: _fechaSeleccionada,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (fecha != null) {
                          setState(() {
                            _fechaSeleccionada = fecha;
                          });
                        }
                      },
                      onHuevosBuenosChanged: () => setState(() {}),
                      cantidadAves:
                          widget.lote.cantidadActual ??
                          widget.lote.cantidadInicial,
                      autoValidate: _autoValidate,
                    ),

                    // Step 2: Clasificación
                    ClasificacionHuevosStep(
                      huevosRotosController: _huevosRotosController,
                      huevosSuciosController: _huevosSuciosController,
                      huevosPequenosController: _huevosPequenosController,
                      huevosMedianosController: _huevosMedianosController,
                      huevosGrandesController: _huevosGrandesController,
                      huevosExtraGrandesController:
                          _huevosExtraGrandesController,
                      pesoPromedioController: _pesoPromedioController,
                      huevosBuenos:
                          int.tryParse(_huevosBuenosController.text) ?? 0,
                      autoValidate: _autoValidate,
                      onClasificacionChanged: () => setState(() {}),
                    ),

                    // Step 3: Observaciones y fotos
                    ObservacionesFotosProduccionStep(
                      observacionesController: _observacionesController,
                      autoValidate: _autoValidate,
                      fotosSeleccionadas: _fotosSeleccionadas,
                      onAgregarFoto: _agregarFoto,
                      onEliminarFoto: _eliminarFoto,
                      huevosRecolectados: int.tryParse(
                        _huevosRecolectadosController.text,
                      ),
                      huevosBuenos: int.tryParse(_huevosBuenosController.text),
                      cantidadAves:
                          widget.lote.cantidadActual ??
                          widget.lote.cantidadInicial,
                      pesoPromedioCalculado: _pesoPromedioCalculado > 0
                          ? _pesoPromedioCalculado
                          : null,
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
    final isProcessing = _isSaving || _isUploadingPhotos;

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
            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),

            // Botón Siguiente o Registrar
            Expanded(
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: isProcessing
                      ? null
                      : (_currentStep < _steps.length - 1
                            ? _nextStep
                            : _guardarRegistro),
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
}
