/// Pantalla de desglose detallado del costo por ave de un lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/presentation/widgets/form_text_scale.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../costos/domain/enums/tipo_gasto.dart';
import '../../../costos/presentation/widgets/costo_tipo_visuals.dart';
import '../../application/providers/costo_por_ave_provider.dart';
import '../../domain/entities/lote.dart';
import '../../domain/value_objects/costo_por_ave.dart';

/// Muestra el desglose completo del costo acumulado por ave viva de un lote.
class CostoPorAvePage extends ConsumerWidget {
  const CostoPorAvePage({super.key, required this.lote});

  final Lote lote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final costoAsync = ref.watch(
      costoPorAveProvider(CostoPorAveParams(loteId: lote.id)),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: FormTextScale(child: Text(S.of(context).batchCostPerBird)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: FormTextScale(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              costoPorAveProvider(CostoPorAveParams(loteId: lote.id)),
            );
          },
          child: costoAsync.when(
            data: (costo) => _buildDetalle(context, theme, costo),
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, __) => ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text(S.of(context).commonErrorLoading)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetalle(
    BuildContext context,
    ThemeData theme,
    CostoPorAve costo,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Bloque destacado: costo por ave
        _HeroCostoPorAve(costo: costo),
        const SizedBox(height: AppSpacing.lg),

        // Desglose por fuente
        _SeccionTitulo(titulo: S.of(context).batchCostBreakdown),
        const SizedBox(height: AppSpacing.sm),
        _CardDesglose(
          filas: [
            _FilaCosto(
              label: S.of(context).costoTypeCompraAves,
              valor: costo.costoInicialAves,
            ),
            _FilaCosto(
              label: S.of(context).batchFeedCost,
              valor: costo.costoAlimento,
            ),
            _FilaCosto(
              label: S.of(context).batchDirectExpenses,
              valor: costo.costoGastosDirectos,
            ),
            _FilaCosto(
              label: S.of(context).batchSharedExpenses,
              valor: costo.costoGastosCompartidos,
            ),
          ],
          total: costo.costoAcumuladoTotal,
          totalLabel: S.of(context).batchTotalAccumulated,
        ),

        // Desglose por tipo de gasto (si hay)
        if (costo.desglosePorTipo.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _SeccionTitulo(titulo: S.of(context).batchCostByType),
          const SizedBox(height: AppSpacing.sm),
          _CardDesglosePorTipo(desglose: costo.desglosePorTipo),
        ],

        // Costos pendientes de registrar (atajos al formulario)
        ..._buildPendientes(context, costo),

        // Base del cálculo
        const SizedBox(height: AppSpacing.lg),
        _SeccionTitulo(titulo: S.of(context).batchCalcBasis),
        const SizedBox(height: AppSpacing.sm),
        _CardBase(costo: costo),

        // Avisos
        if (costo.faltaCostoInicial || costo.consumosSinCosto > 0) ...[
          const SizedBox(height: AppSpacing.lg),
          if (costo.faltaCostoInicial)
            _Aviso(texto: S.of(context).batchMissingInitialCost),
          if (costo.consumosSinCosto > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _Aviso(
              texto: S
                  .of(context)
                  .batchConsumosSinCosto(costo.consumosSinCosto.toString()),
            ),
          ],
        ],
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  /// Tipos de gasto DIRECTOS al lote sugeridos para registrar. Solo se incluyen
  /// los directos porque el formulario de costo descarta el lote en tipos no
  /// directos (mano de obra, energía, etc. son gastos a nivel granja) y no
  /// entrarían en el costo por ave del lote.
  static const _tiposSugeridos = <TipoGasto>[
    TipoGasto.compraAves,
    TipoGasto.alimento,
    TipoGasto.medicamento,
    TipoGasto.cama,
  ];

  /// Construye la sección de "costos pendientes": botones de los tipos
  /// sugeridos que aún NO tienen monto registrado para el lote. Cada botón
  /// abre el registro de costo con el tipo y el lote ya preseleccionados.
  List<Widget> _buildPendientes(BuildContext context, CostoPorAve costo) {
    // Un tipo está "registrado" si aparece con monto > 0 en el desglose.
    // El alimento se considera registrado si hay costo de alimento (viene de
    // los consumos, no del desglose por tipo).
    bool registrado(TipoGasto t) {
      if (t == TipoGasto.alimento) return costo.costoAlimento > 0;
      if (t == TipoGasto.compraAves) return costo.costoInicialAves > 0;
      return (costo.desglosePorTipo[t] ?? 0) > 0;
    }

    final pendientes =
        _tiposSugeridos.where((t) => !registrado(t)).toList();
    if (pendientes.isEmpty) return const [];

    return [
      const SizedBox(height: AppSpacing.lg),
      _SeccionTitulo(titulo: S.of(context).batchPendingCosts),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: pendientes
            .map((t) => _BotonPendiente(tipo: t, lote: lote))
            .toList(),
      ),
    ];
  }
}

/// Botón-chip de un costo pendiente: abre el registro con el tipo y lote
/// preseleccionados.
class _BotonPendiente extends StatelessWidget {
  const _BotonPendiente({required this.tipo, required this.lote});

  final TipoGasto tipo;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = tipo.color;
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: AppRadius.allSm,
      child: InkWell(
        borderRadius: AppRadius.allSm,
        onTap: () => context.push(
          AppRoutes.costoRegistrarConTipo(lote.id, lote.granjaId, tipo.name),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                tipo.displayName,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bloque destacado con el costo por ave y el total.
class _HeroCostoPorAve extends StatelessWidget {
  const _HeroCostoPorAve({required this.costo});

  final CostoPorAve costo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            S.of(context).batchCostPerBird,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            costo.sinDatosDeCosto
                ? S.of(context).batchNoCostData
                : Formatters.currencyValue(costo.costoPorAveViva),
            style: costo.sinDatosDeCosto
                ? theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SeccionTitulo extends StatelessWidget {
  const _SeccionTitulo({required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      titulo,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _FilaCosto {
  const _FilaCosto({required this.label, required this.valor});
  final String label;
  final double valor;
}

/// Card de desglose por fuente con su total.
class _CardDesglose extends StatelessWidget {
  const _CardDesglose({
    required this.filas,
    required this.total,
    required this.totalLabel,
  });

  final List<_FilaCosto> filas;
  final double total;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final f in filas) ...[
            _filaRow(theme, f.label, Formatters.currencyValue(f.valor)),
            const SizedBox(height: 10),
          ],
          Divider(color: theme.colorScheme.outlineVariant, height: 1),
          const SizedBox(height: 10),
          _filaRow(
            theme,
            totalLabel,
            Formatters.currencyValue(total),
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _filaRow(ThemeData theme, String label, String valor,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: bold
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          valor,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: bold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Card de desglose por tipo de gasto (con color del tipo).
class _CardDesglosePorTipo extends StatelessWidget {
  const _CardDesglosePorTipo({required this.desglose});

  final Map<TipoGasto, double> desglose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entradas = desglose.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allMd,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (int i = 0; i < entradas.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: entradas[i].key.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    entradas[i].key.displayName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  Formatters.currencyValue(entradas[i].value),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Card con la base del cálculo (aves vivas y costo total).
class _CardBase extends StatelessWidget {
  const _CardBase({required this.costo});

  final CostoPorAve costo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.allMd,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).batchLiveBirdsBasis(costo.avesVivas.toString()),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _Aviso extends StatelessWidget {
  const _Aviso({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      texto,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
