/// Página principal de reportes.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_breakpoints.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_filter_tab.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/reportes_provider.dart';
import '../../domain/enums/enums.dart';
import '../widgets/reporte_card.dart';
import '../widgets/reporte_preview_dialog.dart';

/// Página principal del módulo de reportes.
class ReportesPage extends ConsumerStatefulWidget {
  const ReportesPage({super.key});

  @override
  ConsumerState<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends ConsumerState<ReportesPage> {
  bool _isGenerating = false;

  DateFormat get _dateFormat => Formatters.fechaCorta;

  @override
  Widget build(BuildContext context) {
    final granja = ref.watch(granjaSeleccionadaProvider);
    final tipoSeleccionado = ref.watch(tipoReporteSeleccionadoProvider);
    final periodoSeleccionado = ref.watch(periodoReporteSeleccionadoProvider);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: Text(S.of(context).reportPageTitle)),
      body: granja == null
          ? _buildNoGranjaMessage()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con información de granja
                        _buildGranjaHeader(granja.nombre),
                        AppSpacing.gapXl,

                        // Selector de período
                        _buildPeriodoSelector(periodoSeleccionado),
                        AppSpacing.gapXl,

                        // Tipos de reportes
                        _buildSeccionTitulo(S.of(context).reportSelectType),
                        AppSpacing.gapMd,
                        _buildReportesGrid(tipoSeleccionado),
                        AppSpacing.gapBase,
                      ],
                    ),
                  ),
                ),
                // Botón fijo en la parte inferior
                _buildGenerarButtonFixed(tipoSeleccionado),
              ],
            ),
    );
  }

  Widget _buildNoGranjaMessage() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_rounded, size: 64, color: colorScheme.outline),
            AppSpacing.gapBase,
            Text(
              S.of(context).reportSelectFarm,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).reportSelectFarmHint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGranjaHeader(String granjaNombre) {
    final theme = Theme.of(context);
    final periodo = ref.watch(periodoReporteSeleccionadoProvider);
    final fechaInicio = periodo == PeriodoReporte.personalizado
        ? ref.watch(fechaInicioReporteProvider)
        : periodo.fechaInicio;
    final fechaFin = periodo == PeriodoReporte.personalizado
        ? ref.watch(fechaFinReporteProvider)
        : periodo.fechaFin;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allLg,
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: AppRadius.allMd,
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
              AppSpacing.hGapBase,
              Expanded(
                child: Text(
                  granjaNombre,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.white.withValues(alpha: 0.7),
                size: 32,
              ),
            ],
          ),
          AppSpacing.gapBase,
          // Período de reporte mejorado
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: AppRadius.allMd,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  color: AppColors.white.withValues(alpha: 0.9),
                  size: 18,
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Text(
                    S
                        .of(context)
                        .reportsPeriodLabel(
                          _formatPeriodoReporte(fechaInicio, fechaFin),
                        ),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white.withValues(alpha: 0.95),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPeriodoReporte(DateTime inicio, DateTime fin) {
    final locale = Formatters.currentLocale;
    final dateFormat = DateFormat.yMMMd(locale);
    return '${dateFormat.format(inicio)} - ${dateFormat.format(fin)}';
  }

  Widget _buildPeriodoSelector(PeriodoReporte periodoSeleccionado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSeccionTitulo(S.of(context).reportPeriodTitle),
        AppSpacing.gapMd,
        AppFilterTabRow(
          tabs: PeriodoReporte.values.map((periodo) {
            final isSelected = periodo == periodoSeleccionado;
            return AppFilterTab(
              label: periodo.displayName,
              isSelected: isSelected,
              color: AppColors.success,
              onTap: () {
                ref.read(periodoReporteSeleccionadoProvider.notifier).state =
                    periodo;
                if (periodo == PeriodoReporte.personalizado) {
                  _showDateRangePicker();
                }
              },
            );
          }).toList(),
        ),
        if (periodoSeleccionado == PeriodoReporte.personalizado) ...[
          AppSpacing.gapMd,
          _buildFechasPersonalizadas(),
        ],
      ],
    );
  }

  Widget _buildFechasPersonalizadas() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fechaInicio = ref.watch(fechaInicioReporteProvider);
    final fechaFin = ref.watch(fechaFinReporteProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppRadius.allMd,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(isStart: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).reportDateFrom,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXxs,
                  Text(
                    _dateFormat.format(fechaInicio),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          Container(width: 1, height: 40, color: colorScheme.outlineVariant),
          AppSpacing.hGapBase,
          Expanded(
            child: InkWell(
              onTap: () => _selectDate(isStart: false),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).reportDateTo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXxs,
                  Text(
                    _dateFormat.format(fechaFin),
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.edit_calendar_rounded,
              color: AppColors.success,
            ),
            onPressed: _showDateRangePicker,
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      titulo,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildReportesGrid(TipoReporte tipoSeleccionado) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppBreakpoints.of(context).gridColumns,
        childAspectRatio: 1.4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: TipoReporte.values.length,
      itemBuilder: (context, index) {
        final tipo = TipoReporte.values[index];
        final isSelected = tipo == tipoSeleccionado;

        return ReporteCard(
          tipo: tipo,
          isSelected: isSelected,
          onTap: () {
            ref.read(tipoReporteSeleccionadoProvider.notifier).state = tipo;
          },
        );
      },
    );
  }

  Widget _buildGenerarButtonFixed(TipoReporte tipoSeleccionado) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _isGenerating
                ? null
                : () => _generarReporte(tipoSeleccionado),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
              elevation: 0,
            ),
            icon: _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 22,
                    color: AppColors.white,
                  ),
            label: Text(
              _isGenerating
                  ? S.of(context).reportGenerating
                  : S.of(context).reportGeneratePdf,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final initialDate = isStart
        ? ref.read(fechaInicioReporteProvider)
        : ref.read(fechaFinReporteProvider);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.success),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        ref.read(fechaInicioReporteProvider.notifier).state = picked;
      } else {
        ref.read(fechaFinReporteProvider.notifier).state = picked;
      }
    }
  }

  Future<void> _showDateRangePicker() async {
    final fechaInicio = ref.read(fechaInicioReporteProvider);
    final fechaFin = ref.read(fechaFinReporteProvider);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: fechaInicio, end: fechaFin),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.success),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(fechaInicioReporteProvider.notifier).state = picked.start;
      ref.read(fechaFinReporteProvider.notifier).state = picked.end;
    }
  }

  Future<void> _generarReporte(TipoReporte tipo) async {
    setState(() => _isGenerating = true);

    try {
      final pdfService = ref.read(pdfGeneratorServiceProvider);
      final granja = ref.read(granjaSeleccionadaProvider);

      if (granja == null) {
        if (mounted) {
          AppSnackBar.warning(
            context,
            message: S.of(context).reportNoFarmSelected,
          );
        }
        return;
      }

      final periodo = ref.read(periodoReporteSeleccionadoProvider);
      final fechaInicio = periodo == PeriodoReporte.personalizado
          ? ref.read(fechaInicioReporteProvider)
          : periodo.fechaInicio;
      final fechaFin = periodo == PeriodoReporte.personalizado
          ? ref.read(fechaFinReporteProvider)
          : periodo.fechaFin;

      final Uint8List pdfBytes;

      // Obtener nombre del usuario autenticado
      final usuario = ref.read(currentUserProvider);
      final generadoPor = usuario?.nombreCompleto.isNotEmpty == true
          ? usuario!.nombreCompleto
          : usuario?.email ?? S.of(context).commonUser;

      // Generar PDF según el tipo seleccionado
      switch (tipo) {
        case TipoReporte.costos:
          final datosCostos = await ref.read(
            datosCostosParaReporteProvider.future,
          );
          final costosPorCategoria = await ref.read(
            costosPorCategoriaProvider.future,
          );
          final totalCostos = datosCostos.fold<double>(
            0,
            (sum, c) => sum + c.monto,
          );
          pdfBytes = await pdfService.generarReporteCostos(
            costos: datosCostos,
            granjaNombre: granja.nombre,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            generadoPor: generadoPor,
            totalCostos: totalCostos,
            costosPorCategoria: costosPorCategoria,
          );
        case TipoReporte.ventas:
          final datosVentas = await ref.read(
            datosVentasParaReporteProvider.future,
          );
          final ventasPorProducto = await ref.read(
            ventasPorProductoProvider.future,
          );
          final totalVentas = datosVentas.fold<double>(
            0,
            (sum, v) => sum + v.subtotal,
          );
          pdfBytes = await pdfService.generarReporteVentas(
            ventas: datosVentas,
            granjaNombre: granja.nombre,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            generadoPor: generadoPor,
            totalVentas: totalVentas,
            ventasPorProducto: ventasPorProducto,
          );
        case TipoReporte.produccionLote:
          // Obtener el primer lote activo para reporte individual
          final lotes = await ref.read(datosLotesParaReporteProvider.future);
          if (lotes.isEmpty) {
            if (mounted) {
              AppSnackBar.warning(
                context,
                message: S.of(context).reportNoActiveBatches,
              );
            }
            return;
          }
          pdfBytes = await pdfService.generarReporteProduccionLote(
            datos: lotes.first,
            granjaNombre: granja.nombre,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            generadoPor: generadoPor,
          );
        case TipoReporte.ejecutivo:
        case TipoReporte.rentabilidad:
        case TipoReporte.mortalidad:
        case TipoReporte.consumo:
        case TipoReporte.peso:
        case TipoReporte.salud:
        case TipoReporte.inventario:
          // Estos tipos usan el reporte ejecutivo como base
          final resumen = await ref.read(resumenEjecutivoProvider.future);
          final lotes = await ref.read(datosLotesParaReporteProvider.future);
          if (resumen == null) {
            if (mounted) {
              AppSnackBar.warning(
                context,
                message: S.of(context).reportInsufficientData,
              );
            }
            return;
          }
          pdfBytes = await pdfService.generarReporteEjecutivo(
            resumen: resumen,
            granjaNombre: granja.nombre,
            fechaInicio: fechaInicio,
            fechaFin: fechaFin,
            generadoPor: generadoPor,
            lotesActivos: lotes,
          );
      }

      if (mounted) {
        // Mostrar diálogo de vista previa
        unawaited(
          showDialog(
            context: context,
            builder: (context) => ReportePreviewDialog(
              pdfBytes: pdfBytes,
              nombreReporte: '${tipo.displayName} - ${granja.nombre}',
            ),
          ),
        );
      }
    } catch (e, stack) {
      Logger().e('Error generando reporte', error: e, stackTrace: stack);
      if (mounted) {
        AppSnackBar.error(
          context,
          message: S.of(context).reportGenerateError,
          detail: ErrorHandler.getUserFriendlyMessage(e),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}
