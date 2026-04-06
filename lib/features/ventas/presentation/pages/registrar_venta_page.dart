/// Página para registrar una nueva venta de producto
///
/// Formulario multi-paso con:
/// - Paso 1: Selección de tipo de producto
/// - Paso 2: Datos del cliente
/// - Paso 3: Detalles del producto según tipo
/// - Paso 4: Información de entrega y pago
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../inventario/application/services/inventario_integracion_service.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../lotes/domain/enums/estado_lote.dart';
import '../../application/providers/ventas_provider.dart';
import '../../domain/entities/venta_producto.dart';
import '../../domain/enums/tipo_producto_venta.dart';
import '../../domain/enums/clasificacion_huevo.dart';
import '../../domain/enums/unidad_venta_pollinaza.dart';
import '../../domain/value_objects/cliente.dart';
import '../../domain/value_objects/direccion.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../../core/utils/formatters.dart';
import '../widgets/tipo_producto_step.dart';
import '../widgets/cliente_step.dart';

/// Página para registrar una nueva venta
class RegistrarVentaPage extends ConsumerStatefulWidget {
  final String? loteId;
  final String? granjaId;
  final VentaProducto? ventaExistente;

  const RegistrarVentaPage({
    super.key,
    this.loteId,
    this.granjaId,
    this.ventaExistente,
  });

  @override
  ConsumerState<RegistrarVentaPage> createState() => _RegistrarVentaPageState();
}

class _RegistrarVentaPageState extends ConsumerState<RegistrarVentaPage> {
  S get l => S.of(context);

  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Estado del formulario
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Auto-validación por paso (activa errores inline después del primer intento)
  final List<bool> _autoValidatePerStep = [false, false, false];

  // Granja y lote seleccionados (si no se proporcionan en el widget)
  String? _selectedGranjaId;
  String? _selectedLoteId;

  // Steps del formulario
  List<FormStepInfo> _buildSteps(S l) => [
    FormStepInfo(label: l.ventaStepProduct),
    FormStepInfo(label: l.ventaStepClient),
    FormStepInfo(label: l.ventaStepSummary),
  ];

  // Paso 1: Tipo de producto
  TipoProductoVenta? _tipoProducto;

  // Paso 2: Cliente
  Cliente? _cliente;

  // Paso 3: Detalles del producto
  // Aves
  final _cantidadAvesController = TextEditingController();
  final _pesoPromedioController = TextEditingController();
  final _precioKgController = TextEditingController();

  // Huevos
  final Map<ClasificacionHuevo, TextEditingController> _huevosControllers = {};
  final Map<ClasificacionHuevo, TextEditingController>
  _preciosHuevosControllers = {};

  // Pollinaza
  final _cantidadPollinazaController = TextEditingController();
  final _precioPollinazaController = TextEditingController();
  UnidadVentaPollinaza _unidadPollinaza = UnidadVentaPollinaza.bulto;

  // Detalles adicionales
  final _observacionesController = TextEditingController();
  DateTime _fechaVenta = DateTime.now();

  // Auto-guardado de borrador
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;
  DateTime? _lastSaveTime;
  static const String _draftKeyPrefix = 'venta_draft_';
  String get _draftKey =>
      '$_draftKeyPrefix${widget.ventaExistente?.id ?? 'new'}';

