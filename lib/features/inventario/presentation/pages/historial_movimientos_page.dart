/// Página de historial completo de movimientos de inventario.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../application/providers/providers.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../widgets/widgets.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

/// Página que muestra el historial completo de movimientos de un item.
class HistorialMovimientosPage extends ConsumerStatefulWidget {
  const HistorialMovimientosPage({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<HistorialMovimientosPage> createState() =>
      _HistorialMovimientosPageState();
}

class _HistorialMovimientosPageState
    extends ConsumerState<HistorialMovimientosPage> {
  S get l => S.of(context);

  TipoMovimiento? _filtroTipo;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = S.of(context);
    final movimientosAsync = ref.watch(
      inventarioMovimientosStreamProvider(widget.itemId),
    );
    final itemAsync = ref.watch(inventarioItemPorIdProvider(widget.itemId));

    return Scaffold(
      appBar: AppBar(
        title: itemAsync.when(
          data: (item) => Text(l.invMovementsOfItem(item?.nombre ?? 'Item')),
          loading: () => Text(l.invMovementsTitle),
          error: (_, __) => Text(l.invMovementsTitle),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltros(context, theme),
            tooltip: l.invFilter,
          ),
        ],
      ),
      body: movimientosAsync.when(
        data: (movimientos) {
          final movimientosFiltrados = _aplicarFiltros(movimientos);

          if (movimientosFiltrados.isEmpty) {
            return _buildEmptyState(theme);
          }

          return _buildMovimientosList(movimientosFiltrados, theme);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                l.invErrorLoadingMovementsPage,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(error.toString(), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swap_horiz,
            size: 64,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            _filtroTipo != null || _fechaInicio != null
                ? l.invNoMovementsWithFilters
                : l.invNoMovementsRegisteredHist,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (_filtroTipo != null || _fechaInicio != null) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: _limpiarFiltros,
              icon: const Icon(Icons.clear),
              label: Text(l.invClearFiltersHist),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMovimientosList(
    List<MovimientoInventario> movimientos,
    ThemeData theme,
  ) {
    // Agrupar por fecha
    final movimientosPorFecha = <String, List<MovimientoInventario>>{};
    for (final movimiento in movimientos) {
      final fechaKey = DateFormat('yyyy-MM-dd').format(movimiento.fecha);
      movimientosPorFecha.putIfAbsent(fechaKey, () => []).add(movimiento);
    }

    final fechasOrdenadas = movimientosPorFecha.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Más recientes primero

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.base),
      itemCount: fechasOrdenadas.length,
      itemBuilder: (context, index) {
        final fechaKey = fechasOrdenadas[index];
        final movimientosDelDia = movimientosPorFecha[fechaKey]!;
        final fecha = DateFormat('yyyy-MM-dd').parse(fechaKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: AppSpacing.base),
            _buildFechaHeader(fecha, theme),
            const SizedBox(height: AppSpacing.sm),
            ...movimientosDelDia.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: MovimientoInventarioCard(movimiento: m),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFechaHeader(DateTime fecha, ThemeData theme) {
    final ahora = DateTime.now();
    final hoy = DateTime(ahora.year, ahora.month, ahora.day);
    final ayer = hoy.subtract(const Duration(days: 1));
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);

    String textoFecha;
    if (fechaNormalizada == hoy) {
      textoFecha = l.invToday;
    } else if (fechaNormalizada == ayer) {
      textoFecha = l.invYesterday;
    } else {
      textoFecha = DateFormat(
        'EEEE d MMMM, yyyy',
        Localizations.localeOf(context).languageCode,
      ).format(fecha);
      textoFecha = textoFecha[0].toUpperCase() + textoFecha.substring(1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.allSm,
      ),
      child: Text(
        textoFecha,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  List<MovimientoInventario> _aplicarFiltros(
    List<MovimientoInventario> movimientos,
  ) {
    return movimientos.where((m) {
      // Filtro por tipo
      if (_filtroTipo != null && m.tipo != _filtroTipo) {
        return false;
      }

      // Filtro por fecha inicio
      if (_fechaInicio != null &&
          m.fecha.isBefore(
            DateTime(
              _fechaInicio!.year,
              _fechaInicio!.month,
              _fechaInicio!.day,
            ),
          )) {
        return false;
      }

      // Filtro por fecha fin
      if (_fechaFin != null &&
          m.fecha.isAfter(
            DateTime(
              _fechaFin!.year,
              _fechaFin!.month,
              _fechaFin!.day,
            ).add(const Duration(days: 1)),
          )) {
        return false;
      }

      return true;
    }).toList();
  }

  void _limpiarFiltros() {
    setState(() {
      _filtroTipo = null;
      _fechaInicio = null;
      _fechaFin = null;
    });
  }

  Future<void> _mostrarFiltros(BuildContext context, ThemeData theme) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.invFilterMovements, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.base),

                  // Filtro por tipo
                  Text(l.invMovementType, style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      FilterChip(
                        label: Text(l.invAll),
                        selected: _filtroTipo == null,
                        onSelected: (_) {
                          setModalState(() => _filtroTipo = null);
                          setState(() {});
                        },
                      ),
                      ...TipoMovimiento.values.map((tipo) {
                        return FilterChip(
                          label: Text(tipo.displayName),
                          selected: _filtroTipo == tipo,
                          onSelected: (_) {
                            setModalState(() => _filtroTipo = tipo);
                            setState(() {});
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.base),

                  // Filtro por fecha
                  Text(l.invDateRange, style: theme.textTheme.labelLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _fechaInicio != null
                                ? DateFormat('dd/MM/yy').format(_fechaInicio!)
                                : l.invFrom,
                          ),
                          onPressed: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate: _fechaInicio ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (fecha != null) {
                              setModalState(() => _fechaInicio = fecha);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(
                            _fechaFin != null
                                ? DateFormat('dd/MM/yy').format(_fechaFin!)
                                : l.invUntil,
                          ),
                          onPressed: () async {
                            final fecha = await showDatePicker(
                              context: context,
                              initialDate: _fechaFin ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (fecha != null) {
                              setModalState(() => _fechaFin = fecha);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.base),

                  // Botones de acción
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _limpiarFiltros();
                          setModalState(() {});
                        },
                        child: Text(l.invClear),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l.commonApply),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
