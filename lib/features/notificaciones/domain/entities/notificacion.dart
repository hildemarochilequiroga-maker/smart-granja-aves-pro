/// Entidad de notificación.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../enums/tipo_notificacion.dart';
import '../enums/prioridad_notificacion.dart';

/// Representa una notificación en el sistema.
class Notificacion extends Equatable {
  const Notificacion({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.titulo,
    required this.mensaje,
    required this.fechaCreacion,
    this.granjaId,
    this.granjaName,
    this.data,
    this.leida = false,
    this.fechaLeida,
    this.prioridad = PrioridadNotificacion.normal,
    this.accionUrl,
  });

  /// ID único de la notificación.
  final String id;

  /// ID del usuario destinatario.
  final String usuarioId;

  /// Tipo de notificación.
  final TipoNotificacion tipo;

  /// Título de la notificación.
  final String titulo;

  /// Mensaje de la notificación.
  final String mensaje;

  /// Fecha de creación.
  final DateTime fechaCreacion;

  /// ID de la granja relacionada (opcional).
  final String? granjaId;

  /// Nombre de la granja relacionada (opcional).
  final String? granjaName;

  /// Datos adicionales de la notificación.
  final Map<String, dynamic>? data;

  /// Si la notificación ha sido leída.
  final bool leida;

  /// Fecha en que fue leída.
  final DateTime? fechaLeida;

  /// Prioridad de la notificación.
  final PrioridadNotificacion prioridad;

  /// URL de acción al tocar la notificación.
  final String? accionUrl;

  @override
  List<Object?> get props => [
    id,
    usuarioId,
    tipo,
    titulo,
    mensaje,
    fechaCreacion,
    granjaId,
    granjaName,
    data,
    leida,
    fechaLeida,
    prioridad,
    accionUrl,
  ];

  /// Crea una copia con los campos modificados.
  Notificacion copyWith({
    String? id,
    String? usuarioId,
    TipoNotificacion? tipo,
    String? titulo,
    String? mensaje,
    DateTime? fechaCreacion,
    String? granjaId,
    String? granjaName,
    Map<String, dynamic>? data,
    bool? leida,
    DateTime? fechaLeida,
    PrioridadNotificacion? prioridad,
    String? accionUrl,
  }) {
    return Notificacion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      tipo: tipo ?? this.tipo,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      granjaId: granjaId ?? this.granjaId,
      granjaName: granjaName ?? this.granjaName,
      data: data ?? this.data,
      leida: leida ?? this.leida,
      fechaLeida: fechaLeida ?? this.fechaLeida,
      prioridad: prioridad ?? this.prioridad,
      accionUrl: accionUrl ?? this.accionUrl,
    );
  }

  /// Crea desde un documento de Firestore.
  factory Notificacion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Notificacion(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? '',
      tipo: TipoNotificacion.fromString(data['tipo'] ?? 'general'),
      titulo: data['titulo'] ?? '',
      mensaje: data['mensaje'] ?? '',
      fechaCreacion:
          (data['fechaCreacion'] as Timestamp?)?.toDate() ?? DateTime.now(),
      granjaId: data['granjaId'],
      granjaName: data['granjaName'],
      data: data['data'] as Map<String, dynamic>?,
      leida: data['leida'] ?? false,
      fechaLeida: (data['fechaLeida'] as Timestamp?)?.toDate(),
      prioridad: PrioridadNotificacion.fromString(
        data['prioridad'] ?? 'normal',
      ),
      accionUrl: data['accionUrl'],
    );
  }

  /// Convierte a Map para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'usuarioId': usuarioId,
      'tipo': tipo.value,
      'titulo': titulo,
      'mensaje': mensaje,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      if (granjaId != null) 'granjaId': granjaId,
      if (granjaName != null) 'granjaName': granjaName,
      if (data != null) 'data': data,
      'leida': leida,
      if (fechaLeida != null) 'fechaLeida': Timestamp.fromDate(fechaLeida!),
      'prioridad': prioridad.value,
      if (accionUrl != null) 'accionUrl': accionUrl,
    };
  }

  /// Tiempo transcurrido desde la creación.
  String get tiempoTranscurrido {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fechaCreacion);

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} h';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return '${fechaCreacion.day}/${fechaCreacion.month}/${fechaCreacion.year}';
    }
  }
}
