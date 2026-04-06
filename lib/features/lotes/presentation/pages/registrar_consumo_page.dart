import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/lote.dart';
import '../../domain/entities/registro_consumo.dart';
import '../../domain/enums/tipo_alimento.dart';
import '../../application/providers/registro_providers.dart';
import '../../application/providers/lote_providers.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/colaboradores_providers.dart';
import '../../../inventario/application/services/inventario_integracion_service.dart';
import '../../../inventario/domain/entities/item_inventario.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/sync_status_indicator.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../widgets/consumo_form_steps/informacion_consumo_step.dart';
import '../widgets/consumo_form_steps/resumen_observaciones_step.dart';

class RegistrarConsumoPage extends ConsumerStatefulWidget {
  final Lote lote;

  const RegistrarConsumoPage({super.key, required this.lote});

  @override
  ConsumerState<RegistrarConsumoPage> createState() =>
      _RegistrarConsumoPageState();
}

class _RegistrarConsumoPageState extends ConsumerState<RegistrarConsumoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadKgController = TextEditingController();
  final _costoPorKgController = TextEditingController();
  final _observacionesController = TextEditingController();
  final _pageController = PageController();

  DateTime _fechaSeleccionada = DateTime.now();
  TipoAlimento _tipoSeleccionado = TipoAlimento.iniciador;
  ItemInventario? _itemInventarioSeleccionado;
  bool _autoValidate = false;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  DateTime? _lastSaveTime;

  int _currentStep = 0;
  Timer? _autoSaveTimer;
  late List<FormStepInfo> _steps;
  bool _stepsInitialized = false;

  double get _cantidadKg => double.tryParse(_cantidadKgController.text) ?? 0;

  int get _edadDias {
    // Calcular edad correcta usando la fecha seleccionada
    return _fechaSeleccionada.difference(widget.lote.fechaIngreso).inDays +
        widget.lote.edadIngresoDias;
  }

  @override
  void initState() {
    super.initState();
    // Sugerir tipo de alimento según la edad
    _tipoSeleccionado = _sugerirTipoAlimento(_edadDias);
    _validateUserAndInit();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_stepsInitialized) {
      _stepsInitialized = true;
      _steps = [
        FormStepInfo(label: S.of(context).batchInfoStep),
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
    _cantidadKgController.removeListener(_onFieldChanged);
    _costoPorKgController.removeListener(_onFieldChanged);
    _observacionesController.removeListener(_onFieldChanged);
    _cantidadKgController.dispose();
    _costoPorKgController.dispose();
    _observacionesController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  TipoAlimento _sugerirTipoAlimento(int edad) {
    if (edad <= 7) return TipoAlimento.preIniciador;
    if (edad <= 21) return TipoAlimento.iniciador;
    if (edad <= 35) return TipoAlimento.crecimiento;
    return TipoAlimento.finalizador;
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
    _cantidadKgController.addListener(_onFieldChanged);
    _costoPorKgController.addListener(_onFieldChanged);
    _observacionesController.addListener(_onFieldChanged);
  }

  Future<void> _saveDraft() async {
    if (!_hasUnsavedChanges) return;

    try {
      setState(() => _isSaving = true);
      final prefs = await SharedPreferences.getInstance();
      final draft = jsonEncode({
        'cantidadKg': _cantidadKgController.text,
        'costoPorKg': _costoPorKgController.text,
        'observaciones': _observacionesController.text,
        'fecha': _fechaSeleccionada.toIso8601String(),
        'tipoAlimento': _tipoSeleccionado.index,
        'step': _currentStep,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await prefs.setString('consumo_draft_${widget.lote.id}', draft);
      if (!mounted) return;
      setState(() {
        _hasUnsavedChanges = false;
        _isSaving = false;
        _lastSaveTime = DateTime.now();
      });
      debugPrint('✅ Borrador guardado exitosamente');
    } on Exception catch (e) {
      debugPrint('❌ Error al guardar borrador: $e');
      if (!mounted) return;
      setState(() => _isSaving = false);
    }
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('consumo_draft_${widget.lote.id}');
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;
    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove('consumo_draft_${widget.lote.id}');
      return;
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

    if (!shouldRestore) {
      await prefs.remove('consumo_draft_${widget.lote.id}');
    }

    if (shouldRestore && mounted) {
      setState(() {
        _cantidadKgController.text = (draft['cantidadKg'] as String?) ?? '';
        _costoPorKgController.text = (draft['costoPorKg'] as String?) ?? '';
        _observacionesController.text =
            (draft['observaciones'] as String?) ?? '';
        _fechaSeleccionada = DateTime.parse(draft['fecha'] as String);
        _tipoSeleccionado = TipoAlimento.values[draft['tipoAlimento'] as int];
        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
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

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: widget.lote.fechaIngreso,
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  /// Maneja la selección de un item de inventario y autocompleta campos.
  void _onItemInventarioChanged(ItemInventario? item) {
    setState(() {
      _itemInventarioSeleccionado = item;

      // Autocompletar precio si el item tiene precio unitario
      if (item != null && item.precioUnitario != null) {
        _costoPorKgController.text = item.precioUnitario!.toStringAsFixed(2);
      }
    });
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

  Future<void> _guardarRegistro() async {
    // Validar usuario
    final user = ref.read(currentUserProvider);
    if (user == null ||
        user.id.isEmpty ||
        user.nombre == null ||
        user.nombre!.isEmpty) {
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
        _showError(S.of(context).batchNoPermissionRecord);
        return;
      }
    } on Exception catch (e) {
      _showError(S.of(context).batchErrorVerifyingPermissions(e.toString()));
      return;
    }

    // Validar fecha
    if (_fechaSeleccionada.isAfter(DateTime.now())) {
      _showError(S.of(context).consumptionFutureDate);
      return;
    }
    if (_fechaSeleccionada.isBefore(widget.lote.fechaIngreso)) {
      _showError(S.of(context).consumptionBeforeEntryDate);
      return;
    }

    // Validar cantidad de aves
    final cantidadActual = widget.lote.avesDisponibles;
    if (cantidadActual <= 0) {
      _showError(S.of(context).consumptionNoBirdsAvailable);
      return;
    }

    try {
      // Calcular costo por kg si se ingresó
      final costoText = _costoPorKgController.text.trim();
      final costoPorKg = costoText.isNotEmpty
          ? double.tryParse(costoText)
          : null;

      // Calcular edad en días usando fecha seleccionada
      final edadDias =
          _fechaSeleccionada.difference(widget.lote.fechaIngreso).inDays +
          widget.lote.edadIngresoDias;

      final registro = RegistroConsumo(
        id: '',
        loteId: widget.lote.id,
        granjaId: widget.lote.granjaId,
        galponId: widget.lote.galponId,
        fecha: _fechaSeleccionada,
        cantidadKg: _cantidadKg,
        tipoAlimento: _tipoSeleccionado,
        loteAlimento: _itemInventarioSeleccionado?.loteProveedor,
        proveedorId: _itemInventarioSeleccionado?.proveedor,
        cantidadAvesActual: cantidadActual,
        consumoAcumuladoAnterior: widget.lote.consumoAcumuladoKg ?? 0,
        edadDias: edadDias,
        costoPorKg: costoPorKg,
        observaciones: _observacionesController.text.trim().isEmpty
            ? null
            : _observacionesController.text.trim(),
        usuarioRegistro: user.id,
        nombreUsuario: user.nombre!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        itemInventarioId: _itemInventarioSeleccionado?.id,
        nombreItemInventario: _itemInventarioSeleccionado?.nombre,
      );

      // Validar el registro antes de guardar
      final errorValidacion = registro.validar();
      if (errorValidacion != null) {
        if (!mounted) return;
        _showError(errorValidacion);
        return;
      }

      debugPrint('🍽️ Guardando registro de consumo...');
      debugPrint('Lote: ${widget.lote.id}');
      debugPrint('Fecha: ${registro.fecha}');
      debugPrint('Cantidad: ${registro.cantidadKg} kg');
      debugPrint('Tipo: ${registro.tipoAlimento.displayName}');
      debugPrint('Edad: ${registro.edadDias} días');

      // Validar stock disponible ANTES de guardar el consumo
      if (_itemInventarioSeleccionado != null) {
        final stockActual = _itemInventarioSeleccionado!.stockActual;
        if (_cantidadKg > stockActual) {
          _showError(
            S
                .of(context)
                .consumptionInsufficientStock(stockActual.toStringAsFixed(1)),
          );
          return;
        }
      }

      await ref.read(registroConsumoDatasourceProvider).crear(registro);

      debugPrint('✅ Registro de consumo guardado exitosamente');

      // Actualizar el consumo acumulado en el lote
      final nuevoConsumoAcumulado =
          (widget.lote.consumoAcumuladoKg ?? 0) + _cantidadKg;

      debugPrint(
        '🔄 Actualizando consumo acumulado del lote: $nuevoConsumoAcumulado kg',
      );

      await ref.read(loteFirebaseDatasourceProvider).actualizarCampos(
        widget.lote.id,
        {'consumoAcumuladoKg': nuevoConsumoAcumulado},
      );

      debugPrint('✅ Lote actualizado exitosamente');

      // Descontar del inventario si se seleccionó un item
      if (_itemInventarioSeleccionado != null) {
        debugPrint('📦 Descontando del inventario...');
        try {
          final integracionService = ref.read(
            inventarioIntegracionServiceProvider,
          );
          await integracionService.registrarSalidaDesdeConsumo(
            granjaId: widget.lote.granjaId,
            itemId: _itemInventarioSeleccionado!.id,
            cantidad: _cantidadKg,
            loteId: widget.lote.id,
            registradoPor: user.id,
            consumoId: registro.id,
          );
          debugPrint('✅ Inventario actualizado exitosamente');
        } on Exception catch (e) {
          debugPrint('⚠️ Error al actualizar inventario: $e');
          // Mostrar advertencia pero no bloquear el flujo
          if (mounted) {
            AppSnackBar.warning(
              context,
              message: S.of(context).consumptionInventoryError(e.toString()),
            );
          }
        }
      }

      if (!mounted) return;
      // Limpiar borrador
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('consumo_draft_${widget.lote.id}');
      setState(() => _hasUnsavedChanges = false);

      if (!mounted) return;
      // Mostrar celebración con animación
      AppSnackBar.success(
        context,
        message: S.of(context).consumptionRegistered,
        detail: S
            .of(context)
            .consumptionRegisteredDetail(
              _cantidadKg.toStringAsFixed(1),
              _tipoSeleccionado.localizedDisplayName(S.of(context)),
            ),
      );

      // Navegar con delay para mostrar celebración
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } on FirebaseException catch (e) {
      debugPrint(
        '❌ Error Firebase en registro consumo: ${e.code} - ${e.message}',
      );
      if (!mounted) return;

      String mensaje = S.of(context).batchFirebaseDbError;
      String? detalle;

      if (e.code == 'permission-denied') {
        mensaje = S.of(context).batchFirebasePermissionDenied;
        detalle = S.of(context).batchFirebasePermissionDetail;
      } else if (e.code == 'unavailable') {
        mensaje = S.of(context).batchFirebaseUnavailable;
        detalle = S.of(context).batchFirebaseNetworkDetail;
      } else if (e.code == 'unauthenticated') {
        mensaje = S.of(context).batchFirebaseSessionExpired;
        detalle = S.of(context).batchFirebaseSessionDetail;
      } else if (e.message != null) {
        mensaje = e.message!;
      }

      AppSnackBar.error(context, message: mensaje, detail: detalle);
    } on Exception catch (e) {
      debugPrint('❌ Error Exception en registro consumo: $e');
      if (!mounted) return;
      AppSnackBar.error(
        context,
        message: S.of(context).batchErrorCreatingRecord,
        detail: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> _showConfirmacionCantidadAlta(double cantidad) async {
    final cantidadActual = widget.lote.avesDisponibles;
    final consumoPorAve = cantidad / cantidadActual;
    final l = S.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          l.consumptionHighAmountTitle,
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
              l.consumptionHighAmountMessage(cantidad.toStringAsFixed(1)),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapMd,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.commonTotal,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${cantidad.toStringAsFixed(1)} kg',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapXs,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l.consumptionPerBird,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${(consumoPorAve * 1000).toStringAsFixed(0)} g/ave',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
            child: Text(l.commonCorrect),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(l.commonConfirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<bool> _mostrarAdvertenciaTipoAlimento() async {
    final tipoRecomendado = _sugerirTipoAlimento(_edadDias);
    final l = S.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
        title: Text(
          l.consumptionFoodTypeTitle,
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
              l.consumptionFoodTypeWarning(
                _tipoSeleccionado.localizedDescripcion(S.of(context)),
                _edadDias,
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
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: AppRadius.allSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.consumptionRecommendedType,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          tipoRecomendado.localizedDescripcion(S.of(context)),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.onSurfaceVariant,
            ),
            child: Text(l.commonReview),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
            ),
            child: Text(l.commonContinue),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cantidadActual = widget.lote.avesDisponibles;
    final isProcessing = _isSaving;

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
            await prefs.remove('consumo_draft_${widget.lote.id}');
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
                S.of(context).registerConsumptionTitle,
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
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: isProcessing
                ? null
                : () async {
                    if (_hasUnsavedChanges) {
                      final navigator = Navigator.of(context);
                      final shouldExit = await _showUnsavedChangesDialog();
                      if (shouldExit == true) {
                        if (!mounted) return;
                        await _saveDraft();
                        if (!mounted) return;
                        navigator.pop();
                      }
                    } else {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('consumo_draft_${widget.lote.id}');
                      if (!mounted) return;
                      if (context.mounted) Navigator.of(context).pop();
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
              onStepTapped: _goToStep,
            ),

            // Contenido de los pasos
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Información del Consumo
                    InformacionConsumoStep(
                      formKey: _formKey,
                      cantidadKgController: _cantidadKgController,
                      fechaSeleccionada: _fechaSeleccionada,
                      tipoSeleccionado: _tipoSeleccionado,
                      onSeleccionarFecha: _seleccionarFecha,
                      onTipoChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _tipoSeleccionado = value;
                          });
                        }
                      },
                      onCantidadChanged: () => setState(() {}),
                      autoValidate: _autoValidate,
                      edadDias: _edadDias,
                      tipoRecomendado: _sugerirTipoAlimento(_edadDias),
                      costoPorKgController: _costoPorKgController,
                      onCostoPorKgChanged: () => setState(() {}),
                      granjaId: widget.lote.granjaId,
                      itemInventarioSeleccionado: _itemInventarioSeleccionado,
                      onItemInventarioChanged: _onItemInventarioChanged,
                      stockDisponible: _itemInventarioSeleccionado?.stockActual,
                    ),

                    // Step 2: Resumen y Observaciones
                    ResumenObservacionesStep(
                      formKey: _formKey,
                      observacionesController: _observacionesController,
                      autoValidate: _autoValidate,
                      cantidadKg: _cantidadKg,
                      tipoAlimento: _tipoSeleccionado,
                      fecha: _fechaSeleccionada,
                      avesActuales: cantidadActual,
                      costoPorKg: double.tryParse(_costoPorKgController.text),
                      consumoAcumuladoKg: widget.lote.consumoAcumuladoKg,
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
    final isProcessing = _isSaving;

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

  Future<void> _onNextOrSubmit() async {
    if (_currentStep < _steps.length - 1) {
      await _nextStep();
    } else {
      await _submit();
    }
  }

  void _previousStep() {
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

  Future<void> _nextStep() async {
    final isValid = await _validateCurrentStep();
    if (!isValid) return;

    if (!mounted) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _currentStep++;
      _autoValidate = false;
    });
    unawaited(
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  Future<bool> _validateCurrentStep() async {
    switch (_currentStep) {
      case 0:
        // Paso 1: Validar cantidad de alimento
        if (_cantidadKgController.text.isEmpty) {
          setState(() => _autoValidate = true);
          return false;
        }
        final cantidad = double.tryParse(_cantidadKgController.text);
        if (cantidad == null || cantidad <= 0) {
          setState(() => _autoValidate = true);
          return false;
        }

        // Confirmación para cantidades excesivas (>5000 kg)
        if (cantidad > 5000) {
          final confirmar = await _showConfirmacionCantidadAlta(cantidad);
          if (!confirmar) return false;
        }

        if (!mounted) return false;

        // Advertencia adicional para cantidades muy altas (>10000 kg)
        if (cantidad > 10000) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).consumptionAmountTooHigh);
          return false;
        }

        // Validar fecha
        if (_fechaSeleccionada.isAfter(DateTime.now())) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).consumptionFutureDate);
          return false;
        }
        if (_fechaSeleccionada.isBefore(widget.lote.fechaIngreso)) {
          setState(() => _autoValidate = true);
          _showError(S.of(context).consumptionBeforeEntryDate);
          return false;
        }

        // Confirmar si el tipo de alimento no es apropiado para la edad
        if (!_tipoSeleccionado.esApropiado(_edadDias)) {
          final confirmar = await _mostrarAdvertenciaTipoAlimento();
          if (!confirmar) return false;
        }

        return true;
      case 1:
        // Paso 2: Validar costo si se ingresó
        final costoText = _costoPorKgController.text.trim();
        if (costoText.isNotEmpty) {
          final costo = double.tryParse(costoText);
          if (costo == null || costo < 0) {
            setState(() => _autoValidate = true);
            _showError(S.of(context).consumptionCostNegative);
            return false;
          }
          if (costo > 100000) {
            setState(() => _autoValidate = true);
            _showError(S.of(context).consumptionCostTooHigh);
            return false;
          }
        }
        return true;
      case 2:
        // Paso 3: Siempre válido (observaciones son opcionales)
        return true;
      default:
        return false;
    }
  }

  Future<void> _submit() async {
    // Validación final con confirmaciones incluidas
    final isValid = await _validateCurrentStep();
    if (!isValid) return;

    setState(() => _isSaving = true);
    await _guardarRegistro();
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      AppSnackBar.error(context, message: message);
    }
  }
}
