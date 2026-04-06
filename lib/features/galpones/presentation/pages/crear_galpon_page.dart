/// Página modularizada para crear un nuevo galpón avícola.
///
/// Implementa un formulario multi-paso con:
/// - Información básica (código, nombre, tipo, estado)
/// - Especificaciones (capacidad, área, equipamiento)
/// - Condiciones ambientales (temperatura, humedad, ventilación)
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../granjas/domain/value_objects/umbrales_ambientales.dart';
import '../../application/providers/galpon_providers.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/enums/tipo_galpon.dart';
import '../../domain/usecases/crear_galpon.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/form_steps/basic_info_step.dart';
import '../widgets/form_steps/environmental_step.dart';
import '../widgets/form_steps/specifications_step.dart';

/// Página modularizada para crear un nuevo galpón avícola.
class CrearGalponPage extends ConsumerStatefulWidget {
  final String granjaId;

  const CrearGalponPage({super.key, required this.granjaId});

  @override
  ConsumerState<CrearGalponPage> createState() => _CrearGalponPageState();
}

class _CrearGalponPageState extends ConsumerState<CrearGalponPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false, false];

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

  // Timer para autoguardado
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

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
  void initState() {
    super.initState();
    _generarCodigo();
    _startAutoSave();
    _loadDraft();
  }

  void _generarCodigo() {
    final ahora = DateTime.now();
    _codigoController.text =
        'GAL-${ahora.year}-${ahora.month.toString().padLeft(2, '0')}-${ahora.millisecondsSinceEpoch.toString().substring(8)}';
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
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
      'nombre': _nombreController.text,
      'descripcion': _descripcionController.text,
      'tipoGalpon': _tipoGalpon?.toJson(),
      'estadoGalpon': _estadoGalpon.toJson(),
      'capacidadAves': _capacidadAvesController.text,
      'areaM2': _areaM2Controller.text,
      'numeroBeberos': _numeroBeberosController.text,
      'numeroComeros': _numeroComerosController.text,
      'numeroNidales': _numeroNidalesController.text,
      'temperaturaMin': _temperaturaMinController.text,
      'temperaturaMax': _temperaturaMaxController.text,
      'humedadMin': _humedadMinController.text,
      'humedadMax': _humedadMaxController.text,
      'ventilacionMin': _ventilacionMinController.text,
      'ventilacionMax': _ventilacionMaxController.text,
      'step': _currentStep,
      'granjaId': widget.granjaId,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('galpon_draft_${widget.granjaId}', jsonEncode(draft));
    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('galpon_draft_${widget.granjaId}');
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;
    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove('galpon_draft_${widget.granjaId}');
      return;
    }

    // Preguntar al usuario si desea restaurar
    if (!mounted) return;
    final l = S.of(context);
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: l.shedDraftFound,
      message: l.shedDraftFoundMessage(_formatDate(timestamp)),
      type: AppDialogType.info,
      confirmText: l.commonRestoreBtn,
      cancelText: l.commonDiscardBtn,
    );

    if (!shouldRestore) {
      await prefs.remove('galpon_draft_${widget.granjaId}');
    }

    if (shouldRestore == true) {
      setState(() {
        _codigoController.text = draft['codigo'] ?? '';
        _nombreController.text = draft['nombre'] ?? '';
        _descripcionController.text = draft['descripcion'] ?? '';

        if (draft['tipoGalpon'] != null) {
          _tipoGalpon = TipoGalpon.tryFromJson(draft['tipoGalpon'] as String?);
        }

        if (draft['estadoGalpon'] != null) {
          _estadoGalpon =
              EstadoGalpon.tryFromJson(draft['estadoGalpon'] as String?) ??
              EstadoGalpon.activo;
        }

        _capacidadAvesController.text = draft['capacidadAves'] ?? '';
        _areaM2Controller.text = draft['areaM2'] ?? '';
        _numeroBeberosController.text = draft['numeroBeberos'] ?? '';
        _numeroComerosController.text = draft['numeroComeros'] ?? '';
        _numeroNidalesController.text = draft['numeroNidales'] ?? '';
        _temperaturaMinController.text = draft['temperaturaMin'] ?? '';
        _temperaturaMaxController.text = draft['temperaturaMax'] ?? '';
        _humedadMinController.text = draft['humedadMin'] ?? '';
        _humedadMaxController.text = draft['humedadMax'] ?? '';
        _ventilacionMinController.text = draft['ventilacionMin'] ?? '';
        _ventilacionMaxController.text = draft['ventilacionMax'] ?? '';

        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    final l = S.of(context);
    if (difference.inDays == 0) {
      return l.commonTodayAt(
        '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
      );
    } else if (difference.inDays == 1) {
      return l.commonYesterday;
    } else {
      return l.commonDaysAgo(difference.inDays);
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    final l = S.of(context);
    if (difference.inSeconds < 10) {
      return l.commonJustNow;
    } else if (difference.inSeconds < 60) {
      return l.commonSecondsAgo(difference.inSeconds);
    } else if (difference.inMinutes < 60) {
      return l.commonMinutesAgo(difference.inMinutes);
    } else {
      return l.commonHoursAgo(difference.inHours);
    }
  }

  bool _hasUnsavedChanges() {
    return _codigoController.text.isNotEmpty ||
        _nombreController.text.isNotEmpty ||
        _capacidadAvesController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
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
              Text(l.shedNewShed),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? l.commonSaving
                      : l.commonSavedAt(_formatSaveTime(_lastSaveTime!)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
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
                        theme.colorScheme.onPrimary.withValues(alpha: 0.8),
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
                      autoValidate: _autoValidatePerStep[0],
                    ),
                    // Paso 2: Especificaciones
                    SpecificationsStep(
                      capacidadAvesController: _capacidadAvesController,
                      areaM2Controller: _areaM2Controller,
                      numeroBeberosController: _numeroBeberosController,
                      numeroComerosController: _numeroComerosController,
                      numeroNidalesController: _numeroNidalesController,
                      autoValidate: _autoValidatePerStep[1],
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
                          _currentStep < _steps.length - 1
                              ? S.of(context).commonNext
                              : S.of(context).shedCreateShed,
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

        setState(() => _currentStep++);
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
      _submitForm();
    }
  }

  bool _validateCurrentStep() {
    // Activar validación automática solo para el step actual
    setState(() => _autoValidatePerStep[_currentStep] = true);

    // Dar feedback háptico al intentar avanzar
    HapticFeedback.lightImpact();

    switch (_currentStep) {
      case 0: // Información Básica
        if (_nombreController.text.trim().isEmpty) {
          return false;
        }
        if (_nombreController.text.trim().length < 3) {
          return false;
        }
        if (_tipoGalpon == null) {
          return false;
        }
        break;
      case 1: // Especificaciones
        if (_capacidadAvesController.text.trim().isEmpty) {
          return false;
        }
        final capacidad = int.tryParse(_capacidadAvesController.text.trim());
        if (capacidad == null || capacidad <= 0 || capacidad > 1000000) {
          return false;
        }

        if (_areaM2Controller.text.trim().isEmpty) {
          return false;
        }
        final area = double.tryParse(_areaM2Controller.text.trim());
        if (area == null || area <= 0 || area > 100000) {
          return false;
        }
        break;
      case 2: // Condiciones Ambientales (todas opcionales)
        // Validar que si se ingresa min, también se ingrese max y viceversa
        if (_temperaturaMinController.text.trim().isNotEmpty &&
            _temperaturaMaxController.text.trim().isEmpty) {
          return false;
        }
        if (_temperaturaMaxController.text.trim().isNotEmpty &&
            _temperaturaMinController.text.trim().isEmpty) {
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
            return false;
          }
        }
        // Validar humedad
        if (_humedadMinController.text.trim().isNotEmpty &&
            _humedadMaxController.text.trim().isEmpty) {
          return false;
        }
        if (_humedadMaxController.text.trim().isNotEmpty &&
            _humedadMinController.text.trim().isEmpty) {
          return false;
        }
        if (_humedadMinController.text.trim().isNotEmpty &&
            _humedadMaxController.text.trim().isNotEmpty) {
          final humMin = double.tryParse(_humedadMinController.text.trim());
          final humMax = double.tryParse(_humedadMaxController.text.trim());
          if (humMin != null && humMax != null && humMin >= humMax) {
            return false;
          }
        }
        break;
    }
    return true;
  }

  Future<void> _submitForm() async {
    // Cerrar teclado antes de enviar formulario
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) {
      setState(() => _autoValidatePerStep[_currentStep] = true);
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

      // Construir metadatos con información adicional (bebederos, comederos, nidales, ventilación)
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

      // Crear params
      final params = CrearGalponParams(
        granjaId: widget.granjaId,
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
      final crearGalponUseCase = ref.read(crearGalponUseCaseProvider);
      final result = await crearGalponUseCase(params);

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
          (galpon) async {
            // Limpiar el draft después de crear exitosamente
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('galpon_draft_${widget.granjaId}');

            if (!mounted) return;

            unawaited(HapticFeedback.mediumImpact());
            AppSnackBar.success(
              context,
              message: S.of(context).shedCreatedSuccess(galpon.nombre),
            );

            // Navegar de vuelta
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                context.pop();
              }
            });
          },
        ),
      );
    } on Exception {
      setState(() => _isLoading = false);
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
    // Verificar si hay cambios sin guardar
    if (!_hasUnsavedChanges()) {
      // Limpiar draft si existe
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('galpon_draft_${widget.granjaId}');
      if (mounted) context.pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: S.of(context).shedExitWithoutCompleting,
      message: S.of(context).shedDataIsSafe,
      type: AppDialogType.warning,
      confirmText: S.of(context).commonExit,
      cancelText: S.of(context).commonContinue,
    );

    if (shouldExit == true) {
      await _autoSave(); // Guardar antes de salir
      if (mounted) context.pop();
    }
  }
}