  @override
  void initState() {
    super.initState();

    // Inicializar granja y lote con los valores del widget si se proporcionan
    _selectedGranjaId = widget.granjaId;
    _selectedLoteId = widget.loteId;

    // Inicializar controladores de huevos
    for (final clasificacion in ClasificacionHuevo.values) {
      _huevosControllers[clasificacion] = TextEditingController(text: '0');
      _preciosHuevosControllers[clasificacion] = TextEditingController();
    }

    if (widget.ventaExistente != null) {
      _loadExistingVenta();
    } else {
      // Solo revisar borrador si es una nueva venta
      _checkForDraft();
    }

    // Agregar listeners para auto-guardado
    _setupAutoSaveListeners();

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

  void _setupAutoSaveListeners() {
    // Controllers de aves
    _cantidadAvesController.addListener(_onFormChanged);
    _pesoPromedioController.addListener(_onFormChanged);
    _precioKgController.addListener(_onFormChanged);

    // Controllers de pollinaza
    _cantidadPollinazaController.addListener(_onFormChanged);
    _precioPollinazaController.addListener(_onFormChanged);

    // Controller de observaciones
    _observacionesController.addListener(_onFormChanged);

    // Controllers de huevos
    for (final controller in _huevosControllers.values) {
      controller.addListener(_onFormChanged);
    }
    for (final controller in _preciosHuevosControllers.values) {
      controller.addListener(_onFormChanged);
    }
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 30), _saveDraft);
  }

  Future<void> _checkForDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString(_draftKey);
    if (draftJson != null && mounted) {
      unawaited(_showDraftRestoreDialog(draftJson));
    }
  }

  Future<void> _showDraftRestoreDialog(String draftJson) async {
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: S.of(context).commonDraftFound,
      message: S.of(context).ventaDraftFoundMessage,
      type: AppDialogType.info,
      confirmText: S.of(context).commonRestore,
      cancelText: S.of(context).commonDiscard,
    );

    if (shouldRestore) {
      unawaited(_restoreDraft(draftJson));
    } else {
      unawaited(_clearDraft());
    }
  }

  Future<void> _restoreDraft(String draftJson) async {
    try {
      final data = jsonDecode(draftJson) as Map<String, dynamic>;

      setState(() {
        // Restaurar tipo de producto
        if (data['tipoProducto'] != null) {
          _tipoProducto = TipoProductoVenta.values.firstWhere(
            (t) => t.name == data['tipoProducto'],
            orElse: () => TipoProductoVenta.avesVivas,
          );
        }

        // Restaurar datos de aves
        _cantidadAvesController.text = data['cantidadAves'] ?? '';
        _pesoPromedioController.text = data['pesoPromedio'] ?? '';
        _precioKgController.text = data['precioKg'] ?? '';

        // Restaurar datos de pollinaza
        _cantidadPollinazaController.text = data['cantidadPollinaza'] ?? '';
        _precioPollinazaController.text = data['precioPollinaza'] ?? '';
        if (data['unidadPollinaza'] != null) {
          _unidadPollinaza = UnidadVentaPollinaza.values.firstWhere(
            (u) => u.name == data['unidadPollinaza'],
            orElse: () => UnidadVentaPollinaza.bulto,
          );
        }

        // Restaurar datos de huevos
        if (data['huevos'] != null) {
          final huevosData = data['huevos'] as Map<String, dynamic>;
          for (final entry in huevosData.entries) {
            final clasificacion = ClasificacionHuevo.values.firstWhere(
              (c) => c.name == entry.key,
              orElse: () => ClasificacionHuevo.grande,
            );
            _huevosControllers[clasificacion]?.text = entry.value.toString();
          }
        }
        if (data['preciosHuevos'] != null) {
          final preciosData = data['preciosHuevos'] as Map<String, dynamic>;
          for (final entry in preciosData.entries) {
            final clasificacion = ClasificacionHuevo.values.firstWhere(
              (c) => c.name == entry.key,
              orElse: () => ClasificacionHuevo.grande,
            );
            _preciosHuevosControllers[clasificacion]?.text = entry.value
                .toString();
          }
        }

        // Restaurar datos de detalles
        _observacionesController.text = data['observaciones'] ?? '';

        if (data['fechaVenta'] != null) {
          _fechaVenta = DateTime.parse(data['fechaVenta']);
        }

        _currentStep = data['currentStep'] ?? 0;

        // Restaurar granja y lote
        if (data['selectedGranjaId'] != null) {
          _selectedGranjaId = data['selectedGranjaId'];
        }
        if (data['selectedLoteId'] != null) {
          _selectedLoteId = data['selectedLoteId'];
        }

        // Restaurar cliente
        if (data['cliente'] != null) {
          final clienteData = data['cliente'] as Map<String, dynamic>;
          _cliente = Cliente(
            nombre: clienteData['nombre'] ?? '',
            identificacion: clienteData['identificacion'] ?? '',
            contacto: clienteData['contacto'] ?? '',
            direccion: clienteData['direccion'] != null
                ? Direccion.fromJson(
                    clienteData['direccion'] as Map<String, dynamic>,
                  )
                : Direccion.empty(),
          );
        }
      });

      if (_currentStep > 0) {
        _pageController.jumpToPage(_currentStep);
      }

      AppSnackBar.success(context, message: S.of(context).salesDraftRestored);
    } on Exception catch (e) {
      debugPrint('Error restaurando borrador: $e');
      unawaited(_clearDraft());
    }
  }

  Future<void> _saveDraft() async {
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      // Construir mapa de huevos
      final huevosMap = <String, String>{};
      for (final entry in _huevosControllers.entries) {
        huevosMap[entry.key.name] = entry.value.text;
      }

      // Construir mapa de precios de huevos
      final preciosHuevosMap = <String, String>{};
      for (final entry in _preciosHuevosControllers.entries) {
        preciosHuevosMap[entry.key.name] = entry.value.text;
      }

      final data = {
        'tipoProducto': _tipoProducto?.name,
        'cantidadAves': _cantidadAvesController.text,
        'pesoPromedio': _pesoPromedioController.text,
        'precioKg': _precioKgController.text,
        'cantidadPollinaza': _cantidadPollinazaController.text,
        'precioPollinaza': _precioPollinazaController.text,
        'unidadPollinaza': _unidadPollinaza.name,
        'huevos': huevosMap,
        'preciosHuevos': preciosHuevosMap,
        'observaciones': _observacionesController.text,
        'fechaVenta': _fechaVenta.toIso8601String(),
        'currentStep': _currentStep,
        'selectedGranjaId': _selectedGranjaId,
        'selectedLoteId': _selectedLoteId,
        'cliente': _cliente != null
            ? {
                'nombre': _cliente!.nombre,
                'identificacion': _cliente!.identificacion,
                'contacto': _cliente!.contacto,
                'direccion': _cliente!.direccion.toJson(),
              }
            : null,
      };

      await prefs.setString(_draftKey, jsonEncode(data));
      if (mounted) {
        setState(() {
          _isSaving = false;
          _lastSaveTime = DateTime.now();
        });
      }
    } on Exception catch (e) {
      debugPrint('Error guardando borrador: $e');
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    if (difference.inSeconds < 10) {
      return S.of(context).commonJustNow;
    } else if (difference.inSeconds < 60) {
      return S.of(context).commonSecondsAgo(difference.inSeconds.toString());
    } else if (difference.inMinutes < 60) {
      return S.of(context).commonMinutesAgo(difference.inMinutes.toString());
    } else {
      return S.of(context).commonHoursAgo(difference.inHours.toString());
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
    _hasUnsavedChanges = false;
  }

  Future<void> _onBackPressed() async {
    if (!_hasUnsavedChanges) {
      await _clearDraft();
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
  void dispose() {
    _autoSaveTimer?.cancel();

    // Remover listeners antes de dispose
    _cantidadAvesController.removeListener(_onFormChanged);
    _pesoPromedioController.removeListener(_onFormChanged);
    _precioKgController.removeListener(_onFormChanged);
    _cantidadPollinazaController.removeListener(_onFormChanged);
    _precioPollinazaController.removeListener(_onFormChanged);
    _observacionesController.removeListener(_onFormChanged);

    for (final controller in _huevosControllers.values) {
      controller.removeListener(_onFormChanged);
    }
    for (final controller in _preciosHuevosControllers.values) {
      controller.removeListener(_onFormChanged);
    }

    // Dispose controllers
    _pageController.dispose();
    _cantidadAvesController.dispose();
    _pesoPromedioController.dispose();
    _precioKgController.dispose();
    _cantidadPollinazaController.dispose();
    _precioPollinazaController.dispose();
    _observacionesController.dispose();

    for (final controller in _huevosControllers.values) {
      controller.dispose();
    }
    for (final controller in _preciosHuevosControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _loadExistingVenta() {
    final venta = widget.ventaExistente!;
    _tipoProducto = venta.tipoProducto;
    _cliente = venta.cliente;
    _selectedGranjaId = venta.granjaId;
    _selectedLoteId = venta.loteId;

    if (venta.cantidadAves != null) {
      _cantidadAvesController.text = venta.cantidadAves.toString();
    }
    // Para edición, convertimos peso promedio a peso total
    if (venta.pesoPromedioKg != null && venta.cantidadAves != null) {
      final pesoTotal = venta.pesoPromedioKg! * venta.cantidadAves!;
      _pesoPromedioController.text = pesoTotal.toStringAsFixed(2);
    } else if (venta.pesoFaenado != null) {
      // Para aves faenadas, usamos peso faenado directamente
      _pesoPromedioController.text = venta.pesoFaenado!.toStringAsFixed(2);
    }
    if (venta.precioKg != null) {
      _precioKgController.text = venta.precioKg!.toStringAsFixed(2);
    }

    if (venta.huevosPorClasificacion != null) {
      venta.huevosPorClasificacion!.forEach((clasificacion, cantidad) {
        _huevosControllers[clasificacion]?.text = cantidad.toString();
      });
    }
    if (venta.preciosPorDocena != null) {
      venta.preciosPorDocena!.forEach((clasificacion, precio) {
        _preciosHuevosControllers[clasificacion]?.text = precio.toStringAsFixed(
          2,
        );
      });
    }

    if (venta.cantidadPollinaza != null) {
      _cantidadPollinazaController.text = venta.cantidadPollinaza.toString();
    }
    if (venta.unidadPollinaza != null) {
      _unidadPollinaza = venta.unidadPollinaza!;
    }
    if (venta.precioUnitarioPollinaza != null) {
      _precioPollinazaController.text = venta.precioUnitarioPollinaza!
          .toStringAsFixed(2);
    }

    _observacionesController.text = venta.observaciones ?? '';
  }

  void _goToStep(int step) {
    if (step >= 0 && step < _buildSteps(S.of(context)).length) {
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
      if (_currentStep < _buildSteps(S.of(context)).length - 1) {
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
      case 0: // Tipo de producto
        if (_tipoProducto == null) {
          return false;
        }
        return true;

      case 1: // Cliente
        if (_cliente == null) {
          return false;
        }
        return true;

      case 2: // Detalles del producto
        // Forzar validación del formulario para mostrar errores inline
        _formKey.currentState?.validate();
        return _validateProductDetails();

      default:
        return true;
    }
  }

  bool _validateProductDetails() {
    // Validar que haya granja y lote seleccionados
    if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
      return false;
    }
    if (_selectedLoteId == null || _selectedLoteId!.isEmpty) {
      return false;
    }

    switch (_tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
        final cantidadAves = int.tryParse(_cantidadAvesController.text) ?? 0;
        if (cantidadAves <= 0) return false;
        final pesoTotal = double.tryParse(_pesoPromedioController.text) ?? 0;
        if (pesoTotal <= 0) return false;
        final precioKg = double.tryParse(_precioKgController.text) ?? 0;
        if (precioKg <= 0) return false;
        return true;

      case TipoProductoVenta.avesFaenadas:
        final cantidadAves = int.tryParse(_cantidadAvesController.text) ?? 0;
        if (cantidadAves <= 0) return false;
        final pesoFaenado = double.tryParse(_pesoPromedioController.text) ?? 0;
        if (pesoFaenado <= 0) return false;
        final precioKg = double.tryParse(_precioKgController.text) ?? 0;
        if (precioKg <= 0) return false;
        return true;

      case TipoProductoVenta.huevos:
        final totalHuevos = _huevosControllers.values.fold<int>(
          0,
          (sum, c) => sum + (int.tryParse(c.text) ?? 0),
        );
        if (totalHuevos == 0) return false;
        // Verificar que cada clasificación con huevos tenga precio
        for (final clasificacion in ClasificacionHuevo.values) {
          final cantidad =
              int.tryParse(_huevosControllers[clasificacion]?.text ?? '0') ?? 0;
          if (cantidad > 0) {
            final precio =
                double.tryParse(
                  _preciosHuevosControllers[clasificacion]?.text ?? '0',
                ) ??
                0;
            if (precio <= 0) return false;
          }
        }
        return true;

      case TipoProductoVenta.pollinaza:
        final cantidad =
            double.tryParse(_cantidadPollinazaController.text) ?? 0;
        if (cantidad <= 0) return false;
        final precio = double.tryParse(_precioPollinazaController.text) ?? 0;
        if (precio <= 0) return false;
        return true;

      default:
        return true;
    }
  }

  /// Registra la salida de inventario correspondiente a la venta.
  Future<void> _registrarSalidaInventario(
    VentaProducto venta,
    String userId,
  ) async {
    try {
      final integracionService = ref.read(inventarioIntegracionServiceProvider);

      switch (venta.tipoProducto) {
        case TipoProductoVenta.huevos:
          // Para huevos, registrar salida por cada clasificación vendida
          final huevosVendidos = venta.huevosPorClasificacion;
          if (huevosVendidos != null) {
            for (final entry in huevosVendidos.entries) {
              await integracionService.registrarSalidaDesdeVenta(
                granjaId: venta.granjaId,
                nombreItem: S
                    .of(context)
                    .salesHuevosName(entry.key.displayName),
                cantidad: entry.value.toDouble(),
                loteId: venta.loteId,
                registradoPor: userId,
                ventaId: venta.id,
                tipoProducto: 'huevos',
              );
            }
          }
          break;

        case TipoProductoVenta.pollinaza:
          await integracionService.registrarSalidaDesdeVenta(
            granjaId: venta.granjaId,
            nombreItem: S.of(context).pollinazaItemName,
            cantidad: venta.cantidadPollinaza ?? 0,
            loteId: venta.loteId,
            registradoPor: userId,
            ventaId: venta.id,
            tipoProducto: 'pollinaza',
          );
          break;

        case TipoProductoVenta.avesVivas:
        case TipoProductoVenta.avesFaenadas:
        case TipoProductoVenta.avesDescarte:
          // Las aves no se descuentan del inventario de items,
          // se descuentan del conteo del lote (ya manejado en otro lugar)
          break;
      }
    } on Exception catch (e) {
      // No interrumpir el flujo de la venta si falla la integración
      debugPrint('Error al registrar salida de inventario: $e');
      if (mounted) {
        AppSnackBar.warning(
          context,
          message: S.of(context).salesInventoryUpdateError,
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    unawaited(HapticFeedback.mediumImpact());

    try {
      final usuario = ref.read(currentUserProvider);
      if (usuario == null) {
        throw Exception(S.of(context).errorUserNotAuthenticated);
      }

      if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
        throw Exception(S.of(context).commonFarmNotSpecified);
      }

      if (_selectedLoteId == null || _selectedLoteId!.isEmpty) {
        throw Exception(S.of(context).commonBatchNotSpecified);
      }

      // Verificar permisos del usuario
      final rol = await ref.read(
        rolUsuarioActualEnGranjaProvider(_selectedGranjaId!).future,
      );

      if (!mounted) return;

      if (widget.ventaExistente != null) {
        // Para editar se requiere canEditRecords
        if (rol == null || !rol.canEditRecords) {
          throw Exception(S.of(context).salesNoEditPermission);
        }
      } else {
        // Para crear se requiere canCreateRecords
        if (rol == null || !rol.canCreateRecords) {
          throw Exception(S.of(context).salesNoCreatePermission);
        }
      }

      final venta = _buildVentaProducto(usuario.id);

      if (widget.ventaExistente != null) {
        await ref
            .read(ventaProductoCrudProvider.notifier)
            .actualizarVenta(venta);
      } else {
        await ref
            .read(ventaProductoCrudProvider.notifier)
            .registrarVenta(venta);

        // Verificar si la operación falló
        final ventaState = ref.read(ventaProductoCrudProvider);
        if (ventaState.errorMessage != null) {
          throw Exception(ventaState.errorMessage);
        }

        // Integración con inventario - registrar salida por venta
        await _registrarSalidaInventario(venta, usuario.id);
      }

      // Verificar si la operación de actualización falló
      final ventaFinalState = ref.read(ventaProductoCrudProvider);
      if (ventaFinalState.errorMessage != null) {
        throw Exception(ventaFinalState.errorMessage);
      }

      // Limpiar borrador después de guardar exitosamente
      await _clearDraft();

      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.success(
          context,
          message: widget.ventaExistente != null
              ? S.of(context).salesUpdatedSuccess
              : S.of(context).salesRegisteredSuccess,
        );
        context.pop(true);
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

  VentaProducto _buildVentaProducto(String userId) {
    final observaciones = _observacionesController.text.trim().isEmpty
        ? null
        : _observacionesController.text.trim();

    // Calcular peso promedio: peso total / cantidad de aves
    final cantidadAves = int.tryParse(_cantidadAvesController.text) ?? 0;
    final pesoTotal = double.tryParse(_pesoPromedioController.text) ?? 0;
    final pesoPromedio = cantidadAves > 0 ? pesoTotal / cantidadAves : 0.0;

    switch (_tipoProducto!) {
      case TipoProductoVenta.avesVivas:
        return VentaProducto.avesVivas(
          id: widget.ventaExistente?.id ?? '',
          loteId: _selectedLoteId!,
          granjaId: _selectedGranjaId!,
          cliente: _cliente!,
          cantidadAves: cantidadAves,
          pesoPromedioKg: pesoPromedio,
          precioKg: double.tryParse(_precioKgController.text) ?? 0,
          registradoPor: userId,
          observaciones: observaciones,
          fechaEntrega: _fechaVenta,
        );

      case TipoProductoVenta.huevos:
        final huevosPorClasificacion = <ClasificacionHuevo, int>{};
        final preciosPorDocena = <ClasificacionHuevo, double>{};

        for (final clasificacion in ClasificacionHuevo.values) {
          final cantidad =
              int.tryParse(_huevosControllers[clasificacion]?.text ?? '0') ?? 0;
          final precio =
              double.tryParse(
                _preciosHuevosControllers[clasificacion]?.text ?? '0',
              ) ??
              0;
          if (cantidad > 0) {
            huevosPorClasificacion[clasificacion] = cantidad;
            preciosPorDocena[clasificacion] = precio;
          }
        }

        return VentaProducto.huevos(
          id: widget.ventaExistente?.id ?? '',
          loteId: _selectedLoteId!,
          granjaId: _selectedGranjaId!,
          cliente: _cliente!,
          huevosPorClasificacion: huevosPorClasificacion,
          preciosPorDocena: preciosPorDocena,
          registradoPor: userId,
          observaciones: observaciones,
          fechaEntrega: _fechaVenta,
        );

      case TipoProductoVenta.pollinaza:
        return VentaProducto.pollinaza(
          id: widget.ventaExistente?.id ?? '',
          loteId: _selectedLoteId!,
          granjaId: _selectedGranjaId!,
          cliente: _cliente!,
          cantidadPollinaza:
              double.tryParse(_cantidadPollinazaController.text) ?? 0,
          unidadPollinaza: _unidadPollinaza,
          precioUnitarioPollinaza:
              double.tryParse(_precioPollinazaController.text) ?? 0,
          registradoPor: userId,
          observaciones: observaciones,
          fechaEntrega: _fechaVenta,
        );

      case TipoProductoVenta.avesFaenadas:
        return VentaProducto.avesFaenadas(
          id: widget.ventaExistente?.id ?? '',
          loteId: _selectedLoteId!,
          granjaId: _selectedGranjaId!,
          cliente: _cliente!,
          cantidadAves: cantidadAves,
          pesoFaenado: pesoTotal,
          precioKg: double.tryParse(_precioKgController.text) ?? 0,
          registradoPor: userId,
          observaciones: observaciones,
          fechaEntrega: _fechaVenta,
        );

      case TipoProductoVenta.avesDescarte:
        return VentaProducto.avesDescarte(
          id: widget.ventaExistente?.id ?? '',
          loteId: _selectedLoteId!,
          granjaId: _selectedGranjaId!,
          cliente: _cliente!,
          cantidadAves: cantidadAves,
          pesoPromedioKg: pesoPromedio,
          precioKg: double.tryParse(_precioKgController.text) ?? 0,
          registradoPor: userId,
          observaciones: observaciones,
          fechaEntrega: _fechaVenta,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final isEditing = widget.ventaExistente != null;
    final steps = _buildSteps(l);

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
              Text(isEditing ? l.ventaEditTitle : l.ventaNewSaleTitle),
              if (_lastSaveTime != null)
                Text(
                  _isSaving
                      ? l.commonSaving
                      : S
                            .of(context)
                            .salesSavedAgo(_formatSaveTime(_lastSaveTime!)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _onBackPressed,
            tooltip: l.commonLeave,
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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // Indicador de progreso
              FormProgressIndicator(
                currentStep: _currentStep,
                steps: steps,
                onStepTapped: _goToStep,
              ),

              // Contenido del paso actual
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentStep = index),
                  children: [
                    // Paso 0: Tipo de producto
                    TipoProductoStep(
                      tipoSeleccionado: _tipoProducto,
                      onTipoChanged: (tipo) =>
                          setState(() => _tipoProducto = tipo),
                    ),

                    // Paso 1: Cliente
                    ClienteStep(
                      clienteInicial: _cliente,
                      onClienteChanged: (cliente) =>
                          setState(() => _cliente = cliente),
                      autoValidate: _autoValidatePerStep[1],
                    ),

                    // Paso 2: Detalles del producto (incluye fecha y observaciones)
                    _buildProductDetailsStep(theme),
                  ],
                ),
              ),

              // Botones de navegación
              _buildNavigationButtons(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetailsStep(ThemeData theme) {
    if (_tipoProducto == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_rounded,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              S.of(context).salesSelectProductFirst,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).salesDetailsOf(_tipoProducto!.displayName),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            S.of(context).salesEnterDetails,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Selector de lote (siempre visible para poder cambiar)
          _buildLoteSelector(theme),

          // Fecha de venta
          _buildFormField(
            label: S.of(context).salesSaleDate,
            isRequired: true,
            child: InkWell(
              onTap: () async {
                unawaited(HapticFeedback.lightImpact());
                final fecha = await showDatePicker(
                  context: context,
                  initialDate: _fechaVenta,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (fecha != null) {
                  setState(() => _fechaVenta = fecha);
                }
              },
              borderRadius: AppRadius.allSm,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.allSm,
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.allSm,
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(_fechaVenta),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Campos específicos según tipo de producto
          if (_tipoProducto == TipoProductoVenta.avesVivas ||
              _tipoProducto == TipoProductoVenta.avesFaenadas ||
              _tipoProducto == TipoProductoVenta.avesDescarte)
            _buildAvesFields(theme),

          if (_tipoProducto == TipoProductoVenta.huevos)
            _buildHuevosFields(theme),

          if (_tipoProducto == TipoProductoVenta.pollinaza)
            _buildPollinazaFields(theme),

          const SizedBox(height: AppSpacing.base),

          // Observaciones
          _buildFormFieldWithController(
            controller: _observacionesController,
            label: S.of(context).salesObservationsLabel,
            hint: S.of(context).salesObservationsHint,
            maxLines: 3,
          ),

          // Espacio para teclado
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLoteSelector(ThemeData theme) {
    // Si no hay granja seleccionada, mostrar mensaje
    if (_selectedGranjaId == null || _selectedGranjaId!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: AppRadius.allSm,
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  S.of(context).salesNoFarmSelected,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final lotesAsync = ref.watch(lotesStreamProvider(_selectedGranjaId!));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).salesSelectBatchLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          lotesAsync.when(
            data: (lotes) {
              // Filtrar solo lotes activos
              final lotesActivos = lotes
                  .where((l) => l.estado == EstadoLote.activo)
                  .toList();

              if (lotesActivos.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allSm,
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.info),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          S.of(context).salesNoActiveBatches,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.info,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Determinar si hay error de lote no seleccionado
              final showLoteError =
                  _autoValidatePerStep[2] &&
                  (_selectedLoteId == null || _selectedLoteId!.isEmpty);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLoteId,
                    decoration: InputDecoration(
                      hintText: S.of(context).salesSelectBatchHint,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.allSm,
                        borderSide: BorderSide(
                          color: showLoteError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.allSm,
                        borderSide: BorderSide(
                          color: showLoteError
                              ? theme.colorScheme.error
                              : theme.colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items: lotesActivos.map((lote) {
                      return DropdownMenuItem<String>(
                        value: lote.id,
                        child: Text(
                          S
                              .of(context)
                              .batchDropdownItemCode(
                                lote.codigo,
                                '${lote.avesDisponibles}',
                              ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _selectedLoteId = value);
                    },
                  ),
                  if (showLoteError) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      S.of(context).salesSelectBatchError,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, _) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: Text(
                S.of(context).salesErrorLoadingBatches(error.toString()),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isRequired = false,
  }) {
    final theme = Theme.of(context);
    final labelText = isRequired ? '$label *' : label;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        child,
      ],
    );
  }

  Widget _buildFormFieldWithController({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isRequired = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? suffixText,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final labelText = isRequired ? '$label *' : label;
    // Usar autovalidación solo si el step 2 ya fue validado una vez
    final autoValidate = _autoValidatePerStep[2];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          labelText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          autovalidateMode: autoValidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: validator,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.normal,
            ),
            suffixText: suffixText,
            counterText: '',
            filled: true,
            fillColor: theme.colorScheme.surface,
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppRadius.allSm,
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvesFields(ThemeData theme) {
    return Column(
      children: [
        _buildFormFieldWithController(
          controller: _cantidadAvesController,
          label: S.of(context).salesBirdCountLabel,
          hint: S.of(context).salesBirdCountHint,
          isRequired: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).salesEnterBirdCount;
            }
            final cantidad = int.tryParse(value) ?? 0;
            if (cantidad <= 0) {
              return S.of(context).salesQuantityGreaterThanZero;
            }
            if (cantidad > 1000000) {
              return S.of(context).salesMaxQuantity;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.base),
        _buildFormFieldWithController(
          controller: _pesoPromedioController,
          label: _tipoProducto == TipoProductoVenta.avesFaenadas
              ? S.of(context).salesDressedWeightKg
              : S.of(context).salesTotalWeightKg,
          hint: S.of(context).salesWeightHint,
          isRequired: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).salesEnterTotalWeight;
            }
            final peso = double.tryParse(value) ?? 0;
            if (peso <= 0) {
              return S.of(context).salesWeightGreaterThanZero;
            }
            if (peso > 50000) {
              return S.of(context).salesMaxWeight;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.base),
        _buildFormFieldWithController(
          controller: _precioKgController,
          label: S.of(context).salesPricePerKgLabel(Formatters.currencySymbol),
          hint: S.of(context).salesPricePerKgHint,
          isRequired: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).salesEnterPricePerKg;
            }
            final precio = double.tryParse(value) ?? 0;
            if (precio <= 0) {
              return S.of(context).salesPriceGreaterThanZero;
            }
            if (precio > 9999999.99) {
              return S.of(context).salesMaxPrice;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHuevosFields(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: AppRadius.allSm,
            border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
          ),
          child: Text(
            S.of(context).salesEggInstructions,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        ...ClasificacionHuevo.values.map((clasificacion) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              borderRadius: AppRadius.allSm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${clasificacion.codigo} - ${clasificacion.displayName}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).salesQuantityLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          TextFormField(
                            controller: _huevosControllers[clasificacion],
                            decoration: InputDecoration(
                              hintText: '0',
                              filled: true,
                              fillColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.allSm,
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              final cantidad = int.tryParse(value);
                              if (cantidad == null || cantidad < 0) {
                                return S.of(context).salesQuantityInvalid;
                              }
                              if (cantidad > 9999999) {
                                return S.of(context).salesQuantityExcessive;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S
                                .of(context)
                                .salesPricePerDozen(Formatters.currencySymbol),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          TextFormField(
                            controller:
                                _preciosHuevosControllers[clasificacion],
                            decoration: InputDecoration(
                              hintText: '0.00',
                              filled: true,
                              fillColor:
                                  theme.colorScheme.surfaceContainerHighest,
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.allSm,
                                borderSide: BorderSide.none,
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              final precio = double.tryParse(value);
                              if (precio == null || precio < 0) {
                                return S.of(context).salesPriceInvalid;
                              }
                              if (precio > 9999999.99) {
                                return S.of(context).salesPriceExcessive;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPollinazaFields(ThemeData theme) {
    return Column(
      children: [
        _buildFormField(
          label: S.of(context).salesSaleUnit,
          isRequired: true,
          child: DropdownButtonFormField<UnidadVentaPollinaza>(
            initialValue: _unidadPollinaza,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.allSm,
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            items: UnidadVentaPollinaza.values.map((unidad) {
              return DropdownMenuItem(
                value: unidad,
                child: Text(unidad.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                setState(() => _unidadPollinaza = value);
              }
            },
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        _buildFormFieldWithController(
          controller: _cantidadPollinazaController,
          label: S
              .of(context)
              .salesPollinazaQuantity(_unidadPollinaza.displayName),
          hint: S.of(context).salesPollinazaQuantityHint,
          isRequired: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).salesEnterQuantity;
            }
            final cantidad = double.tryParse(value) ?? 0;
            if (cantidad <= 0) {
              return S.of(context).salesQuantityGreaterThanZero;
            }
            if (cantidad > 1000000) {
              return S.of(context).salesMaxQuantity;
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.base),
        _buildFormFieldWithController(
          controller: _precioPollinazaController,
          label: S
              .of(context)
              .salesPollinazaPricePerUnit(
                Formatters.currencySymbol,
                _unidadPollinaza.displayName,
              ),
          hint: S.of(context).salesPollinazaPriceHint,
          isRequired: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).salesEnterPrice;
            }
            final precio = double.tryParse(value) ?? 0;
            if (precio <= 0) {
              return S.of(context).salesPriceGreaterThanZero;
            }
            if (precio > 9999999.99) {
              return S.of(context).salesMaxPrice;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
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
                    onPressed: _isSubmitting ? null : _previousStep,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: _isSubmitting
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
                          _currentStep < 3 - 1 ? l.commonNext : l.ventaRegister,
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
