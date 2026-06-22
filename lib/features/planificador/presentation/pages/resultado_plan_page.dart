/// Página de resultado del Planificador Avícola.
///
/// Muestra el plan completo con secciones expandibles y opciones para
/// descargar PDF o crear granja con datos pre-llenados.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../application/providers/planificador_provider.dart';
import '../../application/services/plan_pdf_generator.dart';
import '../../domain/entities/plan_avicola.dart';
import '../widgets/galpon_diagram_section.dart';
import '../widgets/materiales_content.dart';

class ResultadoPlanPage extends ConsumerWidget {
  const ResultadoPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(planResultadoProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu Plan Avícola'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Descargar PDF',
            onPressed: () => _descargarPdf(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ResumenCard(plan: plan),
          const SizedBox(height: 12),
          _SeccionBoton(
            titulo: 'Infraestructura',
            icono: Icons.home_work_outlined,
            color: AppColors.info,
            resumen:
                '${plan.infraestructura.areaRequeridaM2.toStringAsFixed(0)} m² — ${plan.infraestructura.largoM.toStringAsFixed(1)}×${plan.infraestructura.anchoM.toStringAsFixed(1)} m',
            onTap: () => _abrirSheet(
              context,
              'Infraestructura',
              Icons.home_work_outlined,
              AppColors.info,
              _InfraestructuraContent(infra: plan.infraestructura),
            ),
          ),
          _SeccionBoton(
            titulo: 'Diagrama del Galpón',
            icono: Icons.view_in_ar_outlined,
            color: AppColors.success,
            resumen: 'Vista 3D y planta de distribución',
            onTap: () => _abrirSheet(
              context,
              'Diagrama del Galpón',
              Icons.view_in_ar_outlined,
              AppColors.success,
              GalponDiagramSection(plan: plan),
              fullHeight: true,
            ),
          ),
          _SeccionBoton(
            titulo: 'Plan de Alimentación',
            icono: Icons.restaurant_outlined,
            color: AppColors.warning,
            resumen:
                '${plan.alimentacion.fases.length} fases — ${plan.alimentacion.consumoTotalLoteKg.toStringAsFixed(0)} kg total',
            onTap: () => _abrirSheet(
              context,
              'Plan de Alimentación',
              Icons.restaurant_outlined,
              AppColors.warning,
              _AlimentacionContent(alim: plan.alimentacion),
            ),
          ),
          _SeccionBoton(
            titulo: 'Programa de Vacunación',
            icono: Icons.vaccines_outlined,
            color: AppColors.error,
            resumen: '${plan.vacunacion.vacunas.length} vacunas programadas',
            onTap: () => _abrirSheet(
              context,
              'Programa de Vacunación',
              Icons.vaccines_outlined,
              AppColors.error,
              _VacunacionContent(vac: plan.vacunacion),
            ),
          ),
          _SeccionBoton(
            titulo: 'Manejo Ambiental',
            icono: Icons.thermostat_outlined,
            color: AppColors.tertiary,
            resumen:
                '${plan.manejoAmbiental.temperaturaOptima} — ${plan.manejoAmbiental.tipoVentilacion}',
            onTap: () => _abrirSheet(
              context,
              'Manejo Ambiental',
              Icons.thermostat_outlined,
              AppColors.tertiary,
              _AmbientalContent(amb: plan.manejoAmbiental),
            ),
          ),
          _SeccionBoton(
            titulo: 'Equipamiento',
            icono: Icons.build_outlined,
            color: AppColors.secondary,
            resumen: '${plan.equipamiento.length} items requeridos',
            onTap: () => _abrirSheet(
              context,
              'Equipamiento',
              Icons.build_outlined,
              AppColors.secondary,
              _EquipamientoContent(items: plan.equipamiento),
            ),
          ),
          _SeccionBoton(
            titulo: 'Materiales de Construcción',
            icono: Icons.construction_outlined,
            color: AppColors.primary,
            resumen: 'Estructura, cubierta, cerramientos y ferretería',
            onTap: () => _abrirSheet(
              context,
              'Materiales de Construcción',
              Icons.construction_outlined,
              AppColors.primary,
              MaterialesContent(infra: plan.infraestructura),
              fullHeight: true,
            ),
          ),
          _SeccionBoton(
            titulo: 'Cronograma',
            icono: Icons.calendar_month_outlined,
            color: AppColors.info,
            resumen: '${plan.cronograma.length} eventos',
            onTap: () => _abrirSheet(
              context,
              'Cronograma',
              Icons.calendar_month_outlined,
              AppColors.info,
              _CronogramaContent(
                eventos: plan.cronograma,
                tipo: plan.input.tipoProduccion,
              ),
              fullHeight: true,
            ),
          ),
          const SizedBox(height: 24),

          // Botones de acción
          _buildAcciones(context, theme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _abrirSheet(
    BuildContext context,
    String titulo,
    IconData icono,
    Color color,
    Widget child, {
    bool fullHeight = false,
  }) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _SheetWrapper(
          titulo: titulo,
          icono: icono,
          color: color,
          fullHeight: fullHeight,
          child: child,
        ),
      ),
    );
  }

