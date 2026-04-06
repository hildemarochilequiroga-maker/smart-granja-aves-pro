/// Diálogo para filtrar lotes en la lista.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/enums/enums.dart';

/// Resultado del filtrado de lotes.
class LoteFilterResult {
  const LoteFilterResult({
    this.estado,
    this.tipoAve,
    this.galponId,
    this.fechaDesde,
    this.fechaHasta,
  });

  final EstadoLote? estado;
  final TipoAve? tipoAve;
  final String? galponId;
  final DateTime? fechaDesde;
  final DateTime? fechaHasta;

  bool get hasFilters =>
      estado != null ||
      tipoAve != null ||
      galponId != null ||
      fechaDesde != null ||
      fechaHasta != null;

  int get activeFiltersCount {
    var count = 0;
    if (estado != null) count++;
    if (tipoAve != null) count++;
    if (galponId != null) count++;
    if (fechaDesde != null) count++;
    if (fechaHasta != null) count++;
    return count;
  }
}

/// Diálogo para filtrar lotes.
class LoteFilterDialog extends StatefulWidget {
  const LoteFilterDialog({this.initialFilters, super.key});

  final LoteFilterResult? initialFilters;

  @override
  State<LoteFilterDialog> createState() => _LoteFilterDialogState();

  static Future<LoteFilterResult?> show(
    BuildContext context, {
    LoteFilterResult? initialFilters,
  }) {
    return showDialog<LoteFilterResult>(
      context: context,
      builder: (context) => LoteFilterDialog(initialFilters: initialFilters),
    );
  }
}

class _LoteFilterDialogState extends State<LoteFilterDialog> {
  EstadoLote? _estado;
  TipoAve? _tipoAve;
  String? _galponId;
  DateTime? _fechaDesde;
  DateTime? _fechaHasta;

  @override
  void initState() {
    super.initState();
    _estado = widget.initialFilters?.estado;
    _tipoAve = widget.initialFilters?.tipoAve;
    _galponId = widget.initialFilters?.galponId;
    _fechaDesde = widget.initialFilters?.fechaDesde;
    _fechaHasta = widget.initialFilters?.fechaHasta;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      title: Row(
        children: [
          const Icon(Icons.filter_list),
          AppSpacing.hGapMd,
          Text(S.of(context).batchFilterTitle),
          const Spacer(),
          if (_hasActiveFilters)
            TextButton.icon(
              onPressed: _limpiarFiltros,
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(S.of(context).batchFilterClear),
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado
              Text(
                S.of(context).batchFilterStatus,
                style: AppTextStyles.titleSmall,
              ),
              AppSpacing.gapSm,
              DropdownButtonFormField<EstadoLote>(
                initialValue: _estado,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: S.of(context).batchFilterAll,
                  prefixIcon: const Icon(Icons.radio_button_checked),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(S.of(context).batchFilterAll),
                  ),
                  ...EstadoLote.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Text(e.icono, style: theme.textTheme.titleMedium),
                          AppSpacing.hGapSm,
                          Text(e.localizedDisplayName(S.of(context))),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _estado = value),
              ),
              AppSpacing.gapBase,

              // Tipo de ave
              Text(
                S.of(context).batchFilterBirdType,
                style: AppTextStyles.titleSmall,
              ),
              AppSpacing.gapSm,
              DropdownButtonFormField<TipoAve>(
                initialValue: _tipoAve,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: S.of(context).batchFilterAll,
                  prefixIcon: const Icon(Icons.pets),
                  isDense: true,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(S.of(context).batchFilterAll),
                  ),
                  ...TipoAve.values.map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Text(e.icono, style: theme.textTheme.titleMedium),
                          AppSpacing.hGapSm,
                          Text(e.localizedDisplayName(S.of(context))),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _tipoAve = value),
              ),
              AppSpacing.gapBase,

              // Rango de fechas
              Text(
                S.of(context).batchFilterEntryDate,
                style: AppTextStyles.titleSmall,
              ),
              AppSpacing.gapSm,
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _seleccionarFechaDesde,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: S.of(context).batchFilterFrom,
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        child: Text(
                          _fechaDesde != null
                              ? '${_fechaDesde!.day}/${_fechaDesde!.month}/${_fechaDesde!.year}'
                              : S.of(context).batchFilterAny,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: InkWell(
                      onTap: _seleccionarFechaHasta,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: S.of(context).batchFilterTo,
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                        child: Text(
                          _fechaHasta != null
                              ? '${_fechaHasta!.day}/${_fechaHasta!.month}/${_fechaHasta!.year}'
                              : S.of(context).batchFilterAny,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.onSurfaceVariant,
          ),
          child: Text(S.of(context).batchFilterCancel),
        ),
        FilledButton.icon(
          onPressed: _aplicarFiltros,
          icon: const Icon(Icons.check),
          style: FilledButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.allSm),
          ),
          label: Text(S.of(context).batchFilterApply),
        ),
      ],
    );
  }

  bool get _hasActiveFilters =>
      _estado != null ||
      _tipoAve != null ||
      _galponId != null ||
      _fechaDesde != null ||
      _fechaHasta != null;

  void _limpiarFiltros() {
    setState(() {
      _estado = null;
      _tipoAve = null;
      _galponId = null;
      _fechaDesde = null;
      _fechaHasta = null;
    });
  }

  Future<void> _seleccionarFechaDesde() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaDesde ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (fecha != null) {
      setState(() => _fechaDesde = fecha);
    }
  }

  Future<void> _seleccionarFechaHasta() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHasta ?? DateTime.now(),
      firstDate: _fechaDesde ?? DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (fecha != null) {
      setState(() => _fechaHasta = fecha);
    }
  }

  void _aplicarFiltros() {
    Navigator.of(context).pop(
      LoteFilterResult(
        estado: _estado,
        tipoAve: _tipoAve,
        galponId: _galponId,
        fechaDesde: _fechaDesde,
        fechaHasta: _fechaHasta,
      ),
    );
  }
}
