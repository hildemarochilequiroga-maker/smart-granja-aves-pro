library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/providers/granja_providers.dart';

/// **Widget de dashboard de una granja específica.**
///
/// **Uso:**
/// ```dart
/// GranjaDashboardCard(granjaId: 'granja-123')
/// ```
///
/// **Muestra:**
/// - Información general de la granja
/// - Capacidad y ocupación
/// - Estado de lotes
/// - Estado de galpones
/// - Alertas activas
class GranjaDashboardCard extends ConsumerWidget {
  const GranjaDashboardCard({required this.granjaId, super.key});

  final String granjaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardGranjaProvider(granjaId));

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.allMd),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: dashboardAsync.when(
          data: (dashboard) => _DashboardContent(dashboard: dashboard),
          loading: () => const _LoadingView(),
          error: (error, _) => _ErrorView(error: error.toString()),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.dashboard});

  final Map<String, dynamic> dashboard;

  @override
  Widget build(BuildContext context) {
    final granja = dashboard['granja'] as Map<String, dynamic>;
    final capacidad = dashboard['capacidad'] as Map<String, dynamic>;
    final lotes = dashboard['lotes'] as Map<String, dynamic>;
    final galpones = dashboard['galpones'] as Map<String, dynamic>;
    final alertas = dashboard['alertas'] as Map<String, dynamic>;
    final l = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(Icons.dashboard, color: AppColors.primary, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    granja['nombre'] as String,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    granja['estado'] as String,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        const Divider(),
        const SizedBox(height: AppSpacing.base),

        // Capacidad
        _SectionTitle(title: l.farmCapacity),
        const SizedBox(height: AppSpacing.md),
        _CapacidadWidget(
          totalAves: capacidad['totalAves'] as int,
          capacidadMaxima: capacidad['capacidadMaxima'] as int,
          porcentajeOcupacion: capacidad['porcentajeOcupacion'] as double,
        ),
        const SizedBox(height: AppSpacing.base),

        // Lotes y Galpones
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.egg,
                label: l.farmActiveBatches,
                value: (lotes['activos'] as int).toString(),
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: Icons.warehouse,
                label: l.farmActiveShedsLabel,
                value: (galpones['activos'] as int).toString(),
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),

        // Alertas
        if (_tieneAlertas(alertas)) ...[
          const Divider(),
          const SizedBox(height: AppSpacing.base),
          _SectionTitle(title: l.farmAlertsTitle),
          const SizedBox(height: AppSpacing.md),
          _AlertasWidget(alertas: alertas),
        ],
      ],
    );
  }

  bool _tieneAlertas(Map<String, dynamic> alertas) {
    return alertas.values.any((value) => value == true);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _CapacidadWidget extends StatelessWidget {
  const _CapacidadWidget({
    required this.totalAves,
    required this.capacidadMaxima,
    required this.porcentajeOcupacion,
  });

  final int totalAves;
  final int capacidadMaxima;
  final double porcentajeOcupacion;

  @override
  Widget build(BuildContext context) {
    final color = _getColorPorOcupacion(porcentajeOcupacion);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$totalAves / $capacidadMaxima ${S.of(context).farmBirds}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '${porcentajeOcupacion.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.allSm,
          child: LinearProgressIndicator(
            value: porcentajeOcupacion / 100,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Color _getColorPorOcupacion(double porcentaje) {
    if (porcentaje > 100) return AppColors.error;
    if (porcentaje > 90) return AppColors.warning;
    if (porcentaje > 70) return AppColors.success;
    return AppColors.info;
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: AppRadius.allMd,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AlertasWidget extends StatelessWidget {
  const _AlertasWidget({required this.alertas});

  final Map<String, dynamic> alertas;

  @override
  Widget build(BuildContext context) {
    final alertasList = <Widget>[];
    final l = S.of(context);

    if (alertas['sobrepoblacion'] == true) {
      alertasList.add(
        _AlertaItem(
          icon: Icons.warning,
          mensaje: l.farmOverpopulationDetected,
          color: AppColors.error,
        ),
      );
    }

    if (alertas['datosDesactualizados'] == true) {
      alertasList.add(
        _AlertaItem(
          icon: Icons.sync_problem,
          mensaje: l.farmOutdatedData,
          color: AppColors.warning,
        ),
      );
    }

    if (alertas['sinLotes'] == true) {
      alertasList.add(
        _AlertaItem(
          icon: Icons.info,
          mensaje: l.farmShedsWithoutBatches,
          color: AppColors.info,
        ),
      );
    }

    return Column(
      children: alertasList
          .map(
            (alerta) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: alerta,
            ),
          )
          .toList(),
    );
  }
}

class _AlertaItem extends StatelessWidget {
  const _AlertaItem({
    required this.icon,
    required this.mensaje,
    required this.color,
  });

  final IconData icon;
  final String mensaje;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.allMd,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              mensaje,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.base),
            Text(
              S.of(context).farmLoadDashboardError,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              error,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
