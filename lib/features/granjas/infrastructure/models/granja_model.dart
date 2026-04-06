library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/entities.dart';
import '../../domain/enums/enums.dart';
import '../../domain/value_objects/value_objects.dart';

/// Modelo de infraestructura para la entidad Granja
///
/// Maneja la conversión entre Firestore y la entidad del dominio.
class GranjaModel {
  const GranjaModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.propietarioId,
    required this.propietarioNombre,
    required this.fechaCreacion,
    required this.estado,
    this.coordenadas,
    this.umbralesAmbientales,
    this.telefono,
    this.correo,
    this.ruc,
    this.capacidadTotalAves,
    this.areaTotalM2,
    this.numeroTotalGalpones,
    this.notas,
    this.ultimaActualizacion,
    this.imagenUrl,
  });

  final String id;
  final String nombre;
  final Direccion direccion;
  final String propietarioId;
  final String propietarioNombre;
  final DateTime fechaCreacion;
  final EstadoGranja estado;
  final Coordenadas? coordenadas;
  final UmbralesAmbientales? umbralesAmbientales;
  final String? telefono;
  final String? correo;
  final String? ruc;
  final int? capacidadTotalAves;
  final double? areaTotalM2;
  final int? numeroTotalGalpones;
  final String? notas;
  final DateTime? ultimaActualizacion;
  final String? imagenUrl;

  /// Convierte desde Firestore DocumentSnapshot
  factory GranjaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GranjaModel.fromMap(data, doc.id);
  }

  /// Convierte desde Map (con ID opcional)
  factory GranjaModel.fromMap(Map<String, dynamic> data, [String? documentId]) {
    return GranjaModel(
      id: documentId ?? data['id'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      direccion: data['direccion'] != null
          ? Direccion.fromJson(data['direccion'] as Map<String, dynamic>)
          : const Direccion(calle: ''),
      propietarioId: data['propietarioId'] as String? ?? '',
      propietarioNombre: data['propietarioNombre'] as String? ?? '',
      fechaCreacion: _parseDateTime(data['fechaCreacion']) ?? DateTime.now(),
      estado:
          EstadoGranja.tryFromJson(data['estado'] as String?) ??
          EstadoGranja.activo,
      coordenadas: data['coordenadas'] != null
          ? Coordenadas.fromJson(data['coordenadas'] as Map<String, dynamic>)
          : null,
      umbralesAmbientales: data['umbralesAmbientales'] != null
          ? UmbralesAmbientales.fromJson(
              data['umbralesAmbientales'] as Map<String, dynamic>,
            )
          : null,
      telefono: data['telefono'] as String?,
      correo: data['correo'] as String?,
      ruc: data['ruc'] as String?,
      capacidadTotalAves: data['capacidadTotalAves'] as int?,
      areaTotalM2: data['areaTotalM2'] != null
          ? (data['areaTotalM2'] as num).toDouble()
          : null,
      numeroTotalGalpones: data['numeroTotalGalpones'] as int?,
      notas: data['notas'] as String?,
      ultimaActualizacion: _parseDateTime(data['ultimaActualizacion']),
      imagenUrl: data['imagenUrl'] as String?,
    );
  }

  /// Convierte desde la entidad de dominio
  factory GranjaModel.fromEntity(Granja granja) {
    return GranjaModel(
      id: granja.id,
      nombre: granja.nombre,
      direccion: granja.direccion,
      propietarioId: granja.propietarioId,
      propietarioNombre: granja.propietarioNombre,
      fechaCreacion: granja.fechaCreacion,
      estado: granja.estado,
      coordenadas: granja.coordenadas,
      umbralesAmbientales: granja.umbralesAmbientales,
      telefono: granja.telefono,
      correo: granja.correo,
      ruc: granja.ruc,
      capacidadTotalAves: granja.capacidadTotalAves,
      areaTotalM2: granja.areaTotalM2,
      numeroTotalGalpones: granja.numeroTotalGalpones,
      notas: granja.notas,
      ultimaActualizacion: granja.ultimaActualizacion,
      imagenUrl: granja.imagenUrl,
    );
  }

  /// Convierte a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'direccion': direccion.toJson(),
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'estado': estado.toJson(),
      if (coordenadas != null) 'coordenadas': coordenadas!.toJson(),
      if (umbralesAmbientales != null)
        'umbralesAmbientales': umbralesAmbientales!.toJson(),
      if (telefono != null) 'telefono': telefono,
      if (correo != null) 'correo': correo,
      if (ruc != null) 'ruc': ruc,
      if (capacidadTotalAves != null) 'capacidadTotalAves': capacidadTotalAves,
      if (areaTotalM2 != null) 'areaTotalM2': areaTotalM2,
      if (numeroTotalGalpones != null)
        'numeroTotalGalpones': numeroTotalGalpones,
      if (notas != null) 'notas': notas,
      'ultimaActualizacion': ultimaActualizacion != null
          ? Timestamp.fromDate(ultimaActualizacion!)
          : FieldValue.serverTimestamp(),
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
    };
  }

  /// Convierte a Map para almacenamiento local (JSON serializable)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion.toJson(),
      'propietarioId': propietarioId,
      'propietarioNombre': propietarioNombre,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'estado': estado.toJson(),
      if (coordenadas != null) 'coordenadas': coordenadas!.toJson(),
      if (umbralesAmbientales != null)
        'umbralesAmbientales': umbralesAmbientales!.toJson(),
      if (telefono != null) 'telefono': telefono,
      if (correo != null) 'correo': correo,
      if (ruc != null) 'ruc': ruc,
      if (capacidadTotalAves != null) 'capacidadTotalAves': capacidadTotalAves,
      if (areaTotalM2 != null) 'areaTotalM2': areaTotalM2,
      if (numeroTotalGalpones != null)
        'numeroTotalGalpones': numeroTotalGalpones,
      if (notas != null) 'notas': notas,
      if (ultimaActualizacion != null)
        'ultimaActualizacion': ultimaActualizacion!.toIso8601String(),
      if (imagenUrl != null) 'imagenUrl': imagenUrl,
    };
  }

  /// Convierte a entidad del dominio
  Granja toEntity() {
    return Granja(
      id: id,
      nombre: nombre,
      direccion: direccion,
      propietarioId: propietarioId,
      propietarioNombre: propietarioNombre,
      fechaCreacion: fechaCreacion,
      estado: estado,
      coordenadas: coordenadas,
      umbralesAmbientales: umbralesAmbientales,
      telefono: telefono,
      correo: correo,
      ruc: ruc,
      capacidadTotalAves: capacidadTotalAves,
      areaTotalM2: areaTotalM2,
      numeroTotalGalpones: numeroTotalGalpones,
      notas: notas,
      ultimaActualizacion: ultimaActualizacion,
      imagenUrl: imagenUrl,
    );
  }

  /// Copia con modificaciones
  GranjaModel copyWith({
    String? id,
    String? nombre,
    Direccion? direccion,
    String? propietarioId,
    String? propietarioNombre,
    DateTime? fechaCreacion,
    EstadoGranja? estado,
    Coordenadas? coordenadas,
    UmbralesAmbientales? umbralesAmbientales,
    String? telefono,
    String? correo,
    String? ruc,
    int? capacidadTotalAves,
    double? areaTotalM2,
    int? numeroTotalGalpones,
    String? notas,
    DateTime? ultimaActualizacion,
    String? imagenUrl,
  }) {
    return GranjaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
      coordenadas: coordenadas ?? this.coordenadas,
      umbralesAmbientales: umbralesAmbientales ?? this.umbralesAmbientales,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      ruc: ruc ?? this.ruc,
      capacidadTotalAves: capacidadTotalAves ?? this.capacidadTotalAves,
      areaTotalM2: areaTotalM2 ?? this.areaTotalM2,
      numeroTotalGalpones: numeroTotalGalpones ?? this.numeroTotalGalpones,
      notas: notas ?? this.notas,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  /// Parsea DateTime desde varios formatos
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
