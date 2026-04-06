/// BottomSheet para mostrar el historial del galpón.
library;

import 'package:flutter/material.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/galpon.dart';
import 'galpon_detail_utils.dart';

/// BottomSheet que muestra el historial de eventos del galpón.
class GalponHistorialSheet extends ConsumerWidget {
  const GalponHistorialSheet({super.key, required this.galpon});

  final Galpon galpon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.8,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.topXl,
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple.withValues(alpha: 0.1),
                    borderRadius: AppRadius.allMd,
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: AppColors.purple,
                    size: 24,
                  ),
                ),
                AppSpacing.hGapMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).shedHistoryTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        galpon.nombre,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Contenido
          Expanded(child: _buildHistorialContent(context)),
        ],
      ),
    );
  }

  Widget _buildHistorialContent(BuildContext context) {
    final theme = Theme.of(context);
    final eventos = _generarEventosHistorial(context);

    if (eventos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_rounded,
              size: 64,
              color: theme.colorScheme.outlineVariant,
            ),
            AppSpacing.gapBase,
            Text(
              S.of(context).shedNoHistoryAvailable,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppSpacing.gapSm,
            Text(
              S.of(context).shedEventsAppearHere,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: eventos.length,
      separatorBuilder: (_, __) => AppSpacing.gapBase,
      itemBuilder: (context, index) {
        final evento = eventos[index];
        return _HistorialEventoCard(evento: evento);
      },
    );
  }

  List<_HistorialEvento> _generarEventosHistorial(BuildContext context) {
    final l = S.of(context);
    final eventos = <_HistorialEvento>[];

    // Evento de creación
    eventos.add(
      _HistorialEvento(
        tipo: _TipoEvento.creacion,
        titulo: l.shedCreatedEvent,
        descripcion: l.shedCreatedEventDesc(galpon.nombre),
        fecha: galpon.fechaCreacion,
        icono: Icons.add_circle_outline_rounded,
        color: AppColors.success,
      ),
    );

    // Última desinfección
    if (galpon.ultimaDesinfeccion != null) {
      eventos.add(
        _HistorialEvento(
          tipo: _TipoEvento.desinfeccion,
          titulo: l.shedDisinfectionDone,
          descripcion: l.shedDisinfectionDoneDesc,
          fecha: galpon.ultimaDesinfeccion!,
          icono: Icons.cleaning_services_rounded,
          color: AppColors.cyan,
        ),
      );
    }

    // Próximo mantenimiento (si está programado)
    if (galpon.proximoMantenimiento != null) {
      final isPast = galpon.proximoMantenimiento!.isBefore(DateTime.now());
      eventos.add(
        _HistorialEvento(
          tipo: _TipoEvento.mantenimiento,
          titulo: isPast
              ? l.shedMaintenanceOverdueEvent
              : l.shedMaintenanceScheduledEvent,
          descripcion: isPast
              ? l.shedMaintenanceOverdueDesc
              : l.shedMaintenanceScheduledDesc,
          fecha: galpon.proximoMantenimiento!,
          icono: Icons.build_circle_outlined,
          color: isPast ? AppColors.error : AppColors.warning,
        ),
      );
    }

    // Lotes históricos
    for (final loteId in galpon.lotesHistoricos) {
      eventos.add(
        _HistorialEvento(
          tipo: _TipoEvento.lote,
          titulo: l.shedBatchFinished,
          descripcion: l.shedBatchFinishedDesc(loteId),
          fecha: galpon
              .fechaCreacion, // Placeholder - idealmente tendría fecha real
          icono: Icons.egg_outlined,
          color: AppColors.primary,
        ),
      );
    }

    // Última actualización
    if (galpon.ultimaActualizacion != null &&
        galpon.ultimaActualizacion!.isAfter(galpon.fechaCreacion)) {
      eventos.add(
        _HistorialEvento(
          tipo: _TipoEvento.actualizacion,
          titulo: l.shedLastUpdate,
          descripcion: l.shedLastUpdateDesc,
          fecha: galpon.ultimaActualizacion!,
          icono: Icons.edit_rounded,
          color: AppColors.info,
        ),
      );
    }

    // Ordenar por fecha (más reciente primero)
    eventos.sort((a, b) => b.fecha.compareTo(a.fecha));

    return eventos;
  }
}

enum _TipoEvento { creacion, desinfeccion, mantenimiento, lote, actualizacion }

class _HistorialEvento {
  const _HistorialEvento({
    required this.tipo,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.icono,
    required this.color,
  });

  final _TipoEvento tipo;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final IconData icono;
  final Color color;
}

class _HistorialEventoCard extends StatelessWidget {
  const _HistorialEventoCard({required this.evento});

  final _HistorialEvento evento;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: evento.color.withValues(alpha: 0.05),
        borderRadius: AppRadius.allSm,
        border: Border.all(color: evento.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: evento.color.withValues(alpha: 0.15),
              borderRadius: AppRadius.allSm,
            ),
            child: Icon(evento.icono, color: evento.color, size: 20),
          ),
          AppSpacing.hGapMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: evento.color,
                  ),
                ),
                AppSpacing.gapXxs,
                Text(
                  evento.descripcion,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapSm,
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 12,
                      color: theme.colorScheme.outline,
                    ),
                    AppSpacing.hGapXxs,
                    Text(
                      GalponDetailFormatters.formatDate(evento.fecha),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    AppSpacing.hGapMd,
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: theme.colorScheme.outline,
                    ),
                    AppSpacing.hGapXxs,
                    Text(
                      GalponDetailFormatters.formatRelativeDate(
                        evento.fecha,
                        context: context,
                      ),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
