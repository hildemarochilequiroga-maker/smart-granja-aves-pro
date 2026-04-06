/// Servicio de generación de reportes PDF profesionales.
library;

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/datos_reporte.dart';

/// Servicio que genera documentos PDF profesionales para reportes.
class PdfGeneratorService {
  PdfGeneratorService();

  /// Formateadores
  late final _currencyFormat = NumberFormat.currency(
    locale: Formatters.currencyLocale,
    symbol: Formatters.currencySymbol,
  );
  late final _numberFormat = NumberFormat.decimalPattern(
    Formatters.currencyLocale,
  );
  late final _dateFormat = DateFormat('dd/MM/yyyy', Formatters.currentLocale);
  late final _dateTimeFormat = DateFormat(
    'dd/MM/yyyy HH:mm',
    Formatters.currentLocale,
  );

  /// Colores corporativos
  static const PdfColor _primaryColor = PdfColor.fromInt(0xFF2E7D32); // Verde
  static const PdfColor _secondaryColor = PdfColor.fromInt(0xFF1565C0); // Azul
  static const PdfColor _accentColor = PdfColor.fromInt(0xFFF57C00); // Naranja
  static const PdfColor _headerBgColor = PdfColor.fromInt(0xFF2E7D32);
  static const PdfColor _tableBgColor = PdfColor.fromInt(0xFFF5F5F5);
  static const PdfColor _textColor = PdfColor.fromInt(0xFF212121);
  static const PdfColor _subtitleColor = PdfColor.fromInt(0xFF757575);

  /// Genera un PDF de reporte de producción de lote.
  Future<Uint8List> generarReporteProduccionLote({
    required DatosProduccionLote datos,
    required String granjaNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String generadoPor,
  }) async {
    final pdf = pw.Document(
      title: ErrorMessages.format('PDF_TITLE_PRODUCTION', {
        'code': datos.loteCodigo,
      }),
      author: ErrorMessages.get('PDF_AUTHOR'),
      creator: ErrorMessages.get('PDF_AUTHOR'),
      subject: ErrorMessages.get('PDF_SUBJECT_PRODUCTION'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          titulo: ErrorMessages.get('PDF_HEADER_PRODUCTION'),
          subtitulo: ErrorMessages.format('PDF_LOT_SUBTITLE', {
            'code': datos.loteCodigo,
          }),
          granjaNombre: granjaNombre,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ),
        footer: (context) => _buildFooter(
          generadoPor: generadoPor,
          pagina: context.pageNumber,
          totalPaginas: context.pagesCount,
        ),
        build: (context) => [
          _buildInfoLoteSection(datos),
          pw.SizedBox(height: 20),
          _buildIndicadoresProduccion(datos),
          pw.SizedBox(height: 20),
          _buildResumenFinanciero(datos),
          pw.SizedBox(height: 20),
          _buildAnalisisSection(datos),
        ],
      ),
    );

