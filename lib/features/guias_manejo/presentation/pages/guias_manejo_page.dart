/// Página principal de Guías de Manejo Técnico para un lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../application/providers/guias_providers.dart';
import '../../application/services/guias_calculator.dart';
import '../widgets/guia_resumen_card.dart';
import '../widgets/guia_tabla_widget.dart';

class GuiasManejoPage extends ConsumerWidget {
  const GuiasManejoPage({required this.lote, super.key});

  final Lote lote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final result = ref.watch(guiasLoteProvider(lote));

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLowest,
        appBar: AppBar(
          title: Text(l.guiasManejoTitle),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: [
              Tab(text: l.guiaLuzTitle),
              Tab(text: l.guiaAlimentacionTitle),
              Tab(text: l.guiaPesoTitle),
              Tab(text: l.guiaAguaTitle),
              Tab(text: l.guiaTemperaturaTitle),
              Tab(text: l.guiaHumedadTitle),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LuzTab(result: result, lote: lote),
            _AlimentacionTab(result: result, lote: lote),
            _PesoTab(result: result, lote: lote),
            _AguaTab(result: result, lote: lote),
            _TemperaturaTab(result: result, lote: lote),
            _HumedadTab(result: result, lote: lote),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TAB: PROGRAMA DE LUZ
// =============================================================================
class _LuzTab extends StatelessWidget {
  const _LuzTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen semana actual
        if (result.guiaSemanaActual != null)
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor: '${result.guiaSemanaActual!.luzHoras}h',
            subtitulo: l.guiaLuzSubtitle,
            color: AppColors.amber,
          ),
        AppSpacing.gapBase,
        // Tabla completa
        GuiaTablaWidget(
          columnas: [l.guiaSemanaCol, l.guiaHorasLuzCol],
          filas: result.guias
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: ['${g.luzHoras}h'],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }
}

// =============================================================================
// TAB: ALIMENTACIÓN
// =============================================================================
class _AlimentacionTab extends StatelessWidget {
  const _AlimentacionTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (result.guiaSemanaActual != null) ...[
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor:
                '${result.guiaSemanaActual!.alimentoGAve.toStringAsFixed(0)}g/${l.guiaAveAbrev}',
            subtitulo: l.guiaAlimentacionSubtitle(
              GuiasCalculator.totalAlimentoKgDia(
                result.guiaSemanaActual!,
                result.avesActuales,
              ).toStringAsFixed(1),
              result.avesActuales,
            ),
            color: AppColors.success,
          ),
          AppSpacing.gapSm,
          if (result.guiaSemanaActual!.tipoAlimento != null)
            _TipoAlimentoChip(tipo: result.guiaSemanaActual!.tipoAlimento!),
        ],
        AppSpacing.gapBase,
        GuiaTablaWidget(
          columnas: [
            l.guiaSemanaCol,
            'g/${l.guiaAveAbrev}/${l.guiaDiaAbrev}',
            l.guiaTipoCol,
            'kg/${l.guiaDiaAbrev} ${l.guiaTotalLote}',
          ],
          filas: result.guias
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: [
                    g.alimentoGAve.toStringAsFixed(0),
                    g.tipoAlimento ?? '-',
                    GuiasCalculator.totalAlimentoKgDia(
                      g,
                      result.avesActuales,
                    ).toStringAsFixed(1),
                  ],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }
}

// =============================================================================
// TAB: CURVA DE PESO
// =============================================================================
class _PesoTab extends StatelessWidget {
  const _PesoTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final pesoActual = lote.pesoPromedioActual;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (result.guiaSemanaActual != null) ...[
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor:
                '${result.guiaSemanaActual!.pesoObjetivoG.toStringAsFixed(0)}g',
            subtitulo: pesoActual != null
                ? l.guiaPesoComparacion(
                    (pesoActual * 1000).toStringAsFixed(0),
                    result.guiaSemanaActual!.pesoObjetivoG.toStringAsFixed(0),
                  )
                : l.guiaPesoSinDatos,
            color: _pesoColor(
              pesoActual,
              result.guiaSemanaActual!.pesoObjetivoG,
            ),
          ),
        ],
        AppSpacing.gapBase,
        GuiaTablaWidget(
          columnas: [l.guiaSemanaCol, l.guiaPesoObjetivoCol],
          filas: result.guias
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: [
                    g.pesoObjetivoG >= 1000
                        ? '${(g.pesoObjetivoG / 1000).toStringAsFixed(2)} kg'
                        : '${g.pesoObjetivoG.toStringAsFixed(0)} g',
                  ],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }

