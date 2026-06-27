/// Entidad que representa una integración de inventario que falló por un
/// problema transitorio y quedó encolada para reintento automático.
///
/// Garantiza que el inventario nunca se desincronice en silencio del dato
/// primario (un costo, un consumo, una venta, etc.): si la actualización de
/// stock no se pudo aplicar en el momento, se persiste aquí con todos los
/// datos necesarios para re-ejecutarla y el reconciliador la completa después.
library;

import 'package:equatable/equatable.dart';

/// Tipo de operación de inventario encolada, identifica qué método del
/// servicio de integración debe re-ejecutarse al reconciliar.
enum TipoIntegracionPendiente {
  entradaDesdeCosto,
  salidaDesdeConsumo,
  salidaDesdeVenta,
  salidaDesdeTratamiento,
  salidaDesdeVacunacion,
  salidaDesdeDesinfeccion;

  String toJson() => name;

  static TipoIntegracionPendiente fromJson(String value) =>
      TipoIntegracionPendiente.values.firstWhere(
        (e) => e.name == value,
        orElse: () => TipoIntegracionPendiente.entradaDesdeCosto,
      );
}

/// Una integración de inventario pendiente de aplicarse.
class IntegracionPendiente extends Equatable {
  const IntegracionPendiente({
    required this.id,
    required this.granjaId,
    required this.tipo,
    required this.parametros,
    required this.creadoEn,
    this.intentos = 0,
    this.ultimoError,
    this.ultimoIntento,
  });

  /// ID del documento.
  final String id;

  /// Granja a la que pertenece (para filtrar y para reglas de seguridad).
  final String granjaId;

  /// Operación a re-ejecutar.
  final TipoIntegracionPendiente tipo;

  /// Parámetros serializados de la llamada original (claves = nombres de los
  /// argumentos del método del servicio). Se re-hidratan al reconciliar.
  final Map<String, dynamic> parametros;

  /// Cuándo se encoló.
  final DateTime creadoEn;

  /// Número de reintentos ya realizados.
  final int intentos;

  /// Mensaje del último error (diagnóstico).
  final String? ultimoError;

  /// Cuándo se intentó por última vez.
  final DateTime? ultimoIntento;

  /// Máximo de reintentos antes de marcarla como agotada (no se borra: queda
  /// para inspección manual, pero el reconciliador deja de tomarla).
  static const int maxIntentos = 5;

  /// `true` si aún se debe seguir reintentando.
  bool get puedeReintentar => intentos < maxIntentos;

  IntegracionPendiente copyWith({
    int? intentos,
    String? ultimoError,
    DateTime? ultimoIntento,
  }) {
    return IntegracionPendiente(
      id: id,
      granjaId: granjaId,
      tipo: tipo,
      parametros: parametros,
      creadoEn: creadoEn,
      intentos: intentos ?? this.intentos,
      ultimoError: ultimoError ?? this.ultimoError,
      ultimoIntento: ultimoIntento ?? this.ultimoIntento,
    );
  }

  @override
  List<Object?> get props => [
    id,
    granjaId,
    tipo,
    parametros,
    creadoEn,
    intentos,
    ultimoError,
    ultimoIntento,
  ];
}
