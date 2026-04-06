/// Página para crear/editar un item de inventario.
/// Implementa un formulario multi-paso con la misma UI/UX que crear granja
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/storage/image_upload_service.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../application/providers/providers.dart';
import '../../application/services/inventario_costos_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../widgets/form_steps/form_steps.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página para crear o editar un item de inventario.
class CrearItemInventarioPage extends ConsumerStatefulWidget {
  const CrearItemInventarioPage({
    super.key,
    required this.granjaId,
    this.itemExistente,
    this.itemId,
  });

  final String granjaId;
  final ItemInventario? itemExistente;
  final String? itemId;

  @override
  ConsumerState<CrearItemInventarioPage> createState() =>
      _CrearItemInventarioPageState();
}

class _CrearItemInventarioPageState
    extends ConsumerState<CrearItemInventarioPage> {
  static const int _totalSteps = 4;
  S get l => S.of(context);

  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  // AutoValidate por step para que errores solo afecten el step actual
  final List<bool> _autoValidatePerStep = [false, false, false, false];

  // Controllers - Información Básica
  late TextEditingController _nombreController;
  late TextEditingController _codigoController;
  late TextEditingController _descripcionController;

  // Controllers - Stock
  late TextEditingController _stockActualController;
  late TextEditingController _stockMinimoController;
  late TextEditingController _stockMaximoController;

  // Controllers - Detalles
  late TextEditingController _precioController;
  late TextEditingController _proveedorController;
  late TextEditingController _ubicacionController;
  late TextEditingController _loteProveedorController;

  // Estado
  TipoItem _tipoSeleccionado = TipoItem.alimento;
  UnidadMedida _unidadSeleccionada = UnidadMedida.kilogramo;
  DateTime? _fechaVencimiento;
  XFile? _imagenSeleccionada;
  bool _imagenRemovida = false;

  bool _isLoading = false;
  Timer? _autoSaveTimer;
  bool _isSaving = false;
  DateTime? _lastSaveTime;

  bool get _isEditing => widget.itemExistente != null;

  // Definición de los pasos del formulario
  List<FormStepInfo> _getSteps(S l) => [
    FormStepInfo(label: l.invStepType),
    FormStepInfo(label: l.invStepBasic),
    FormStepInfo(label: l.invStepStock),
    FormStepInfo(label: l.invStepDetails),
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.itemExistente;

    _nombreController = TextEditingController(text: item?.nombre ?? '');
    _codigoController = TextEditingController(text: item?.codigo ?? '');
    _descripcionController = TextEditingController(
      text: item?.descripcion ?? '',
    );
    _stockActualController = TextEditingController(
      text: item?.stockActual.toString() ?? '',
    );
    _stockMinimoController = TextEditingController(
      text: item?.stockMinimo.toString() ?? '0',
    );
    _stockMaximoController = TextEditingController(
      text: item?.stockMaximo?.toString() ?? '',
    );
    _precioController = TextEditingController(
      text: item?.precioUnitario?.toString() ?? '',
    );
    _proveedorController = TextEditingController(text: item?.proveedor ?? '');
    _ubicacionController = TextEditingController(text: item?.ubicacion ?? '');
    _loteProveedorController = TextEditingController(
      text: item?.loteProveedor ?? '',
    );

    if (item != null) {
      _tipoSeleccionado = item.tipo;
      _unidadSeleccionada = item.unidad;
      _fechaVencimiento = item.fechaVencimiento;
    }

    if (!_isEditing) {
      _loadDraft();
      _startAutoSave();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pageController.dispose();
    _nombreController.dispose();
    _codigoController.dispose();
    _descripcionController.dispose();
    _stockActualController.dispose();
    _stockMinimoController.dispose();
    _stockMaximoController.dispose();
    _precioController.dispose();
    _proveedorController.dispose();
    _ubicacionController.dispose();
    _loteProveedorController.dispose();
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
      'granjaId': widget.granjaId,
      'nombre': _nombreController.text,
      'codigo': _codigoController.text,
      'descripcion': _descripcionController.text,
      'stockActual': _stockActualController.text,
      'stockMinimo': _stockMinimoController.text,
      'stockMaximo': _stockMaximoController.text,
      'precio': _precioController.text,
      'proveedor': _proveedorController.text,
      'ubicacion': _ubicacionController.text,
      'loteProveedor': _loteProveedorController.text,
      'tipo': _tipoSeleccionado.index,
      'unidad': _unidadSeleccionada.index,
      'fechaVencimiento': _fechaVencimiento?.toIso8601String(),
      'step': _currentStep,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await prefs.setString('inventario_item_draft', jsonEncode(draft));
    setState(() {
      _isSaving = false;
      _lastSaveTime = DateTime.now();
    });
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final draftJson = prefs.getString('inventario_item_draft');
    if (draftJson == null) return;

    final draft = jsonDecode(draftJson) as Map<String, dynamic>;

    // Solo cargar si es para la misma granja
    if (draft['granjaId'] != widget.granjaId) return;

    final timestamp = DateTime.parse(draft['timestamp'] as String);

    // Solo cargar si el draft tiene menos de 7 días
    if (DateTime.now().difference(timestamp).inDays > 7) {
      await prefs.remove('inventario_item_draft');
      return;
    }

    // Preguntar al usuario si desea restaurar
    if (!mounted) return;
    final shouldRestore = await showAppConfirmDialog(
      context: context,
      title: l.invDraftFound,
      message: l.draftFoundMessage(_formatDate(timestamp)),
      type: AppDialogType.info,
      confirmText: l.commonRestore,
      cancelText: l.commonDiscard,
      icon: Icons.restore,
    );

    if (!shouldRestore) {
      await prefs.remove('inventario_item_draft');
    }

    if (shouldRestore && mounted) {
      setState(() {
        _nombreController.text = draft['nombre'] ?? '';
        _codigoController.text = draft['codigo'] ?? '';
        _descripcionController.text = draft['descripcion'] ?? '';
        _stockActualController.text = draft['stockActual'] ?? '';
        _stockMinimoController.text = draft['stockMinimo'] ?? '0';
        _stockMaximoController.text = draft['stockMaximo'] ?? '';
        _precioController.text = draft['precio'] ?? '';
        _proveedorController.text = draft['proveedor'] ?? '';
        _ubicacionController.text = draft['ubicacion'] ?? '';
        _loteProveedorController.text = draft['loteProveedor'] ?? '';
        _tipoSeleccionado = TipoItem.values[draft['tipo'] ?? 0];
        _unidadSeleccionada = UnidadMedida.values[draft['unidad'] ?? 0];
        if (draft['fechaVencimiento'] != null) {
          _fechaVencimiento = DateTime.parse(draft['fechaVencimiento']);
        }
        _currentStep = draft['step'] ?? 0;
      });
      _pageController.jumpToPage(_currentStep);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return S
          .of(context)
          .commonTodayAt(
            '${date.hour}:${date.minute.toString().padLeft(2, '0')}',
          );
    } else if (difference.inDays == 1) {
      return S.of(context).commonYesterday;
    } else {
      return S.of(context).commonDaysAgo(difference.inDays.toString());
    }
  }

  String _formatSaveTime(DateTime saveTime) {
    final now = DateTime.now();
    final difference = now.difference(saveTime);

    if (difference.inSeconds < 10) {
      return S.of(context).commonTimeRightNow;
    } else if (difference.inSeconds < 60) {
      return S
          .of(context)
          .commonTimeSecondsAgo(difference.inSeconds.toString());
    } else if (difference.inMinutes < 60) {
      return S
          .of(context)
          .commonTimeMinutesAgo(difference.inMinutes.toString());
    } else {
      return S.of(context).commonTimeHoursAgo(difference.inHours.toString());
    }
  }

  bool _hasUnsavedChanges() {
    return _nombreController.text.isNotEmpty ||
        _codigoController.text.isNotEmpty ||
        _stockActualController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final steps = _getSteps(l);
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
              Text(_isEditing ? l.invEditItem : l.invNewItemTitle),
              if (_lastSaveTime != null && !_isEditing)
                Text(
                  _isSaving
                      ? l.commonSaving
                      : S
                            .of(context)
                            .commonSavedAt(_formatSaveTime(_lastSaveTime!)),
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
            if (_isSaving)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.base),
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
              steps: steps,
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
                    TipoItemStep(
                      tipoSeleccionado: _tipoSeleccionado,
                      onTipoChanged: (tipo) {
                        setState(() => _tipoSeleccionado = tipo);
                      },
                    ),
                    InventarioBasicInfoStep(
                      nombreController: _nombreController,
                      codigoController: _codigoController,
                      descripcionController: _descripcionController,
                      autoValidate: _autoValidatePerStep[1],
                    ),
                    InventarioStockStep(
                      tipoItem: _tipoSeleccionado,
                      stockActualController: _stockActualController,
                      stockMinimoController: _stockMinimoController,
                      stockMaximoController: _stockMaximoController,
                      unidadSeleccionada: _unidadSeleccionada,
                      onUnidadChanged: (unidad) {
                        setState(() => _unidadSeleccionada = unidad);
                      },
                      autoValidate: _autoValidatePerStep[2],
                    ),
                    InventarioDetailsStep(
                      precioController: _precioController,
                      proveedorController: _proveedorController,
                      ubicacionController: _ubicacionController,
                      loteProveedorController: _loteProveedorController,
                      tipoSeleccionado: _tipoSeleccionado,
                      fechaVencimiento: _fechaVencimiento,
                      onFechaVencimientoChanged: (fecha) {
                        setState(() => _fechaVencimiento = fecha);
                      },
                      imagenSeleccionada: _imagenSeleccionada,
                      imagenUrlExistente: _imagenRemovida
                          ? null
                          : widget.itemExistente?.imagenUrl,
                      onPickImage: _pickImage,
                      onRemoveImage: () {
                        setState(() {
                          _imagenSeleccionada = null;
                          _imagenRemovida = true;
                        });
                      },
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
    final colorScheme = theme.colorScheme;
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
                          _currentStep < _totalSteps - 1
                              ? l.commonNext
                              : _isEditing
                              ? l.commonUpdate
                              : l.invCreateItem,
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
    if (_currentStep < _totalSteps - 1) {
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

    // Forzar validación del formulario para mostrar errores inline
    _formKey.currentState?.validate();

    switch (_currentStep) {
      case 0: // Tipo de Item - siempre válido (ya tiene selección por defecto)
        break;
      case 1: // Información Básica
        if (_nombreController.text.trim().isEmpty) {
          return false;
        }
        if (_nombreController.text.trim().length < 2) {
          return false;
        }
        break;
      case 2: // Stock
        if (_stockActualController.text.trim().isEmpty) {
          return false;
        }
        if (double.tryParse(_stockActualController.text) == null) {
          return false;
        }
        break;
      case 3: // Detalles - todos opcionales
        break;
    }
    return true;
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

      if (image != null) {
        // Validar tamaño del archivo
        final fileToCheck = File(image.path);
        final bytes = await fileToCheck.length();
        if (bytes > AppConstants.maxImageSizeBytes) {
          if (mounted) {
            AppSnackBar.error(context, message: l.invImageTooLarge);
          }
          return;
        }

        setState(() {
          _imagenSeleccionada = image;
          _imagenRemovida = false;
        });

        if (mounted) {
          AppSnackBar.success(context, message: l.invImageSelected);
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          message: l.invErrorSelectingImage,
          detail: e.toString(),
        );
      }
    }
  }

  Future<String?> _uploadImage(String itemId) async {
    if (_imagenSeleccionada == null) return widget.itemExistente?.imagenUrl;

    try {
      final imageService = ref.read(imageUploadServiceProvider);
      final file = File(_imagenSeleccionada!.path);

      final result = await imageService.uploadImage(
        file: file,
        type: ImageUploadType.inventario,
        granjaId: widget.granjaId,
        entityId: itemId,
        metadata: {
          'itemId': itemId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
        firestoreDocPath: 'inventario_items/$itemId',
        firestoreField: 'imagenUrl',
      );

      return result.url;
    } on Exception catch (e) {
      debugPrint('Error al subir imagen: $e');
      if (mounted) {
        AppSnackBar.warning(
          context,
          message: l.invCouldNotUploadImage,
          detail: l.invItemSavedWithoutImage,
        );
      }
      // Re-lanzar errores de conectividad para que el usuario sea notificado
      if (e.toString().contains('No hay conexión')) rethrow;
      return null;
    }
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_validateCurrentStep()) return;

    setState(() => _isLoading = true);
    unawaited(HapticFeedback.mediumImpact());

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception(S.of(context).errorUserNotAuthenticated);
      }

      final notifier = ref.read(inventarioItemNotifierProvider.notifier);
      String? imagenUrl = _imagenRemovida
          ? null
          : widget.itemExistente?.imagenUrl;

      if (_isEditing) {
        // Si estamos editando, subir imagen primero si hay una nueva
        if (_imagenSeleccionada != null) {
          imagenUrl = await _uploadImage(widget.itemExistente!.id);
        }

        final item = ItemInventario(
          id: widget.itemExistente!.id,
          granjaId: widget.granjaId,
          tipo: _tipoSeleccionado,
          nombre: _nombreController.text.trim(),
          codigo: _codigoController.text.trim().isEmpty
              ? null
              : _codigoController.text.trim(),
          descripcion: _descripcionController.text.trim().isEmpty
              ? null
              : _descripcionController.text.trim(),
          stockActual: double.parse(_stockActualController.text),
          stockMinimo: double.tryParse(_stockMinimoController.text) ?? 0,
          stockMaximo: double.tryParse(_stockMaximoController.text),
          unidad: _unidadSeleccionada,
          precioUnitario: double.tryParse(_precioController.text),
          proveedor: _proveedorController.text.trim().isEmpty
              ? null
              : _proveedorController.text.trim(),
          ubicacion: _ubicacionController.text.trim().isEmpty
              ? null
              : _ubicacionController.text.trim(),
          fechaVencimiento: _fechaVencimiento,
          loteProveedor: _loteProveedorController.text.trim().isEmpty
              ? null
              : _loteProveedorController.text.trim(),
          registradoPor: widget.itemExistente!.registradoPor,
          fechaCreacion: widget.itemExistente!.fechaCreacion,
          activo: true,
          imagenUrl: imagenUrl,
        );

        await notifier.actualizarItem(item);
      } else {
        // Si es nuevo, crear primero sin imagen, luego subir imagen y actualizar
        final itemSinImagen = ItemInventario(
          id: '',
          granjaId: widget.granjaId,
          tipo: _tipoSeleccionado,
          nombre: _nombreController.text.trim(),
          codigo: _codigoController.text.trim().isEmpty
              ? null
              : _codigoController.text.trim(),
          descripcion: _descripcionController.text.trim().isEmpty
              ? null
              : _descripcionController.text.trim(),
          stockActual: double.parse(_stockActualController.text),
          stockMinimo: double.tryParse(_stockMinimoController.text) ?? 0,
          stockMaximo: double.tryParse(_stockMaximoController.text),
          unidad: _unidadSeleccionada,
          precioUnitario: double.tryParse(_precioController.text),
          proveedor: _proveedorController.text.trim().isEmpty
              ? null
              : _proveedorController.text.trim(),
          ubicacion: _ubicacionController.text.trim().isEmpty
              ? null
              : _ubicacionController.text.trim(),
          fechaVencimiento: _fechaVencimiento,
          loteProveedor: _loteProveedorController.text.trim().isEmpty
              ? null
              : _loteProveedorController.text.trim(),
          registradoPor: currentUser.id,
          fechaCreacion: DateTime.now(),
          activo: true,
        );

        final itemCreado = await notifier.crearItem(itemSinImagen);

        // Si hay imagen, subirla y actualizar el item
        if (_imagenSeleccionada != null && itemCreado != null) {
          imagenUrl = await _uploadImage(itemCreado.id);
          if (imagenUrl != null) {
            final itemConImagen = itemCreado.copyWith(imagenUrl: imagenUrl);
            await notifier.actualizarItem(itemConImagen);
          }
        }

        // Generar costo automáticamente si tiene stock y precio
        if (itemCreado != null) {
          final costosService = ref.read(inventarioCostosServiceProvider);
          if (costosService.debeGenerarCosto(itemCreado)) {
            await costosService.generarCostoDesdeNuevoItem(
              item: itemCreado,
              registradoPor: currentUser.id,
            );
          }
        }

        // Limpiar draft si se creó exitosamente
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('inventario_item_draft');
      }

      if (mounted) {
        unawaited(HapticFeedback.mediumImpact());
        AppSnackBar.success(
          context,
          message: _isEditing
              ? l.invItemUpdatedSuccess
              : l.invItemCreated(_nombreController.text),
        );
        context.pop();
      }
    } on Exception catch (e) {
      if (mounted) {
        unawaited(HapticFeedback.heavyImpact());
        AppSnackBar.error(
          context,
          message: S.of(context).errorGeneric,
          detail: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onBackPressed() async {
    if (_isEditing || !_hasUnsavedChanges()) {
      if (!_isEditing) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('inventario_item_draft');
      }
      if (mounted) context.pop();
      return;
    }

    final shouldExit = await showAppConfirmDialog(
      context: context,
      title: l.commonExitWithoutCompleting,
      message: l.invDraftAutoSaveMessage,
      type: AppDialogType.warning,
      confirmText: l.commonLeave,
      cancelText: l.commonContinue,
    );

    if (shouldExit == true) {
      await _autoSave();
      if (mounted) context.pop();
    }
  }
}
