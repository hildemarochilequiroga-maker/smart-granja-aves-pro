import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/entities/plan_avicola.dart';
import 'galpon_layout.dart';

/// Dibuja la planta (vista superior) del galpón en **orientación vertical**:
/// el eje largo va de arriba (puerta) hacia abajo y el ancho se extiende
/// horizontalmente. Incluye distribución de equipos, acotaciones,
/// brújula, barra de escala, leyenda y cuadro de título.
class GalponPlantaPainter extends CustomPainter {
  GalponPlantaPainter(this.layout);

  final GalponLayout layout;

  // ── Paleta ────────────────────────────────────────────────────────────────
  static const _bg = Color(0xFFF8FAFB);
  static const _gridMinor = Color(0x08455A64);
  static const _gridMajor = Color(0x18455A64);
  static const _wall = Color(0xFF263238);
  static const _wallHatch = Color(0xFF455A64);
  static const _floorGrad1 = Color(0xFFFFFDE7);
  static const _floorGrad2 = Color(0xFFFFF9C4);
  static const _comedero = Color(0xFFEF6C00);
  static const _bebedero = Color(0xFF1565C0);
  static const _nidal = Color(0xFF5D4037);
  static const _campana = Color(0xFFD32F2F);
  static const _ventilador = Color(0xFF546E7A);
  static const _cortina = Color(0xFF2E7D32);
  static const _iluminacion = Color(0xFFF9A825);
  static const _foco = Color(0xFFFFC107);
  static const _gas = Color(0xFF5C6BC0);
  static const _dimColor = Color(0xFF1565C0);
  static const _dimText = Color(0xFF0D47A1);
  static const _labelBg = Color(0xF4FFFFFF);
  static const _titleBg = Color(0xFF263238);
  static const _zoneFill = Color(0x06455A64);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = _bg);

    // ── Márgenes: izq/der para acotaciones, arriba/abajo para leyenda ──
    const mLeft = 36.0;
    const mTop = 22.0;
    const mRight = 36.0;
    const mBottom = 66.0;

    final drawW = size.width - mLeft - mRight;
    final drawH = size.height - mTop - mBottom;

    // VERTICAL: ancho→pantalla X, largo→pantalla Y
    final scaleX = drawW / layout.anchoM;
    final scaleY = drawH / layout.largoM;
    final scale = min(scaleX, scaleY);

    final barnW = layout.anchoM * scale; // ancho en pantalla (horizontal)
    final barnH = layout.largoM * scale; // largo en pantalla (vertical)
    final ox = mLeft + (drawW - barnW) / 2;
    final oy = mTop + (drawH - barnH) / 2;

    // m(xLargo, yAncho) → pantalla  (largo=filaY, ancho=colX)
    Offset m(double xm, double ym) => Offset(ox + ym * scale, oy + xm * scale);

    // ── Dibujo en capas superpuestas ──────────────────────────────────────
    _drawGrid(canvas, ox, oy, barnW, barnH, scale);
    _drawFloor(canvas, ox, oy, barnW, barnH);
    _drawZones(canvas, m, scale);
    _drawWalls(canvas, ox, oy, barnW, barnH, scale);
    _drawDoor(canvas, m, scale);
    _drawCortinas(canvas, m, scale);
    _drawBebederos(canvas, m, scale);
    _drawComederos(canvas, m, scale);
    _drawCampanas(canvas, m, scale);
    _drawBalonesGas(canvas, m, scale);
    _drawVentiladores(canvas, m, scale);
    _drawNidales(canvas, m, scale);
    _drawIluminacion(canvas, m, scale);
    _drawFocos(canvas, m, scale);
    _drawEquipLabels(canvas, m, scale);
    _drawDimensions(canvas, ox, oy, barnW, barnH, scale);
    _drawCompass(canvas, Offset(ox + barnW + 18, oy + 18), layout.esEsteOeste);
    _drawScaleBar(canvas, Offset(ox, oy + barnH + 14), scale);
    _drawLegend(canvas, Offset(ox, oy + barnH + 30), barnW);
    _drawTitleBlock(canvas, size);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GRILLA 1m
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawGrid(Canvas c, double ox, double oy, double w, double h, double s) {
    final minor = Paint()
      ..color = _gridMinor
      ..strokeWidth = 0.3;
    final major = Paint()
      ..color = _gridMajor
      ..strokeWidth = 0.6;
    // Verticales (recorren ancho)
    for (var a = 0.0; a <= layout.anchoM; a += 1.0) {
      final px = ox + a * s;
      c.drawLine(
        Offset(px, oy),
        Offset(px, oy + h),
        a % 5 == 0 ? major : minor,
      );
    }
    // Horizontales (recorren largo)
    for (var l = 0.0; l <= layout.largoM; l += 1.0) {
      final py = oy + l * s;
      c.drawLine(
        Offset(ox, py),
        Offset(ox + w, py),
        l % 5 == 0 ? major : minor,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PISO CON GRADIENTE
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawFloor(Canvas c, double ox, double oy, double w, double h) {
    c.drawRect(
      Rect.fromLTWH(ox, oy, w, h),
      Paint()
        ..shader = ui.Gradient.linear(Offset(ox, oy), Offset(ox, oy + h), [
          _floorGrad1,
          _floorGrad2,
        ]),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ZONAS FUNCIONALES (bandas verticales alternantes)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawZones(Canvas c, Offset Function(double, double) m, double s) {
    final totalLines = layout.filasComederos + layout.filasBebederos;
    final step = layout.anchoUtil / (totalLines + 1);
    for (var i = 0; i < totalLines; i++) {
      if (i.isOdd) continue;
      final y0 = layout.margen + step * i;
      final y1 = layout.margen + step * (i + 1);
      final p0 = m(0, y0);
      final p1 = m(layout.largoM, y1);
      c.drawRect(Rect.fromPoints(p0, p1), Paint()..color = _zoneFill);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MUROS ACHURADOS GRUESOS
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawWalls(
    Canvas c,
    double ox,
    double oy,
    double w,
    double h,
    double s,
  ) {
    final t = max(5.0, 0.35 * s);

    final rects = <Rect>[
      Rect.fromLTWH(ox - t / 2, oy - t / 2, w + t, t), // arriba
      Rect.fromLTWH(ox - t / 2, oy + h - t / 2, w + t, t), // abajo
      Rect.fromLTWH(ox - t / 2, oy - t / 2, t, h + t), // izq
      Rect.fromLTWH(ox + w - t / 2, oy - t / 2, t, h + t), // der
    ];

    final fill = Paint()..color = _wall;
    final hatch = Paint()
      ..color = _wallHatch
      ..strokeWidth = 0.5;

    for (final r in rects) {
      c.drawRect(r, fill);
      c.save();
      c.clipRect(r);
      final ds = t * 0.55;
      for (var d = r.left - r.height; d < r.right + r.height; d += ds) {
        c.drawLine(Offset(d, r.top), Offset(d + r.height, r.bottom), hatch);
      }
      c.restore();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PUERTA (apertura en pared superior — inicio del largo)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDoor(Canvas c, Offset Function(double, double) m, double s) {
    final t = max(5.0, 0.35 * s);
    final mid = layout.anchoM / 2;
    // Puntos izq/der en la pared superior (xLargo=0)
    final pL = m(0, mid - 0.6);
    final pR = m(0, mid + 0.6);
    final doorW = pR.dx - pL.dx;

    // Borrar pared en la puerta
    c.drawRect(
      Rect.fromLTWH(pL.dx, pL.dy - t / 2, doorW, t),
      Paint()..color = _floorGrad1,
    );

    // Arco de apertura (hoja abre hacia adentro ↓)
    c.drawArc(
      Rect.fromCircle(center: Offset(pR.dx, pR.dy), radius: doorW),
      pi * 0.5,
      pi * 0.5,
      false,
      Paint()
        ..color = _wall.withAlpha(60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    // Línea de hoja
    c.drawLine(
      Offset(pR.dx, pR.dy),
      Offset(pR.dx - doorW * 0.7, pR.dy + doorW * 0.7),
      Paint()
        ..color = _wall.withAlpha(80)
        ..strokeWidth = 1.2,
    );

    // Etiqueta
    _drawLabelAt(
      c,
      Offset((pL.dx + pR.dx) / 2, pL.dy - t - 6),
      'Puerta',
      _wall,
      7,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CORTINAS (líneas punteadas verdes a lo largo de las paredes laterales)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawCortinas(Canvas c, Offset Function(double, double) m, double s) {
    final p = Paint()
      ..color = _cortina
      ..strokeWidth = max(2.5, 0.08 * s)
      ..style = PaintingStyle.stroke;

    final off = max(5.0, 0.15 * s);
    // Pared izquierda (ancho=0) → offset hacia adentro (+X)
    _drawDashed(
      c,
      m(0, 0) + Offset(off, 0),
      m(layout.largoM, 0) + Offset(off, 0),
      p,
    );
    // Pared derecha (ancho=anchoM) → offset hacia adentro (-X)
    _drawDashed(
      c,
      m(0, layout.anchoM) - Offset(off, 0),
      m(layout.largoM, layout.anchoM) - Offset(off, 0),
      p,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BEBEDEROS (nipple o campana según nivel de automatización)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawBebederos(Canvas c, Offset Function(double, double) m, double s) {
    if (layout.bebederoEsNipple) {
      _drawBebederosNipple(c, m, s);
    } else {
      _drawBebederosCampana(c, m, s);
    }
  }

  /// Bebederos tipo nipple: línea continua con puntos.
  void _drawBebederosNipple(
    Canvas c,
    Offset Function(double, double) m,
    double s,
  ) {
    final lineP = Paint()
      ..color = _bebedero.withAlpha(100)
      ..strokeWidth = max(2.0, 0.06 * s);
    final dotP = Paint()..color = _bebedero;
    final dotR = max(2.5, 0.12 * s);
    final strokeP = Paint()
      ..color = _bebedero.withAlpha(180)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (final y in layout.posYBebederos) {
      final start = m(layout.margen, y);
      final end = m(layout.largoM - layout.margen, y);
      c.drawLine(start, end, lineP);

      final dist = (end - start).distance;
      if (dist < 1) continue;
      final dir = (end - start) / dist;
      final numDots = max(5, (layout.largoM / 2.5).floor());
      final step = dist / (numDots + 1);

      for (var i = 1; i <= numDots; i++) {
        final pos = start + dir * (step * i);
        c.drawCircle(pos, dotR, dotP);
        c.drawCircle(
          pos,
          dotR * 0.45,
          Paint()..color = const Color(0xFFBBDEFB),
        );
        c.drawCircle(pos, dotR, strokeP);
      }
    }
  }

  /// Bebederos tipo campana (bell): círculos grandes equidistantes.
  void _drawBebederosCampana(
    Canvas c,
    Offset Function(double, double) m,
    double s,
  ) {
    final bellR = max(5.0, 0.28 * s);

    final guideP = Paint()
      ..color = _bebedero.withAlpha(35)
      ..strokeWidth = max(1.0, 0.03 * s);

    for (final y in layout.posYBebederos) {
      final start = m(layout.margen, y);
      final end = m(layout.largoM - layout.margen, y);
      c.drawLine(start, end, guideP);

      // Distribuir campanas a lo largo de la fila
      final dist = (end - start).distance;
      if (dist < 1) continue;
      final dir = (end - start) / dist;
      // Menos unidades que nipples (campanas cubren más aves)
      final numBells = max(3, (layout.largoM / 4.0).floor());
      final step = dist / (numBells + 1);

      for (var i = 1; i <= numBells; i++) {
        final pos = start + dir * (step * i);
        // Platillo exterior
        c.drawCircle(pos, bellR, Paint()..color = _bebedero.withAlpha(60));
        // Borde campana
        c.drawCircle(
          pos,
          bellR,
          Paint()
            ..color = _bebedero.withAlpha(180)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
        // Cono central (ojo de campana)
        c.drawCircle(
          pos,
          bellR * 0.35,
          Paint()..color = _bebedero.withAlpha(140),
        );
        // Brillo interior
        c.drawCircle(
          pos,
          bellR * 0.15,
          Paint()..color = const Color(0xFFBBDEFB),
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // COMEDEROS (círculos dobles + línea guía vertical)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawComederos(Canvas c, Offset Function(double, double) m, double s) {
    final fillP = Paint()..color = _comedero;
    final innerP = Paint()..color = const Color(0xFFFFE0B2);
    final strokeP = Paint()
      ..color = _comedero.withAlpha(200)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    final r = max(4.5, 0.32 * s);

    final guideP = Paint()
      ..color = _comedero.withAlpha(40)
      ..strokeWidth = max(1.0, 0.03 * s);

    for (final y in layout.posYComederos) {
      final start = m(layout.margen, y);
      final end = m(layout.largoM - layout.margen, y);
      c.drawLine(start, end, guideP);

      final perRow = layout.comederosPorFila;
      final sep = layout.separacionComederos;
      for (var i = 0; i < perRow; i++) {
        final x = layout.margen + sep * (i + 1);
        if (x > layout.largoM - layout.margen * 0.5) break;
        final pos = m(x, y);
        // Sombra sutil
        c.drawCircle(
          pos + const Offset(1, 1),
          r,
          Paint()..color = const Color(0x0C000000),
        );
        c.drawCircle(pos, r, fillP);
        c.drawCircle(pos, r * 0.45, innerP);
        c.drawCircle(pos, r, strokeP);
        // Cruz símbolo comedero tubular
        final crossP = Paint()
          ..color = const Color(0xFFBF360C)
          ..strokeWidth = 0.6;
        c.drawLine(
          Offset(pos.dx - r * 0.25, pos.dy),
          Offset(pos.dx + r * 0.25, pos.dy),
          crossP,
        );
        c.drawLine(
          Offset(pos.dx, pos.dy - r * 0.25),
          Offset(pos.dx, pos.dy + r * 0.25),
          crossP,
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CAMPANAS DE CALEFACCIÓN CON ZONA DE COBERTURA
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawCampanas(Canvas c, Offset Function(double, double) m, double s) {
    final campR = max(8.0, 1.8 * s);
    final zoneR = campR * 3.0;

    for (var i = 0; i < layout.posicionesCampanas.length; i++) {
      final pos = layout.posicionesCampanas[i];
      final px = m(pos.dx, pos.dy);

      c.drawCircle(
        px,
        zoneR,
        Paint()
          ..shader = ui.Gradient.radial(
            px,
            zoneR,
            [
              const Color(0x20D32F2F),
              const Color(0x08D32F2F),
              const Color(0x00D32F2F),
            ],
            [0.0, 0.6, 1.0],
          ),
      );
      c.drawCircle(
        px,
        zoneR,
        Paint()
          ..color = _campana.withAlpha(25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );

      c.drawCircle(px, campR, Paint()..color = _campana);
      _drawHeatSymbol(c, px, campR);
      c.drawCircle(
        px,
        campR,
        Paint()
          ..color = const Color(0xFFB71C1C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );

      _drawLabelAt(c, px + Offset(campR + 8, 0), 'C${i + 1}', _campana, 7);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BALONES DE GAS (junto a las campanas de calefacción)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawBalonesGas(Canvas c, Offset Function(double, double) m, double s) {
    if (layout.numBalonesGas <= 0) return;

    final gasR = max(4.0, 0.22 * s);
    final campPos = layout.posicionesCampanas;

    // Distribuir balones entre campanas existentes
    var placed = 0;
    for (var i = 0; i < campPos.length && placed < layout.numBalonesGas; i++) {
      final pos = campPos[i];
      final px = m(pos.dx, pos.dy);
      // Offset a la derecha-abajo de la campana
      final campR = max(8.0, 1.8 * s);
      final gasPos = Offset(px.dx + campR * 1.5, px.dy + campR * 0.8);

      // Cilindro
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: gasPos,
            width: gasR * 1.4,
            height: gasR * 2.2,
          ),
          Radius.circular(gasR * 0.6),
        ),
        Paint()..color = _gas.withAlpha(180),
      );
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: gasPos,
            width: gasR * 1.4,
            height: gasR * 2.2,
          ),
          Radius.circular(gasR * 0.6),
        ),
        Paint()
          ..color = _gas
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
      // Válvula
      c.drawCircle(
        Offset(gasPos.dx, gasPos.dy - gasR * 1.0),
        gasR * 0.3,
        Paint()..color = _gas,
      );

      _drawLabelAt(
        c,
        Offset(gasPos.dx, gasPos.dy + gasR * 1.5),
        'Gas',
        _gas,
        5.5,
      );
      placed++;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VENTILADORES CON FLUJO DE AIRE VERTICAL
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawVentiladores(
    Canvas c,
    Offset Function(double, double) m,
    double s,
  ) {
    final ventR = max(8.0, 0.6 * s);

    for (var i = 0; i < layout.posicionesVentiladores.length; i++) {
      final pos = layout.posicionesVentiladores[i];
      final px = m(pos.dx, pos.dy);
      // ¿Está en el extremo lejano del largo (pared inferior)?
      final atBottom = pos.dx >= layout.largoM - 0.1;

      // Flujo de aire vertical (hacia adentro del galpón)
      final airDir = atBottom ? -1.0 : 1.0;
      for (var j = 1; j <= 4; j++) {
        final dist = ventR * 1.3 * j;
        final alpha = (80 - j * 16).clamp(10, 80);
        final center = Offset(px.dx, px.dy + airDir * dist);
        c.drawArc(
          Rect.fromCircle(center: center, radius: ventR * 0.5),
          atBottom ? pi * 0.05 : pi * 1.05,
          pi * 0.9,
          false,
          Paint()
            ..color = Color.fromARGB(alpha, 0x78, 0x90, 0x9C)
            ..strokeWidth = 1.2
            ..style = PaintingStyle.stroke,
        );
      }

      _drawFanSymbolV(c, px, ventR, atBottom);

      final labelOff = atBottom ? Offset(ventR + 5, 0) : Offset(ventR + 5, 0);
      _drawLabelAt(c, px + labelOff, 'V${i + 1}', _ventilador, 7);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NIDALES (ponedora) — ORIENTADOS VERTICALMENTE
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawNidales(Canvas c, Offset Function(double, double) m, double s) {
    if (layout.tipo != TipoProduccion.ponedora || layout.numNidales <= 0) {
      return;
    }

    // Swap: en vertical el nidal es más alto que ancho
    final nidalW = max(12.0, 0.7 * s);
    final nidalH = max(16.0, 1.3 * s);

    for (var i = 0; i < layout.posicionesNidales.length; i++) {
      final pos = layout.posicionesNidales[i];
      final px = m(pos.dx, pos.dy);
      final rect = Rect.fromCenter(center: px, width: nidalW, height: nidalH);

      c.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.5)),
        Paint()
          ..shader = ui.Gradient.linear(rect.topLeft, rect.bottomLeft, [
            _nidal.withAlpha(180),
            _nidal.withAlpha(120),
          ]),
      );

      final numComp = max(3, min(5, (nidalH / 4.5).floor()));
      final compH = rect.height / numComp;
      final divP = Paint()
        ..color = const Color(0xFFD7CCC8)
        ..strokeWidth = 0.6;
      for (var j = 1; j < numComp; j++) {
        final y = rect.top + compH * j;
        c.drawLine(Offset(rect.left, y), Offset(rect.right, y), divP);
      }

      for (var j = 0; j < numComp; j++) {
        final cy = rect.top + compH * j + compH / 2;
        c.drawCircle(
          Offset(rect.center.dx, cy),
          1.5,
          Paint()..color = const Color(0xFFFFF8E1),
        );
      }

      c.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(1.5)),
        Paint()
          ..color = _nidal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );

      _drawLabelAt(c, Offset(rect.right + 6, px.dy), 'N${i + 1}', _nidal, 6);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ILUMINACIÓN LED (ponedora) — VERTICAL CENTRAL
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawIluminacion(Canvas c, Offset Function(double, double) m, double s) {
    if (!layout.tieneIluminacion) return;

    final ledP = Paint()
      ..color = _iluminacion.withAlpha(140)
      ..strokeWidth = max(2.0, 0.05 * s);

    final start = m(layout.margen, layout.anchoM / 2);
    final end = m(layout.largoM - layout.margen, layout.anchoM / 2);
    _drawDashed(c, start, end, ledP, dashW: 5, gapW: 7);

    final dotP = Paint()..color = _iluminacion;
    final glowP = Paint()
      ..color = _iluminacion.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final dist = (end - start).distance;
    if (dist < 1) return;
    final dir = (end - start) / dist;
    final numLeds = max(5, (layout.largoM / 2).floor());
    final step = dist / (numLeds + 1);
    final dotR = max(2.5, 0.09 * s);
    for (var i = 1; i <= numLeds; i++) {
      final pos = start + dir * (step * i);
      c.drawCircle(pos, dotR * 2.5, glowP);
      c.drawCircle(pos, dotR, dotP);
      c.drawCircle(pos, dotR * 0.4, Paint()..color = const Color(0xFFFFF9C4));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FOCOS (bombillas a lo largo de dos líneas laterales)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawFocos(Canvas c, Offset Function(double, double) m, double s) {
    if (layout.numFocos <= 0) return;

    final focoR = max(3.0, 0.14 * s);
    final glowR = focoR * 2.5;

    // Distribuir focos en 2 filas (a 1/3 y 2/3 del ancho)
    final y1 = layout.anchoM * 0.33;
    final y2 = layout.anchoM * 0.67;
    final rows = [y1, y2];
    final focosPerRow = (layout.numFocos / rows.length).ceil();

    var placed = 0;
    for (final ry in rows) {
      final step = layout.largoUtil / (focosPerRow + 1);
      for (var i = 0; i < focosPerRow && placed < layout.numFocos; i++) {
        final x = layout.margen + step * (i + 1);
        final pos = m(x, ry);

        // Glow
        c.drawCircle(
          pos,
          glowR,
          Paint()
            ..color = _foco.withAlpha(25)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        // Bulb
        c.drawCircle(pos, focoR, Paint()..color = _foco);
        c.drawCircle(
          pos,
          focoR * 0.4,
          Paint()..color = const Color(0xFFFFF9C4),
        );
        c.drawCircle(
          pos,
          focoR,
          Paint()
            ..color = _foco.withAlpha(180)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.6,
        );
        placed++;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawEquipLabels(Canvas c, Offset Function(double, double) m, double s) {
    final topY = m(0, 0).dy; // borde superior del galpón (screen)
    final t = max(5.0, 0.35 * s);

    // Bebederos — cada franja vertical tiene su etiqueta arriba
    for (var i = 0; i < layout.posYBebederos.length; i++) {
      final px = m(0, layout.posYBebederos[i]).dx;
      _drawLabelAt(c, Offset(px, topY - t - 8), 'B${i + 1}', _bebedero, 6);
    }

    // Comederos
    for (var i = 0; i < layout.posYComederos.length; i++) {
      final px = m(0, layout.posYComederos[i]).dx;
      _drawLabelAt(c, Offset(px, topY - t - 16), 'C${i + 1}', _comedero, 6);
    }

    // Cortina etiqueta en la pared izquierda
    final leftX = m(0, 0).dx;
    final midY = m(layout.largoM / 2, 0).dy;
    _drawMiniLabel(
      c,
      Offset(leftX - 6, midY),
      'Cortina',
      _cortina,
      anchor: _Anchor.right,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACOTACIONES PROFESIONALES (VERTICAL)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDimensions(
    Canvas c,
    double ox,
    double oy,
    double bW,
    double bH,
    double s,
  ) {
    final dimP = Paint()
      ..color = _dimColor
      ..strokeWidth = 0.9;
    final extP = Paint()
      ..color = _dimColor.withAlpha(80)
      ..strokeWidth = 0.4;
    const dimOff = 10.0;

    // ── LARGO a la izquierda (vertical) ──
    final lx = ox - 14;
    c.drawLine(Offset(ox, oy), Offset(lx - 2, oy), extP);
    c.drawLine(Offset(ox, oy + bH), Offset(lx - 2, oy + bH), extP);
    _drawVDim(
      c,
      Offset(lx, oy),
      Offset(lx, oy + bH),
      '${layout.largoM.toStringAsFixed(1)} m',
      dimP,
    );

    // ── ANCHO abajo (horizontal) ──
    final ly = oy + bH + dimOff;
    c.drawLine(Offset(ox, oy + bH), Offset(ox, ly + 2), extP);
    c.drawLine(Offset(ox + bW, oy + bH), Offset(ox + bW, ly + 2), extP);
    _drawHDim(
      c,
      Offset(ox, ly),
      Offset(ox + bW, ly),
      '${layout.anchoM.toStringAsFixed(1)} m',
      dimP,
    );

    // ── Separación comederos (horizontal arriba) ──
    if (layout.posYComederos.length >= 2) {
      final x1 = ox + layout.posYComederos[0] * s;
      final x2 = ox + layout.posYComederos[1] * s;
      final sepY = oy - 6;
      final sepM = (layout.posYComederos[1] - layout.posYComederos[0]).abs();
      c.drawLine(Offset(x1, oy), Offset(x1, sepY - 2), extP);
      c.drawLine(Offset(x2, oy), Offset(x2, sepY - 2), extP);
      _drawHDim(
        c,
        Offset(x1, sepY),
        Offset(x2, sepY),
        '${sepM.toStringAsFixed(1)} m',
        Paint()
          ..color = _comedero
          ..strokeWidth = 0.8,
      );
    }

    // ── Margen interior (izquierda, primer tramo) ──
    if (layout.margen > 0 && bH > 100) {
      final my0 = oy;
      final my1 = oy + layout.margen * s;
      final mx = ox + bW + 8;
      c.drawLine(Offset(ox + bW, my0), Offset(mx + 2, my0), extP);
      c.drawLine(Offset(ox + bW, my1), Offset(mx + 2, my1), extP);
      _drawVDim(
        c,
        Offset(mx, my0),
        Offset(mx, my1),
        '${layout.margen.toStringAsFixed(0)} m',
        Paint()
          ..color = const Color(0xFF78909C)
          ..strokeWidth = 0.6,
      );
    }
  }

  void _drawHDim(Canvas c, Offset s, Offset e, String label, Paint p) {
    c.drawLine(s, e, p);
    _drawArrowH(c, s, true, p.color);
    _drawArrowH(c, e, false, p.color);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 8,
          color: _dimText,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final mid = (s.dx + e.dx) / 2;
    final bgR = Rect.fromCenter(
      center: Offset(mid, s.dy + 7),
      width: tp.width + 6,
      height: tp.height + 2,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bgR, const Radius.circular(2)),
      Paint()..color = _labelBg,
    );
    tp.paint(c, Offset(mid - tp.width / 2, s.dy + 7 - tp.height / 2));
  }

  void _drawVDim(Canvas c, Offset s, Offset e, String label, Paint p) {
    c.drawLine(s, e, p);
    _drawArrowV(c, s, true, p.color);
    _drawArrowV(c, e, false, p.color);
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: 8,
          color: _dimText,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final midY = (s.dy + e.dy) / 2;
    c.save();
    c.translate(s.dx - tp.height / 2 - 3, midY + tp.width / 2);
    c.rotate(-pi / 2);
    final bgR = Rect.fromLTWH(-3, -1, tp.width + 6, tp.height + 2);
    c.drawRRect(
      RRect.fromRectAndRadius(bgR, const Radius.circular(2)),
      Paint()..color = _labelBg,
    );
    tp.paint(c, Offset.zero);
    c.restore();
  }

  void _drawArrowH(Canvas c, Offset pt, bool left, Color color) {
    const a = 5.0;
    final dir = left ? 1.0 : -1.0;
    final path = Path()
      ..moveTo(pt.dx, pt.dy)
      ..lineTo(pt.dx + dir * a, pt.dy - a * 0.4)
      ..lineTo(pt.dx + dir * a, pt.dy + a * 0.4)
      ..close();
    c.drawPath(path, Paint()..color = color);
  }

  void _drawArrowV(Canvas c, Offset pt, bool up, Color color) {
    const a = 5.0;
    final dir = up ? 1.0 : -1.0;
    final path = Path()
      ..moveTo(pt.dx, pt.dy)
      ..lineTo(pt.dx - a * 0.4, pt.dy + dir * a)
      ..lineTo(pt.dx + a * 0.4, pt.dy + dir * a)
      ..close();
    c.drawPath(path, Paint()..color = color);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BRÚJULA
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawCompass(Canvas c, Offset center, bool esteOeste) {
    const r = 14.0;
    c.drawCircle(
      center + const Offset(1, 1),
      r,
      Paint()
        ..color = const Color(0x15000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    c.drawCircle(
      center,
      r,
      Paint()
        ..shader = ui.Gradient.radial(center - const Offset(2, 2), r * 1.5, [
          const Color(0xFFFAFAFA),
          const Color(0xFFE8E8E8),
        ]),
    );
    c.drawCircle(
      center,
      r,
      Paint()
        ..color = _wall
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final north = Path()
      ..moveTo(center.dx, center.dy - r + 3)
      ..lineTo(center.dx + 3, center.dy)
      ..lineTo(center.dx, center.dy + r - 5)
      ..close();
    c.drawPath(north, Paint()..color = const Color(0xFFC62828));
    final south = Path()
      ..moveTo(center.dx, center.dy - r + 3)
      ..lineTo(center.dx - 3, center.dy)
      ..lineTo(center.dx, center.dy + r - 5)
      ..close();
    c.drawPath(south, Paint()..color = const Color(0xFFDDDDDD));
    c.drawCircle(center, 1.5, Paint()..color = _wall);

    void lbl(String s, double dx, double dy, {bool accent = false}) {
      final tp = TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            fontSize: accent ? 8 : 6,
            color: accent ? const Color(0xFFC62828) : _wall,
            fontWeight: accent ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        c,
        Offset(center.dx + dx - tp.width / 2, center.dy + dy - tp.height / 2),
      );
    }

    lbl('N', 0, -(r - 4), accent: true);
    lbl('S', 0, (r - 4));
    lbl('E', (r - 4), 0);
    lbl('O', -(r - 4), 0);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ESCALA GRÁFICA
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawScaleBar(Canvas c, Offset origin, double scale) {
    final segM = _niceStep(layout.anchoM * 0.3);
    final segPx = segM * scale;
    const numSegs = 3;
    const h = 3.5;

    for (var i = 0; i < numSegs; i++) {
      final color = i.isEven
          ? const Color(0xFF37474F)
          : const Color(0xFFBDBDBD);
      c.drawRect(
        Rect.fromLTWH(origin.dx + segPx * i, origin.dy, segPx, h),
        Paint()..color = color,
      );
    }
    c.drawRect(
      Rect.fromLTWH(origin.dx, origin.dy, segPx * numSegs, h),
      Paint()
        ..color = const Color(0xFF37474F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4,
    );

    for (var i = 0; i <= numSegs; i++) {
      final label = '${(segM * i).toStringAsFixed(0)} m';
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(fontSize: 6, color: Color(0xFF757575)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        c,
        Offset(origin.dx + segPx * i - tp.width / 2, origin.dy + h + 1),
      );
    }
  }

  double _niceStep(double a) => a <= 1
      ? 1
      : a <= 2
      ? 2
      : a <= 5
      ? 5
      : 10;

  // ═══════════════════════════════════════════════════════════════════════════
  // LEYENDA CON ICONOS (2 filas si es necesario)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawLegend(Canvas c, Offset origin, double maxW) {
    var x = origin.dx;
    var y = origin.dy;
    const gap = 8.0;
    const iconSz = 9.0;
    final startX = origin.dx;

    void item(
      Color color,
      String label, {
      bool line = false,
      bool dashed = false,
    }) {
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 7.5,
            color: Color(0xFF546E7A),
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final itemW = iconSz + 4 + tp.width + gap;

      if (x + itemW > startX + maxW && x > startX + 10) {
        x = startX;
        y += 14;
      }

      if (line) {
        final lp = Paint()
          ..color = color
          ..strokeWidth = 2;
        if (dashed) {
          _drawDashed(
            c,
            Offset(x, y + iconSz / 2),
            Offset(x + iconSz, y + iconSz / 2),
            lp,
            dashW: 3,
            gapW: 2,
          );
        } else {
          c.drawLine(
            Offset(x, y + iconSz / 2),
            Offset(x + iconSz, y + iconSz / 2),
            lp,
          );
        }
      } else {
        c.drawCircle(
          Offset(x + iconSz / 2, y + iconSz / 2),
          iconSz / 2 - 1,
          Paint()..color = color,
        );
        c.drawCircle(
          Offset(x + iconSz / 2, y + iconSz / 2),
          iconSz / 2 - 1,
          Paint()
            ..color = color.withAlpha(160)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
      tp.paint(c, Offset(x + iconSz + 3, y + 0.5));
      x += itemW;
    }

    item(_comedero, 'Comedero ×${layout.numComederos}');
    final bebLabel = layout.bebederoEsNipple ? 'Nipple' : 'Campana';
    item(
      _bebedero,
      '$bebLabel ×${layout.numBebederos}',
      line: layout.bebederoEsNipple,
    );
    item(_campana, 'Calefacción ×${layout.numCampanas}');
    if (layout.numBalonesGas > 0) {
      item(_gas, 'Gas ×${layout.numBalonesGas}');
    }
    item(_ventilador, 'Ventilador ×${layout.numVentiladores}');
    item(_cortina, 'Cortina', line: true, dashed: true);
    if (layout.numFocos > 0) {
      item(_foco, 'Foco ${layout.watiosFoco}W ×${layout.numFocos}');
    }
    if (layout.tipo == TipoProduccion.ponedora) {
      if (layout.numNidales > 0) {
        item(_nidal, 'Nidal ×${layout.numNidales}');
      }
      if (layout.tieneIluminacion) {
        item(_iluminacion, 'LED', line: true, dashed: true);
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CUADRO DE TÍTULO
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawTitleBlock(Canvas c, Size size) {
    const bW = 130.0;
    const bH = 30.0;
    final rect = Rect.fromLTWH(
      size.width - bW - 6,
      size.height - bH - 4,
      bW,
      bH,
    );

    c.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3)),
      Paint()..color = _titleBg,
    );

    final tipo = layout.tipo == TipoProduccion.ponedora
        ? 'PONEDORA'
        : 'ENGORDE';
    final tp1 = TextPainter(
      text: TextSpan(
        text: 'PLANTA – $tipo',
        style: const TextStyle(
          fontSize: 7.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp1.paint(c, Offset(rect.center.dx - tp1.width / 2, rect.top + 4));

    final dim =
        '${layout.largoM.toStringAsFixed(1)} × ${layout.anchoM.toStringAsFixed(1)} m  |  ${(layout.largoM * layout.anchoM).toStringAsFixed(0)} m²';
    final tp2 = TextPainter(
      text: TextSpan(
        text: dim,
        style: const TextStyle(fontSize: 6.5, color: Color(0xFFB0BEC5)),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp2.paint(c, Offset(rect.center.dx - tp2.width / 2, rect.top + 17));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UTILIDADES
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDashed(
    Canvas c,
    Offset start,
    Offset end,
    Paint paint, {
    double dashW = 5,
    double gapW = 3,
  }) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final len = sqrt(dx * dx + dy * dy);
    if (len < 1) return;
    final ux = dx / len;
    final uy = dy / len;
    var d = 0.0;
    while (d < len) {
      final s = Offset(start.dx + ux * d, start.dy + uy * d);
      d += dashW;
      if (d > len) d = len;
      final e = Offset(start.dx + ux * d, start.dy + uy * d);
      c.drawLine(s, e, paint);
      d += gapW;
    }
  }

  void _drawHeatSymbol(Canvas c, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (var i = -1; i <= 1; i++) {
      final path = Path();
      final x = center.dx + i * radius * 0.35;
      final y0 = center.dy - radius * 0.4;
      final y1 = center.dy + radius * 0.4;
      path.moveTo(x, y1);
      path.cubicTo(
        x - 2,
        y0 + (y1 - y0) * 0.6,
        x + 2,
        y0 + (y1 - y0) * 0.3,
        x,
        y0,
      );
      c.drawPath(path, paint);
    }
  }

  /// Dibuja el símbolo de ventilador orientado verticalmente.
  void _drawFanSymbolV(Canvas c, Offset center, double r, bool atBottom) {
    final rect = Rect.fromCircle(center: center, radius: r);
    // Si está abajo, la mitad superior coloreada (aire va hacia arriba)
    // Si está arriba, la mitad inferior coloreada
    final startAngle = atBottom ? pi : 0.0;
    c.drawCircle(center, r, Paint()..color = const Color(0xFFECEFF1));
    c.drawArc(rect, startAngle, pi, true, Paint()..color = _ventilador);
    c.drawCircle(
      center,
      r,
      Paint()
        ..color = _wall
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    // Aspas
    final bp = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;
    for (var a = 0; a < 6; a++) {
      final angle = a * pi / 3;
      c.drawLine(
        center,
        Offset(
          center.dx + r * 0.65 * cos(angle),
          center.dy + r * 0.65 * sin(angle),
        ),
        bp,
      );
    }
    c.drawCircle(center, 2, Paint()..color = _wall);
  }

  void _drawLabelAt(
    Canvas c,
    Offset pos,
    String text,
    Color color,
    double fontSize,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final bg = Rect.fromCenter(
      center: pos,
      width: tp.width + 5,
      height: tp.height + 2,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bg, const Radius.circular(2)),
      Paint()..color = _labelBg,
    );
    tp.paint(c, Offset(pos.dx - tp.width / 2, pos.dy - tp.height / 2));
  }

  void _drawMiniLabel(
    Canvas c,
    Offset pos,
    String text,
    Color color, {
    _Anchor anchor = _Anchor.left,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 6.5,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final x = anchor == _Anchor.left ? pos.dx : pos.dx - tp.width;
    final bg = Rect.fromLTWH(
      x - 2,
      pos.dy - tp.height / 2 - 1,
      tp.width + 4,
      tp.height + 2,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bg, const Radius.circular(1.5)),
      Paint()..color = _labelBg,
    );
    tp.paint(c, Offset(x, pos.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(GalponPlantaPainter oldDelegate) =>
      layout != oldDelegate.layout;
}

enum _Anchor { left, right }
