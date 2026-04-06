/// Configuración de animaciones de la aplicación
library;

import 'package:flutter/material.dart';

/// Constantes y configuraciones de animaciones
abstract final class AppAnimations {
  const AppAnimations._();

  // ===========================================================================
  // DURACIONES
  // ===========================================================================

  /// Duración muy rápida (feedback inmediato)
  static const Duration fastest = Duration(milliseconds: 100);

  /// Duración rápida (microinteracciones)
  static const Duration fast = Duration(milliseconds: 200);

  /// Duración media (transiciones de elementos)
  static const Duration medium = Duration(milliseconds: 350);

  /// Duración lenta (transiciones complejas)
  static const Duration slow = Duration(milliseconds: 500);

  /// Duración de transición de página
  static const Duration pageTransition = Duration(milliseconds: 400);

  /// Duración del splash screen
  static const Duration splashDuration = Duration(milliseconds: 2500);

  /// Delay entre animaciones secuenciales
  static const Duration staggerDelay = Duration(milliseconds: 80);

  // ===========================================================================
  // REDUCED MOTION SUPPORT
  // ===========================================================================

  /// Verifica si el usuario tiene activada la opción de reducir animaciones.
  ///
  /// Respeta `AccessibilityFeatures.reduceMotion` del sistema operativo.
  static bool shouldReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Retorna [Duration.zero] si el usuario tiene animaciones reducidas,
  /// o la duración [normal] si no.
  ///
  /// ```dart
  /// duration: AppAnimations.durationFor(context, AppAnimations.pageTransition),
  /// ```
  static Duration durationFor(BuildContext context, Duration normal) {
    return MediaQuery.of(context).disableAnimations ? Duration.zero : normal;
  }

  // ===========================================================================
  // CURVAS DE ANIMACIÓN
  // ===========================================================================

  /// Curva de entrada suave (elementos que aparecen)
  static const Curve enterCurve = Curves.easeOutCubic;

  /// Curva de salida suave (elementos que desaparecen)
  static const Curve exitCurve = Curves.easeInCubic;

  /// Curva estándar (movimiento natural)
  static const Curve standardCurve = Curves.easeInOutCubic;

  /// Curva con rebote (feedback de botones)
  static const Curve bounceCurve = Curves.elasticOut;

  /// Curva de énfasis (llamar atención)
  static const Curve emphasisCurve = Curves.easeOutBack;

  /// Curva de desaceleración (llegada a destino)
  static const Curve decelerateCurve = Curves.decelerate;

  // ===========================================================================
  // TRANSICIONES DE PÁGINA
  // ===========================================================================

  /// Crear transición de fade
  static Widget fadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: enterCurve),
      child: child,
    );
  }

  /// Crear transición de slide desde la derecha
  static Widget slideFromRight(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: enterCurve)),
      child: child,
    );
  }

  /// Crear transición de slide desde abajo
  static Widget slideFromBottom(Animation<double> animation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: enterCurve)),
      child: child,
    );
  }

  /// Crear transición de scale con fade
  static Widget scaleWithFade(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: enterCurve),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: enterCurve)),
        child: child,
      ),
    );
  }

  // ===========================================================================
  // HELPERS DE ANIMACIÓN
  // ===========================================================================

  /// Crear un intervalo de animación para efectos staggered
  static Animation<double> staggeredAnimation({
    required AnimationController controller,
    required int index,
    required int totalItems,
    double overlap = 0.4,
  }) {
    final start = (index / totalItems) * (1 - overlap);
    final end = start + overlap;

    return CurvedAnimation(
      parent: controller,
      curve: Interval(
        start.clamp(0.0, 1.0),
        end.clamp(0.0, 1.0),
        curve: enterCurve,
      ),
    );
  }
}

/// Extension para agregar animaciones fácilmente a widgets
extension AnimatedWidgetExtension on Widget {
  /// Envolver en un FadeTransition
  Widget fadeIn({
    required Animation<double> animation,
    Curve curve = AppAnimations.enterCurve,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve),
      child: this,
    );
  }

  /// Envolver en un SlideTransition
  Widget slideIn({
    required Animation<double> animation,
    Offset begin = const Offset(0.0, 0.3),
    Curve curve = AppAnimations.enterCurve,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve)),
      child: this,
    );
  }

  /// Envolver en ambos Fade y Slide
  Widget fadeSlideIn({
    required Animation<double> animation,
    Offset begin = const Offset(0.0, 0.2),
    Curve curve = AppAnimations.enterCurve,
  }) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: curve),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve)),
        child: this,
      ),
    );
  }

  // ===========================================================================
  // IMPLICIT ENTRANCE ANIMATIONS (no AnimationController needed)
  // ===========================================================================

  /// Entrada de card — fade + slide up (400ms, translateY 20px).
  ///
  /// Patrón estándar para cards de entidades y registros en listas.
  /// No necesita AnimationController — usa [TweenAnimationBuilder].
  Widget cardEntrance({
    Duration duration = AppAnimations.pageTransition,
    double translateY = 20.0,
    Curve curve = AppAnimations.enterCurve,
    Key? key,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translateY * (1 - value)),
            child: child,
          ),
        );
      },
      child: this,
    );
  }

  /// Entrada de card resumen — fade + slide up más suave (500ms, translateY 15px).
  ///
  /// Para cards de resumen/estadísticas en la parte superior de listas.
  Widget summaryEntrance({Key? key}) {
    return cardEntrance(
      duration: AppAnimations.slow,
      translateY: 15.0,
      key: key,
    );
  }

  /// Entrada escalonada para items en listas — delay incremental por índice.
  ///
  /// Base 300ms + 50ms por item, con máximo de 200ms de stagger adicional.
  Widget staggeredEntrance({
    required int index,
    int baseMs = 300,
    int perItemMs = 50,
    int maxStaggerMs = 200,
    double translateY = 20.0,
    Curve curve = AppAnimations.enterCurve,
    Key? key,
  }) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(
        milliseconds: baseMs + (index * perItemMs).clamp(0, maxStaggerMs),
      ),
      curve: curve,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translateY * (1 - value)),
            child: child,
          ),
        );
      },
      child: this,
    );
  }
}
