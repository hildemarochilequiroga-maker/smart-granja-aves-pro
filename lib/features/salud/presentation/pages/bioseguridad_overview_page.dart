library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/application/providers/auth_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../application/providers/inspeccion_bioseguridad_provider.dart';
import '../../domain/entities/inspeccion_bioseguridad.dart';

class BioseguridadOverviewPage extends ConsumerWidget {
  const BioseguridadOverviewPage({super.key, required this.granjaId});

  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = S.of(context);
    final granjasAsync = ref.watch(granjasStreamProvider);
    final inspeccionesAsync = ref.watch(
      inspeccionesBioseguridadStreamProvider(granjaId),
    );
    final usuario = ref.watch(currentUserProvider);

    void onNuevaInspeccion() => context.push(
      AppRoutes.nuevaInspeccionBioseguridadPorGranja(
        granjaId,
        inspectorId: usuario?.id,
        inspectorNombre: usuario?.nombreCompleto,
      ),
    );

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(l.bioTitle),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'bioseguridad_fab',
        onPressed: onNuevaInspeccion,
        icon: const Icon(Icons.add_task_rounded),
        label: Text(
          l.bioNewInspection,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        tooltip: l.bioNewInspectionTooltip,
      ),
      body: granjasAsync.when(
        data: (granjas) {
          final granja = granjas
              .where((item) => item.id == granjaId)
              .firstOrNull;

          return inspeccionesAsync.when(
            data: (inspecciones) => _OverviewContent(
              granjaNombre: granja?.nombre ?? S.of(context).commonFarm,
              inspecciones: inspecciones,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _OverviewError(
              message: error.toString(),
              onRetry: () => ref.invalidate(
                inspeccionesBioseguridadStreamProvider(granjaId),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _OverviewError(
          message: error.toString(),
          onRetry: () => ref.invalidate(granjasStreamProvider),
        ),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({
    required this.granjaNombre,
    required this.inspecciones,
  });

  final String granjaNombre;
  final List<InspeccionBioseguridad> inspecciones;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final promedio = inspecciones.isEmpty
        ? 0.0
        : inspecciones
                  .map((item) => item.porcentajeCumplimiento)
                  .reduce((a, b) => a + b) /
              inspecciones.length;
    final criticas = inspecciones
        .where((item) => item.tieneIncumplimientosCriticos)
        .length;
    final ultima = inspecciones.isEmpty ? null : inspecciones.first;
    final theme = Theme.of(context);

    if (inspecciones.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.gapLg,
              Text(
                l.bioEmptyTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapSm,
              Text(
                l.bioEmptyDescription(granjaNombre),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.base,
        AppSpacing.xxxl,
      ),
      children: [
        _HeroCard(granjaNombre: granjaNombre, ultimaFecha: ultima?.fecha),
        AppSpacing.gapBase,
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: l.bioInspections,
                value: inspecciones.length.toString(),
                icon: Icons.fact_check_rounded,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: _MetricCard(
                label: l.bioAverage,
                value: '${promedio.toStringAsFixed(0)}%',
                icon: Icons.speed_rounded,
                color: _scoreColor(promedio),
              ),
            ),
          ],
        ),
        AppSpacing.gapMd,
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                label: l.bioCritical,
                value: criticas.toString(),
                icon: Icons.warning_amber_rounded,
                color: criticas > 0 ? AppColors.error : AppColors.success,
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: _MetricCard(
                label: l.bioLastLevel,
                value: ultima?.nivelRiesgo.displayName ?? '-',
                icon: Icons.shield_rounded,
                color: ultima == null
                    ? AppColors.blueGrey
                    : _riskColor(ultima.nivelRiesgo),
              ),
            ),
          ],
        ),
        AppSpacing.gapXl,
        Text(
          l.bioRecentHistory,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapMd,
        ...inspecciones.take(10).map(_InspectionListCard.new),
      ],
    );
  }

  static Color _scoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }

  static Color _riskColor(NivelRiesgoBioseguridad riesgo) {
    switch (riesgo) {
      case NivelRiesgoBioseguridad.bajo:
        return AppColors.success;
      case NivelRiesgoBioseguridad.medio:
        return AppColors.warning;
      case NivelRiesgoBioseguridad.alto:
        return AppColors.error;
      case NivelRiesgoBioseguridad.critico:
        return AppColors.purple;
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.granjaNombre, required this.ultimaFecha});

  final String granjaNombre;
  final DateTime? ultimaFecha;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.info],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppRadius.allXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            granjaNombre,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSpacing.gapSm,
          Text(
            ultimaFecha == null
                ? l.bioNoInspectionYet
                : '${l.bioLastInspection} ${_formatDateLocalized(ultimaFecha!, l)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    //     final l = S.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allLg,
        border: Border.all(color: color.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          AppSpacing.gapMd,
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          AppSpacing.gapXxs,
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _InspectionListCard extends StatelessWidget {
  const _InspectionListCard(this.inspeccion);

  final InspeccionBioseguridad inspeccion;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final color = _OverviewContent._riskColor(inspeccion.nivelRiesgo);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.allLg,
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inspeccion.galponId == null
                          ? l.bioGeneralInspection
                          : l.bioShedInspection,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    AppSpacing.gapXxs,
                    Text(
                      '${_formatDateLocalized(inspeccion.fecha, l)} • ${inspeccion.inspectorNombre}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.allFull,
                ),
                child: Text(
                  inspeccion.nivelRiesgo.displayName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapMd,
          Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: l.bioScore,
                  value:
                      '${inspeccion.porcentajeCumplimiento.toStringAsFixed(0)}%',
                  color: _OverviewContent._scoreColor(
                    inspeccion.porcentajeCumplimiento,
                  ),
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: l.bioNonCompliant,
                  value: inspeccion.itemsNoCumplen.toString(),
                  color: AppColors.error,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: l.bioPending,
                  value: inspeccion.itemsPendientes.toString(),
                  color: AppColors.blueGrey,
                ),
              ),
            ],
          ),
          if ((inspeccion.observaciones ?? '').isNotEmpty) ...[
            AppSpacing.gapMd,
            Text(
              inspeccion.observaciones!,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    //     final l = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        AppSpacing.gapXxxs,
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _OverviewError extends StatelessWidget {
  const _OverviewError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: AppColors.error,
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).couldNotLoadBiosecurity,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapSm,
            Text(message, textAlign: TextAlign.center),
            AppSpacing.gapBase,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.commonRetry),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateLocalized(DateTime fecha, S l) {
  final meses = [
    l.monthJanAbbr,
    l.monthFebAbbr,
    l.monthMarAbbr,
    l.monthAprAbbr,
    l.monthMayAbbr,
    l.monthJunAbbr,
    l.monthJulAbbr,
    l.monthAugAbbr,
    l.monthSepAbbr,
    l.monthOctAbbr,
    l.monthNovAbbr,
    l.monthDecAbbr,
  ];
  return '${fecha.day} ${meses[fecha.month - 1]} ${fecha.year}';
}
