import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../inventario/application/services/inventario_integracion_service.dart';
import '../../../inventario/domain/entities/entities.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../inventario/domain/enums/enums.dart';
import '../../application/providers/costos_provider.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';
import '../widgets/widgets.dart';

/// Página para registrar un nuevo costo con estructura modular
/// Sigue el mismo patrón visual de CrearGranjaPage y CrearGalponPage
class RegistrarCostoPage extends ConsumerStatefulWidget {
  final String? granjaId;
  final String? loteId;
  final CostoGasto? costoExistente;

  const RegistrarCostoPage({
    super.key,
    this.granjaId,
    this.loteId,
    this.costoExistente,
  });

  @override
  ConsumerState<RegistrarCostoPage> createState() => _RegistrarCostoPageState();
}

class _RegistrarCostoPageState extends ConsumerState<RegistrarCostoPage> {
  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  final _proveedorController = TextEditingController();
  final _facturaController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _pageController = PageController();

  // Estado del formulario
  int _currentStep = 0;
  TipoGasto? _tipoGasto;
  DateTime _fechaGasto = DateTime.now();
  bool _isSubmitting = false;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false, false];

  // Granja seleccionada (si no se proporciona en el widget)
  String? _selectedGranjaId;

  // Item del inventario seleccionado (para vincular costo con inventario)
  ItemInventario? _itemInventarioSeleccionado;

  // Timer para auto-guardado
  Timer? _autoSaveTimer;
  static const _draftKey = 'costo_draft';

  // Definición de los pasos del formulario
  late final List<FormStepInfo> _steps;

  void _initSteps(BuildContext context) {
    final l = S.of(context);
    _steps = [
      FormStepInfo(label: l.costoStepType),
      FormStepInfo(label: l.costoStepAmount),
      FormStepInfo(label: l.costoStepDetails),
    ];
  }

  bool _stepsInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stepsInitialized) {
      _initSteps(context);
      _stepsInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();

    // Si se proporciona granjaId, usarlo
    _selectedGranjaId = widget.granjaId;

    if (widget.costoExistente != null) {
      _loadExistingCosto();
    } else {
      _checkForDraft();
    }

    // Configurar auto-guardado cada 30 segundos
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasUnsavedChanges) {
        _saveDraft();
      }
    });

    // Listeners para detectar cambios
    _conceptoController.addListener(_onFormChanged);
    _montoController.addListener(_onFormChanged);
    _proveedorController.addListener(_onFormChanged);
    _facturaController.addListener(_onFormChanged);
    _observacionesController.addListener(_onFormChanged);

    // Usar granja seleccionada globalmente si no se proporciona
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
        final granjaGlobal = ref.read(granjaSeleccionadaProvider);
        if (granjaGlobal != null) {
          setState(() {
            _selectedGranjaId = granjaGlobal.id;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _conceptoController.dispose();
    _montoController.dispose();
    _proveedorController.dispose();
    _facturaController.dispose();
    _observacionesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
  }

  /// Callback cuando se selecciona un item del inventario
  void _onItemInventarioChanged(ItemInventario? item) {
    setState(() {
      _itemInventarioSeleccionado = item;
      _hasUnsavedChanges = true;

      if (item != null) {
        // Autocompletar el concepto con el nombre del producto
        if (_conceptoController.text.isEmpty) {
          _conceptoController.text = S.of(context).purchaseOf(item.nombre);
        }

        // Autocompletar proveedor si el item tiene uno
        if (_proveedorController.text.isEmpty && item.proveedor != null) {
          _proveedorController.text = item.proveedor!;
        }
      }
    });
  }

  void _loadExistingCosto() {
    final costo = widget.costoExistente!;
    _selectedGranjaId = costo.granjaId;
    _tipoGasto = costo.tipo;
    _conceptoController.text = costo.concepto;
    _montoController.text = costo.monto.toStringAsFixed(2);
    _fechaGasto = costo.fecha;
    _proveedorController.text = costo.proveedor ?? '';
    _facturaController.text = costo.numeroFactura ?? '';
    _observacionesController.text = costo.observaciones ?? '';
  }

  Future<void> _checkForDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftJson = prefs.getString(_draftKey);

      if (draftJson != null && mounted) {
        final draft = jsonDecode(draftJson) as Map<String, dynamic>;

        // Verificar que el borrador sea para la misma granja (o si no hay granja seleccionada)
        if (_selectedGranjaId == null ||
            draft['granjaId'] == _selectedGranjaId) {
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
      message: S.of(context).commonDraftRestoreMessage,
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
      if (draft['tipoGasto'] != null) {
        _tipoGasto = TipoGasto.values.firstWhere(
          (t) => t.name == draft['tipoGasto'],
          orElse: () => TipoGasto.alimento,
        );
      }
      _conceptoController.text = draft['concepto'] ?? '';
      _montoController.text = draft['monto'] ?? '';
      _proveedorController.text = draft['proveedor'] ?? '';
      _facturaController.text = draft['factura'] ?? '';
      _observacionesController.text = draft['observaciones'] ?? '';
      if (draft['fecha'] != null) {
        _fechaGasto = DateTime.tryParse(draft['fecha']) ?? DateTime.now();
      }
    });
  }

  Future<void> _saveDraft() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'granjaId': _selectedGranjaId,
        'tipoGasto': _tipoGasto?.name,
        'concepto': _conceptoController.text,
        'monto': _montoController.text,
        'proveedor': _proveedorController.text,
        'factura': _facturaController.text,
        'observaciones': _observacionesController.text,
        'fecha': _fechaGasto.toIso8601String(),
        'savedAt': DateTime.now().toIso8601String(),
      };
      await prefs.setString(_draftKey, jsonEncode(draft));
      debugPrint('Borrador guardado automáticamente');
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

  void _goToStep(int step) {
    if (step >= 0 && step < _steps.length) {
      HapticFeedback.lightImpact();
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = step);
    }
  }

  void _nextStep() {
    if (_validateCurrentStep()) {
      if (_currentStep < _steps.length - 1) {
        _goToStep(_currentStep + 1);
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _goToStep(_currentStep - 1);
    }
  }

  bool _validateCurrentStep() {
    // Activar validación automática solo para el step actual
    setState(() => _autoValidatePerStep[_currentStep] = true);

    // Dar feedback háptico al intentar avanzar
    HapticFeedback.lightImpact();

    switch (_currentStep) {
      case 0:
        // Validar solo tipo de gasto (granja viene del home)
        if (_tipoGasto == null) {
          _showValidationError(S.of(context).pleaseSelectExpenseType);
          return false;
        }
        return true;

      case 1:
        // Validar concepto y monto - los errores se muestran inline
        if (_conceptoController.text.trim().isEmpty ||
            _conceptoController.text.trim().length < 5) {
          return false;
        }
        if (_montoController.text.trim().isEmpty) {
          return false;
        }
        final monto = double.tryParse(
          _montoController.text.replaceAll(',', '.'),
        );
        if (monto == null || monto <= 0) {
          return false;
        }
        return true;

      case 2:
        // Validar proveedor obligatorio
        if (_proveedorController.text.trim().isEmpty ||
            _proveedorController.text.trim().length < 3) {
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  /// Registra entrada en inventario si el costo es de tipo alimento o medicamento.
  Future<void> _registrarEntradaInventario(
    CostoGasto costo,
    String userId,
  ) async {
    // Solo registrar entrada para costos de alimento o medicamento
    if (costo.tipo != TipoGasto.alimento &&
        costo.tipo != TipoGasto.medicamento) {
      return;
    }

    try {
      final integracionService = ref.read(inventarioIntegracionServiceProvider);

      // Si hay un item seleccionado del inventario, registrar entrada a ese item
      if (_itemInventarioSeleccionado != null) {
        await integracionService.registrarEntradaDesdeCosto(
          granjaId: costo.granjaId,
          tipoItem: _itemInventarioSeleccionado!.tipo,
          nombreItem: _itemInventarioSeleccionado!.nombre,
          cantidad: 1, // Por defecto 1 unidad
          unidad: _itemInventarioSeleccionado!.unidad,
          costoTotal: costo.monto,
          proveedor: costo.proveedor,
          numeroDocumento: costo.numeroFactura,
          registradoPor: userId,
          costoId: costo.id,
          itemId: _itemInventarioSeleccionado!.id, // Vincular al item existente
        );
        debugPrint(
          '✅ Entrada registrada para item existente: ${_itemInventarioSeleccionado!.nombre}',
        );
        return;
      }

      // Si no hay item seleccionado, crear nuevo item como antes
      final tipoItem = costo.tipo == TipoGasto.alimento
          ? TipoItem.alimento
          : TipoItem.medicamento;

      await integracionService.registrarEntradaDesdeCosto(
        granjaId: costo.granjaId,
        tipoItem: tipoItem,
        nombreItem: costo.concepto,
        cantidad: 1,
        unidad: tipoItem == TipoItem.alimento
            ? UnidadMedida.kilogramo
            : UnidadMedida.unidad,
        costoTotal: costo.monto,
        proveedor: costo.proveedor,
        numeroDocumento: costo.numeroFactura,
        registradoPor: userId,
        costoId: costo.id,
      );

      debugPrint('✅ Entrada de inventario registrada desde costo');
    } on Exception catch (e) {
      // No interrumpir el flujo del costo si falla la integración
      debugPrint('Error al registrar entrada de inventario: $e');
      if (mounted) {
        AppSnackBar.warning(
          context,
          message: S.of(context).costRegisteredInventoryError,
        );
      }
    }
  }

  void _showValidationError(String message) {
    HapticFeedback.heavyImpact();
    AppSnackBar.error(context, message: message);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    unawaited(HapticFeedback.mediumImpact());

    final l = S.of(context);

    try {
      final monto =
          double.tryParse(_montoController.text.replaceAll(',', '.')) ?? 0;

      // Verificar permisos del usuario
      if (_selectedGranjaId != null && _selectedGranjaId!.isNotEmpty) {
        final rol = await ref.read(
          rolUsuarioActualEnGranjaProvider(_selectedGranjaId!).future,
        );

        if (widget.costoExistente != null) {
          if (rol == null || !rol.canEditRecords) {
            throw Exception(l.noPermissionEditCosts);
          }
        } else {
          if (rol == null || !rol.canCreateRecords) {
            throw Exception(l.noPermissionCreateCosts);
          }
        }
      }

      if (widget.costoExistente != null) {
        // Actualizar costo existente usando copyWith para preservar todos los campos
        final costoActualizado = widget.costoExistente!.copyWith(
          tipo: _tipoGasto!,
          concepto: _conceptoController.text.trim(),
          monto: monto,
          fecha: _fechaGasto,
          proveedor: _proveedorController.text.trim().isEmpty
              ? null
              : _proveedorController.text.trim(),
          numeroFactura: _facturaController.text.trim().isEmpty
              ? null
              : _facturaController.text.trim(),
          observaciones: _observacionesController.text.trim().isEmpty
              ? null
              : _observacionesController.text.trim(),
        );

        await ref
            .read(costoCrudProvider.notifier)
            .actualizarCosto(costoActualizado);

        final costoState = ref.read(costoCrudProvider);
        if (costoState.errorMessage != null) {
          throw Exception(costoState.errorMessage);
        }

        if (mounted) {
          AppSnackBar.success(
            context,
            message: S.of(context).costoUpdatedSuccess,
          );
          context.pop(true);
        }
      } else {
        // Crear nuevo costo
        final usuario = ref.read(currentUserProvider);
        if (usuario == null) {
          throw Exception(l.errorUserNotAuthenticated);
        }

        if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
          throw Exception(l.errorSelectFarm);
        }

        final nuevoCosto = CostoGasto.crear(
          id: '',
          granjaId: _selectedGranjaId!,
          tipo: _tipoGasto!,
          concepto: _conceptoController.text.trim(),
          monto: monto,
          fecha: _fechaGasto,
          registradoPor: usuario.id,
          loteId: widget.loteId,
          proveedor: _proveedorController.text.trim().isEmpty
              ? null
              : _proveedorController.text.trim(),
          numeroFactura: _facturaController.text.trim().isEmpty
              ? null
              : _facturaController.text.trim(),
          observaciones: _observacionesController.text.trim().isEmpty
              ? null
              : _observacionesController.text.trim(),
        );

        await ref.read(costoCrudProvider.notifier).registrarCosto(nuevoCosto);

        final costoCreateState = ref.read(costoCrudProvider);
        if (costoCreateState.errorMessage != null) {
          throw Exception(costoCreateState.errorMessage);
        }

        // Integración con inventario - registrar entrada si aplica
        await _registrarEntradaInventario(nuevoCosto, usuario.id);

        // Limpiar borrador después de guardar exitosamente
        await _clearDraft();

        if (mounted) {
          unawaited(HapticFeedback.heavyImpact());
          AppSnackBar.success(
            context,
            message: S.of(context).costoRegisteredSuccess,
          );
          context.pop(true);
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).commonError,
          detail: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (!_hasUnsavedChanges) {
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
      await _saveDraft();
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.costoExistente != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
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
                isEditing
                    ? S.of(context).costsEditCost
                    : S.of(context).costRegisterCost,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_lastSaveTime != null)
                Text(
                  _formatSaveTime(_lastSaveTime!, S.of(context)),
                  style: AppTextStyles.bodySmall.copyWith(
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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // Indicador de progreso
              FormProgressIndicator(
                steps: _steps,
                currentStep: _currentStep,
                onStepTapped: (step) {
                  if (step < _currentStep) {
                    _goToStep(step);
                  }
                },
              ),

              // Contenido del formulario
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _currentStep = index);
                  },
                  children: [
                    // Paso 1: Tipo y Concepto (con selector de granja si es necesario)
                    _buildStep1WithGranjaSelector(),

                    // Paso 2: Monto y Fecha
                    MontoStep(
                      conceptoController: _conceptoController,
                      montoController: _montoController,
                      fecha: _fechaGasto,
                      onFechaChanged: (fecha) {
                        setState(() {
                          _fechaGasto = fecha;
                          _hasUnsavedChanges = true;
                        });
                      },
                      autoValidate: _autoValidatePerStep[1],
                      tipoGasto: _tipoGasto,
                      granjaId: _selectedGranjaId,
                      itemInventarioSeleccionado: _itemInventarioSeleccionado,
                      onItemInventarioChanged: _onItemInventarioChanged,
                    ),

                    // Paso 3: Detalles adicionales
                    DetallesStep(
                      proveedorController: _proveedorController,
                      numeroFacturaController: _facturaController,
                      observacionesController: _observacionesController,
                      autoValidate: _autoValidatePerStep[2],
                    ),
                  ],
                ),
              ),

              // Botones de navegación
              _buildNavigationButtons(theme, isEditing),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el paso 1 con selector de granja si es necesario
  Widget _buildStep1WithGranjaSelector() {
    // Ya tenemos granja seleccionada desde home, mostrar solo el paso de tipo
    return TipoConceptoStep(
      tipoSeleccionado: _tipoGasto,
      onTipoChanged: (tipo) {
        setState(() {
          _tipoGasto = tipo;
          _hasUnsavedChanges = true;
        });
      },
    );
  }

  Widget _buildNavigationButtons(ThemeData theme, bool isEditing) {
    final colorScheme = theme.colorScheme;
    final isLastStep = _currentStep == _steps.length - 1;

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
                    onPressed: _isSubmitting ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isSubmitting
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

            // Botón Siguiente o Registrar
            Expanded(
              flex: _currentStep > 0 ? 1 : 1,
              child: SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _nextStep,
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
                  child: _isSubmitting
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
                          isLastStep
                              ? (isEditing
                                    ? S.of(context).commonUpdate
                                    : S.of(context).commonRegister)
                              : S.of(context).commonNext,
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
