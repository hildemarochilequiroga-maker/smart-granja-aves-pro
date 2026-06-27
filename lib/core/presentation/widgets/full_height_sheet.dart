/// Helper para presentar contenido a pantalla casi completa dentro de un
/// bottom sheet modal.
///
/// Se usa para convertir flujos que originalmente eran pantallas completas
/// (con su propio [Scaffold]) en bottom sheets, sin tener que reescribir su
/// lógica interna: el contenido se monta tal cual dentro de un contenedor
/// redondeado con un alto fijo (casi pantalla completa).
library;

import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

/// Muestra [child] dentro de un bottom sheet modal a casi pantalla completa.
///
/// El [child] puede ser una pantalla completa (incluso con su propio
/// [Scaffold]); se renderiza dentro de un contenedor con esquinas superiores
/// redondeadas y un alto fijo ([heightFactor] del alto disponible). Se usa un
/// alto fijo (en vez de un sheet arrastrable) para evitar overflows cuando el
/// contenido tiene botones fijos abajo. Devuelve el valor con el que se cierre
/// la hoja.
Future<T?> showFullHeightSheet<T>({
  required BuildContext context,
  required Widget child,
  double heightFactor = 0.92,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final maxHeight = MediaQuery.sizeOf(sheetContext).height;
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        child: SizedBox(
          height: maxHeight * heightFactor,
          // El contenido (p.ej. una pantalla con Scaffold) ocupa todo el alto
          // fijo de la hoja y maneja su propio scroll interno.
          child: child,
        ),
      );
    },
  );
}