  Widget _buildAcciones(BuildContext context, ThemeData theme) {
    return Consumer(
      builder: (context, ref, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.primary(
            label: 'Descargar PDF Completo',
            icon: Icons.picture_as_pdf,
            onPressed: () => _descargarPdf(context, ref),
            expanded: true,
            height: 52,
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            label: 'Modificar Parámetros',
            icon: Icons.edit,
            onPressed: () => Navigator.of(context).pop(),
            expanded: true,
          ),
        ],
      ),
    );
  }

  Future<void> _descargarPdf(BuildContext context, WidgetRef ref) async {
    await HapticFeedback.mediumImpact();
    final plan = ref.read(planResultadoProvider);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Generando PDF...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

    try {
      final bytes = await PlanPdfGenerator.generar(plan);
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }
      await Printing.sharePdf(
        bytes: bytes,
        filename: 'plan_avicola_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.error(context, message: 'Error al generar PDF: $e');
      }
    }
  }
}

// =============================================================================
// RESUMEN CARD
// =============================================================================

class _ResumenCard extends StatelessWidget {
  const _ResumenCard({required this.plan});

  final ResultadoPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.15),
            AppColors.info.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.success,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Resumen del Plan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _KpiChip(
                label: plan.input.tipoProduccion == TipoProduccion.engorde
                    ? 'Engorde'
                    : 'Ponedora',
                value: plan.input.nombreRaza,
                color: AppColors.info,
              ),
              const SizedBox(width: 8),
              _KpiChip(
                label: 'Aves',
                value: '${plan.input.cantidadAves}',
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              _KpiChip(
                label: 'Zona',
                value: plan.input.zona.nombre,
                color: AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BOTÓN DE SECCIÓN (abre BottomSheet)
// =============================================================================

class _SeccionBoton extends StatelessWidget {
  const _SeccionBoton({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.resumen,
    required this.onTap,
  });

  final String titulo;
  final IconData icono;
  final Color color;
  final String resumen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.surface,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icono, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        resumen,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BOTTOM SHEET WRAPPER
// =============================================================================

class _SheetWrapper extends StatelessWidget {
  const _SheetWrapper({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.child,
    this.fullHeight = false,
  });

  final String titulo;
  final IconData icono;
  final Color color;
  final Widget child;
  final bool fullHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.of(context).size.height * (fullHeight ? 0.92 : 0.75),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icono, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONTENIDO DE SECCIONES
// =============================================================================

class _InfraestructuraContent extends StatelessWidget {
  const _InfraestructuraContent({required this.infra});
  final InfraestructuraRecomendada infra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TablaInfo(
          titulo: 'Dimensiones',
          filas: [
            ('Área Total', '${infra.areaRequeridaM2.toStringAsFixed(1)} m²'),
            (
              'Largo × Ancho',
              '${infra.largoM.toStringAsFixed(1)} × ${infra.anchoM.toStringAsFixed(1)} m',
            ),
            ('Densidad', '${infra.densidadAvesM2} aves/m²'),
            ('Altura Cumbrera', '${infra.alturaCumbreraM} m'),
            ('Altura Alero', '${infra.alturaAleroM} m'),
          ],
        ),
        const SizedBox(height: 12),
        _TablaInfo(
          titulo: 'Construcción',
          filas: [
            ('Tipo de Techo', infra.tipoTecho),
            ('Orientación', infra.orientacion),
          ],
        ),
        if (infra.observaciones.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Observaciones',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...infra.observaciones.map(
            (o) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('  •  ', style: TextStyle(fontSize: 12)),
                  Expanded(child: Text(o, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AlimentacionContent extends StatelessWidget {
  const _AlimentacionContent({required this.alim});
  final PlanAlimentacion alim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cards por fase
        ...alim.fases.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          final colors = [
            AppColors.info,
            AppColors.warning,
            AppColors.success,
            AppColors.error,
          ];
          final color = colors[i % colors.length];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        f.nombre,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f.periodo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _AlimStat(
                      label: 'g/ave/día',
                      value: f.consumoDiarioPorAveG.toStringAsFixed(0),
                      color: color,
                    ),
                    const SizedBox(width: 12),
                    _AlimStat(
                      label: 'kg/ave',
                      value: f.consumoTotalPorAveKg.toStringAsFixed(2),
                      color: color,
                    ),
                    const SizedBox(width: 12),
                    _AlimStat(
                      label: 'kg Lote',
                      value: f.consumoTotalLoteKg.toStringAsFixed(0),
                      color: color,
                    ),
                    const SizedBox(width: 12),
                    _AlimStat(
                      label: 'Proteína',
                      value: '${f.proteina.toStringAsFixed(1)}%',
                      color: color,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 6),
        // Resumen totales
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AlimTotal(
                label: 'Consumo/ave',
                value: '${alim.consumoTotalPorAveKg.toStringAsFixed(2)} kg',
              ),
              Container(
                width: 1,
                height: 28,
                color: AppColors.success.withValues(alpha: 0.2),
              ),
              _AlimTotal(
                label: 'Consumo lote',
                value: '${alim.consumoTotalLoteKg.toStringAsFixed(0)} kg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlimStat extends StatelessWidget {
  const _AlimStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 9,
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlimTotal extends StatelessWidget {
  const _AlimTotal({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}

class _VacunacionContent extends StatelessWidget {
  const _VacunacionContent({required this.vac});
  final PlanVacunacion vac;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TablaEncabezada(
          columnas: const ['Día', 'Vacuna', 'Vía', 'Dosis'],
          filas: vac.vacunas
              .map((v) => ['D${v.dia}', v.nombre, v.via, '${v.dosisTotales}'])
              .toList(),
        ),
      ],
    );
  }
}

class _AmbientalContent extends StatelessWidget {
  const _AmbientalContent({required this.amb});
  final RecomendacionAmbiental amb;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TablaInfo(
          filas: [
            ('Temperatura óptima', amb.temperaturaOptima),
            ('Humedad relativa', amb.humedadRelativa),
            ('Ventilación', amb.tipoVentilacion),
            ('Cortinas', amb.tipoCortinas),
          ],
        ),
        if (amb.notasEspeciales.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'Notas especiales',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          ...amb.notasEspeciales.map(
            (n) => Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('  •  ', style: TextStyle(fontSize: 12)),
                  Expanded(child: Text(n, style: theme.textTheme.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EquipamientoContent extends StatelessWidget {
  const _EquipamientoContent({required this.items});
  final List<ItemEquipamiento> items;

  @override
  Widget build(BuildContext context) {
    return _TablaEncabezada(
      columnas: const ['Equipo', 'Cantidad'],
      filas: items.map((e) => [e.nombre, '×${e.cantidad}']).toList(),
    );
  }
}

class _CronogramaContent extends StatelessWidget {
  const _CronogramaContent({required this.eventos, required this.tipo});
  final List<EventoCronograma> eventos;
  final TipoProduccion tipo;

  @override
  Widget build(BuildContext context) {
    final unidad = tipo == TipoProduccion.engorde ? 'Día' : 'Sem';
    return _TablaEncabezada(
      columnas: [unidad, 'Categoría', 'Evento', 'Descripción'],
      filas: eventos
          .map((e) => ['${e.dia}', e.categoria.name, e.titulo, e.descripcion])
          .toList(),
    );
  }
}

// =============================================================================
// WIDGETS REUTILIZABLES
// =============================================================================

class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Tabla simple label–value (dos columnas, sin encabezado).
class _TablaInfo extends StatelessWidget {
  const _TablaInfo({required this.filas, this.titulo});
  final List<(String, String)> filas;
  final String? titulo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titulo != null) ...[
          Text(
            titulo!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Table(
          columnWidths: const {0: FlexColumnWidth(3), 1: FlexColumnWidth(2)},
          children: [
            for (var i = 0; i < filas.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i.isEven
                      ? theme.colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.4,
                        )
                      : null,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    child: Text(filas[i].$1, style: theme.textTheme.bodySmall),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 8,
                    ),
                    child: Text(
                      filas[i].$2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// Tabla con columnas de encabezado y filas de datos (multi-columna).
class _TablaEncabezada extends StatelessWidget {
  const _TablaEncabezada({required this.columnas, required this.filas});
  final List<String> columnas;
  final List<List<String>> filas;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 36,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 48,
        columnSpacing: 14,
        horizontalMargin: 8,
        headingTextStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
        dataTextStyle: theme.textTheme.bodySmall,
        columns: columnas.map((c) => DataColumn(label: Text(c))).toList(),
        rows: [
          for (var i = 0; i < filas.length; i++)
            DataRow(
              color: WidgetStateProperty.resolveWith(
                (_) => i.isEven
                    ? theme.colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      )
                    : null,
              ),
              cells: filas[i].map((v) => DataCell(Text(v))).toList(),
            ),
        ],
      ),
    );
  }
}
