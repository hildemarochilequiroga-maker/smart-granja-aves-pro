/// Generador de PDF para el Plan Avícola.
///
/// Produce un documento PDF profesional con portada, índice y secciones
/// numeradas: resumen ejecutivo, infraestructura, alimentación, vacunación,
/// manejo ambiental, equipamiento, proyección financiera y cronograma.
library;

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/galpon_materiales.dart';
import '../../domain/entities/plan_avicola.dart';
import 'galpon_pdf_renderer.dart';

class PlanPdfGenerator {
  const PlanPdfGenerator._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PALETA
  // ═══════════════════════════════════════════════════════════════════════════
  static const _primary = PdfColor.fromInt(0xFF2E7D32);
  static const _primaryLight = PdfColor.fromInt(0xFFE8F5E9);
  static const _secondary = PdfColor.fromInt(0xFF1565C0);
  static const _secondaryLight = PdfColor.fromInt(0xFFE3F2FD);
  static const _accent = PdfColor.fromInt(0xFFF57C00);
  static const _accentLight = PdfColor.fromInt(0xFFFFF3E0);
  static const _dark = PdfColor.fromInt(0xFF212121);
  static const _grey = PdfColor.fromInt(0xFF616161);
  static const _lightGrey = PdfColor.fromInt(0xFF9E9E9E);
  static const _bgLight = PdfColor.fromInt(0xFFF5F5F5);
  static const _zebraRow = PdfColor.fromInt(0xFFFAFAFA);
  static const _white = PdfColors.white;
  static const _red = PdfColor.fromInt(0xFFC62828);

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERAR
  // ═══════════════════════════════════════════════════════════════════════════
  static Future<Uint8List> generar(ResultadoPlan plan) async {
    final pdf = pw.Document(
      title: 'Plan Avícola - Smart Granja Aves',
      author: 'Smart Granja Aves',
      creator: 'Smart Granja Aves',
      subject: 'Planificador Avícola Profesional',
    );

    final tipoProd = plan.input.tipoProduccion == TipoProduccion.engorde
        ? 'Pollo de Engorde'
        : 'Gallina Ponedora';
    final raza = plan.input.nombreRaza;
    final fecha = DateFormat(
      "dd 'de' MMMM 'de' yyyy",
      'es',
    ).format(DateTime.now());
    final fechaCorta = DateFormat('dd/MM/yyyy').format(DateTime.now());

    // Renderizar diagramas del galpón
    final diagramaWidget = await GalponPdfRenderer.buildDiagramas(plan);

    // ── PORTADA ─────────────────────────────────────────────────────────────
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => _buildPortada(plan, tipoProd, raza, fecha),
      ),
    );

    // ── CONTENIDO ───────────────────────────────────────────────────────────
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        header: (ctx) => _buildHeader(tipoProd, raza, fechaCorta, ctx),
        footer: (ctx) => _buildFooter(ctx),
        build: (_) => [
          // Índice
          _buildIndice(plan.input.tipoProduccion),
          pw.SizedBox(height: 20),

          // 1. Resumen
          _numbered(1, 'Resumen Ejecutivo'),
          pw.SizedBox(height: 8),
          _buildResumen(plan, tipoProd, raza),
          pw.SizedBox(height: 24),

          // 2. Infraestructura
          _numbered(2, 'Infraestructura Recomendada'),
          pw.SizedBox(height: 8),
          _buildInfraestructura(plan.infraestructura),
          pw.SizedBox(height: 24),

          // 3. Diagrama del Galpón
          _numbered(3, 'Diagrama del Galpón'),
          pw.SizedBox(height: 8),
          diagramaWidget,
          pw.SizedBox(height: 24),

          // 4. Alimentación
          _numbered(4, 'Plan de Alimentación'),
          pw.SizedBox(height: 8),
          _buildAlimentacion(plan.alimentacion),
          pw.SizedBox(height: 24),

          // 5. Vacunación
          _numbered(5, 'Programa de Vacunación'),
          pw.SizedBox(height: 8),
          _buildVacunacion(plan.vacunacion),
          pw.SizedBox(height: 24),

          // 6. Manejo Ambiental
          _numbered(
            6,
            'Manejo Ambiental — ${plan.manejoAmbiental.zona.nombre}',
          ),
          pw.SizedBox(height: 8),
          _buildManejoAmbiental(plan.manejoAmbiental),
          pw.SizedBox(height: 24),

          // 7. Equipamiento
          _numbered(7, 'Equipamiento Requerido'),
          pw.SizedBox(height: 8),
          _buildEquipamiento(plan.equipamiento),
          pw.SizedBox(height: 24),

          // 8. Materiales de Construcción
          _numbered(8, 'Materiales de Construcción'),
          pw.SizedBox(height: 8),
          _buildMateriales(plan.infraestructura),
          pw.SizedBox(height: 24),

          // 9. Cronograma
          _numbered(9, 'Cronograma Productivo'),
          pw.SizedBox(height: 8),
          _buildCronograma(plan.cronograma, plan.input.tipoProduccion),
          pw.SizedBox(height: 24),

          // Disclaimer
          _buildDisclaimer(),
        ],
      ),
    );

    return pdf.save();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PORTADA
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildPortada(
    ResultadoPlan plan,
    String tipoProd,
    String raza,
    String fecha,
  ) {
    return pw.Stack(
      children: [
        // Fondo verde arriba
        pw.Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: pw.Container(
            height: 340,
            decoration: const pw.BoxDecoration(
              color: _primary,
              borderRadius: pw.BorderRadius.only(
                bottomLeft: pw.Radius.circular(40),
                bottomRight: pw.Radius.circular(40),
              ),
            ),
          ),
        ),
        // Contenido de portada
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 60),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(height: 70),
              pw.Text(
                'SMART GRANJA',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: _white,
                  letterSpacing: 4,
                ),
              ),
              pw.Text(
                'AVES',
                style: pw.TextStyle(
                  fontSize: 42,
                  fontWeight: pw.FontWeight.bold,
                  color: _white,
                ),
              ),
              pw.SizedBox(height: 6),
              pw.Container(width: 60, height: 3, color: _white),
              pw.SizedBox(height: 16),
              pw.Text(
                'PLAN DE PRODUCCIÓN',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: _white,
                  letterSpacing: 2,
                ),
              ),
              pw.Text(
                tipoProd.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: _white,
                ),
              ),
              pw.SizedBox(height: 30),

              // KPI cards (sin costos)
              pw.Container(
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: _white,
                  borderRadius: pw.BorderRadius.circular(12),
                  boxShadow: const [
                    pw.BoxShadow(
                      color: PdfColor.fromInt(0x22000000),
                      blurRadius: 10,
                      offset: PdfPoint(0, 4),
                    ),
                  ],
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        _portadaKpi('Raza', raza, _primary),
                        pw.SizedBox(width: 16),
                        _portadaKpi(
                          'Aves',
                          '${plan.input.cantidadAves}',
                          _secondary,
                        ),
                        pw.SizedBox(width: 16),
                        _portadaKpi('Zona', plan.input.zona.nombre, _accent),
                      ],
                    ),
                    pw.SizedBox(height: 16),
                    pw.Divider(color: _bgLight, thickness: 1),
                    pw.SizedBox(height: 16),
                    pw.Row(
                      children: [
                        _portadaKpi(
                          'Alimentación',
                          '${plan.alimentacion.consumoTotalLoteKg.toStringAsFixed(0)} kg',
                          _secondary,
                        ),
                        pw.SizedBox(width: 16),
                        _portadaKpi(
                          'Vacunas',
                          '${plan.vacunacion.vacunas.length} dosis',
                          _primary,
                        ),
                        pw.SizedBox(width: 16),
                        _portadaKpi(
                          'Equipos',
                          '${plan.equipamiento.length} items',
                          _accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              pw.Spacer(),

              // Pie de portada
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Fecha de generación',
                        style: const pw.TextStyle(
                          fontSize: 8,
                          color: _lightGrey,
                        ),
                      ),
                      pw.Text(
                        fecha,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: _dark,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Smart Granja Aves',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _portadaKpi(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Column(
        children: [
          pw.Text(
            label.toUpperCase(),
            style: const pw.TextStyle(
              fontSize: 7,
              color: _lightGrey,
              letterSpacing: 0.5,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER / FOOTER (páginas interiores)
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildHeader(
    String tipoProd,
    String raza,
    String fecha,
    pw.Context ctx,
  ) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _primary, width: 2)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 6),
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Row(
        children: [
          pw.Text(
            'Smart Granja Aves',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: _primary,
            ),
          ),
          pw.Spacer(),
          pw.Text(
            'Plan de $tipoProd — $raza',
            style: const pw.TextStyle(fontSize: 8, color: _grey),
          ),
          pw.SizedBox(width: 16),
          pw.Text(
            fecha,
            style: const pw.TextStyle(fontSize: 8, color: _lightGrey),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(pw.Context ctx) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _bgLight, width: 1)),
      ),
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Documento generado por Smart Granja Aves',
            style: const pw.TextStyle(fontSize: 7, color: _lightGrey),
          ),
          pw.Text(
            'Página ${ctx.pageNumber} de ${ctx.pagesCount}',
            style: const pw.TextStyle(fontSize: 7, color: _lightGrey),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ÍNDICE
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildIndice(TipoProduccion tipo) {
    final secciones = [
      'Resumen Ejecutivo',
      'Infraestructura Recomendada',
      'Diagrama del Galpón',
      'Plan de Alimentación',
      'Programa de Vacunación',
      'Manejo Ambiental',
      'Equipamiento Requerido',
      'Materiales de Construcción',
      'Cronograma Productivo',
    ];

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _bgLight,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'CONTENIDO DEL PLAN',
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: _primary,
              letterSpacing: 1,
            ),
          ),
          pw.SizedBox(height: 10),
          ...secciones.asMap().entries.map(
            (e) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 3),
              child: pw.Row(
                children: [
                  pw.Container(
                    width: 22,
                    height: 22,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      color: _primary,
                      borderRadius: pw.BorderRadius.circular(4),
                    ),
                    child: pw.Text(
                      '${e.key + 1}',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: _white,
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Text(
                    e.value,
                    style: const pw.TextStyle(fontSize: 10, color: _dark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 1. RESUMEN EJECUTIVO
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildResumen(
    ResultadoPlan plan,
    String tipoProd,
    String raza,
  ) {
    final input = plan.input;
    final infra = plan.infraestructura;

    return pw.Container(
      padding: const pw.EdgeInsets.all(14),
      decoration: pw.BoxDecoration(
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _bgLight, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Fila 1: tipo, raza, aves, zona
          pw.Row(
            children: [
              _kpiBox('Tipo de Producción', tipoProd, _primary),
              pw.SizedBox(width: 12),
              _kpiBox('Raza Seleccionada', raza, _secondary),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _kpiBox('Cantidad de Aves', '${input.cantidadAves}', _accent),
              pw.SizedBox(width: 12),
              _kpiBox('Zona Climática', input.zona.nombre, _primary),
              pw.SizedBox(width: 12),
              _kpiBox(
                'Área Requerida',
                '${infra.areaRequeridaM2.toStringAsFixed(1)} m²',
                _secondary,
              ),
            ],
          ),
          if (input.direccionTexto != null) ...[
            pw.SizedBox(height: 10),
            _labelValue('Ubicación', input.direccionTexto!),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 2. INFRAESTRUCTURA
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildInfraestructura(InfraestructuraRecomendada infra) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Dimensiones en cards
        pw.Row(
          children: [
            _dimCard(
              'Área Total',
              '${infra.areaRequeridaM2.toStringAsFixed(1)} m²',
              _primary,
            ),
            pw.SizedBox(width: 8),
            _dimCard(
              'Dimensiones',
              '${infra.largoM.toStringAsFixed(1)} × ${infra.anchoM.toStringAsFixed(1)} m',
              _secondary,
            ),
            pw.SizedBox(width: 8),
            _dimCard('Densidad', '${infra.densidadAvesM2} aves/m²', _accent),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          children: [
            _dimCard('Altura Cumbrera', '${infra.alturaCumbreraM} m', _grey),
            pw.SizedBox(width: 8),
            _dimCard('Altura Alero', '${infra.alturaAleroM} m', _grey),
            pw.SizedBox(width: 8),
            pw.Expanded(child: pw.SizedBox()),
          ],
        ),
        pw.SizedBox(height: 10),

        // Detalles
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: _bgLight,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _labelValue('Tipo de techo', infra.tipoTecho),
              pw.SizedBox(height: 4),
              _labelValue('Orientación', infra.orientacion),
            ],
          ),
        ),
        pw.SizedBox(height: 10),

        // Observaciones
        _subTitle('Observaciones'),
        pw.SizedBox(height: 4),
        ...infra.observaciones.map((o) => _bulletPoint(o)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 3. ALIMENTACIÓN
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildAlimentacion(PlanAlimentacion alim) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildZebraTable(
          headers: [
            'Fase',
            'Período',
            'g/ave/día',
            'kg/ave',
            'kg Lote',
            'Proteína',
          ],
          alignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.center,
          },
          data: alim.fases
              .map(
                (f) => [
                  f.nombre,
                  f.periodo,
                  f.consumoDiarioPorAveG.toStringAsFixed(0),
                  f.consumoTotalPorAveKg.toStringAsFixed(2),
                  f.consumoTotalLoteKg.toStringAsFixed(0),
                  '${f.proteina.toStringAsFixed(1)}%',
                ],
              )
              .toList(),
        ),
        pw.SizedBox(height: 10),
        // Totales
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _primaryLight,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _miniStat(
                'Consumo/ave',
                '${alim.consumoTotalPorAveKg.toStringAsFixed(2)} kg',
              ),
              _miniStat(
                'Consumo lote',
                '${alim.consumoTotalLoteKg.toStringAsFixed(0)} kg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 4. VACUNACIÓN
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildVacunacion(PlanVacunacion vac) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildZebraTable(
          headers: ['Día', 'Vacuna', 'Vía de Aplicación', 'Dosis'],
          alignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerRight,
          },
          data: vac.vacunas
              .map((v) => ['${v.dia}', v.nombre, v.via, '${v.dosisTotales}'])
              .toList(),
        ),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: pw.BoxDecoration(
            color: _secondaryLight,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [_miniStat('Total vacunas', '${vac.vacunas.length}')],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 5. MANEJO AMBIENTAL
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildManejoAmbiental(RecomendacionAmbiental amb) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: _bgLight,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  _envParam('Temperatura óptima', amb.temperaturaOptima),
                  pw.SizedBox(width: 12),
                  _envParam('Humedad relativa', amb.humedadRelativa),
                ],
              ),
              pw.SizedBox(height: 10),
              _labelValue('Ventilación', amb.tipoVentilacion),
              pw.SizedBox(height: 6),
              _labelValue('Cortinas', amb.tipoCortinas),
            ],
          ),
        ),
        pw.SizedBox(height: 10),
        _subTitle('Notas especiales para la zona ${amb.zona.nombre}'),
        pw.SizedBox(height: 4),
        ...amb.notasEspeciales.map((n) => _bulletPoint(n)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 6. EQUIPAMIENTO
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildEquipamiento(List<ItemEquipamiento> items) {
    return _buildZebraTable(
      headers: ['Equipo', 'Cantidad'],
      alignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center},
      data: items.map((e) => [e.nombre, '${e.cantidad}']).toList(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 8. CRONOGRAMA
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildCronograma(
    List<EventoCronograma> eventos,
    TipoProduccion tipo,
  ) {
    final unidad = tipo == TipoProduccion.engorde ? 'Día' : 'Sem';

    // Agrupar por categoría
    final agrupado = <CategoriaCronograma, List<EventoCronograma>>{};
    for (final e in eventos) {
      agrupado.putIfAbsent(e.categoria, () => []).add(e);
    }

    final categoriaColors = {
      CategoriaCronograma.manejo: _secondary,
      CategoriaCronograma.alimentacion: _accent,
      CategoriaCronograma.vacunacion: _red,
      CategoriaCronograma.produccion: _primary,
      CategoriaCronograma.venta: const PdfColor.fromInt(0xFF6A1B9A),
    };

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Leyenda
        pw.Row(
          children: categoriaColors.entries.map((e) {
            return pw.Padding(
              padding: const pw.EdgeInsets.only(right: 12),
              child: pw.Row(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    width: 8,
                    height: 8,
                    decoration: pw.BoxDecoration(
                      color: e.value,
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),
                  pw.SizedBox(width: 4),
                  pw.Text(
                    e.key.nombre,
                    style: const pw.TextStyle(fontSize: 7, color: _grey),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        pw.SizedBox(height: 8),
        // Tabla con color por categoría
        _buildZebraTable(
          headers: [unidad, 'Categoría', 'Evento', 'Detalle'],
          alignments: {
            0: pw.Alignment.center,
            1: pw.Alignment.center,
            2: pw.Alignment.centerLeft,
            3: pw.Alignment.centerLeft,
          },
          data: eventos
              .map(
                (e) => [
                  '${e.dia}',
                  e.categoria.nombre,
                  e.titulo,
                  e.descripcion,
                ],
              )
              .toList(),
          columnWidths: {
            0: const pw.FlexColumnWidth(0.7),
            1: const pw.FlexColumnWidth(1.2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(3),
          },
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MATERIALES DE CONSTRUCCIÓN
  // ═══════════════════════════════════════════════════════════════════════════

  static pw.Widget _buildMateriales(InfraestructuraRecomendada infra) {
    // Calcula con valores por defecto (madera, calamina 0.80, puntales c/3 m)
    final mat = GalponMateriales.calcular(infra);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Info geométrica
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: _bgLight,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _miniStat(
                'Pendiente',
                '${mat.pendienteTechoPct.toStringAsFixed(1)}%',
              ),
              _miniStat(
                'Faldón',
                '${mat.longitudPendiente.toStringAsFixed(2)} m',
              ),
              _miniStat('Área techo', '${mat.areaRoof.toStringAsFixed(1)} m²'),
              _miniStat('Perímetro', '${mat.perimetro.toStringAsFixed(1)} m'),
            ],
          ),
        ),
        pw.SizedBox(height: 10),

        // Tabla por categoría
        for (final cat in CategoriaMaterial.values) ...[
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 6),
            decoration: const pw.BoxDecoration(
              color: _primaryLight,
              border: pw.Border(left: pw.BorderSide(color: _primary, width: 3)),
            ),
            child: pw.Text(
              cat.nombre.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: _primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          pw.SizedBox(height: 4),
          _buildZebraTable(
            headers: ['Material', 'Detalle', 'Cantidad'],
            alignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
            },
            columnWidths: {
              0: const pw.FlexColumnWidth(2.5),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1.5),
            },
            data: mat
                .porCategoria(cat)
                .map(
                  (e) => [
                    e.nombre,
                    e.descripcion,
                    '${e.cantidad % 1 == 0 ? e.cantidad.toInt() : e.cantidad.toStringAsFixed(1)} ${e.unidad}',
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 10),
        ],

        // Nota
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: _accentLight,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Nota: ',
                style: pw.TextStyle(
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                  color: _accent,
                ),
              ),
              pw.Expanded(
                child: pw.Text(
                  'Cantidades calculadas para estructura de ${mat.config.tipoEstructura.nombre.toLowerCase()}, '
                  '${mat.config.tipoCubierta.nombre.toLowerCase()}, puntales cada '
                  '${mat.config.separacionPuntalesM.toStringAsFixed(1)} m. '
                  'Incluye un margen de traslape estándar. Ajustar según proveedores locales.',
                  style: const pw.TextStyle(fontSize: 7, color: _grey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _miniStat(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 6.5, color: _grey)),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: _dark,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISCLAIMER
  // ═══════════════════════════════════════════════════════════════════════════
  static pw.Widget _buildDisclaimer() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: _accentLight,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: _accent, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 16,
                height: 16,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: _accent,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  '!',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: _white,
                  ),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                'Aviso Importante',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: _accent,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Este plan es una estimación basada en datos técnicos de las casas genéticas y '
            'precios referenciales del mercado peruano. Los resultados reales pueden variar '
            'según condiciones locales, manejo, clima, disponibilidad de insumos y fluctuaciones '
            'de mercado. Se recomienda consultar con un profesional veterinario y ajustar los '
            'valores según su realidad local.',
            style: const pw.TextStyle(fontSize: 8, color: _grey),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // WIDGETS AUXILIARES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Título de sección numerado
  static pw.Widget _numbered(int n, String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          left: pw.BorderSide(color: _primary, width: 4),
          bottom: pw.BorderSide(color: _bgLight, width: 1),
        ),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 24,
            height: 24,
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              color: _primary,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Text(
              '$n',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: _white,
              ),
            ),
          ),
          pw.SizedBox(width: 10),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: _dark,
            ),
          ),
        ],
      ),
    );
  }

  /// Subtítulo dentro de una sección
  static pw.Widget _subTitle(String text) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: _grey,
      ),
    );
  }

  /// KPI box para resumen
  static pw.Widget _kpiBox(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: color, width: 1),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              label.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 6,
                color: _lightGrey,
                letterSpacing: 0.3,
              ),
            ),
            pw.SizedBox(height: 3),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Card de dimensión (infraestructura)
  static pw.Widget _dimCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: pw.BoxDecoration(
          color: _bgLight,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border(
            left: pw.BorderSide(color: color, width: 3),
          ), // ignore: prefer_const_constructors
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 6,
                color: _lightGrey,
                letterSpacing: 0.3,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: _dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Parámetro ambiental
  static pw.Widget _envParam(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          color: _white,
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 6,
                color: _lightGrey,
                letterSpacing: 0.3,
              ),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: _dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Label : value row
  static pw.Widget _labelValue(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                color: _grey,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 8)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISCLAIMER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bullet point
  static pw.Widget _bulletPoint(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 4, top: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 4,
            height: 4,
            margin: const pw.EdgeInsets.only(top: 3, right: 8),
            decoration: pw.BoxDecoration(
              color: _primary,
              borderRadius: pw.BorderRadius.circular(2),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              text,
              style: const pw.TextStyle(fontSize: 8, color: _dark),
            ),
          ),
        ],
      ),
    );
  }

  /// Tabla con filas zebra
  static pw.Widget _buildZebraTable({
    required List<String> headers,
    required Map<int, pw.Alignment> alignments,
    required List<List<String>> data,
    Map<int, pw.TableColumnWidth>? columnWidths,
  }) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 7.5,
        color: _white,
      ),
      headerDecoration: const pw.BoxDecoration(color: _primary),
      headerHeight: 24,
      cellStyle: const pw.TextStyle(fontSize: 7, color: _dark),
      cellHeight: 20,
      cellAlignments: alignments,
      cellDecoration: (index, data, rowNum) {
        return pw.BoxDecoration(color: rowNum.isOdd ? _zebraRow : _white);
      },
      headerCellDecoration: const pw.BoxDecoration(color: _primary),
      headers: headers,
      data: data,
      columnWidths: columnWidths,
    );
  }
}
