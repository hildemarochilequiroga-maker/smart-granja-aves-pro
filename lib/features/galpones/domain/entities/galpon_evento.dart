/// Entidad que representa un evento histórico de un galpón avícola.
library;

import 'package:equatable/equatable.dart';

import '../enums/tipo_evento_galpon.dart';

/// Entidad que representa un evento histórico de un galpón.
class GalponEvento extends Equatable {
  const GalponEvento({
    required this.id,
    required this.galponId,
    required this.granjaId,
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    this.usuarioId,
    this.usuarioNombre,
    this.datosAdicionales = const {},
    this.loteId,
  });

  /// ID único del evento.
  final String id;

  /// ID del galpón asociado.
  final String galponId;

  /// ID de la granja asociada.
  final String granjaId;

  /// Tipo de evento.
  final TipoEventoGalpon tipo;

  /// Fecha y hora del evento.
  final DateTime fecha;

  /// Descripción legible del evento.
  final String descripcion;

  /// ID del usuario que realizó la acción (opcional).
  final String? usuarioId;

  /// Nombre del usuario que realizó la acción (opcional).
  final String? usuarioNombre;

  /// Datos adicionales del evento.
  final Map<String, dynamic> datosAdicionales;

  /// ID del lote relacionado (opcional).
  final String? loteId;

  @override
  List<Object?> get props => [
    id,
    galponId,
    granjaId,
    tipo,
    fecha,
    descripcion,
    usuarioId,
    usuarioNombre,
    datosAdicionales,
    loteId,
  ];

  /// Crea una copia con campos modificados.
  GalponEvento copyWith({
    String? id,
    String? galponId,
    String? granjaId,
    TipoEventoGalpon? tipo,
    DateTime? fecha,
    String? descripcion,
    String? usuarioId,
    String? usuarioNombre,
    Map<String, dynamic>? datosAdicionales,
    String? loteId,
  }) {
    return GalponEvento(
      id: id ?? this.id,
      galponId: galponId ?? this.galponId,
      granjaId: granjaId ?? this.granjaId,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      usuarioId: usuarioId ?? this.usuarioId,
      usuarioNombre: usuarioNombre ?? this.usuarioNombre,
      datosAdicionales: datosAdicionales ?? this.datosAdicionales,
      loteId: loteId ?? this.loteId,
    );
  }
}
