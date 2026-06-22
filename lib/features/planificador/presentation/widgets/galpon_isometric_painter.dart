import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/entities/plan_avicola.dart';
import 'galpon_layout.dart';

/// Vista isométrica 3D interactiva del galpón con proyección ortográfica real.
///
/// Acepta [rotX] (inclinación vertical) y [rotY] (rotación horizontal) para
/// permitir vista libre 360°. El orden de pintado se ajusta dinámicamente
/// según la dirección de la cámara (painter's algorithm por capas).
class GalponIsometricPainter extends CustomPainter {
  GalponIsometricPainter(
    this.layout, {
    this.rotX = defaultRotX,
    this.rotY = defaultRotY,
  });

  final GalponLayout layout;
  final double rotX;
  final double rotY;

  /// Ángulos por defecto que dan una vista isométrica clásica.
  static const defaultRotX = -0.55;
  static const defaultRotY = 0.78;

  // ── Paleta ────────────────────────────────────────────────────────────────
  static const _wallFront1 = Color(0xFF81C784);
  static const _wallFront2 = Color(0xFFA5D6A7);
  static const _wallSolid1 = Color(0xFF66BB6A);
  static const _wallSolid2 = Color(0xFF388E3C);
  static const _roofLight1 = Color(0xFFBCAAA4);
  static const _roofLight2 = Color(0xFFA1887F);
  static const _roofDark1 = Color(0xFF8D6E63);
  static const _roofDark2 = Color(0xFF6D4C41);
  static const _edge = Color(0xFF5D4037);
  static const _dimBlue = Color(0xFF1565C0);
  static const _dimBlueFaint = Color(0x601565C0);

  // ── Estado de proyección ──────────────────────────────────────────────────
  late double _cx, _cy, _sc;
  late double _halfL, _halfW;
  late double _cosY, _sinY, _cosX, _sinX;

  void _initProj(Size size) {
    _halfL = layout.largoM / 2;
    _halfW = layout.anchoM / 2;
    final maxD = max(
      layout.largoM,
      max(layout.anchoM, layout.alturaCumbreraM * 1.5),
    );
    _sc = min(size.width, size.height) * 0.52 / maxD;
    _cx = size.width * 0.50;
    _cy = size.height * 0.55;
    _cosY = cos(rotY);
    _sinY = sin(rotY);
    _cosX = cos(rotX);
    _sinX = sin(rotX);
  }

  /// Proyecta punto 3D (x derecha, y arriba, z profundidad) → pantalla.
  Offset _p(double x, double y, double z) {
    final mx = x - _halfL;
    final mz = z - _halfW;
    final x1 = mx * _cosY + mz * _sinY;
    final z1 = -mx * _sinY + mz * _cosY;
    final y1 = y * _cosX - z1 * _sinX;
    return Offset(_cx + x1 * _sc, _cy - y1 * _sc);
  }