  Color _pesoColor(double? pesoActualKg, double pesoObjetivoG) {
    if (pesoActualKg == null) return AppColors.info;
    final actualG = pesoActualKg * 1000;
    final diff = (actualG - pesoObjetivoG).abs() / pesoObjetivoG;
    if (diff <= 0.05) return AppColors.success;
    if (diff <= 0.15) return AppColors.amber;
    return AppColors.error;
  }
}

// =============================================================================
// TAB: CONSUMO DE AGUA
// =============================================================================
class _AguaTab extends StatelessWidget {
  const _AguaTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (result.guiaSemanaActual != null)
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor:
                '${result.guiaSemanaActual!.aguaMlAve.toStringAsFixed(0)} ml/${l.guiaAveAbrev}',
            subtitulo: l.guiaAguaSubtitle(
              GuiasCalculator.totalAguaLitrosDia(
                result.guiaSemanaActual!,
                result.avesActuales,
              ).toStringAsFixed(1),
              result.avesActuales,
            ),
            color: AppColors.info,
          ),
        AppSpacing.gapBase,
        GuiaTablaWidget(
          columnas: [
            l.guiaSemanaCol,
            'ml/${l.guiaAveAbrev}/${l.guiaDiaAbrev}',
            'L/${l.guiaDiaAbrev} ${l.guiaTotalLote}',
          ],
          filas: result.guias
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: [
                    g.aguaMlAve.toStringAsFixed(0),
                    GuiasCalculator.totalAguaLitrosDia(
                      g,
                      result.avesActuales,
                    ).toStringAsFixed(1),
                  ],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }
}

// =============================================================================
// TAB: TEMPERATURA
// =============================================================================
class _TemperaturaTab extends StatelessWidget {
  const _TemperaturaTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (result.guiaSemanaActual != null &&
            result.guiaSemanaActual!.temperaturaC != null)
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor:
                '${result.guiaSemanaActual!.temperaturaC!.toStringAsFixed(0)}°C',
            subtitulo: l.guiaTemperaturaSubtitle,
            color: AppColors.error,
          ),
        AppSpacing.gapBase,
        GuiaTablaWidget(
          columnas: [l.guiaSemanaCol, l.guiaTemperaturaCol],
          filas: result.guias
              .where((g) => g.temperaturaC != null)
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: ['${g.temperaturaC!.toStringAsFixed(0)}°C'],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }
}

// =============================================================================
// TAB: HUMEDAD
// =============================================================================
class _HumedadTab extends StatelessWidget {
  const _HumedadTab({required this.result, required this.lote});
  final GuiaLoteResult result;
  final Lote lote;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (result.guiaSemanaActual != null &&
            result.guiaSemanaActual!.humedadPct != null)
          GuiaResumenCard(
            titulo: l.guiaSemanaActualLabel(result.semanaActual),
            valor:
                '${result.guiaSemanaActual!.humedadPct!.toStringAsFixed(0)}%',
            subtitulo: l.guiaHumedadSubtitle,
            color: AppColors.info,
          ),
        AppSpacing.gapBase,
        GuiaTablaWidget(
          columnas: [l.guiaSemanaCol, l.guiaHumedadCol],
          filas: result.guias
              .where((g) => g.humedadPct != null)
              .map(
                (g) => GuiaTablaFila(
                  semana: g.semana,
                  valores: ['${g.humedadPct!.toStringAsFixed(0)}%'],
                  esActual: g.semana == result.semanaActual,
                ),
              )
              .toList(),
          semanaActual: result.semanaActual,
        ),
        AppSpacing.gapBase,
        _FuenteManual(fuente: result.fuenteManual),
      ],
    );
  }
}

// =============================================================================
// WIDGETS AUXILIARES
// =============================================================================

class _TipoAlimentoChip extends StatelessWidget {
  const _TipoAlimentoChip({required this.tipo});
  final String tipo;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Text(
            '${l.guiaTipoAlimentoRecomendado}: $tipo',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FuenteManual extends StatelessWidget {
  const _FuenteManual({required this.fuente});
  final String fuente;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        '${l.guiaFuenteManual}: $fuente',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
