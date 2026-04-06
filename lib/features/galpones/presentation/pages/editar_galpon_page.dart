/// Página para editar un galpón existente
/// Implementa el mismo formulario multi-paso que CrearGalponPage
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../granjas/domain/value_objects/umbrales_ambientales.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../application/application.dart';
import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/enums/tipo_galpon.dart';
import '../../domain/usecases/actualizar_galpon.dart';
import '../widgets/widgets.dart';

/// Página para editar un galpón existente usando formulario multi-paso
class EditarGalponPage extends ConsumerStatefulWidget {
  const EditarGalponPage({
    super.key,
    required this.granjaId,
    required this.galponId,
  });

  final String granjaId;
  final String galponId;

  @override
  ConsumerState<EditarGalponPage> createState() => _EditarGalponPageState();
}

class _EditarGalponPageState extends ConsumerState<EditarGalponPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _autoValidate = false;

  // Controllers - Información Básica
  final _codigoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  TipoGalpon? _tipoGalpon;
  EstadoGalpon _estadoGalpon = EstadoGalpon.activo;

  // Controllers - Especificaciones
  final _capacidadAvesController = TextEditingController();
  final _areaM2Controller = TextEditingController();
  final _numeroBeberosController = TextEditingController();
  final _numeroComerosController = TextEditingController();
  final _numeroNidalesController = TextEditingController();

  // Controllers - Condiciones Ambientales
  final _temperaturaMinController = TextEditingController();
  final _temperaturaMaxController = TextEditingController();
  final _humedadMinController = TextEditingController();
  final _humedadMaxController = TextEditingController();
  final _ventilacionMinController = TextEditingController();
  final _ventilacionMaxController = TextEditingController();

  bool _isLoading = false;
  bool _inicializado = false;
  Galpon? _galponOriginal;
  TipoGalpon? _tipoGalponOriginal;

  // Definición de los pasos del formulario
  late final List<FormStepInfo> _steps;

  List<FormStepInfo> _buildSteps(BuildContext context) {
    final l = S.of(context);
    return [
      FormStepInfo(label: l.shedStepBasic),
      FormStepInfo(label: l.shedStepSpecifications),
      FormStepInfo(label: l.shedStepEnvironment),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _capacidadAvesController.dispose();
    _areaM2Controller.dispose();
    _numeroBeberosController.dispose();
    _numeroComerosController.dispose();
    _numeroNidalesController.dispose();
    _temperaturaMinController.dispose();
    _temperaturaMaxController.dispose();
    _humedadMinController.dispose();
    _humedadMaxController.dispose();
    _ventilacionMinController.dispose();
    _ventilacionMaxController.dispose();
    super.dispose();
  }

  void _cargarDatosGalpon(Galpon galpon) {
    if (_inicializado) return;

    _galponOriginal = galpon;

    // Información Básica
    _codigoController.text = galpon.codigo;
    _nombreController.text = galpon.nombre;
    _descripcionController.text = galpon.descripcion ?? '';
    _tipoGalpon = galpon.tipo;
    _tipoGalponOriginal = galpon.tipo;
    _estadoGalpon = galpon.estado;

    // Especificaciones
    _capacidadAvesController.text = galpon.capacidadMaxima.toString();
    _areaM2Controller.text = galpon.areaM2?.toString() ?? '';

    // Cargar datos de metadatos si existen
    final metadatos = galpon.metadatos;
    if (metadatos.isNotEmpty) {
      _numeroBeberosController.text =
          metadatos['numeroBebederos']?.toString() ?? '';
      _numeroComerosController.text =
          metadatos['numeroComederos']?.toString() ?? '';
      _numeroNidalesController.text =
          metadatos['numeroNidales']?.toString() ?? '';
      _ventilacionMinController.text =
          metadatos['ventilacionMinima']?.toString() ?? '';
      _ventilacionMaxController.text =
          metadatos['ventilacionMaxima']?.toString() ?? '';
    }

    // Umbrales ambientales
    final umbrales = galpon.umbralesAmbientales;
    if (umbrales != null) {
      _temperaturaMinController.text = umbrales.temperaturaMinima.toString();
      _temperaturaMaxController.text = umbrales.temperaturaMaxima.toString();
      _humedadMinController.text = umbrales.humedadMinima.toString();
      _humedadMaxController.text = umbrales.humedadMaxima.toString();
    }

    _inicializado = true;
  }

  bool _tieneCambios() {
    if (_galponOriginal == null) return false;

    // Comparar información básica
    if (_codigoController.text.trim() != _galponOriginal!.codigo) {
      return true;
    }
    if (_nombreController.text.trim() != _galponOriginal!.nombre) {
      return true;
    }
    if (_descripcionController.text.trim() !=
        (_galponOriginal!.descripcion ?? '')) {
      return true;
    }
    if (_tipoGalpon != _tipoGalponOriginal) {
      return true;
    }

    // Comparar especificaciones
    if (_capacidadAvesController.text !=
        _galponOriginal!.capacidadMaxima.toString()) {
      return true;
    }
    if (_areaM2Controller.text != (_galponOriginal!.areaM2?.toString() ?? '')) {
      return true;
    }

    // Comparar metadatos
    final metadatosOriginales = _galponOriginal!.metadatos;
    if (_numeroBeberosController.text !=
        (metadatosOriginales['numeroBebederos']?.toString() ?? '')) {
      return true;
    }
    if (_numeroComerosController.text !=
        (metadatosOriginales['numeroComederos']?.toString() ?? '')) {
      return true;
    }
    if (_numeroNidalesController.text !=
        (metadatosOriginales['numeroNidales']?.toString() ?? '')) {
      return true;
    }
    if (_ventilacionMinController.text !=
        (metadatosOriginales['ventilacionMinima']?.toString() ?? '')) {
      return true;
    }
    if (_ventilacionMaxController.text !=
        (metadatosOriginales['ventilacionMaxima']?.toString() ?? '')) {
      return true;
    }

    // Comparar umbrales ambientales
    final umbralesOriginales = _galponOriginal!.umbralesAmbientales;
    if (_temperaturaMinController.text !=
        (umbralesOriginales?.temperaturaMinima.toString() ?? '')) {
      return true;
    }
    if (_temperaturaMaxController.text !=
        (umbralesOriginales?.temperaturaMaxima.toString() ?? '')) {
      return true;
    }
    if (_humedadMinController.text !=
        (umbralesOriginales?.humedadMinima.toString() ?? '')) {
      return true;
    }
    if (_humedadMaxController.text !=
        (umbralesOriginales?.humedadMaxima.toString() ?? '')) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final galponAsync = ref.watch(galponByIdProvider(widget.galponId));

    return galponAsync.when(
      data: (galpon) {
        if (galpon == null) {
          final theme = Theme.of(context);
          final l = S.of(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(l.shedNotFound),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.shedRequestedNotExist,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.pop(),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.allSm,
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(l.commonBack),
                  ),
                ],
              ),
            ),
          );
        }

        _cargarDatosGalpon(galpon);

        return _buildEditForm(galpon, context);
      },
      loading: () {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).commonLoading),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, _) {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).commonError),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          body: GalponErrorWidget(
            mensaje: error.toString(),
            onReintentar: () =>
                ref.invalidate(galponByIdProvider(widget.galponId)),
          ),
        );
      },
    );
  }

  Widget _buildEditForm(Galpon galpon, BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    _steps = _buildSteps(context);
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
              Text(galpon.nombre),
              if (_tieneCambios())
                Text(
                  l.commonUnsavedChanges,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: l.commonExit,
          ),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
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
                    // Paso 1: Información básica
                    BasicInfoStep(
                      codigoController: _codigoController,
                      nombreController: _nombreController,
                      descripcionController: _descripcionController,
                      tipoGalpon: _tipoGalpon,
                      estadoGalpon: _estadoGalpon,
                      onTipoGalponChanged: (v) =>
                          setState(() => _tipoGalpon = v),
                      onEstadoGalponChanged: (v) => setState(
                        () => _estadoGalpon = v ?? EstadoGalpon.activo,
                      ),
                      granjaId: widget.granjaId,
                      autoValidate: _autoValidate,
                      isEditing: true,
                    ),
                    // Paso 2: Especificaciones
                    SpecificationsStep(
                      capacidadAvesController: _capacidadAvesController,
                      areaM2Controller: _areaM2Controller,
                      numeroBeberosController: _numeroBeberosController,
                      numeroComerosController: _numeroComerosController,
                      numeroNidalesController: _numeroNidalesController,
                      autoValidate: _autoValidate,
                    ),
                    // Paso 3: Ambiente
                    EnvironmentalStep(
                      temperaturaMinController: _temperaturaMinController,
                      temperaturaMaxController: _temperaturaMaxController,
                      humedadMinController: _humedadMinController,
                      humedadMaxController: _humedadMaxController,
                      ventilacionMinController: _ventilacionMinController,
                      ventilacionMaxController: _ventilacionMaxController,
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.base,
      ),
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
            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),

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
                          _currentStep < _steps.length - 1
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
      HapticFeedback.lightImpact();
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

  void _previousStep() {
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
      if (_validateCurrentStep()) {
        HapticFeedback.lightImpact();
        FocusScope.of(context).unfocus();

        setState(() => _currentStep++);
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOutCubic,
        );
      } else {
        setState(() => _autoValidate = true);
      }
    } else {
      _submitForm();
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Información Básica
        if (_tipoGalpon == null) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedSelectType);
          return false;
        }
        break;
      case 1: // Especificaciones
        if (_capacidadAvesController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterBirdCapacity);
          return false;
        }
        final capacidad = int.tryParse(_capacidadAvesController.text.trim());
        if (capacidad == null || capacidad <= 0) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedCapacityMustBePositive);
          return false;
        }
        if (capacidad > 1000000) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedCapacityTooHigh);
          return false;
        }

        if (_areaM2Controller.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterArea);
          return false;
        }
        final area = double.tryParse(_areaM2Controller.text.trim());
        if (area == null || area <= 0) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedAreaMustBePositive);
          return false;
        }
        if (area > 100000) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedAreaTooLarge);
          return false;
        }
        break;
      case 2: // Condiciones Ambientales (todas opcionales)
        // Validar que si se ingresa min, también se ingrese max y viceversa
        if (_temperaturaMinController.text.trim().isNotEmpty &&
            _temperaturaMaxController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterMaxTemp);
          return false;
        }
        if (_temperaturaMaxController.text.trim().isNotEmpty &&
            _temperaturaMinController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterMinTemp);
          return false;
        }
        // Validar que min < max en temperatura
        if (_temperaturaMinController.text.trim().isNotEmpty &&
            _temperaturaMaxController.text.trim().isNotEmpty) {
          final tempMin = double.tryParse(
            _temperaturaMinController.text.trim(),
          );
          final tempMax = double.tryParse(
            _temperaturaMaxController.text.trim(),
          );
          if (tempMin != null && tempMax != null && tempMin >= tempMax) {
            setState(() => _autoValidate = true);
            _showError(S.of(context).shedTempMinLessThanMax);
            return false;
          }
        }
        // Validar humedad
        if (_humedadMinController.text.trim().isNotEmpty &&
            _humedadMaxController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterMaxHumidity);
          return false;
        }
        if (_humedadMaxController.text.trim().isNotEmpty &&
            _humedadMinController.text.trim().isEmpty) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).shedEnterMinHumidity);
          return false;
        }
        if (_humedadMinController.text.trim().isNotEmpty &&
            _humedadMaxController.text.trim().isNotEmpty) {
          final humMin = double.tryParse(_humedadMinController.text.trim());
          final humMax = double.tryParse(_humedadMaxController.text.trim());
          if (humMin != null && humMax != null && humMin >= humMax) {
            setState(() => _autoValidate = true);
            _showError(S.of(context).shedHumidityMinLessThanMax);
            return false;
          }
        }
        break;
    }
    return true;
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      setState(() => _autoValidate = true);
      return;
    }

    if (_galponOriginal == null) {
      _showError(S.of(context).shedErrorOriginalData);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Construir umbrales ambientales si se ingresaron
      UmbralesAmbientales? umbrales;
      if (_temperaturaMinController.text.trim().isNotEmpty &&
          _temperaturaMaxController.text.trim().isNotEmpty &&
          _humedadMinController.text.trim().isNotEmpty &&
          _humedadMaxController.text.trim().isNotEmpty) {
        umbrales = UmbralesAmbientales(
          temperaturaMinima: double.parse(
            _temperaturaMinController.text.trim(),
          ),
          temperaturaMaxima: double.parse(
            _temperaturaMaxController.text.trim(),
          ),
          humedadMinima: double.parse(_humedadMinController.text.trim()),
          humedadMaxima: double.parse(_humedadMaxController.text.trim()),
        );
      }

      // Construir metadatos
      final metadatos = <String, dynamic>{};
      if (_numeroBeberosController.text.trim().isNotEmpty) {
        metadatos['numeroBebederos'] = int.tryParse(
          _numeroBeberosController.text.trim(),
        );
      }
      if (_numeroComerosController.text.trim().isNotEmpty) {
        metadatos['numeroComederos'] = int.tryParse(
          _numeroComerosController.text.trim(),
        );
      }
      if (_numeroNidalesController.text.trim().isNotEmpty) {
        metadatos['numeroNidales'] = int.tryParse(
          _numeroNidalesController.text.trim(),
        );
      }
      if (_ventilacionMinController.text.trim().isNotEmpty) {
        metadatos['ventilacionMinima'] = double.tryParse(
          _ventilacionMinController.text.trim(),
        );
      }
      if (_ventilacionMaxController.text.trim().isNotEmpty) {
        metadatos['ventilacionMaxima'] = double.tryParse(
          _ventilacionMaxController.text.trim(),
        );
      }

      // Crear params para actualizar
      final params = ActualizarGalponParams(
        id: _galponOriginal!.id,
        codigo: _codigoController.text.trim(),
        nombre: _nombreController.text.trim().isEmpty
            ? _codigoController.text.trim()
            : _nombreController.text.trim(),
        tipo: _tipoGalpon!,
        capacidadMaxima: int.parse(_capacidadAvesController.text.trim()),
        areaM2: _areaM2Controller.text.trim().isEmpty
            ? null
            : double.tryParse(_areaM2Controller.text.trim()),
        descripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        umbralesAmbientales: umbrales,
        metadatos: metadatos.isNotEmpty ? metadatos : null,
      );

      // Ejecutar use case
      final actualizarGalponUseCase = ref.read(actualizarGalponUseCaseProvider);
      final result = await actualizarGalponUseCase(params);

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
        (galpon) {
          if (!mounted) return;

          HapticFeedback.mediumImpact();
          AppSnackBar.success(
            context,
            message: S.of(context).shedUpdatedSuccess(galpon.nombre),
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
      unawaited(HapticFeedback.heavyImpact());
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).commonUnexpectedError,
          detail: S.of(context).commonCheckConnection,
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
      title: S.of(context).commonExitWithoutSaving,
      message: S.of(context).commonYouHaveUnsavedChanges,
      type: AppDialogType.danger,
      confirmText: S.of(context).commonExit,
      cancelText: S.of(context).commonContinueEditing,
    );

    if (shouldExit == true && mounted) {
      context.pop();
    }
  }
}
