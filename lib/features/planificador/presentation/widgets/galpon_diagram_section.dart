import 'package:flutter/material.dart';

import '../../domain/entities/plan_avicola.dart';
import 'galpon_3d_view.dart';
import 'galpon_layout.dart';
import 'galpon_planta_painter.dart';

/// Widget que muestra los diagramas del galpón con pestañas:
/// vista isométrica y planta con distribución de equipos,
/// botón de expandir a pantalla completa y tabla detallada de equipos.
class GalponDiagramSection extends StatelessWidget {
  const GalponDiagramSection({super.key, required this.plan});

  final ResultadoPlan plan;

  @override
  Widget build(BuildContext context) {
    final layout = GalponLayout.fromPlan(plan);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // ── Pestañas ──
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              dividerHeight: 0,
              tabs: const [
                Tab(
                  icon: Icon(Icons.view_in_ar_outlined, size: 18),
                  text: 'Vista 3D',
                  height: 52,
                ),
                Tab(
                  icon: Icon(Icons.grid_on_outlined, size: 18),
                  text: 'Planta',
                  height: 52,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // ── Contenido de diagramas ──
          SizedBox(
            height: 560,
            child: TabBarView(
              children: [
                // Vista 3D interactiva
                _DiagramCard(child: GalponInteractive3DView(layout: layout)),
                // Planta vertical con botón de expandir
                _DiagramCard(
                  child: Stack(
                    children: [
                      InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 5.0,
                        child: CustomPaint(
                          painter: GalponPlantaPainter(layout),
                          size: Size.infinite,
                        ),
                      ),
                      // Botón expandir esquina superior derecha
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Material(
                          color: Colors.white.withAlpha(220),
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => _openFullscreen(context, layout),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.fullscreen,
                                size: 22,
                                color: Color(0xFF263238),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ── Tabla detallada de equipos ──
          _EquipDetailTable(layout: layout),
        ],
      ),
    );
  }

  void _openFullscreen(BuildContext context, GalponLayout layout) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullscreenPlantView(layout: layout),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// VISTA PLANTA A PANTALLA COMPLETA
// ═══════════════════════════════════════════════════════════════════════════════

class _FullscreenPlantView extends StatelessWidget {
  const _FullscreenPlantView({required this.layout});

  final GalponLayout layout;

  @override
  Widget build(BuildContext context) {
    final tipo = layout.tipo == TipoProduccion.ponedora
        ? 'Ponedora'
        : 'Engorde';
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: Text('Planta – $tipo'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: InteractiveViewer(
        minScale: 0.3,
        maxScale: 8.0,
        child: CustomPaint(
          painter: GalponPlantaPainter(layout),
          size: Size.infinite,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TABLA DETALLADA DE EQUIPOS
// ═══════════════════════════════════════════════════════════════════════════════

class _EquipDetailTable extends StatelessWidget {
  const _EquipDetailTable({required this.layout});

  final GalponLayout layout;

  @override
  Widget build(BuildContext context) {
    final rows = <_EquipRow>[
      _EquipRow(
        icon: Icons.restaurant,
        color: const Color(0xFFEF6C00),
        equipo: 'Comederos (${layout.tipoComedero})',
        cantidad: '${layout.numComederos}',
        distribucion:
            '${layout.filasComederos} filas × '
            '${layout.comederosPorFila} / fila',
        detalle:
            'Sep. ${layout.separacionComederos.toStringAsFixed(1)} m  •  '
            'Margen ${layout.margen.toStringAsFixed(0)} m',
      ),
      _EquipRow(
        icon: Icons.water_drop,
        color: const Color(0xFF1565C0),
        equipo: 'Bebederos (${layout.tipoBebedero})',
        cantidad: '${layout.numBebederos}',
        distribucion: layout.bebederoEsNipple
            ? '${layout.filasBebederos} filas nipple'
            : '${layout.filasBebederos} filas campana',
        detalle: 'Dist. uniforme a lo largo del galpón',
      ),
      _EquipRow(
        icon: Icons.local_fire_department,
        color: const Color(0xFFD32F2F),
        equipo: 'Calefacción',
        cantidad: '${layout.numCampanas}',
        distribucion:
            'Línea central cada '
            '${layout.largoM > 0 && layout.numCampanas > 0 ? (layout.largoM / (layout.numCampanas + 1)).toStringAsFixed(1) : "-"} m',
        detalle: 'Cobertura radial con zona de calor',
      ),
      _EquipRow(
        icon: Icons.air,
        color: const Color(0xFF546E7A),
        equipo: 'Ventiladores',
        cantidad: '${layout.numVentiladores}',
        distribucion: 'Paredes testeras (extremos)',
        detalle: layout.esEsteOeste ? 'Orientación E-O' : 'Orientación N-S',
      ),
      _EquipRow(
        icon: Icons.curtains,
        color: const Color(0xFF2E7D32),
        equipo: 'Cortinas',
        cantidad: '2 laterales',
        distribucion: 'Paredes laterales completas',
        detalle: '${layout.largoM.toStringAsFixed(1)} m cada una',
      ),
    ];

    // ── Nuevos equipos ──
    if (layout.numFocos > 0) {
      rows.add(
        _EquipRow(
          icon: Icons.lightbulb_outline,
          color: const Color(0xFFFFC107),
          equipo: 'Focos ${layout.watiosFoco}W',
          cantidad: '${layout.numFocos}',
          distribucion: '2 filas a 1/3 y 2/3 del ancho',
          detalle: layout.watiosFoco >= 100
              ? 'Incandescente (manual)'
              : 'LED bajo consumo',
        ),
      );
    }

    if (layout.numBalonesGas > 0) {
      rows.add(
        _EquipRow(
          icon: Icons.propane_tank,
          color: const Color(0xFF5C6BC0),
          equipo: 'Balones de gas 10 kg',
          cantidad: '${layout.numBalonesGas}',
          distribucion: 'Junto a campanas criadoras',
          detalle: 'Crianza primeros 14 días',
        ),
      );
    }

    if (layout.numSacosCama > 0) {
      rows.add(
        _EquipRow(
          icon: Icons.grass,
          color: const Color(0xFF795548),
          equipo: 'Cama (cascarilla/viruta)',
          cantidad: '${layout.numSacosCama} sacos 25 kg',
          distribucion: 'Cobertura total del piso',
          detalle: 'Espesor 8–10 cm mínimo',
        ),
      );
    }

    if (layout.numCajasTransporte > 0) {
      rows.add(
        _EquipRow(
          icon: Icons.inventory_2,
          color: const Color(0xFF6D4C41),
          equipo: 'Cajas de transporte',
          cantidad: '${layout.numCajasTransporte}',
          distribucion: '100 aves por caja (estándar Perú)',
          detalle: 'Para saca / venta final',
        ),
      );
    }

    if (layout.tipo == TipoProduccion.ponedora) {
      if (layout.numNidales > 0) {
        rows.add(
          _EquipRow(
            icon: Icons.egg_alt,
            color: const Color(0xFF5D4037),
            equipo: 'Nidales',
            cantidad: '${layout.numNidales}',
            distribucion: 'Pared lateral, dist. uniforme',
            detalle: 'Multi-compartimento individual',
          ),
        );
      }
      if (layout.tieneIluminacion) {
        rows.add(
          const _EquipRow(
            icon: Icons.lightbulb,
            color: Color(0xFFF9A825),
            equipo: 'Iluminación LED',
            cantidad: 'Línea central',
            distribucion: 'Centro del galpón',
            detalle: 'Programa de luz para postura',
          ),
        );
      }
    }

    // Fila resumen de dimensiones
    rows.insert(
      0,
      _EquipRow(
        icon: Icons.straighten,
        color: const Color(0xFF37474F),
        equipo: 'Dimensiones',
        cantidad:
            '${layout.largoM.toStringAsFixed(1)} × ${layout.anchoM.toStringAsFixed(1)} m',
        distribucion:
            'Área: ${(layout.largoM * layout.anchoM).toStringAsFixed(0)} m²',
        detalle:
            'Útil: ${(layout.anchoUtil).toStringAsFixed(1)} m ancho  •  Margen ${layout.margen.toStringAsFixed(0)} m',
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Encabezado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF263238),
            child: const Row(
              children: [
                Icon(Icons.table_chart, size: 16, color: Colors.white70),
                SizedBox(width: 8),
                Text(
                  'Ficha técnica del galpón',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          // Cabecera de columnas
          Container(
            color: const Color(0xFFF5F5F5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Row(
              children: [
                SizedBox(width: 30),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Equipo',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF455A64),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Cantidad',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF455A64),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Distribución',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF455A64),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filas
          ...List.generate(rows.length, (i) {
            final row = rows[i];
            return Container(
              color: i.isOdd ? const Color(0xFFFAFAFA) : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(row.icon, size: 18, color: row.color),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.equipo,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: row.color,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          row.cantidad,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF37474F),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          row.distribucion,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF546E7A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (row.detalle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        row.detalle,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF78909C),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _EquipRow {
  const _EquipRow({
    required this.icon,
    required this.color,
    required this.equipo,
    required this.cantidad,
    required this.distribucion,
    required this.detalle,
  });

  final IconData icon;
  final Color color;
  final String equipo;
  final String cantidad;
  final String distribucion;
  final String detalle;
}

// ═══════════════════════════════════════════════════════════════════════════════
// CARD WRAPPER
// ═══════════════════════════════════════════════════════════════════════════════

class _DiagramCard extends StatelessWidget {
  const _DiagramCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