  /// True si la cara con normal (nx,ny,nz) apunta hacia la cámara.
  bool _vis(double nx, double ny, double nz) {
    final nz1 = -nx * _sinY + nz * _cosY;
    final nz2 = ny * _sinX + nz1 * _cosX;
    return nz2 < 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAINT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void paint(Canvas canvas, Size size) {
    _initProj(size);
    final l = layout.largoM;
    final w = layout.anchoM;
    final hA = layout.alturaAleroM;
    final hC = layout.alturaCumbreraM;

    // ── Fondo cielo ─────────────────────────────────────────────────────
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(Offset.zero, Offset(0, size.height), [
          const Color(0xFFE8F5E9),
          const Color(0xFFC8E6C9),
        ]),
    );

    // ── Sombra en suelo ─────────────────────────────────────────────────
    _drawShadow(canvas, l, w);

    // ── Visibilidad de caras ────────────────────────────────────────────
    final seeSouth = _vis(0, 0, -1);
    final seeNorth = _vis(0, 0, 1);
    final seeWest = _vis(-1, 0, 0);
    final seeEast = _vis(1, 0, 0);
    final ra = atan2(hC - hA, w / 2);
    final seeSRoof = _vis(0, sin(ra), -cos(ra));

    // ── Paredes traseras (opacas, se ven por detrás) ────────────────────
    if (!seeSouth) {
      _drawLongWall(canvas, l, w, hA, south: true, alpha: 255);
    }
    if (!seeNorth) {
      _drawLongWall(canvas, l, w, hA, south: false, alpha: 255);
    }
    if (!seeWest) {
      _drawEndWall(canvas, l, w, hA, hC, west: true, alpha: 255);
    }
    if (!seeEast) {
      _drawEndWall(canvas, l, w, hA, hC, west: false, alpha: 255);
    }

    // ── Piso con cuadrícula ─────────────────────────────────────────────
    _drawFloor(canvas, l, w);

    // ── Equipos interiores ──────────────────────────────────────────────
    _drawInteriorEquipment(canvas, l, w);

    // ── Corte seccional (cutaway ~35% del largo) ────────────────────────
    const cutFrac = 0.35;
    final cutX = l * cutFrac;
    _drawSectionCut(canvas, cutX, w, hA, hC);

    // ── Techo (panel lejano completo, panel frontal con corte) ──────────
    _drawRoofPanel(canvas, l, w, hA, hC, south: !seeSRoof);
    _drawRoofPanel(canvas, l, w, hA, hC, south: seeSRoof, cutX: cutX);

    // ── Voladizo + cumbrera ─────────────────────────────────────────────
    _drawOverhang(canvas, l, w, hA, hC);
    canvas.drawLine(
      _p(0, hC, w / 2),
      _p(l, hC, w / 2),
      Paint()
        ..color = _edge
        ..strokeWidth = 2.5,
    );

    // ── Paredes frontales con corte (semi-transparentes) ────────────────
    if (seeSouth) {
      _drawLongWall(
        canvas,
        l,
        w,
        hA,
        south: true,
        alpha: 140,
        details: true,
        cutX: cutX,
      );
    }
    if (seeNorth) {
      _drawLongWall(
        canvas,
        l,
        w,
        hA,
        south: false,
        alpha: 140,
        details: true,
        cutX: cutX,
      );
    }
    if (seeWest) {
      _drawEndWall(canvas, l, w, hA, hC, west: true, alpha: 140, details: true);
    }
    if (seeEast) {
      _drawEndWall(
        canvas,
        l,
        w,
        hA,
        hC,
        west: false,
        alpha: 140,
        details: true,
      );
    }

    // ── Acotaciones ─────────────────────────────────────────────────────
    _drawDimensions(canvas, l, w, hA, hC);

    // ── Brújula ─────────────────────────────────────────────────────────
    _drawCompass(canvas, size, layout.esEsteOeste);

    // ── Etiqueta tipo ───────────────────────────────────────────────────
    final tipo = layout.tipo == TipoProduccion.ponedora
        ? 'PONEDORA'
        : 'ENGORDE';
    _drawBadge(canvas, Offset(16, size.height - 20), tipo);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SOMBRA
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawShadow(Canvas c, double l, double w) {
    const off = Offset(8, 6);
    final s0 = _p(0, 0, 0) + off;
    final s1 = _p(l, 0, 0) + off;
    final s2 = _p(l, 0, w) + off;
    final s3 = _p(0, 0, w) + off;
    final path = Path()
      ..moveTo(s0.dx, s0.dy)
      ..lineTo(s1.dx, s1.dy)
      ..lineTo(s2.dx, s2.dy)
      ..lineTo(s3.dx, s3.dy)
      ..close();
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0x30000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PISO
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawFloor(Canvas c, double l, double w) {
    final b0 = _p(0, 0, 0);
    final b1 = _p(l, 0, 0);
    final b2 = _p(l, 0, w);
    final b3 = _p(0, 0, w);
    final path = Path()
      ..moveTo(b0.dx, b0.dy)
      ..lineTo(b1.dx, b1.dy)
      ..lineTo(b2.dx, b2.dy)
      ..lineTo(b3.dx, b3.dy)
      ..close();

    c.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(b3, b1, [
          const Color(0xFFD7CCC8),
          const Color(0xFFEFEBE9),
        ]),
    );

    // Cuadrícula de piso
    c.save();
    c.clipPath(path);
    final gp = Paint()
      ..color = const Color(0x18000000)
      ..strokeWidth = 0.5;
    const step = 2.0;
    for (var x = 0.0; x <= l; x += step) {
      c.drawLine(_p(x, 0, 0), _p(x, 0, w), gp);
    }
    for (var z = 0.0; z <= w; z += step) {
      c.drawLine(_p(0, 0, z), _p(l, 0, z), gp);
    }
    c.restore();

    c.drawPath(
      path,
      Paint()
        ..color = _edge
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAREDES LATERALES (largo, a lo largo de x; z=0 ó z=w)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawLongWall(
    Canvas c,
    double l,
    double w,
    double hA, {
    required bool south,
    required int alpha,
    bool details = false,
    double? cutX,
  }) {
    final z = south ? 0.0 : w;
    final x0 = cutX ?? 0.0;
    final v0 = _p(x0, 0, z);
    final v1 = _p(l, 0, z);
    final v2 = _p(l, hA, z);
    final v3 = _p(x0, hA, z);

    final path = Path()
      ..moveTo(v0.dx, v0.dy)
      ..lineTo(v1.dx, v1.dy)
      ..lineTo(v2.dx, v2.dy)
      ..lineTo(v3.dx, v3.dy)
      ..close();

    final c1 = details ? _wallFront1 : _wallSolid1;
    final c2 = details ? _wallFront2 : _wallSolid2;

    c.save();
    c.clipPath(path);
    c.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(v0, v3, [
          c1.withAlpha(alpha),
          c2.withAlpha(alpha),
        ]),
    );

    if (details) {
      if (south) {
        _drawDoor(c, l, hA, z);
      }
      _drawWindows(c, l, hA, z, avoidDoor: south);
      _drawCortinas(c, l, hA, z);
    }
    c.restore();

    c.drawPath(
      path,
      Paint()
        ..color = _edge
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAREDES EXTREMAS (pentágono con frontón; x=0 ó x=l)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawEndWall(
    Canvas c,
    double l,
    double w,
    double hA,
    double hC, {
    required bool west,
    required int alpha,
    bool details = false,
  }) {
    final x = west ? 0.0 : l;
    final v0 = _p(x, 0, 0);
    final v1 = _p(x, 0, w);
    final v2 = _p(x, hA, w);
    final v3 = _p(x, hC, w / 2);
    final v4 = _p(x, hA, 0);

    final path = Path()
      ..moveTo(v0.dx, v0.dy)
      ..lineTo(v1.dx, v1.dy)
      ..lineTo(v2.dx, v2.dy)
      ..lineTo(v3.dx, v3.dy)
      ..lineTo(v4.dx, v4.dy)
      ..close();

    final c1 = details ? _wallFront1 : _wallSolid1;
    final c2 = details ? _wallFront2 : _wallSolid2;

    c.save();
    c.clipPath(path);
    c.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(v0, v3, [
          c1.withAlpha(alpha),
          c2.withAlpha(alpha),
        ]),
    );

    if (details) {
      _drawWallVents(c, w, hA, x);
    }
    c.restore();

    c.drawPath(
      path,
      Paint()
        ..color = _edge
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PANELES DE TECHO
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawRoofPanel(
    Canvas c,
    double l,
    double w,
    double hA,
    double hC, {
    required bool south,
    double? cutX,
  }) {
    final x0 = cutX ?? 0.0;
    final Offset e0, e1, r0, r1;
    final Color col1, col2;

    if (south) {
      e0 = _p(x0, hA, 0);
      e1 = _p(l, hA, 0);
      r1 = _p(l, hC, w / 2);
      r0 = _p(x0, hC, w / 2);
      col1 = _roofLight1;
      col2 = _roofLight2;
    } else {
      e0 = _p(x0, hA, w);
      e1 = _p(l, hA, w);
      r1 = _p(l, hC, w / 2);
      r0 = _p(x0, hC, w / 2);
      col1 = _roofDark1;
      col2 = _roofDark2;
    }

    final path = Path()
      ..moveTo(e0.dx, e0.dy)
      ..lineTo(e1.dx, e1.dy)
      ..lineTo(r1.dx, r1.dy)
      ..lineTo(r0.dx, r0.dy)
      ..close();

    c.save();
    c.clipPath(path);
    c.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(e0, r0, [
          col1.withAlpha(210),
          col2.withAlpha(210),
        ]),
    );
    // Líneas de teja
    final tejaP = Paint()
      ..color = const Color(0x20000000)
      ..strokeWidth = 0.6;
    const rows = 6;
    for (var i = 1; i < rows; i++) {
      final t = i / rows;
      c.drawLine(Offset.lerp(e0, r0, t)!, Offset.lerp(e1, r1, t)!, tejaP);
    }
    c.restore();

    c.drawPath(
      path,
      Paint()
        ..color = _edge
        ..strokeWidth = 1.4
        ..style = PaintingStyle.stroke,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VOLADIZO
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawOverhang(Canvas c, double l, double w, double hA, double hC) {
    const oh = 0.3;
    final ov0 = _p(-oh, hA, -oh);
    final ov1 = _p(l + oh, hA, -oh);
    final ovr0 = _p(-oh, hC, w / 2);
    final ovr1 = _p(l + oh, hC, w / 2);
    final path = Path()
      ..moveTo(ov0.dx, ov0.dy)
      ..lineTo(ov1.dx, ov1.dy)
      ..lineTo(ovr1.dx, ovr1.dy)
      ..lineTo(ovr0.dx, ovr0.dy)
      ..close();
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0x18000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CORTE SECCIONAL (CUTAWAY)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dibuja la sección transversal del edificio en el plano de corte (x=cutX).
  /// Muestra el perfil del galpón con relleno achurado arquitectónico.
  void _drawSectionCut(Canvas c, double cutX, double w, double hA, double hC) {
    // Perfil pentagonal del edificio en el plano de corte
    final v0 = _p(cutX, 0, 0);
    final v1 = _p(cutX, 0, w);
    final v2 = _p(cutX, hA, w);
    final v3 = _p(cutX, hC, w / 2);
    final v4 = _p(cutX, hA, 0);

    final profile = Path()
      ..moveTo(v0.dx, v0.dy)
      ..lineTo(v1.dx, v1.dy)
      ..lineTo(v2.dx, v2.dy)
      ..lineTo(v3.dx, v3.dy)
      ..lineTo(v4.dx, v4.dy)
      ..close();

    // Relleno cálido semi‑transparente
    c.drawPath(profile, Paint()..color = const Color(0x28795548));

    // Achurado diagonal 45° (estilo arquitectónico)
    c.save();
    c.clipPath(profile);
    final hatchP = Paint()
      ..color = const Color(0x50795548)
      ..strokeWidth = 0.7;
    final bounds = profile.getBounds();
    final dim = max(bounds.width, bounds.height);
    const step = 5.0;
    for (var d = -dim; d < dim * 2; d += step) {
      c.drawLine(
        Offset(bounds.left + d, bounds.top),
        Offset(bounds.left + d + dim, bounds.bottom),
        hatchP,
      );
    }
    c.restore();

    // Borde de corte grueso
    c.drawPath(
      profile,
      Paint()
        ..color = _edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // Etiqueta "CORTE"
    final labelPos = Offset(v3.dx, v3.dy - 10);
    final tp = TextPainter(
      text: const TextSpan(
        text: 'CORTE',
        style: TextStyle(
          fontSize: 7,
          color: Color(0xFF5D4037),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final bg = Rect.fromCenter(
      center: labelPos,
      width: tp.width + 6,
      height: tp.height + 3,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bg, const Radius.circular(2)),
      Paint()..color = const Color(0xE0FFFFFF),
    );
    tp.paint(
      c,
      Offset(labelPos.dx - tp.width / 2, labelPos.dy - tp.height / 2),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DETALLES ARQUITECTÓNICOS EN PAREDES
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDoor(Canvas c, double l, double hA, double z) {
    final doorW = min(2.0, l * 0.12);
    final doorH = hA * 0.7;
    final doorX = l * 0.15;

    final d0 = _p(doorX, 0, z);
    final d1 = _p(doorX + doorW, 0, z);
    final d2 = _p(doorX + doorW, doorH, z);
    final d3 = _p(doorX, doorH, z);

    final path = Path()
      ..moveTo(d0.dx, d0.dy)
      ..lineTo(d1.dx, d1.dy)
      ..lineTo(d2.dx, d2.dy)
      ..lineTo(d3.dx, d3.dy)
      ..close();

    c.drawPath(
      path,
      Paint()
        ..shader = ui.Gradient.linear(d0, d2, [
          const Color(0xFF5D4037),
          const Color(0xFF795548),
        ]),
    );
    c.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF3E2723)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
    final handlePos = Offset.lerp(d1, d2, 0.55)!;
    c.drawCircle(handlePos, 1.2, Paint()..color = const Color(0xFFFFD54F));
  }

  void _drawWindows(
    Canvas c,
    double l,
    double hA,
    double z, {
    bool avoidDoor = false,
  }) {
    final winW = min(1.5, l * 0.06);
    final winH = hA * 0.3;
    final winY = hA * 0.45;
    final numWin = max(2, (l / 6).floor());
    final step = l / (numWin + 1);

    final winStroke = Paint()
      ..color = const Color(0xFF4E342E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = 0; i < numWin; i++) {
      final wx = step * (i + 1);
      if (avoidDoor && (wx - l * 0.15).abs() < 2.5) {
        continue;
      }

      final w0 = _p(wx, winY, z);
      final w1 = _p(wx + winW, winY, z);
      final w2 = _p(wx + winW, winY + winH, z);
      final w3 = _p(wx, winY + winH, z);

      final winPath = Path()
        ..moveTo(w0.dx, w0.dy)
        ..lineTo(w1.dx, w1.dy)
        ..lineTo(w2.dx, w2.dy)
        ..lineTo(w3.dx, w3.dy)
        ..close();

      c.drawPath(
        winPath,
        Paint()
          ..shader = ui.Gradient.linear(w0, w3, [
            const Color(0xB0B3E5FC),
            const Color(0xB081D4FA),
          ]),
      );
      c.drawPath(winPath, winStroke);
      // Cruz
      c.drawLine(
        Offset.lerp(w0, w3, 0.5)!,
        Offset.lerp(w1, w2, 0.5)!,
        winStroke,
      );
      c.drawLine(
        Offset.lerp(w0, w1, 0.5)!,
        Offset.lerp(w3, w2, 0.5)!,
        winStroke,
      );
    }
  }

  void _drawCortinas(Canvas c, double l, double hA, double z) {
    final cortinaP = Paint()
      ..color = const Color(0x3066BB6A)
      ..strokeWidth = max(1.0, 0.06 * _sc);
    const n = 4;
    for (var i = 1; i <= n; i++) {
      final y = hA * (i / (n + 1)) * 0.4;
      c.drawLine(_p(0, y, z), _p(l, y, z), cortinaP);
    }
  }

  void _drawWallVents(Canvas c, double w, double hA, double x) {
    final numV = layout.numVentiladores;
    if (numV <= 0) return;
    final perSide = (numV / 2).ceil();
    final ventR = max(3.0, 0.5 * _sc);

    for (var i = 0; i < perSide; i++) {
      final step = w / (perSide + 1);
      final z = step * (i + 1);
      final center = _p(x, hA * 0.5, z);

      c.drawCircle(center, ventR, Paint()..color = const Color(0x6078909C));
      c.drawCircle(
        center,
        ventR,
        Paint()
          ..color = const Color(0xFF546E7A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      final bp = Paint()
        ..color = const Color(0x90FFFFFF)
        ..strokeWidth = 0.8;
      for (var a = 0; a < 4; a++) {
        final ang = a * pi / 2 + pi / 6;
        c.drawLine(
          center,
          Offset(
            center.dx + ventR * 0.7 * cos(ang),
            center.dy + ventR * 0.7 * sin(ang),
          ),
          bp,
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EQUIPOS INTERIORES
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawInteriorEquipment(Canvas c, double l, double w) {
    // Bebederos
    final bebP = Paint()
      ..color = const Color(0x901565C0)
      ..strokeWidth = max(1.2, 0.08 * _sc);
    for (final y in layout.posYBebederos) {
      c.drawLine(
        _p(layout.margen, 0.05, y),
        _p(l - layout.margen, 0.05, y),
        bebP,
      );
    }

    // Comederos
    final comP = Paint()..color = const Color(0xCCF57C00);
    final comR = max(1.5, 0.15 * _sc);
    for (final y in layout.posYComederos) {
      final perRow = layout.comederosPorFila;
      final sep = layout.separacionComederos;
      for (var i = 0; i < perRow; i++) {
        final x = layout.margen + sep * (i + 1);
        if (x > l - layout.margen * 0.5) break;
        c.drawCircle(_p(x, 0.05, y), comR, comP);
      }
    }

    // Campanas de calefacción
    for (final pos in layout.posicionesCampanas) {
      final px = _p(pos.dx, 0.1, pos.dy);
      c.drawCircle(
        px,
        max(3.0, 0.6 * _sc),
        Paint()..color = const Color(0x40E53935),
      );
      c.drawCircle(
        px,
        max(1.5, 0.3 * _sc),
        Paint()..color = const Color(0xCCE53935),
      );
    }

    // Nidales (ponedora)
    if (layout.tipo == TipoProduccion.ponedora) {
      final nidalP = Paint()..color = const Color(0xB06D4C41);
      for (final pos in layout.posicionesNidales) {
        final px = _p(pos.dx, 0.05, pos.dy);
        c.drawRect(
          Rect.fromCenter(
            center: px,
            width: max(4, 0.5 * _sc),
            height: max(3, 0.3 * _sc),
          ),
          nidalP,
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACOTACIONES
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDimensions(Canvas c, double l, double w, double hA, double hC) {
    final dimP = Paint()
      ..color = _dimBlue
      ..strokeWidth = 0.8;
    final extP = Paint()
      ..color = _dimBlueFaint
      ..strokeWidth = 0.5;

    // Largo
    final dl0 = _p(0, 0, -2.0);
    final dl1 = _p(l, 0, -2.0);
    c.drawLine(_p(0, 0, 0), dl0, extP);
    c.drawLine(_p(l, 0, 0), dl1, extP);
    _drawDimLine(c, dl0, dl1, '${l.toStringAsFixed(1)} m', dimP);

    // Ancho
    final dw0 = _p(l + 2.0, 0, 0);
    final dw1 = _p(l + 2.0, 0, w);
    c.drawLine(_p(l, 0, 0), dw0, extP);
    c.drawLine(_p(l, 0, w), dw1, extP);
    _drawDimLine(c, dw0, dw1, '${w.toStringAsFixed(1)} m', dimP);

    // Altura alero
    final dha0 = _p(-2.2, 0, 0);
    final dha1 = _p(-2.2, hA, 0);
    c.drawLine(_p(0, 0, 0), dha0, extP);
    c.drawLine(_p(0, hA, 0), dha1, extP);
    _drawDimLine(
      c,
      dha0,
      dha1,
      '${hA.toStringAsFixed(1)} m',
      dimP,
      labelOffset: -14,
    );

    // Altura cumbrera
    final dhc0 = _p(-3.8, 0, 0);
    final dhc1 = _p(-3.8, hC, 0);
    c.drawLine(dha0, dhc0, extP);
    c.drawLine(_p(-2.2, hC, 0), dhc1, extP);
    _drawDimLine(
      c,
      dhc0,
      dhc1,
      '${hC.toStringAsFixed(1)} m',
      dimP,
      labelOffset: -14,
    );
  }

  void _drawDimLine(
    Canvas c,
    Offset start,
    Offset end,
    String label,
    Paint paint, {
    double labelOffset = 8,
  }) {
    c.drawLine(start, end, paint);
    const aSize = 5.0;
    final angle = atan2(end.dy - start.dy, end.dx - start.dx);
    for (final pt in [start, end]) {
      final sign = pt == start ? 1.0 : -1.0;
      final a1 = Offset(
        pt.dx + sign * aSize * cos(angle + 0.35),
        pt.dy + sign * aSize * sin(angle + 0.35),
      );
      final a2 = Offset(
        pt.dx + sign * aSize * cos(angle - 0.35),
        pt.dy + sign * aSize * sin(angle - 0.35),
      );
      c.drawPath(
        Path()
          ..moveTo(pt.dx, pt.dy)
          ..lineTo(a1.dx, a1.dy)
          ..lineTo(a2.dx, a2.dy)
          ..close(),
        Paint()..color = paint.color,
      );
    }
    final mid = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
    _drawLabelWithBg(c, label, mid, labelOffset);
  }

  void _drawLabelWithBg(Canvas c, String text, Offset pos, double offsetY) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 9,
          color: Color(0xFF0D47A1),
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final textPos = Offset(pos.dx - tp.width / 2, pos.dy + offsetY);
    final bgRect = Rect.fromLTWH(
      textPos.dx - 3,
      textPos.dy - 1,
      tp.width + 6,
      tp.height + 2,
    );
    c.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(2)),
      Paint()..color = const Color(0xE0FFFFFF),
    );
    tp.paint(c, textPos);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BRÚJULA
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawCompass(Canvas c, Size size, bool esteOeste) {
    final cx = size.width - 36;
    const cy = 36.0;
    const r = 20.0;

    c.drawCircle(
      Offset(cx + 1, cy + 1),
      r + 1,
      Paint()
        ..color = const Color(0x20000000)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    c.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = ui.Gradient.radial(Offset(cx - 4, cy - 4), r * 1.5, [
          const Color(0xFFFAFAFA),
          const Color(0xFFE0E0E0),
        ]),
    );
    c.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = _edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    c.drawCircle(
      Offset(cx, cy),
      r * 0.35,
      Paint()
        ..color = _edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5,
    );

    // Flecha norte
    c.drawPath(
      Path()
        ..moveTo(cx, cy - r + 4)
        ..lineTo(cx - 4, cy)
        ..lineTo(cx, cy + r - 10)
        ..close(),
      Paint()..color = const Color(0xFFCCCCCC),
    );
    c.drawPath(
      Path()
        ..moveTo(cx, cy - r + 4)
        ..lineTo(cx + 4, cy)
        ..lineTo(cx, cy + r - 10)
        ..close(),
      Paint()..color = const Color(0xFFC62828),
    );
    c.drawCircle(Offset(cx, cy), 2, Paint()..color = _edge);

    final labels = esteOeste
        ? [('N', 0.0, -1.0), ('S', 0.0, 1.0), ('E', 1.0, 0.0), ('O', -1.0, 0.0)]
        : [
            ('N', -1.0, 0.0),
            ('S', 1.0, 0.0),
            ('E', 0.0, -1.0),
            ('O', 0.0, 1.0),
          ];

    for (final (letter, dx, dy) in labels) {
      final tp = TextPainter(
        text: TextSpan(
          text: letter,
          style: TextStyle(
            fontSize: letter == 'N' ? 10 : 7,
            color: letter == 'N' ? const Color(0xFFC62828) : _edge,
            fontWeight: letter == 'N' ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        c,
        Offset(
          cx + dx * (r - 6) - tp.width / 2,
          cy + dy * (r - 6) - tp.height / 2,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawBadge(Canvas c, Offset pos, String text) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        pos.dx,
        pos.dy - tp.height - 4,
        tp.width + 12,
        tp.height + 6,
      ),
      const Radius.circular(3),
    );
    c.drawRRect(bgRect, Paint()..color = const Color(0xFF2E7D32));
    tp.paint(c, Offset(pos.dx + 6, pos.dy - tp.height - 1));
  }

  @override
  bool shouldRepaint(GalponIsometricPainter old) =>
      layout != old.layout || rotX != old.rotX || rotY != old.rotY;
}
