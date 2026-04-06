/// Step 2: Checklist de Items de Bioseguridad
/// Permite evaluar cada ítem por categoría
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/entities/inspeccion_bioseguridad.dart';
import '../../../domain/enums/enums.dart';

/// Step del checklist de bioseguridad
class ChecklistBioseguridadStep extends StatelessWidget {
  const ChecklistBioseguridadStep({
    super.key,
    required this.itemsPorCategoria,
    required this.onItemChanged,
    required this.onObservacionAdded,
    required this.progresoGeneral,
    required this.itemsCumplen,
    required this.itemsNoCumplen,
    required this.itemsParciales,
  });

  final Map<CategoriaBioseguridad, List<ItemInspeccion>> itemsPorCategoria;
  final void Function(String codigoItem, EstadoBioseguridad estado)
  onItemChanged;
  final void Function(String codigoItem, String observacion) onObservacionAdded;
  final double progresoGeneral;
  final int itemsCumplen;
  final int itemsNoCumplen;
  final int itemsParciales;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: itemsPorCategoria.length,
      itemBuilder: (context, index) {
        final entry = itemsPorCategoria.entries.elementAt(index);
        return _CategoriaCard(
          categoria: entry.key,
          items: entry.value,
          onItemChanged: onItemChanged,
          onObservacionAdded: onObservacionAdded,
        );
      },
    );
  }
}

/// Card expandible para una categoría
class _CategoriaCard extends StatefulWidget {
  const _CategoriaCard({
    required this.categoria,
    required this.items,
    required this.onItemChanged,
    required this.onObservacionAdded,
  });

  final CategoriaBioseguridad categoria;
  final List<ItemInspeccion> items;
  final void Function(String, EstadoBioseguridad) onItemChanged;
  final void Function(String, String) onObservacionAdded;

