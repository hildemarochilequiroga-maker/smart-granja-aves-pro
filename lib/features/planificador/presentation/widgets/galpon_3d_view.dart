import 'dart:math';

import 'package:flutter/material.dart';

import 'galpon_isometric_painter.dart';
import 'galpon_layout.dart';

/// Vista 3D interactiva del galpón con gestos de rotación, zoom y pan.
///
/// - **Un dedo**: rota el modelo (arrastre horizontal/vertical).
/// - **Dos dedos**: zoom (pellizcar) y pan (arrastrar).
/// - **Doble tap**: restablece la vista por defecto con animación.
class GalponInteractive3DView extends StatefulWidget {
  const GalponInteractive3DView({super.key, required this.layout});

  final GalponLayout layout;

  @override
  State<GalponInteractive3DView> createState() =>
      _GalponInteractive3DViewState();
}

class _GalponInteractive3DViewState extends State<GalponInteractive3DView>
    with TickerProviderStateMixin {
  double _rotX = GalponIsometricPainter.defaultRotX;
  double _rotY = GalponIsometricPainter.defaultRotY;
  static const _defaultZoom = 1.35;
  double _zoom = _defaultZoom;
  double _baseZoom = _defaultZoom;
  Offset _pan = Offset.zero;
  Offset _lastFocal = Offset.zero;

  late final AnimationController _resetCtrl;
  late final AnimationController _flingCtrl;
  double _rStartRotX = 0;
  double _rStartRotY = 0;
  double _rStartZoom = _defaultZoom;
  Offset _rStartPan = Offset.zero;

  // Velocidad para inercia
  Offset _velocity = Offset.zero;
  double _flingStartRotX = 0;
  double _flingStartRotY = 0;

  static const _minRotX = -1.4;
  static const _maxRotX = -0.08;
  static const _minZoom = 0.5;
  static const _maxZoom = 4.0;
  // Sensibilidad de rotación — mayor = más fluido
  static const _rotSensitivity = 0.012;

  @override
  void initState() {
    super.initState();
    _resetCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(_onResetTick);
    _flingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(_onFlingTick);
  }

  @override
  void dispose() {
    _resetCtrl.dispose();
    _flingCtrl.dispose();
    super.dispose();
  }

  // ── Animación de reset ──────────────────────────────────────────────────

  void _onResetTick() {
    final t = Curves.easeOut.transform(_resetCtrl.value);
    setState(() {
      _rotX = _lerp(_rStartRotX, GalponIsometricPainter.defaultRotX, t);
      _rotY = _lerp(_rStartRotY, GalponIsometricPainter.defaultRotY, t);
      _zoom = _lerp(_rStartZoom, _defaultZoom, t);
      _pan = Offset.lerp(_rStartPan, Offset.zero, t)!;
    });
  }

  // ── Animación de inercia ────────────────────────────────────────────────

  void _onFlingTick() {
    final t = Curves.decelerate.transform(_flingCtrl.value);
    setState(() {
      _rotY = _flingStartRotY + _velocity.dx * _rotSensitivity * 18 * t;
      _rotX = (_flingStartRotX - _velocity.dy * _rotSensitivity * 18 * t).clamp(
        _minRotX,
        _maxRotX,
      );
    });
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;

  void _resetView() {
    _flingCtrl.stop();
    _rStartRotX = _rotX;
    _rStartRotY = _rotY;
    _rStartZoom = _zoom;
    _rStartPan = _pan;
    _resetCtrl.forward(from: 0);
  }

  // ── Gestos ──────────────────────────────────────────────────────────────

  void _onScaleStart(ScaleStartDetails details) {
    _flingCtrl.stop();
    _lastFocal = details.focalPoint;
    _baseZoom = _zoom;
    _velocity = Offset.zero;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      final delta = details.focalPoint - _lastFocal;
      _lastFocal = details.focalPoint;

      if (details.pointerCount == 1) {
        // Un dedo → rotar (sensibilidad mejorada)
        _rotY += delta.dx * _rotSensitivity;
        _rotX = (_rotX - delta.dy * _rotSensitivity).clamp(_minRotX, _maxRotX);
        // Acumular velocidad para inercia
        _velocity = delta;
      } else {
        // Varios dedos → zoom + pan
        _zoom = (_baseZoom * details.scale).clamp(_minZoom, _maxZoom);
        _pan += delta;
      }
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    // Inercia de rotación si el gesto fue rápido
    if (_velocity.distance > 2.0) {
      _flingStartRotX = _rotX;
      _flingStartRotY = _rotY;
      _flingCtrl.forward(from: 0);
    }
  }

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Vista interactiva
        GestureDetector(
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          onDoubleTap: _resetView,
          child: ClipRect(
            child: Transform.translate(
              offset: _pan,
              child: Transform.scale(
                scale: _zoom,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: GalponIsometricPainter(
                      widget.layout,
                      rotX: _rotX,
                      rotY: _rotY,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Controles flotantes
        Positioned(
          right: 8,
          bottom: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _MiniButton(
                icon: Icons.add,
                onTap: () => setState(() {
                  _zoom = (_zoom * 1.3).clamp(_minZoom, _maxZoom);
                }),
              ),
              const SizedBox(height: 4),
              _MiniButton(
                icon: Icons.remove,
                onTap: () => setState(() {
                  _zoom = (_zoom / 1.3).clamp(_minZoom, _maxZoom);
                }),
              ),
              const SizedBox(height: 4),
              _MiniButton(icon: Icons.refresh, onTap: _resetView),
            ],
          ),
        ),

        // Indicador de gesto
        Positioned(
          left: 8,
          bottom: 8,
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(90),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 10,
                    color: Colors.white.withAlpha(180),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Girar',
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 9,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Transform.rotate(
                    angle: pi / 4,
                    child: Icon(
                      Icons.open_with,
                      size: 10,
                      color: Colors.white.withAlpha(180),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Zoom / Mover',
                    style: TextStyle(
                      color: Colors.white.withAlpha(180),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Indicador de zoom
        if ((_zoom - _defaultZoom).abs() > 0.05)
          Positioned(
            right: 8,
            top: 8,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(90),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${(_zoom * 100).round()}%',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Botón mini circular reutilizable
// ═══════════════════════════════════════════════════════════════════════════════

class _MiniButton extends StatelessWidget {
  const _MiniButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withAlpha(210),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 16, color: const Color(0xFF455A64)),
        ),
      ),
    );
  }
}
