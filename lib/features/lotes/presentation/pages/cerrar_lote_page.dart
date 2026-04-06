/// Página completa para cerrar un lote de aves.
///
/// **Características:**
/// - Formulario multi-paso para proceso de cierre
/// - Cálculo automático de métricas finales
/// - Resumen completo del ciclo del lote
/// - Validaciones de negocio
/// - Diseño Material 3 consistente
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/providers/lote_providers.dart';
import '../../domain/entities/lote.dart';
import '../../../../core/presentation/widgets/form_progress_indicator.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página para cerrar un lote de aves.
class CerrarLotePage extends ConsumerStatefulWidget {
  const CerrarLotePage({super.key, required this.lote});

  final Lote lote;

  @override
  ConsumerState<CerrarLotePage> createState() => _CerrarLotePageState();
}

class _CerrarLotePageState extends ConsumerState<CerrarLotePage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  int _currentStep = 0;

  // Pasos del formulario
  late final List<FormStepInfo> _steps;

  // Controllers
  final _cantidadFinalController = TextEditingController();
  final _pesoFinalController = TextEditingController();
  final _motivoCierreController = TextEditingController();
  final _observacionesController = TextEditingController();

  // State
  DateTime _fechaCierre = DateTime.now();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cantidadFinalController.text = widget.lote.avesActuales.toString();
    if (widget.lote.pesoPromedioActual != null) {
      // Convertir kg a gramos para mostrar
      _pesoFinalController.text = (widget.lote.pesoPromedioActual! * 1000)
          .toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cantidadFinalController.dispose();
    _pesoFinalController.dispose();
    _motivoCierreController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_currentStep < _steps.length - 1) {
      if (!_validateCurrentStep()) {
        return;
      }

      setState(() => _currentStep++);
      await _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _previousStep() async {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      await _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        // Validar datos del cierre
        if (_cantidadFinalController.text.isEmpty) {
          _showError(S.of(context).batchEnterFinalBirdCount);
          return false;
        }
        final cantidad = int.tryParse(_cantidadFinalController.text);
        if (cantidad == null || cantidad < 0) {
          _showError(S.of(context).batchInvalidCount);
          return false;
        }
        if (cantidad > widget.lote.cantidadInicial) {
          _showError(S.of(context).batchFinalCannotExceedInitial);
          return false;
        }
        return true;
      case 1:
        // Las métricas son solo visualización
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    AppSnackBar.error(context, message: message);
  }

  Future<void> _cerrarLote() async {
    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final cantidadFinal =
          int.tryParse(_cantidadFinalController.text) ??
          widget.lote.avesActuales;
      // Convertir gramos a kg
      final pesoFinalKg = double.tryParse(_pesoFinalController.text) != null
          ? double.parse(_pesoFinalController.text) / 1000.0
          : widget.lote.pesoPromedioActual;
      final motivo = _motivoCierreController.text.trim().isEmpty
          ? S.of(context).batchNormalCycleClose
          : _motivoCierreController.text.trim();

      final loteCerrado = widget.lote.copyWith(
        fechaCierreReal: _fechaCierre,
        cantidadActual: cantidadFinal,
        pesoPromedioActual: pesoFinalKg,
        motivoCierre: motivo,
        observaciones: _observacionesController.text.trim().isNotEmpty
            ? '${widget.lote.observaciones ?? ''}\n${S.of(context).batchClosePrefix} ${_observacionesController.text.trim()}'
            : widget.lote.observaciones,
        ultimaActualizacion: DateTime.now(),
      );

      final result = await ref
          .read(loteNotifierProvider.notifier)
          .cerrar(loteCerrado.id, motivo: motivo);

      result.fold(
        (failure) {
          if (mounted) {
            AppSnackBar.error(
              context,
              message: S.of(context).errorWithMessage(failure.message),
            );
          }
        },
        (lote) {
          if (mounted) {
            AppSnackBar.success(
              context,
              message: S.of(context).batchClosedSuccess,
            );
            context.pop(true);
          }
        },
      );
    } on Exception catch (e) {
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).batchErrorClosing(e.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber, color: AppColors.warning),
            AppSpacing.hGapMd,
            Text(S.of(context).batchConfirmClose),
          ],
        ),
        content: Text(S.of(context).batchCloseIrreversibleWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(S.of(context).commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(S.of(context).batchCloseBatch),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _steps = [
      FormStepInfo(label: S.of(context).batchDataStep),
      FormStepInfo(label: S.of(context).batchMetricsStep),
      FormStepInfo(label: S.of(context).batchConfirmStep),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).batchCloseBatch),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: FormProgressIndicator(
                steps: _steps,
                currentStep: _currentStep,
              ),
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildDatosStep(theme),
                  _buildMetricasStep(theme),
                  _buildResumenStep(theme),
                ],
              ),
            ),

            // Navigation
            _buildNavigationButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Botón anterior
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSaving ? null : _previousStep,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(S.of(context).batchPrevious),
                ),
              ),

            if (_currentStep > 0) AppSpacing.hGapMd,

            // Botón siguiente o cerrar
            Expanded(
              flex: 2,
              child: _currentStep == _steps.length - 1
                  ? FilledButton.icon(
                      onPressed: _isSaving ? null : _cerrarLote,
                      icon: _isSaving
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        _isSaving
                            ? S.of(context).batchClosing
                            : S.of(context).batchCloseBatch,
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: _isSaving ? null : _nextStep,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(S.of(context).batchNext),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== PASO 1: DATOS ====================

  Widget _buildDatosStep(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchClosureData,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchCompleteClosureInfo,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Info card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.info),
                      AppSpacing.hGapMd,
                      Text(
                        S.of(context).batchLoteInfo,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(S.of(context).commonCode, widget.lote.codigo),
                  _buildInfoRow(
                    S.of(context).batchBirdType,
                    widget.lote.tipoAve.localizedDisplayName(S.of(context)),
                  ),
                  _buildInfoRow(
                    S.of(context).batchInitialCount,
                    S
                        .of(context)
                        .batchInitialCountBirds(widget.lote.cantidadInicial),
                  ),
                  _buildInfoRow(
                    S.of(context).batchEntryDate,
                    DateFormat('dd/MM/yyyy').format(widget.lote.fechaIngreso),
                  ),
                  _buildInfoRow(
                    S.of(context).batchDaysInCycleLabel,
                    S
                        .of(context)
                        .batchDaysInCycle(widget.lote.diasDesdeIngreso),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapXl,

          // Fecha de cierre
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _fechaCierre,
                firstDate: widget.lote.fechaIngreso,
                lastDate: DateTime.now(),
                helpText: S.of(context).batchCloseDatePicker,
              );

              if (picked != null) {
                setState(() => _fechaCierre = picked);
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: S.of(context).batchCloseDateLabel,
                prefixIcon: const Icon(Icons.calendar_today),
                border: const OutlineInputBorder(),
                helperText: S.of(context).batchCloseDateHelper,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(_fechaCierre),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          AppSpacing.gapLg,

          // Cantidad final
          TextFormField(
            controller: _cantidadFinalController,
            decoration: InputDecoration(
              labelText: S.of(context).batchFinalBirdCount,
              hintText: widget.lote.cantidadInicial.toString(),
              prefixIcon: const Icon(Icons.pets),
              suffixText: S.of(context).batchBirds.toLowerCase(),
              border: const OutlineInputBorder(),
              helperText: S
                  .of(context)
                  .batchFinalBirdCountHelper(widget.lote.cantidadInicial),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).batchFieldRequired;
              }
              final cantidad = int.tryParse(value);
              if (cantidad == null) {
                return S.of(context).batchEnterValidNumber;
              }
              if (cantidad < 0) {
                return S.of(context).batchCannotBeNegative;
              }
              if (cantidad > widget.lote.cantidadInicial) {
                return S.of(context).batchCannotExceedInitial;
              }
              return null;
            },
          ),
          AppSpacing.gapLg,

          // Peso final
          TextFormField(
            controller: _pesoFinalController,
            decoration: InputDecoration(
              labelText: S.of(context).batchFinalAvgWeight,
              hintText: S.of(context).batchFinalAvgWeightHint,
              prefixIcon: const Icon(Icons.monitor_weight),
              suffixText: 'g',
              border: const OutlineInputBorder(),
              helperText: S.of(context).batchFinalAvgWeightHelper,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
          ),
          AppSpacing.gapLg,

          // Motivo de cierre
          TextFormField(
            controller: _motivoCierreController,
            decoration: InputDecoration(
              labelText: S.of(context).batchClosureReason,
              hintText: S.of(context).batchClosureReasonHint,
              prefixIcon: const Icon(Icons.description),
              border: const OutlineInputBorder(),
              helperText: S.of(context).batchClosureReasonHelper,
            ),
            maxLines: 2,
          ),
          AppSpacing.gapLg,

          // Observaciones
          TextFormField(
            controller: _observacionesController,
            decoration: InputDecoration(
              labelText: S.of(context).batchAdditionalNotes,
              hintText: S.of(context).batchAdditionalNotesHint,
              prefixIcon: const Icon(Icons.notes),
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ==================== PASO 2: MÉTRICAS ====================

  Widget _buildMetricasStep(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final cantidadFinal =
        int.tryParse(_cantidadFinalController.text) ?? widget.lote.avesActuales;
    final mortalidadTotal = widget.lote.cantidadInicial - cantidadFinal;
    final porcentajeMortalidad =
        (mortalidadTotal / widget.lote.cantidadInicial) * 100;
    final duracionCiclo = _fechaCierre
        .difference(widget.lote.fechaIngreso)
        .inDays;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchBatchMetrics,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchCycleIndicators,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXl,

          // Métricas de supervivencia
          _buildMetricCard(
            S.of(context).batchSurvival,
            Icons.favorite,
            AppColors.error,
            [
              _buildMetricItem(
                S.of(context).batchInitialBirds,
                '${widget.lote.cantidadInicial}',
                null,
              ),
              _buildMetricItem(
                S.of(context).batchFinalBirds,
                '$cantidadFinal',
                null,
              ),
              _buildMetricItem(
                S.of(context).batchTotalMortality,
                S.of(context).batchMortalityBirds(mortalidadTotal),
                porcentajeMortalidad > 5 ? AppColors.error : AppColors.success,
              ),
              _buildMetricItem(
                S.of(context).batchMortalityPercent,
                '${porcentajeMortalidad.toStringAsFixed(2)}%',
                porcentajeMortalidad > 5 ? AppColors.error : AppColors.success,
              ),
              _buildMetricItem(
                S.of(context).batchSurvivalPercent,
                '${(100 - porcentajeMortalidad).toStringAsFixed(2)}%',
                porcentajeMortalidad > 5 ? AppColors.error : AppColors.success,
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Métricas de tiempo
          _buildMetricCard(
            S.of(context).batchCycleDuration,
            Icons.calendar_today,
            AppColors.purple,
            [
              _buildMetricItem(
                S.of(context).batchEntryDate,
                DateFormat('dd/MM/yyyy').format(widget.lote.fechaIngreso),
                null,
              ),
              _buildMetricItem(
                S.of(context).batchCloseDateSimple,
                DateFormat('dd/MM/yyyy').format(_fechaCierre),
                null,
              ),
              _buildMetricItem(
                S.of(context).batchTotalDuration,
                S.of(context).batchDaysInCycle(duracionCiclo),
                null,
              ),
              _buildMetricItem(
                S.of(context).batchAgeAtClose,
                S
                    .of(context)
                    .batchAgeAtCloseDays(
                      duracionCiclo + widget.lote.edadIngresoDias,
                    ),
                null,
              ),
            ],
          ),
          AppSpacing.gapBase,

          // Métricas de peso
          if (widget.lote.pesoPromedioActual != null)
            _buildMetricCard(
              S.of(context).batchWeight,
              Icons.monitor_weight,
              AppColors.warning,
              [
                _buildMetricItem(
                  S.of(context).batchCurrentAvgWeightLabel,
                  '${(widget.lote.pesoPromedioActual! * 1000).toStringAsFixed(0)} g',
                  null,
                ),
                if (widget.lote.pesoPromedioObjetivo != null)
                  _buildMetricItem(
                    S.of(context).batchTargetWeight,
                    '${(widget.lote.pesoPromedioObjetivo! * 1000).toStringAsFixed(0)} g',
                    null,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // ==================== PASO 3: RESUMEN ====================

  Widget _buildResumenStep(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final cantidadFinal =
        int.tryParse(_cantidadFinalController.text) ?? widget.lote.avesActuales;
    final mortalidadTotal = widget.lote.cantidadInicial - cantidadFinal;
    final duracionCiclo = _fechaCierre
        .difference(widget.lote.fechaIngreso)
        .inDays;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            S.of(context).batchClosureSummary,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.deepPurple,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            S.of(context).batchClosureSummaryWarning,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppSpacing.gapXxl,

          // Advertencia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.allMd,
              border: Border.all(color: AppColors.warningLight, width: 2),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: AppColors.warning,
                  size: 32,
                ),
                AppSpacing.hGapBase,
                Expanded(
                  child: Text(
                    S.of(context).batchCloseWarningMessage,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.warningDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapXl,

          // Datos del lote
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).batchLoteInfo,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(S.of(context).commonCode, widget.lote.codigo),
                  _buildInfoRow(
                    S.of(context).batchBirdType,
                    widget.lote.tipoAve.localizedDisplayName(S.of(context)),
                  ),
                  _buildInfoRow(
                    S.of(context).batchCloseDateSimple,
                    DateFormat('dd/MM/yyyy').format(_fechaCierre),
                  ),
                  _buildInfoRow(
                    S.of(context).batchCycleDuration,
                    S.of(context).batchDaysInCycle(duracionCiclo),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapBase,

          // Datos finales
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).batchFinalData,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    S.of(context).batchInitialCount,
                    S
                        .of(context)
                        .batchInitialCountBirds(widget.lote.cantidadInicial),
                  ),
                  _buildInfoRow(
                    S.of(context).batchFinalCount,
                    S.of(context).batchInitialCountBirds(cantidadFinal),
                  ),
                  _buildInfoRow(
                    S.of(context).batchTotalMortality,
                    S.of(context).birdCountWithPercent('$mortalidadTotal', ((mortalidadTotal / widget.lote.cantidadInicial) * 100).toStringAsFixed(2)),
                  ),
                  if (_pesoFinalController.text.isNotEmpty)
                    _buildInfoRow(
                      S.of(context).batchFinalWeightAvg,
                      '${_pesoFinalController.text} g',
                    ),
                ],
              ),
            ),
          ),
          AppSpacing.gapBase,

          // Motivo y observaciones
          if (_motivoCierreController.text.isNotEmpty ||
              _observacionesController.text.isNotEmpty)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).batchClosureNotes,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(height: 24),
                    if (_motivoCierreController.text.isNotEmpty)
                      _buildInfoRow(
                        S.of(context).batchReason,
                        _motivoCierreController.text,
                      ),
                    if (_observacionesController.text.isNotEmpty)
                      _buildInfoRow(
                        S.of(context).batchObservations,
                        _observacionesController.text,
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ==================== HELPERS ====================

  Widget _buildInfoRow(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> items,
  ) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                AppSpacing.hGapMd,
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color? valueColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
