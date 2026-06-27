/// Resultado explícito de una integración de inventario (entrada/salida
/// disparada desde Costos, Consumo, Ventas, Salud, etc.).
///
/// Reemplaza el antiguo patrón de devolver `null` ante cualquier problema, que
/// ocultaba al llamador si la integración se completó, se omitió por una razón
/// de negocio, o falló por un problema transitorio (red) que debe reintentarse.
library;

import 'package:equatable/equatable.dart';

import '../entities/movimiento_inventario.dart';

/// Clasificación del desenlace de una integración de inventario.
enum EstadoIntegracion {
  /// La integración se completó: el movimiento de stock quedó registrado.
  exitoso,

  /// La integración no aplicaba y se omitió de forma intencional (p. ej. un
  /// costo que no es de alimento/medicamento, o no se eligió ningún item).
  /// No es un error: no hay nada que reintentar ni que avisar como problema.
  omitido,

  /// La integración falló por una condición de negocio NO reintentable
  /// (p. ej. stock insuficiente, item inexistente). Reintentar no la
  /// resolvería; requiere acción del usuario.
  fallidoNegocio,

  /// La integración falló por un problema transitorio (red, timeout, conflicto
  /// de transacción). Se encoló para reintento automático: el dato primario se
  /// conservó y la sincronización del inventario se completará al reconciliar.
  pendienteReintento,
}

/// Resultado tipado de una operación de integración de inventario.
class ResultadoIntegracion extends Equatable {
  const ResultadoIntegracion._({
    required this.estado,
    this.movimiento,
    this.razon,
  });

  /// Desenlace de la integración.
  final EstadoIntegracion estado;

  /// Movimiento de inventario generado (solo en [EstadoIntegracion.exitoso]).
  final MovimientoInventario? movimiento;

  /// Motivo legible del desenlace (para omitido/fallido/pendiente).
  final String? razon;

  /// La integración se completó correctamente.
  factory ResultadoIntegracion.exitoso(MovimientoInventario movimiento) =>
      ResultadoIntegracion._(
        estado: EstadoIntegracion.exitoso,
        movimiento: movimiento,
      );

  /// La integración no aplicaba; se omitió intencionalmente.
  factory ResultadoIntegracion.omitido(String razon) =>
      ResultadoIntegracion._(estado: EstadoIntegracion.omitido, razon: razon);

  /// Falló por una condición de negocio que el usuario debe resolver.
  factory ResultadoIntegracion.fallidoNegocio(String razon) =>
      ResultadoIntegracion._(
        estado: EstadoIntegracion.fallidoNegocio,
        razon: razon,
      );

  /// Falló por un problema transitorio; quedó encolada para reintento.
  factory ResultadoIntegracion.pendienteReintento(String razon) =>
      ResultadoIntegracion._(
        estado: EstadoIntegracion.pendienteReintento,
        razon: razon,
      );

  /// `true` si el movimiento quedó registrado.
  bool get fueExitoso => estado == EstadoIntegracion.exitoso;

  /// `true` si hay algo que comunicar al usuario como advertencia (un fallo de
  /// negocio o una sincronización diferida). `omitido` y `exitoso` no avisan.
  bool get requiereAviso =>
      estado == EstadoIntegracion.fallidoNegocio ||
      estado == EstadoIntegracion.pendienteReintento;

  @override
  List<Object?> get props => [estado, movimiento, razon];
}
