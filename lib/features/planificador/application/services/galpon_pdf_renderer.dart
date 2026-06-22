import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/entities/plan_avicola.dart';
import '../../presentation/widgets/galpon_isometric_painter.dart';
import '../../presentation/widgets/galpon_layout.dart';
import '../../presentation/widgets/galpon_planta_painter.dart';

/// Renderiza los diagramas del galpón como imágenes PNG para insertarlas
/// en el PDF generado.
class GalponPdfRenderer {
  const GalponPdfRenderer._();

  /// Genera los widgets PDF con ambos diagramas (isométrico + planta).
  static Future<pw.Widget> buildDiagramas(ResultadoPlan plan) async {
    final layout = GalponLayout.fromPlan(plan);

    // Renderizar a imágenes de alta resolución
    final isoBytes = await _renderPainter(
      GalponIsometricPainter(layout),
      1400,
      900,
    );
    final plantaBytes = await _renderPainter(
      GalponPlantaPainter(layout),
      1600,
      1200,
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Vista isométrica
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(
            'Vista Isométrica del Galpón',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF616161),
            ),
          ),
        ),
        pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(
              color: const PdfColor.fromInt(0xFFE0E0E0),
              width: 0.5,
            ),
          ),
          child: pw.Image(pw.MemoryImage(isoBytes), fit: pw.BoxFit.contain),
        ),

        pw.SizedBox(height: 14),

        // Planta
        pw.Container(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Text(
            'Planta – Distribución de Equipos',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF616161),
            ),
          ),
        ),
        pw.Container(
          width: double.infinity,
          decoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.circular(4),
            border: pw.Border.all(
              color: const PdfColor.fromInt(0xFFE0E0E0),
              width: 0.5,
            ),
          ),
          child: pw.Image(pw.MemoryImage(plantaBytes), fit: pw.BoxFit.contain),
        ),
      ],
    );
  }

  /// Renderiza un [CustomPainter] a una imagen PNG como [Uint8List].
  static Future<Uint8List> _renderPainter(
    CustomPainter painter,
    double width,
    double height,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width, height));

    // Fondo blanco
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Colors.white,
    );

    painter.paint(canvas, Size(width, height));

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return byteData!.buffer.asUint8List();
  }
}
