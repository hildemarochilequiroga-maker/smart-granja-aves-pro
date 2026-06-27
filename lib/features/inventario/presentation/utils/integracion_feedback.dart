/// Helper de presentación para comunicar el desenlace de una integración de
/// inventario de forma consistente en todas las pantallas que la disparan
/// (costos, consumo, ventas, tratamientos, vacunación, desinfección).
library;

import 'package:flutter/widgets.dart';

import '../../../../core/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/value_objects/resultado_integracion.dart';

/// Muestra el feedback adecuado para un [ResultadoIntegracion], sin bloquear el
/// flujo del registro primario (que ya quedó guardado):
///
/// - éxito / omitido → no muestra nada (es el caso esperado, no se molesta al
///   usuario con un "ok" redundante).
/// - sincronización diferida (pendiente de reintento) → mensaje informativo y
///   tranquilizador: el dato se guardó y el inventario se sincroniza solo.
/// - fallo de negocio (stock insuficiente, etc.) → advertencia accionable.
void mostrarFeedbackIntegracion(
  BuildContext context,
  ResultadoIntegracion resultado,
) {
  if (!context.mounted) return;
  switch (resultado.estado) {
    case EstadoIntegracion.exitoso:
    case EstadoIntegracion.omitido:
      break;
    case EstadoIntegracion.pendienteReintento:
      AppSnackBar.info(
        context,
        message: S.of(context).inventorySyncDeferred,
      );
    case EstadoIntegracion.fallidoNegocio:
      AppSnackBar.warning(
        context,
        message:
            resultado.razon ?? S.of(context).costRegisteredInventoryError,
      );
  }
}

/// Variante para cuando una sola acción dispara varias integraciones (p. ej.
/// una venta de huevos con varias clasificaciones). Muestra un único feedback
/// del desenlace más relevante: un fallo de negocio prevalece sobre una
/// sincronización diferida, y esta sobre el éxito/omisión silenciosos.
void mostrarFeedbackIntegracionMultiple(
  BuildContext context,
  List<ResultadoIntegracion> resultados,
) {
  if (resultados.isEmpty) return;
  final fallido = resultados
      .where((r) => r.estado == EstadoIntegracion.fallidoNegocio)
      .firstOrNull;
  if (fallido != null) {
    mostrarFeedbackIntegracion(context, fallido);
    return;
  }
  final pendiente = resultados
      .where((r) => r.estado == EstadoIntegracion.pendienteReintento)
      .firstOrNull;
  if (pendiente != null) {
    mostrarFeedbackIntegracion(context, pendiente);
  }
  // Si todas fueron éxito/omitido, no se muestra nada.
}