  @override
  State<_CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<_CategoriaCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final itemsEvaluados = widget.items
        .where((i) => i.estado != EstadoBioseguridad.pendiente)
        .length;
    final totalItems = widget.items.length;
    final progreso = totalItems > 0 ? itemsEvaluados / totalItems : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.allXl,
        side: BorderSide(
          color: _isExpanded
              ? theme.colorScheme.primary.withValues(alpha: 0.18)
              : theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header de la categoría
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _isExpanded = !_isExpanded);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isExpanded
                    ? theme.colorScheme.primary.withValues(alpha: 0.03)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getCategoriaColor(widget.categoria),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoria.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          l.bioChecklistProgress(
                            itemsEvaluados.toString(),
                            totalItems.toString(),
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  SizedBox(
                    width: 56,
                    child: ClipRRect(
                      borderRadius: AppRadius.allFull,
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.outlineVariant,
                        valueColor: AlwaysStoppedAnimation(
                          progreso == 1.0
                              ? AppColors.success
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Items de la categoría
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: widget.items.map((item) {
                return _ItemInspeccionCard(
                  item: item,
                  onEstadoChanged: (estado) =>
                      widget.onItemChanged(item.codigo, estado),
                  onObservacionAdded: (obs) =>
                      widget.onObservacionAdded(item.codigo, obs),
                );
              }).toList(),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Color _getCategoriaColor(CategoriaBioseguridad categoria) {
    switch (categoria) {
      case CategoriaBioseguridad.accesoPersonal:
        return AppColors.info;
      case CategoriaBioseguridad.accesoVehiculos:
        return AppColors.indigo;
      case CategoriaBioseguridad.limpiezaDesinfeccion:
        return AppColors.teal;
      case CategoriaBioseguridad.controlPlagas:
        return AppColors.brown;
      case CategoriaBioseguridad.manejoAves:
        return AppColors.warning;
      case CategoriaBioseguridad.manejoMortalidad:
        return AppColors.error;
      case CategoriaBioseguridad.agua:
        return AppColors.cyan;
      case CategoriaBioseguridad.alimento:
        return AppColors.amber;
      case CategoriaBioseguridad.instalaciones:
        return AppColors.blueGrey;
      case CategoriaBioseguridad.registros:
        return AppColors.purple;
    }
  }
}

/// Card para un item individual
class _ItemInspeccionCard extends StatelessWidget {
  const _ItemInspeccionCard({
    required this.item,
    required this.onEstadoChanged,
    required this.onObservacionAdded,
  });

  final ItemInspeccion item;
  final void Function(EstadoBioseguridad) onEstadoChanged;
  final void Function(String) onObservacionAdded;

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final estadoActual = _estadoConfig(context, item.estado);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _mostrarBottomSheetEstados(context),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
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
                        if (item.esCritico) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: AppRadius.allXs,
                            ),
                            child: Text(
                              l.bioChecklistCritical,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                        ],
                        Text(
                          item.descripcion,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildEstadoBadge(context, estadoActual, item.estado),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(
    BuildContext context,
    _EstadoUiConfig estadoActual,
    EstadoBioseguridad estado,
  ) {
    final l = S.of(context);
    final theme = Theme.of(context);
    final isPendiente = estado == EstadoBioseguridad.pendiente;

    return Material(
      color: isPendiente
          ? theme.colorScheme.surfaceContainerHighest
          : estadoActual.color.withValues(alpha: 0.08),
      elevation: isPendiente ? 1 : 0,
      borderRadius: AppRadius.allSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: estadoActual.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                isPendiente ? l.bioChecklistTapToEvaluate : estadoActual.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isPendiente
                      ? theme.colorScheme.onSurfaceVariant
                      : estadoActual.color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarBottomSheetEstados(BuildContext context) {
    final theme = Theme.of(context);
    final opciones = [
      EstadoBioseguridad.cumple,
      EstadoBioseguridad.parcial,
      EstadoBioseguridad.noCumple,
      EstadoBioseguridad.noAplica,
      EstadoBioseguridad.pendiente,
    ];

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      isScrollControlled: true,
      builder: (sheetContext) {
        final l = S.of(sheetContext);
        return SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.descripcion,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l.bioChecklistSelectResult,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                ...opciones.map(
                  (estado) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildBottomSheetOption(
                      context,
                      estado,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        onEstadoChanged(estado);
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
                _ObservacionField(
                  initialValue: item.observacion ?? '',
                  onChanged: (value) {
                    onObservacionAdded(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(
    BuildContext context,
    EstadoBioseguridad estado, {
    required VoidCallback onTap,
  }) {
    //     final l = S.of(context);
    final theme = Theme.of(context);
    final config = _estadoConfig(context, estado);
    final selected = item.estado == estado;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allLg,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: selected
                ? config.color.withValues(alpha: 0.12)
                : theme.colorScheme.surfaceContainerLowest,
            borderRadius: AppRadius.allLg,
            border: Border.all(
              color: selected ? config.color : theme.colorScheme.outlineVariant,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: config.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      config.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? config.color : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      config.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: config.color)
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  _EstadoUiConfig _estadoConfig(
    BuildContext context,
    EstadoBioseguridad estado,
  ) {
    switch (estado) {
      case EstadoBioseguridad.pendiente:
        return _EstadoUiConfig(
          label: S.of(context).bioChecklistPending,
          description: S.of(context).saludCheckNotReviewed,
          color: AppColors.blueGrey,
        );
      case EstadoBioseguridad.cumple:
        return _EstadoUiConfig(
          label: S.of(context).bioChecklistCompliant,
          description: S.of(context).saludCheckCompliance,
          color: AppColors.success,
        );
      case EstadoBioseguridad.noCumple:
        return _EstadoUiConfig(
          label: S.of(context).bioChecklistNonCompliant,
          description: S.of(context).saludCheckNonCompliance,
          color: AppColors.error,
        );
      case EstadoBioseguridad.parcial:
        return _EstadoUiConfig(
          label: S.of(context).bioChecklistPartial,
          description: S.of(context).saludCheckPartial,
          color: AppColors.warning,
        );
      case EstadoBioseguridad.noAplica:
        return _EstadoUiConfig(
          label: S.of(context).bioChecklistNotApplicable,
          description: S.of(context).saludCheckNA,
          color: AppColors.blueGrey,
        );
    }
  }
}

/// Campo de observación inline para el bottom sheet.
class _ObservacionField extends StatefulWidget {
  const _ObservacionField({
    required this.initialValue,
    required this.onChanged,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  State<_ObservacionField> createState() => _ObservacionFieldState();
}

class _ObservacionFieldState extends State<_ObservacionField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    // Guardar al cerrar el bottom sheet
    widget.onChanged(_controller.text);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = S.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l.bioChecklistObservation,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: _controller,
          maxLines: 2,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: l.bioChecklistObservationHint,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLowest,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.allMd,
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _EstadoUiConfig {
  const _EstadoUiConfig({
    required this.label,
    required this.description,
    required this.color,
  });

  final String label;
  final String description;
  final Color color;
}
