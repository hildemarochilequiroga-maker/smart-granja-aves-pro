/// Contenido del bottom sheet de Materiales de Construcción.
///
/// Permite al usuario configurar tipo de estructura, cubierta y separación
/// de puntales, y muestra la lista completa de materiales agrupados.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/galpon_materiales.dart';
import '../../domain/entities/plan_avicola.dart';

class MaterialesContent extends StatefulWidget {
  const MaterialesContent({super.key, required this.infra});

  final InfraestructuraRecomendada infra;

  @override
  State<MaterialesContent> createState() => _MaterialesContentState();
}

class _MaterialesContentState extends State<MaterialesContent> {
  var _config = const ConfigMateriales();

  GalponMateriales get _mat =>
      GalponMateriales.calcular(widget.infra, config: _config);

  @override
  Widget build(BuildContext context) {
    final m = _mat;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Configuración ────────────────────────────────────────────────
        _ConfigBar(
          config: _config,
          onChanged: (c) => setState(() => _config = c),
        ),
        const SizedBox(height: 12),

        // ── Datos generales del techo ────────────────────────────────────
        _InfoGeometria(mat: m),
        const SizedBox(height: 16),

        // ── Tablas por categoría ─────────────────────────────────────────
        for (final cat in CategoriaMaterial.values) ...[
          _CategoriaTable(
            categoria: cat,
            items: m.porCategoria(cat),
            theme: theme,
          ),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),

        // ── Totales ──────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total ítems',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
              Text(
                '${m.items.length} materiales distintos',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// BARRA DE CONFIGURACIÓN (estructura, cubierta, separación)
// =============================================================================

class _ConfigBar extends StatelessWidget {
  const _ConfigBar({required this.config, required this.onChanged});

  final ConfigMateriales config;
  final ValueChanged<ConfigMateriales> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Tipo de estructura
          Row(
            children: [
              const Icon(Icons.foundation, size: 16, color: AppColors.info),
              const SizedBox(width: 6),
              Text(
                'Estructura',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SegmentedButton<TipoEstructura>(
                segments: const [
                  ButtonSegment(
                    value: TipoEstructura.madera,
                    label: Text('Madera'),
                    icon: Icon(Icons.park_outlined, size: 14),
                  ),
                  ButtonSegment(
                    value: TipoEstructura.metal,
                    label: Text('Metal'),
                    icon: Icon(Icons.hardware_outlined, size: 14),
                  ),
                ],
                selected: {config.tipoEstructura},
                onSelectionChanged: (s) =>
                    onChanged(config.copyWith(tipoEstructura: s.first)),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: WidgetStatePropertyAll(theme.textTheme.labelSmall),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          // Tipo de cubierta
          Row(
            children: [
              const Icon(Icons.roofing, size: 16, color: AppColors.warning),
              const SizedBox(width: 6),
              Text(
                'Cubierta',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SegmentedButton<TipoCubierta>(
                segments: const [
                  ButtonSegment(
                    value: TipoCubierta.calamina080,
                    label: Text('0.80 m'),
                  ),
                  ButtonSegment(
                    value: TipoCubierta.calamina110,
                    label: Text('1.10 m'),
                  ),
                ],
                selected: {config.tipoCubierta},
                onSelectionChanged: (s) =>
                    onChanged(config.copyWith(tipoCubierta: s.first)),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: WidgetStatePropertyAll(theme.textTheme.labelSmall),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          // Separación de puntales
          Row(
            children: [
              const Icon(Icons.straighten, size: 16, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'Puntales cada',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SegmentedButton<double>(
                segments: const [
                  ButtonSegment(value: 2.5, label: Text('2.5 m')),
                  ButtonSegment(value: 3.0, label: Text('3.0 m')),
                  ButtonSegment(value: 4.0, label: Text('4.0 m')),
                ],
                selected: {config.separacionPuntalesM},
                onSelectionChanged: (s) =>
                    onChanged(config.copyWith(separacionPuntalesM: s.first)),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: WidgetStatePropertyAll(theme.textTheme.labelSmall),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// INFO GEOMÉTRICA DEL TECHO
// =============================================================================

class _InfoGeometria extends StatelessWidget {
  const _InfoGeometria({required this.mat});
  final GalponMateriales mat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      ('Pendiente techo', '${mat.pendienteTechoPct.toStringAsFixed(1)}%'),
      ('Longitud faldón', '${mat.longitudPendiente.toStringAsFixed(2)} m'),
      ('Área total techo', '${mat.areaRoof.toStringAsFixed(1)} m²'),
      ('Perímetro galpón', '${mat.perimetro.toStringAsFixed(1)} m'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: items.map((e) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                e.$1,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                e.$2,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// =============================================================================
// TABLA POR CATEGORÍA
// =============================================================================

class _CategoriaTable extends StatelessWidget {
  const _CategoriaTable({
    required this.categoria,
    required this.items,
    required this.theme,
  });

  final CategoriaMaterial categoria;
  final List<ItemMaterial> items;
  final ThemeData theme;

  IconData get _icon => switch (categoria) {
    CategoriaMaterial.estructura => Icons.foundation_outlined,
    CategoriaMaterial.cubierta => Icons.roofing_outlined,
    CategoriaMaterial.cerramientos => Icons.grid_on_outlined,
    CategoriaMaterial.ferreteria => Icons.handyman_outlined,
  };

  Color get _color => switch (categoria) {
    CategoriaMaterial.estructura => AppColors.info,
    CategoriaMaterial.cubierta => AppColors.warning,
    CategoriaMaterial.cerramientos => AppColors.success,
    CategoriaMaterial.ferreteria => AppColors.secondary,
  };

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_icon, size: 16, color: _color),
            const SizedBox(width: 6),
            Text(
              categoria.nombre,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Table(
          columnWidths: const {0: FlexColumnWidth(4), 1: FlexColumnWidth(1.3)},
          children: [
            for (var i = 0; i < items.length; i++)
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
                      vertical: 5,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].nombre,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          items[i].descripcion,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 8,
                    ),
                    child: Text(
                      '${items[i].cantidad % 1 == 0 ? items[i].cantidad.toInt() : items[i].cantidad.toStringAsFixed(1)} ${items[i].unidad}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
