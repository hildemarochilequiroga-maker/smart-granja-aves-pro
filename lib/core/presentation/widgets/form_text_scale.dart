/// Escala de texto para formularios de registro.
///
/// Envuelve a [child] en un [MediaQuery] que aumenta el `textScaler` un
/// [factor] sobre la escala actual del sistema. Así todo el texto descendiente
/// (labels, encabezados, subtítulos, texto ingresado, métricas, botones…) se ve
/// más grande de forma uniforme, sin tener que tocar cada `Text` individual.
library;

import 'package:flutter/material.dart';

/// Agranda todo el texto descendiente multiplicando la escala actual por
/// [factor] (por defecto 1.15 = 15% más grande), respetando el ajuste de
/// accesibilidad del sistema.
class FormTextScale extends StatelessWidget {
  const FormTextScale({super.key, required this.child, this.factor = 1.15});

  final Widget child;
  final double factor;

  @override
  Widget build(BuildContext context) {
    final currentScale = MediaQuery.textScalerOf(context).scale(1.0);
    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(currentScale * factor)),
      child: child,
    );
  }
}
