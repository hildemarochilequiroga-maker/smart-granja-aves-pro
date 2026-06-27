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
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/save_success_overlay.dart';
import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../inventario/application/services/inventario_integracion_service.dart';
import '../../../inventario/presentation/utils/integracion_feedback.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../../lotes/domain/enums/estado_lote.dart';
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

  /// Tipo de gasto preseleccionado al abrir el formulario (atajo desde, p. ej.,
  /// los botones de "costos pendientes" del costo por ave).
  final TipoGasto? tipoInicial;

  const RegistrarCostoPage({
    super.key,
    this.granjaId,
    this.loteId,
    this.costoExistente,
    this.tipoInicial,
  });

  @override
  ConsumerState<RegistrarCostoPage> createState() => _RegistrarCostoPageState();
}

class _RegistrarCostoPageState extends ConsumerState<RegistrarCostoPage> {
  // Controladores del formulario
  final _formKey = GlobalKey<FormState>();
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();
  // Costo por ave (solo para tipo compra de aves; enlazado con el monto total).
  final _costoPorAveController = TextEditingController();
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
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false, false];

  // Granja seleccionada (si no se proporciona en el widget)
  String? _selectedGranjaId;

  // Lote seleccionado para gastos directos (alimento/medicamento).
  String? _selectedLoteId;

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
    _selectedLoteId = widget.loteId;

    if (widget.costoExistente != null) {
      _loadExistingCosto();
    } else {
      _checkForDraft();
      // Tipo preseleccionado (atajo desde costos pendientes): prevalece sobre
      // el draft para respetar la intención explícita del usuario.
      if (widget.tipoInicial != null) {
        _tipoGasto = widget.tipoInicial;
      }
    }

    // Configurar auto-guardado cada 30 segundos
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasUnsavedChanges && !_isSaving) {
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

  /// Cantidad de aves del lote seleccionado (cantidadInicial), o null si no hay
  /// lote o aún no cargó. Se usa para enlazar costo total ↔ costo por ave.
  int? get _cantidadAvesLote {
    final loteId = _selectedLoteId;
    if (loteId == null) return null;
    final lote = ref.watch(loteByIdProvider(loteId)).valueOrNull;
    return lote?.cantidadInicial;
  }

  /// El usuario editó el monto TOTAL → recalcula el costo por ave.
  void _onMontoTotalChanged() {
    final aves = _cantidadAvesLote;
    final total = double.tryParse(_montoController.text.replaceAll(',', '.'));
    if (aves != null && aves > 0 && total != null) {
      _costoPorAveController.text = (total / aves).toStringAsFixed(4);
    }
    setState(() => _hasUnsavedChanges = true);
  }

  /// El usuario editó el costo POR AVE → recalcula el monto total.
  void _onCostoPorAveChanged() {
    final aves = _cantidadAvesLote;
    final porAve =
        double.tryParse(_costoPorAveController.text.replaceAll(',', '.'));
    if (aves != null && aves > 0 && porAve != null) {
      _montoController.text = (porAve * aves).toStringAsFixed(2);
    }
    setState(() => _hasUnsavedChanges = true);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _debounceSaveTimer?.cancel();
    _conceptoController.dispose();
    _montoController.dispose();
    _costoPorAveController.dispose();
    _proveedorController.dispose();
    _facturaController.dispose();
    _observacionesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Timer? _debounceSaveTimer;

  void _onFormChanged() {
    _hasUnsavedChanges = true;
    _debounceSaveTimer?.cancel();
    _debounceSaveTimer = Timer(const Duration(seconds: 2), () {
      if (_hasUnsavedChanges && !_isSaving) {
        _saveDraft();
      }
    });
  }

  void _loadExistingCosto() {
    final costo = widget.costoExistente!;
    _selectedGranjaId = costo.granjaId;
    _selectedLoteId = costo.loteId;
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
      if (draft['loteId'] != null) {
        _selectedLoteId = draft['loteId'] as String?;
      }
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
    _isSaving = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final draft = {
        'granjaId': _selectedGranjaId,
        'loteId': _selectedLoteId,
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
      _hasUnsavedChanges = false;
    } on Exception catch (e) {
      debugPrint('Error al guardar borrador: $e');
    } finally {
      _isSaving = false;
    }
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
      unawaited(AppHaptics.selection());
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
    } else {
      unawaited(AppHaptics.error());
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
        // Para gastos directos (alimento/medicamento) el lote es obligatorio
        if ((_tipoGasto?.esDirecto ?? false) &&
            (_selectedLoteId == null || _selectedLoteId!.isEmpty)) {
          _showValidationError(S.of(context).costoSelectBatchRequired);
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

    final integracionService = ref.read(inventarioIntegracionServiceProvider);

    // Crear nuevo item de inventario a partir del costo
    final tipoItem = costo.tipo == TipoGasto.alimento
        ? TipoItem.alimento
        : TipoItem.medicamento;

    final resultado = await integracionService.registrarEntradaDesdeCosto(
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

    if (mounted) mostrarFeedbackIntegracion(context, resultado);
  }

  void _showValidationError(String message) {
    unawaited(AppHaptics.error());
    AppSnackBar.error(context, message: message);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Cancelar auto-guardado para evitar conflictos
    _autoSaveTimer?.cancel();

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
          loteId: _tipoGasto!.esDirecto ? _selectedLoteId : null,
          clearLoteId: !_tipoGasto!.esDirecto,
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
          await SaveSuccessOverlay.show(
            context,
            message: S.of(context).costoUpdatedSuccess,
          );
          if (mounted) context.pop(true);
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
          loteId: _tipoGasto!.esDirecto ? _selectedLoteId : null,
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

        final costoGuardado = await ref
            .read(costoCrudProvider.notifier)
            .registrarCosto(nuevoCosto);

        final costoCreateState = ref.read(costoCrudProvider);
        if (costoCreateState.errorMessage != null) {
          throw Exception(costoCreateState.errorMessage);
        }

        // Integración con inventario - registrar entrada si aplica (usar costo con ID real)
        await _registrarEntradaInventario(
          costoGuardado ?? nuevoCosto,
          usuario.id,
        );

        // Limpiar borrador después de guardar exitosamente
        await _clearDraft();

        if (mounted) {
          await SaveSuccessOverlay.show(
            context,
            message: S.of(context).costoRegisteredSuccess,
          );
          if (mounted) context.pop(true);
        }
      }
    } on Exception catch (e) {
      unawaited(AppHaptics.error());
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
          toolbarHeight: 64,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
          ),
          title: FormTextScale(
            factor: 1.4,
            child: Text(
              isEditing
                  ? S.of(context).costsEditCost
                  : S.of(context).costRegisterCost,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: FormTextScale(
          child: Form(
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
                        esCompraAves: _tipoGasto?.esCompraAves ?? false,
                        cantidadAves: _cantidadAvesLote,
                        costoPorAveController: _costoPorAveController,
                        onMontoTotalChanged: _onMontoTotalChanged,
                        onCostoPorAveChanged: _onCostoPorAveChanged,
                        tipoGasto: _tipoGasto,
                      ),

                      // Paso 3: Detalles adicionales
                      DetallesStep(
                        proveedorController: _proveedorController,
                        numeroFacturaController: _facturaController,
                        observacionesController: _observacionesController,
                        autoValidate: _autoValidatePerStep[2],
                        loteSelector: (_tipoGasto?.esDirecto ?? false)
                            ? _buildLoteSelector()
                            : null,
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
          // Si el nuevo tipo no es directo, limpiar el lote asignado.
          if (!tipo.esDirecto) {
            _selectedLoteId = null;
          }
        });
      },
    );
  }

  /// Selector de lote para gastos directos (alimento/medicamento).
  ///
  /// Se muestra como un campo que abre un bottom sheet unificado.
  Widget _buildLoteSelector() {
    final theme = Theme.of(context);
    final l = S.of(context);

    if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
      return const SizedBox.shrink();
    }

    final lotesAsync = ref.watch(lotesStreamProvider(_selectedGranjaId!));
    final showError =
        _autoValidatePerStep[2] &&
        (_selectedLoteId == null || _selectedLoteId!.isEmpty);

    return lotesAsync.when(
      data: (lotes) {
        final lotesActivos = lotes
            .where((lote) => lote.estado == EstadoLote.activo)
            .toList();

        final loteSeleccionado = lotesActivos
            .where((lote) => lote.id == _selectedLoteId)
            .firstOrNull;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l.costoBatchLabel} *',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            InkWell(
              onTap: lotesActivos.isEmpty
                  ? null
                  : () => _mostrarSelectorLoteCosto(lotesActivos),
              borderRadius: AppRadius.allSm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.allSm,
                  border: Border.all(
                    color: showError
                        ? theme.colorScheme.error
                        : theme.colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: lotesActivos.isEmpty
                          ? Text(
                              S.of(context).salesNoActiveBatches,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            )
                          : loteSeleccionado == null
                          ? Text(
                              l.costoSelectBatchHint,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loteSeleccionado.nombre ??
                                      loteSeleccionado.codigo,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  l.historialBirdsUnit(
                                    loteSeleccionado.avesActuales,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (lotesActivos.isNotEmpty)
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ),
            ),
            if (showError) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                l.costoSelectBatchRequired,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.base),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  /// Muestra el bottom sheet unificado para seleccionar el lote del gasto.
  void _mostrarSelectorLoteCosto(List<Lote> lotes) {
    final l = S.of(context);
    showAppBottomSheet<void>(
      context: context,
      title: l.costoBatchLabel,
      isScrollControlled: true,
      scrollable: true,
      builder: (ctx) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        children: lotes.map((lote) {
          return AppSheetOptionTile(
            icon: Icons.inventory_2_outlined,
            label: lote.nombre ?? lote.codigo,
            subtitle: l.historialBirdsUnit(lote.avesActuales),
            selected: lote.id == _selectedLoteId,
            onTap: () {
              unawaited(AppHaptics.selection());
              setState(() {
                _selectedLoteId = lote.id;
                _hasUnsavedChanges = true;
              });
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
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
                child: AppButton.secondary(
                  label: S.of(context).commonPrevious,
                  onPressed: _isSubmitting ? null : _previousStep,
                  expanded: true,
                ),
              ),
            if (_currentStep > 0) AppSpacing.hGapMd,

            // Botón Siguiente o Registrar
            Expanded(
              child: AppButton.primary(
                label: isLastStep
                    ? (isEditing
                          ? S.of(context).commonUpdate
                          : S.of(context).commonRegister)
                    : S.of(context).commonNext,
                onPressed: _isSubmitting ? null : _nextStep,
                isLoading: _isSubmitting,
                expanded: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
