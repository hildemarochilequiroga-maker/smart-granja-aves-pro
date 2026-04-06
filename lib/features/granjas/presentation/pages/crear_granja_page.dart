/// Página para crear una nueva granja avícola
/// Implementa un formulario multi-paso con auto-save
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/application.dart';
import '../../domain/domain.dart';
import '../widgets/widgets.dart';

/// Página modularizada para crear una nueva granja avícola.
///
/// Implementa un formulario multi-paso con:
/// - Información básica
/// - Ubicación (con selección jerárquica País → Región → Ciudad)
/// - Contacto
/// - Capacidad
class CrearGranjaPage extends ConsumerStatefulWidget {
  const CrearGranjaPage({super.key});

  @override
  ConsumerState<CrearGranjaPage> createState() => _CrearGranjaPageState();
}

class _CrearGranjaPageState extends ConsumerState<CrearGranjaPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false, false, false];

  // Controllers - Información Básica
  final _nombreController = TextEditingController();
  final _propietarioController = TextEditingController();
  final _descripcionController = TextEditingController();

  // Controllers - Ubicación
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _departamentoController = TextEditingController();
  final _paisController = TextEditingController(text: 'Perú');
  final _referenciaController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  // Controllers - Contacto
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _rucController = TextEditingController();

  // Controllers - Capacidad
  final _capacidadTotalController = TextEditingController();
  final _areaTotalController = TextEditingController();
  final _numeroCasasController = TextEditingController();

  bool _isLoading = false;
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  // Definición de los pasos del formulario
  List<FormStepInfo> _buildSteps(S l) => [
    FormStepInfo(label: l.formStepBasic),
    FormStepInfo(label: l.formStepLocation),
    FormStepInfo(label: l.formStepContact),
    FormStepInfo(label: l.formStepCapacity),
  ];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _startAutoSave();

    // Pre-llenar propietario con el nombre del usuario actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuario = ref.read(currentUserProvider);
      if (usuario != null && _propietarioController.text.isEmpty) {
        _propietarioController.text = usuario.nombreCompleto;
      }
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pageController.dispose();
    _nombreController.dispose();
    _propietarioController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _departamentoController.dispose();
    _paisController.dispose();
    _referenciaController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _whatsappController.dispose();
    _rucController.dispose();
    _capacidadTotalController.dispose();
    _areaTotalController.dispose();
    _numeroCasasController.dispose();
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
      'nombre': _nombreController.text,
      'propietario': _propietarioController.text,
      'descripcion': _descripcionController.text,
      'direccion': _direccionController.text,
      'ciudad': _ciudadController.text,
      'departamento': _departamentoController.text,
      'pais': _paisController.text,
      'referencia': _referenciaController.text,
      'latitud': _latitudController.text,
      'longitud': _longitudController.text,
      'email': _emailController.text,
      'telefono': _telefonoController.text,
      'whatsapp': _whatsappController.text,
      'ruc': _rucController.text,
      'capacidad': _capacidadTotalController.text,
      'area': _areaTotalController.text,
      'galpones': _numeroCasasController.text,
      'step': _currentStep,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('granja_draft', jsonEncode(draft));
    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('granja_draft');
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;
    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove('granja_draft');
      return;
    }

    // Preguntar al usuario si desea restaurar
    if (!mounted) return;
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: S.of(context).farmDraftFound,
      message: S.of(context).farmDraftFoundMsg(_formatDate(timestamp)),
      type: AppDialogType.info,
      confirmText: S.of(context).commonRestoreBtn,
      cancelText: S.of(context).commonDiscardBtn,
    );

    if (!shouldRestore) {
      await prefs.remove('granja_draft');
    }

    if (shouldRestore == true && mounted) {
      setState(() {
        _nombreController.text = draft['nombre'] ?? '';
        _propietarioController.text = draft['propietario'] ?? '';
        _descripcionController.text = draft['descripcion'] ?? '';
        _direccionController.text = draft['direccion'] ?? '';
        _ciudadController.text = draft['ciudad'] ?? '';
        _departamentoController.text = draft['departamento'] ?? '';
        _paisController.text = draft['pais'] ?? 'Perú';
        _referenciaController.text = draft['referencia'] ?? '';
        _latitudController.text = draft['latitud'] ?? '';
        _longitudController.text = draft['longitud'] ?? '';
        _emailController.text = draft['email'] ?? '';
        _telefonoController.text = draft['telefono'] ?? '';
        _whatsappController.text = draft['whatsapp'] ?? '';
        _rucController.text = draft['ruc'] ?? '';
        _capacidadTotalController.text = draft['capacidad'] ?? '';
        _areaTotalController.text = draft['area'] ?? '';
        _numeroCasasController.text = draft['galpones'] ?? '';
        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
  }

  String _formatDate(DateTime date) {
    final l = S.of(context);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l.farmTodayAt(
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
      );
    } else if (difference.inDays == 1) {
      return l.farmYesterday;
    } else {
      return l.farmDaysAgo(difference.inDays.toString());
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final l = S.of(context);
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    if (difference.inSeconds < 10) {
      return l.commonSavedJustNow;
    } else if (difference.inSeconds < 60) {
      return l.commonSavedSecondsAgo(difference.inSeconds.toString());
    } else if (difference.inMinutes < 60) {
      return l.commonSavedMinutesAgo(difference.inMinutes.toString());
    } else {
      return l.commonSavedHoursAgo(difference.inHours.toString());
    }
  }

  bool _hasUnsavedChanges() {
    return _nombreController.text.isNotEmpty ||
        _propietarioController.text.isNotEmpty ||
        _descripcionController.text.isNotEmpty ||
        _direccionController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _telefonoController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
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
              Text(l.farmNewFarm),
              if (_lastSaveTime != null)
                Text(
                  _isSaving ? l.commonSaving : _formatSaveTime(_lastSaveTime!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: l.commonExit,
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
              steps: _buildSteps(l),
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
                    BasicInfoStep(
                      nombreController: _nombreController,
                      propietarioController: _propietarioController,
                      descripcionController: _descripcionController,
                      autoValidate: _autoValidatePerStep[0],
                    ),
                    LocationStep(
                      direccionController: _direccionController,
                      paisController: _paisController,
                      departamentoController: _departamentoController,
                      ciudadController: _ciudadController,
                      referenciaController: _referenciaController,
                      latitudController: _latitudController,
                      longitudController: _longitudController,
                      onLocationSelected: _onLocationSelected,
                      autoValidate: _autoValidatePerStep[1],
                    ),
                    ContactInfoStep(
                      emailController: _emailController,
                      telefonoController: _telefonoController,
                      whatsappController: _whatsappController,
                      rucController: _rucController,
                      autoValidate: _autoValidatePerStep[2],
                      pais: _paisController.text,
                    ),
                    CapacityStep(
                      capacidadTotalController: _capacidadTotalController,
                      areaTotalController: _areaTotalController,
                      numeroCasasController: _numeroCasasController,
                      autoValidate: _autoValidatePerStep[3],
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
                      l.commonPrevious,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) AppSpacing.hGapMd,

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
                          _currentStep < _buildSteps(l).length - 1
                              ? l.commonNext
                              : l.farmCreateFarm,
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
    if (_currentStep < 3) {
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
      case 0: // Información Básica
        if (_nombreController.text.trim().isEmpty ||
            _nombreController.text.trim().length < 3) {
          return false;
        }
        if (_propietarioController.text.trim().isEmpty ||
            _propietarioController.text.trim().length < 3) {
          return false;
        }
        break;
      case 1: // Ubicación
        if (_paisController.text.trim().isEmpty) {
          return false;
        }
        if (_departamentoController.text.trim().isEmpty) {
          return false;
        }
        if (_ciudadController.text.trim().isEmpty) {
          return false;
        }
        if (_direccionController.text.trim().isEmpty ||
            _direccionController.text.trim().length < 10) {
          return false;
        }
        break;
      case 2: // Contacto
        if (_emailController.text.trim().isEmpty) {
          return false;
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(_emailController.text.trim())) {
          return false;
        }
        if (_telefonoController.text.trim().isEmpty) {
          return false;
        }
        // Validar teléfono según país
        final pais = _paisController.text;
        final phoneLen = LocationData.getPhoneLength(pais);
        if (_telefonoController.text.trim().length != phoneLen) {
          return false;
        }
        if (!LocationData.isValidPhoneStart(
          pais,
          _telefonoController.text.trim(),
        )) {
          return false;
        }
        break;
      case 3: // Capacidad - todos opcionales
        break;
    }
    return true;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception(S.of(context).farmUserNotAuthenticated);
      }

      // Construir dirección
      final direccion = Direccion(
        calle: _direccionController.text.trim(),
        ciudad: _ciudadController.text.trim(),
        provincia: _ciudadController.text.trim(),
        departamento: _departamentoController.text.trim(),
        pais: _paisController.text.trim(),
        referencia: _referenciaController.text.trim().isEmpty
            ? null
            : _referenciaController.text.trim(),
      );

      // Construir Coordenadas si están disponibles
      Coordenadas? coordenadas;
      if (_latitudController.text.isNotEmpty &&
          _longitudController.text.isNotEmpty) {
        coordenadas = Coordenadas(
          latitud: double.parse(_latitudController.text),
          longitud: double.parse(_longitudController.text),
        );
      }

      // Crear params
      final params = CrearGranjaParams(
        usuarioId: currentUser.id,
        nombre: _nombreController.text.trim(),
        propietarioNombre: _propietarioController.text.trim(),
        direccion: direccion,
        coordenadas: coordenadas,
        telefono: _telefonoController.text.trim().isEmpty
            ? null
            : _telefonoController.text.trim(),
        correo: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        ruc: _rucController.text.trim().isEmpty
            ? null
            : _rucController.text.trim(),
        capacidadMaximaAves: _capacidadTotalController.text.isNotEmpty
            ? int.parse(_capacidadTotalController.text)
            : null,
        areaTotal: _areaTotalController.text.isNotEmpty
            ? double.parse(_areaTotalController.text)
            : null,
      );

      // Ejecutar use case
      final crearGranjaUseCase = ref.read(crearGranjaUseCaseProvider);
      final result = await crearGranjaUseCase(params);

      if (!mounted) return;

      unawaited(
        result.fold(
          (failure) async {
            setState(() => _isLoading = false);
            unawaited(HapticFeedback.heavyImpact());
            AppSnackBar.error(
              context,
              message: failure.message,
              actionLabel: S.of(context).commonRetry,
              onAction: _submitForm,
            );
          },
          (granja) async {
            // Feedback háptico de éxito
            unawaited(HapticFeedback.mediumImpact());

            // Limpiar el draft después de crear exitosamente
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('granja_draft');

            if (!mounted) return;

            AppSnackBar.success(
              context,
              message: S.of(context).farmCreatedSuccess(granja.nombre),
            );

            // Navegar a la lista de granjas
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.go(AppRoutes.granjas);
              }
            });
          },
        ),
      );
    } on Exception {
      setState(() => _isLoading = false);
      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.error(
          context,
          message: S.of(context).commonUnexpectedError,
          detail: S.of(context).commonVerifyConnection,
        );
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (!_hasUnsavedChanges()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('granja_draft');
      if (mounted) context.pop();
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
      if (mounted) context.pop();
    }
  }

  void _onLocationSelected(double lat, double lng) {
    setState(() {
      _latitudController.text = lat.toString();
      _longitudController.text = lng.toString();
    });
  }
}