    return pdf.save();
  }

  /// Genera un PDF de reporte ejecutivo consolidado.
  Future<Uint8List> generarReporteEjecutivo({
    required ResumenEjecutivo resumen,
    required String granjaNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String generadoPor,
    required List<DatosProduccionLote> lotesActivos,
  }) async {
    final pdf = pw.Document(
      title: ErrorMessages.format('PDF_TITLE_EXECUTIVE', {
        'farm': granjaNombre,
      }),
      author: ErrorMessages.get('PDF_AUTHOR'),
      creator: ErrorMessages.get('PDF_AUTHOR'),
      subject: ErrorMessages.get('PDF_SUBJECT_EXECUTIVE'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          titulo: ErrorMessages.get('PDF_HEADER_EXECUTIVE'),
          subtitulo: granjaNombre,
          granjaNombre: granjaNombre,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ),
        footer: (context) => _buildFooter(
          generadoPor: generadoPor,
          pagina: context.pageNumber,
          totalPaginas: context.pagesCount,
        ),
        build: (context) => [
          _buildKPIsSection(resumen),
          pw.SizedBox(height: 20),
          _buildTablaLotes(lotesActivos),
          pw.SizedBox(height: 20),
          _buildResumenFinancieroEjecutivo(resumen),
        ],
      ),
    );

    return pdf.save();
  }

  /// Genera un PDF de reporte de costos.
  Future<Uint8List> generarReporteCostos({
    required List<DatosCostos> costos,
    required String granjaNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String generadoPor,
    required double totalCostos,
    required Map<String, double> costosPorCategoria,
  }) async {
    final pdf = pw.Document(
      title: ErrorMessages.format('PDF_TITLE_COSTS', {'farm': granjaNombre}),
      author: ErrorMessages.get('PDF_AUTHOR'),
      creator: ErrorMessages.get('PDF_AUTHOR'),
      subject: ErrorMessages.get('PDF_SUBJECT_COSTS'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          titulo: ErrorMessages.get('PDF_HEADER_COSTS'),
          subtitulo: granjaNombre,
          granjaNombre: granjaNombre,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ),
        footer: (context) => _buildFooter(
          generadoPor: generadoPor,
          pagina: context.pageNumber,
          totalPaginas: context.pagesCount,
        ),
        build: (context) => [
          _buildResumenCostos(totalCostos, costosPorCategoria),
          pw.SizedBox(height: 20),
          _buildTablaCostos(costos),
        ],
      ),
    );

    return pdf.save();
  }

  /// Genera un PDF de reporte de ventas.
  Future<Uint8List> generarReporteVentas({
    required List<DatosVentas> ventas,
    required String granjaNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required String generadoPor,
    required double totalVentas,
    required Map<String, double> ventasPorProducto,
  }) async {
    final pdf = pw.Document(
      title: ErrorMessages.format('PDF_TITLE_SALES', {'farm': granjaNombre}),
      author: ErrorMessages.get('PDF_AUTHOR'),
      creator: ErrorMessages.get('PDF_AUTHOR'),
      subject: ErrorMessages.get('PDF_SUBJECT_SALES'),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          titulo: ErrorMessages.get('PDF_HEADER_SALES'),
          subtitulo: granjaNombre,
          granjaNombre: granjaNombre,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
        ),
        footer: (context) => _buildFooter(
          generadoPor: generadoPor,
          pagina: context.pageNumber,
          totalPaginas: context.pagesCount,
        ),
        build: (context) => [
          _buildResumenVentas(totalVentas, ventasPorProducto),
          pw.SizedBox(height: 20),
          _buildTablaVentas(ventas),
        ],
      ),
    );

    return pdf.save();
  }

  // =========================================================================
  // COMPONENTES REUTILIZABLES
  // =========================================================================

  /// Construye el encabezado profesional del reporte.
  pw.Widget _buildHeader({
    required String titulo,
    required String subtitulo,
    required String granjaNombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: _headerBgColor, width: 2),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 10),
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Logo y nombre de la app
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  ErrorMessages.get('PDF_APP_NAME'),
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: _headerBgColor,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  granjaNombre,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: _subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          // Título del reporte
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  titulo,
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  subtitulo,
                  style: const pw.TextStyle(
                    fontSize: 11,
                    color: _subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          // Período del reporte
          pw.Expanded(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  ErrorMessages.get('PDF_PERIOD'),
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    color: _subtitleColor,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  _dateFormat.format(fechaInicio),
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  ErrorMessages.format('PDF_DATE_TO', {
                    'date': _dateFormat.format(fechaFin),
                  }),
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el pie de página profesional.
  pw.Widget _buildFooter({
    required String generadoPor,
    required int pagina,
    required int totalPaginas,
  }) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      padding: const pw.EdgeInsets.only(top: 10),
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            ErrorMessages.format('PDF_GENERATED_BY', {
              'datetime': _dateTimeFormat.format(DateTime.now()),
              'user': generadoPor,
            }),
            style: const pw.TextStyle(fontSize: 8, color: _subtitleColor),
          ),
          pw.Text(
            ErrorMessages.format('PDF_PAGE', {
              'current': '$pagina',
              'total': '$totalPaginas',
            }),
            style: const pw.TextStyle(fontSize: 8, color: _subtitleColor),
          ),
          pw.Text(
            ErrorMessages.get('PDF_AUTHOR'),
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Sección de información del lote.
  pw.Widget _buildInfoLoteSection(DatosProduccionLote datos) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(
        color: _tableBgColor,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ErrorMessages.get('PDF_LOT_INFO'),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_CODE'),
                datos.loteCodigo,
              ),
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_BIRD_TYPE'),
                datos.tipoAve,
              ),
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_SHED'),
                datos.galponNombre,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_ENTRY_DATE'),
                _dateFormat.format(datos.fechaIngreso),
              ),
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_CURRENT_AGE'),
                ErrorMessages.format('PDF_DAYS_UNIT', {
                  'count': '${datos.edadActualDias}',
                }),
              ),
              _buildInfoItem(
                ErrorMessages.get('PDF_LABEL_DAYS_IN_FARM'),
                ErrorMessages.format('PDF_DAYS_UNIT', {
                  'count': '${datos.diasEnGranja}',
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget de información individual.
  pw.Widget _buildInfoItem(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8, color: _subtitleColor),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// Indicadores de producción en cards.
  pw.Widget _buildIndicadoresProduccion(DatosProduccionLote datos) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_PRODUCTION_INDICATORS'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildKPICard(
              ErrorMessages.get('PDF_INITIAL_BIRDS'),
              _numberFormat.format(datos.cantidadInicial),
              '',
              _secondaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_CURRENT_BIRDS'),
              _numberFormat.format(datos.cantidadActual),
              '',
              _primaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_MORTALITY'),
              '${datos.porcentajeMortalidad.toStringAsFixed(2)}%',
              ErrorMessages.format('PDF_MORTALITY_BIRDS', {
                'count': '${datos.mortalidadTotal}',
              }),
              datos.porcentajeMortalidad > 5 ? PdfColors.red : _primaryColor,
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildKPICard(
              ErrorMessages.get('PDF_AVG_WEIGHT'),
              datos.pesoPromedioActual != null
                  ? ErrorMessages.format('PDF_WEIGHT_KG', {
                      'value': datos.pesoPromedioActual!.toStringAsFixed(2),
                    })
                  : 'N/A',
              datos.pesoPromedioObjetivo != null
                  ? ErrorMessages.format('PDF_WEIGHT_OBJECTIVE', {
                      'value': datos.pesoPromedioObjetivo!.toStringAsFixed(2),
                    })
                  : '',
              _secondaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_TOTAL_CONSUMPTION'),
              ErrorMessages.format('PDF_WEIGHT_KG', {
                'value': _numberFormat.format(datos.consumoTotalKg),
              }),
              '',
              _accentColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_CONVERSION'),
              datos.conversionAlimenticia != null
                  ? datos.conversionAlimenticia!.toStringAsFixed(2)
                  : 'N/A',
              ErrorMessages.get('PDF_CONVERSION_UNIT'),
              _secondaryColor,
            ),
          ],
        ),
      ],
    );
  }

  /// Card de KPI.
  pw.Widget _buildKPICard(
    String label,
    String value,
    String subtitle,
    PdfColor color,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 1),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 9, color: _subtitleColor),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                subtitle,
                style: const pw.TextStyle(fontSize: 8, color: _subtitleColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Resumen financiero del lote.
  pw.Widget _buildResumenFinanciero(DatosProduccionLote datos) {
    final costoAves = datos.costoTotalAves ?? 0;
    final costoAlimento = datos.costoTotalAlimento ?? 0;
    final ingresos = datos.ingresosTotales ?? 0;
    final balance = datos.balance;

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ErrorMessages.get('PDF_FINANCIAL_SUMMARY'),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _primaryColor,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
            },
            children: [
              _buildTableRow(
                ErrorMessages.get('PDF_BIRD_COST'),
                _currencyFormat.format(costoAves),
              ),
              _buildTableRow(
                ErrorMessages.get('PDF_FEED_COST'),
                _currencyFormat.format(costoAlimento),
              ),
              _buildTableRow(
                ErrorMessages.get('PDF_TOTAL_COSTS'),
                _currencyFormat.format(costoAves + costoAlimento),
                isBold: true,
              ),
              _buildTableRow('', ''),
              _buildTableRow(
                ErrorMessages.get('PDF_SALES_REVENUE'),
                _currencyFormat.format(ingresos),
              ),
              _buildTableRow('', ''),
              _buildTableRow(
                ErrorMessages.get('PDF_BALANCE'),
                _currencyFormat.format(balance),
                isBold: true,
                color: balance >= 0 ? _primaryColor : PdfColors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fila de tabla financiera.
  pw.TableRow _buildTableRow(
    String label,
    String value, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : null,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : null,
              color: color,
            ),
            textAlign: pw.TextAlign.right,
          ),
        ),
      ],
    );
  }

  /// Sección de análisis.
  pw.Widget _buildAnalisisSection(DatosProduccionLote datos) {
    final observaciones = <String>[];

    // Análisis automático basado en datos
    if (datos.porcentajeMortalidad > 5) {
      observaciones.add(
        ErrorMessages.format('PDF_HIGH_MORTALITY', {
          'pct': datos.porcentajeMortalidad.toStringAsFixed(2),
        }),
      );
    } else if (datos.porcentajeMortalidad < 2) {
      observaciones.add(
        ErrorMessages.format('PDF_GOOD_SURVIVAL', {
          'pct': datos.porcentajeSupervivencia.toStringAsFixed(2),
        }),
      );
    }

    if (datos.conversionAlimenticia != null) {
      if (datos.conversionAlimenticia! > 2.0) {
        observaciones.add(
          ErrorMessages.format('PDF_HIGH_CONVERSION', {
            'value': datos.conversionAlimenticia!.toStringAsFixed(2),
          }),
        );
      } else if (datos.conversionAlimenticia! < 1.7) {
        observaciones.add(
          ErrorMessages.format('PDF_GOOD_CONVERSION', {
            'value': datos.conversionAlimenticia!.toStringAsFixed(2),
          }),
        );
      }
    }

    if (datos.pesoPromedioActual != null &&
        datos.pesoPromedioObjetivo != null) {
      final diferencia =
          datos.pesoPromedioActual! - datos.pesoPromedioObjetivo!;
      if (diferencia < -0.2) {
        observaciones.add(
          ErrorMessages.format('PDF_WEIGHT_BELOW', {
            'diff': (diferencia.abs() * 1000).toStringAsFixed(0),
          }),
        );
      } else if (diferencia > 0.1) {
        observaciones.add(
          ErrorMessages.format('PDF_WEIGHT_ABOVE', {
            'diff': (diferencia * 1000).toStringAsFixed(0),
          }),
        );
      }
    }

    if (observaciones.isEmpty) {
      observaciones.add(ErrorMessages.get('PDF_NO_OBSERVATIONS'));
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFFFF8E1),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            ErrorMessages.get('PDF_ANALYSIS_TITLE'),
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: _accentColor,
            ),
          ),
          pw.SizedBox(height: 10),
          ...observaciones.map(
            (obs) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Text(obs, style: const pw.TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  /// KPIs para reporte ejecutivo.
  pw.Widget _buildKPIsSection(ResumenEjecutivo resumen) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_KEY_INDICATORS'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildKPICard(
              ErrorMessages.get('PDF_ACTIVE_LOTS'),
              resumen.totalLotesActivos.toString(),
              '',
              _secondaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_TOTAL_BIRDS'),
              _numberFormat.format(resumen.totalAvesActivas),
              '',
              _primaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_AVG_MORTALITY'),
              '${resumen.mortalidadPromedio.toStringAsFixed(2)}%',
              '',
              resumen.mortalidadPromedio > 5 ? PdfColors.red : _primaryColor,
            ),
            pw.SizedBox(width: 10),
            _buildKPICard(
              ErrorMessages.get('PDF_AVG_CONVERSION'),
              resumen.conversionPromedio.toStringAsFixed(2),
              '',
              _accentColor,
            ),
          ],
        ),
      ],
    );
  }

  /// Tabla de lotes activos.
  pw.Widget _buildTablaLotes(List<DatosProduccionLote> lotes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_ACTIVE_LOTS_SUMMARY'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: _headerBgColor),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.center,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.centerRight,
            4: pw.Alignment.centerRight,
            5: pw.Alignment.centerRight,
          },
          headers: [
            ErrorMessages.get('PDF_TABLE_LOT'),
            ErrorMessages.get('PDF_TABLE_TYPE'),
            ErrorMessages.get('PDF_TABLE_BIRDS'),
            ErrorMessages.get('PDF_TABLE_MORTALITY_PCT'),
            ErrorMessages.get('PDF_TABLE_WEIGHT_KG'),
            ErrorMessages.get('PDF_TABLE_CONVERSION'),
          ],
          data: lotes
              .map(
                (l) => [
                  l.loteCodigo,
                  l.tipoAve,
                  _numberFormat.format(l.cantidadActual),
                  l.porcentajeMortalidad.toStringAsFixed(1),
                  l.pesoPromedioActual?.toStringAsFixed(2) ?? '-',
                  l.conversionAlimenticia?.toStringAsFixed(2) ?? '-',
                ],
              )
              .toList(),
        ),
      ],
    );
  }

  /// Resumen financiero ejecutivo.
  pw.Widget _buildResumenFinancieroEjecutivo(ResumenEjecutivo resumen) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  ErrorMessages.get('PDF_FINANCIAL_SUMMARY'),
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildFinanceRow(
                  ErrorMessages.get('PDF_TOTAL_COSTS_LABEL'),
                  _currencyFormat.format(resumen.costosTotales),
                ),
                _buildFinanceRow(
                  ErrorMessages.get('PDF_TOTAL_SALES_LABEL'),
                  _currencyFormat.format(resumen.ventasTotales),
                ),
                pw.Divider(color: PdfColors.grey300),
                _buildFinanceRow(
                  ErrorMessages.get('PDF_NET_PROFIT'),
                  _currencyFormat.format(resumen.utilidadNeta),
                  color: resumen.utilidadNeta >= 0
                      ? _primaryColor
                      : PdfColors.red,
                  isBold: true,
                ),
                pw.SizedBox(height: 4),
                _buildFinanceRow(
                  ErrorMessages.get('PDF_PROFIT_MARGIN'),
                  '${resumen.margenUtilidad.toStringAsFixed(1)}%',
                  color: resumen.margenUtilidad >= 0
                      ? _primaryColor
                      : PdfColors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Fila de resumen financiero.
  pw.Widget _buildFinanceRow(
    String label,
    String value, {
    PdfColor? color,
    bool isBold = false,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : null,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isBold ? pw.FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Resumen de costos por categoría.
  pw.Widget _buildResumenCostos(
    double total,
    Map<String, double> porCategoria,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_COSTS_SUMMARY'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildKPICard(
              ErrorMessages.get('PDF_TOTAL_COSTS'),
              _currencyFormat.format(total),
              '',
              _accentColor,
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              flex: 3,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: _tableBgColor,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      ErrorMessages.get('PDF_BY_CATEGORY'),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    ...porCategoria.entries.map(
                      (e) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              e.key,
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                            pw.Text(
                              _currencyFormat.format(e.value),
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Tabla de costos detallada.
  pw.Widget _buildTablaCostos(List<DatosCostos> costos) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_COSTS_DETAIL'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: _headerBgColor),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerLeft,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.center,
            4: pw.Alignment.centerLeft,
          },
          headers: [
            ErrorMessages.get('PDF_TABLE_CATEGORY'),
            ErrorMessages.get('PDF_TABLE_CONCEPT'),
            ErrorMessages.get('PDF_TABLE_AMOUNT'),
            ErrorMessages.get('PDF_TABLE_DATE'),
            ErrorMessages.get('PDF_TABLE_SUPPLIER'),
          ],
          data: costos
              .map(
                (c) => [
                  c.categoria,
                  c.concepto,
                  _currencyFormat.format(c.monto),
                  _dateFormat.format(c.fecha),
                  c.proveedor ?? '-',
                ],
              )
              .toList(),
        ),
      ],
    );
  }

  /// Resumen de ventas por producto.
  pw.Widget _buildResumenVentas(double total, Map<String, double> porProducto) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_SALES_SUMMARY'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildKPICard(
              ErrorMessages.get('PDF_TOTAL_SALES_KPI'),
              _currencyFormat.format(total),
              '',
              _primaryColor,
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              flex: 3,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: _tableBgColor,
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      ErrorMessages.get('PDF_BY_PRODUCT'),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    ...porProducto.entries.map(
                      (e) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              e.key,
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                            pw.Text(
                              _currencyFormat.format(e.value),
                              style: const pw.TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Tabla de ventas detallada.
  pw.Widget _buildTablaVentas(List<DatosVentas> ventas) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          ErrorMessages.get('PDF_SALES_DETAIL'),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
            color: PdfColors.white,
          ),
          headerDecoration: const pw.BoxDecoration(color: _headerBgColor),
          cellStyle: const pw.TextStyle(fontSize: 8),
          cellAlignments: {
            0: pw.Alignment.centerLeft,
            1: pw.Alignment.centerRight,
            2: pw.Alignment.centerRight,
            3: pw.Alignment.center,
            4: pw.Alignment.centerLeft,
          },
          headers: [
            ErrorMessages.get('PDF_TABLE_PRODUCT'),
            ErrorMessages.get('PDF_TABLE_QUANTITY'),
            ErrorMessages.get('PDF_TABLE_SUBTOTAL'),
            ErrorMessages.get('PDF_TABLE_DATE'),
            ErrorMessages.get('PDF_TABLE_CLIENT'),
          ],
          data: ventas
              .map(
                (v) => [
                  v.tipoProducto,
                  '${_numberFormat.format(v.cantidad)} ${v.unidad}',
                  _currencyFormat.format(v.subtotal),
                  _dateFormat.format(v.fecha),
                  v.cliente,
                ],
              )
              .toList(),
        ),
      ],
    );
  }
}
