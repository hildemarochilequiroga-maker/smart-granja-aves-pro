/// Página para editar una granja existente
/// Implementa el mismo formulario multi-paso que CrearGranjaPage
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/application.dart';
import '../../domain/domain.dart';
import '../widgets/widgets.dart';

/// Página para editar una granja existente usando formulario multi-paso
class EditarGranjaPage extends ConsumerStatefulWidget {
  final String granjaId;

  const EditarGranjaPage({super.key, required this.granjaId});

  @override
  ConsumerState<EditarGranjaPage> createState() => _EditarGranjaPageState();
}

class _EditarGranjaPageState extends ConsumerState<EditarGranjaPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _autoValidate = false;

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
  bool _inicializado = false;
  Granja? _granjaOriginal;
  Timer? _autoSaveTimer;

  // Definición de los pasos del formulario
  List<FormStepInfo> _buildSteps(S l) => [
    FormStepInfo(label: l.formStepBasic),
    FormStepInfo(label: l.formStepLocation),
    FormStepInfo(label: l.formStepContact),
    FormStepInfo(label: l.formStepCapacity),
  ];

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

  void _cargarDatosGranja(Granja granja) {
    if (_inicializado) return;

    _granjaOriginal = granja;

    // Información Básica
    _nombreController.text = granja.nombre;
    _propietarioController.text = granja.propietarioNombre;
    _descripcionController.text = granja.notas ?? '';

    // Ubicación
    _direccionController.text = granja.direccion.calle;
    _ciudadController.text = granja.direccion.ciudad ?? '';
    _departamentoController.text = granja.direccion.departamento ?? '';
    _paisController.text = granja.direccion.pais; // Cargar país de la granja
    _referenciaController.text = granja.direccion.referencia ?? '';

    // Coordenadas
    if (granja.coordenadas != null) {
      _latitudController.text = granja.coordenadas!.latitud.toString();
      _longitudController.text = granja.coordenadas!.longitud.toString();
    }

    // Contacto
    _emailController.text = granja.correo ?? '';
    _telefonoController.text = granja.telefono ?? '';
    // WhatsApp podría ser el mismo teléfono o diferente
    _whatsappController.text = '';
    _rucController.text = granja.ruc ?? '';

    // Capacidad
    _capacidadTotalController.text =
        granja.capacidadTotalAves?.toString() ?? '';
    _areaTotalController.text = granja.areaTotalM2?.toString() ?? '';
    _numeroCasasController.text = granja.numeroTotalGalpones?.toString() ?? '';

    _inicializado = true;
  }

  bool _tieneCambios() {
    if (_granjaOriginal == null) return false;

    // Comparar cada campo con el original
    if (_nombreController.text.trim() != _granjaOriginal!.nombre) {
      return true;
    }
    if (_propietarioController.text.trim() !=
        _granjaOriginal!.propietarioNombre) {
      return true;
    }
    if (_descripcionController.text.trim() != (_granjaOriginal!.notas ?? '')) {
      return true;
    }

    if (_direccionController.text.trim() != _granjaOriginal!.direccion.calle) {
      return true;
    }
    if (_ciudadController.text.trim() !=
        (_granjaOriginal!.direccion.ciudad ?? '')) {
      return true;
    }
    if (_departamentoController.text.trim() !=
        (_granjaOriginal!.direccion.departamento ?? '')) {
      return true;
    }
    if (_referenciaController.text.trim() !=
        (_granjaOriginal!.direccion.referencia ?? '')) {
      return true;
    }

    if (_emailController.text.trim() != (_granjaOriginal!.correo ?? '')) {
      return true;
    }
    if (_telefonoController.text.trim() != (_granjaOriginal!.telefono ?? '')) {
      return true;
    }
    if (_rucController.text.trim() != (_granjaOriginal!.ruc ?? '')) {
      return true;
    }

    if (_capacidadTotalController.text !=
        (_granjaOriginal!.capacidadTotalAves?.toString() ?? '')) {
      return true;
    }
    if (_areaTotalController.text !=
        (_granjaOriginal!.areaTotalM2?.toString() ?? '')) {
      return true;
    }
    if (_numeroCasasController.text !=
        (_granjaOriginal!.numeroTotalGalpones?.toString() ?? '')) {
      return true;
    }

    // Coordenadas
    final latOriginal = _granjaOriginal!.coordenadas?.latitud.toString() ?? '';
    final lngOriginal = _granjaOriginal!.coordenadas?.longitud.toString() ?? '';
    if (_latitudController.text != latOriginal) {
      return true;
    }
    if (_longitudController.text != lngOriginal) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final granjaAsync = ref.watch(granjaByIdProvider(widget.granjaId));

    return granjaAsync.when(
      data: (granja) {
        if (granja == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l.farmNotFound),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  AppSpacing.gapBase,
                  Text(
                    l.farmFarmNotExists,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXl,
                  FilledButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(l.commonBack),
                  ),
                ],
              ),
            ),
          );
        }

        _cargarDatosGranja(granja);

        return _buildEditForm(granja);
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(l.commonLoading),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          title: Text(l.commonError),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        body: GranjaErrorWidget(
          mensaje: error.toString(),
          onReintentar: () =>
              ref.invalidate(granjaByIdProvider(widget.granjaId)),
        ),
      ),
    );
  }

  Widget _buildEditForm(Granja granja) {
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
              Text(granja.nombre),
              if (_tieneCambios())
                Text(
                  l.commonUnsavedChanges,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
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
                      autoValidate: _autoValidate,
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
                      autoValidate: _autoValidate,
                    ),
                    ContactInfoStep(
                      emailController: _emailController,
                      telefonoController: _telefonoController,
                      whatsappController: _whatsappController,
                      rucController: _rucController,
                      autoValidate: _autoValidate,
                      pais: _paisController.text,
                    ),
                    CapacityStep(
                      capacidadTotalController: _capacidadTotalController,
                      areaTotalController: _areaTotalController,
                      numeroCasasController: _numeroCasasController,
                      autoValidate: _autoValidate,
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
                          _currentStep < _buildSteps(S.of(context)).length - 1
                              ? S.of(context).commonNext
                              : S.of(context).commonSaveChanges,
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
      FocusScope.of(context).unfocus();
      setState(() {
        _currentStep = step;
        _autoValidate = false;
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
      _autoValidate = false;
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
      _autoValidate = false;
    });
    _pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Información Básica
        if (_nombreController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmNameRequired);
          return false;
        }
        if (_nombreController.text.trim().length < 3) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmNameMinLength);
          return false;
        }
        if (_propietarioController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmOwnerRequired);
          return false;
        }
        if (_propietarioController.text.trim().length < 3) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmNameMinLength);
          return false;
        }
        break;
      case 1: // Ubicación
        if (_paisController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmSelectCountry);
          return false;
        }
        if (_departamentoController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmSelectDepartment);
          return false;
        }
        if (_ciudadController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmSelectCity);
          return false;
        }
        if (_direccionController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmEnterAddress);
          return false;
        }
        if (_direccionController.text.trim().length < 10) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmAddressMinLength);
          return false;
        }
        break;
      case 2: // Contacto
        if (_emailController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmEnterEmail);
          return false;
        }
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        if (!emailRegex.hasMatch(_emailController.text.trim())) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmEnterValidEmail);
          return false;
        }
        if (_telefonoController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmEnterPhone);
          return false;
        }
        // Validar teléfono según país
        final pais = _paisController.text;
        final phoneLen = LocationData.getPhoneLength(pais);
        if (_telefonoController.text.trim().length != phoneLen) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).farmPhoneLength(phoneLen.toString()));
          return false;
        }
        if (!LocationData.isValidPhoneStart(
          pais,
          _telefonoController.text.trim(),
        )) {
          setState(() => _autoValidate = true);
          _showError(LocationData.getPhoneStartError(pais));
          return false;
        }
        break;
      case 3: // Capacidad - todos opcionales
        break;
    }
    return true;
  }

  void _showError(String message) {
    HapticFeedback.heavyImpact();
    AppSnackBar.error(
      context,
      message: message,
      duration: const Duration(milliseconds: 2500),
    );
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_granjaOriginal == null) {
      _showError(S.of(context).farmErrorOriginalData);
      return;
    }

    setState(() => _isLoading = true);

    try {
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

      // Crear params para actualizar
      final params = ActualizarGranjaParams(
        id: _granjaOriginal!.id,
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
        areaTotalM2: _areaTotalController.text.isNotEmpty
            ? double.tryParse(_areaTotalController.text)
            : null,
        capacidadTotalAves: _capacidadTotalController.text.isNotEmpty
            ? int.tryParse(_capacidadTotalController.text)
            : null,
        numeroTotalGalpones: _numeroCasasController.text.isNotEmpty
            ? int.tryParse(_numeroCasasController.text)
            : null,
        notas: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
      );

      // Ejecutar use case
      final actualizarGranjaUseCase = ref.read(actualizarGranjaUseCaseProvider);
      final result = await actualizarGranjaUseCase(params);

      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() => _isLoading = false);
          HapticFeedback.heavyImpact();
          AppSnackBar.error(
            context,
            message: failure.message,
            actionLabel: S.of(context).commonRetry,
            onAction: _submitForm,
          );
        },
        (granja) {
          if (!mounted) return;

          // Feedback háptico de éxito
          HapticFeedback.mediumImpact();

          AppSnackBar.success(
            context,
            message: S.of(context).farmUpdatedSuccess(granja.nombre),
          );

          // Navegar de vuelta
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              context.pop();
            }
          });
        },
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
    // Si no hay cambios, salir directamente
    if (!_tieneCambios()) {
      context.pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonExitWithoutSave,
      message: S.of(context).commonUnsavedChanges,
      type: AppDialogType.danger,
      confirmText: S.of(context).commonExit,
      cancelText: S.of(context).farmContinueEditing,
    );

    if (shouldExit == true && mounted) {
      context.pop();
    }
  }

  void _onLocationSelected(double lat, double lng) {
    setState(() {
      _latitudController.text = lat.toString();
      _longitudController.text = lng.toString();
    });
  }
}
