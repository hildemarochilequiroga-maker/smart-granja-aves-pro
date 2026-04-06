library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/entities.dart';

/// Modelo de datos para el usuario
///
/// Extiende la entidad Usuario con métodos de serialización
/// para interactuar con fuentes de datos externas.
class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.email,
    super.nombre,
    super.apellido,
    super.telefono,
    super.fotoUrl,
    super.emailVerificado,
    super.activo,
    super.metodoAuth,
    super.fechaCreacion,
    super.ultimoAcceso,
    super.metadata,
    super.proveedoresVinculados = const [],
  });

  /// Crea un modelo desde un mapa JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      telefono: json['telefono'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      emailVerificado: json['emailVerificado'] as bool? ?? false,
      activo: json['activo'] as bool? ?? true,
      metodoAuth: AuthMethod.fromString(json['metodoAuth'] as String?),
      fechaCreacion: _parseDateTime(json['fechaCreacion']),
      ultimoAcceso: _parseDateTime(json['ultimoAcceso']),
      metadata: json['metadata'] as Map<String, dynamic>?,
      proveedoresVinculados: _parseProveedores(json['proveedoresVinculados']),
    );
  }

  /// Parsea la lista de proveedores vinculados
  static List<String> _parseProveedores(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  /// Crea un modelo desde un documento de Firestore
  factory UsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UsuarioModel.fromJson({'id': doc.id, ...data});
  }

  /// Crea un modelo desde una entidad de dominio
  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      email: usuario.email,
      nombre: usuario.nombre,
      apellido: usuario.apellido,
      telefono: usuario.telefono,
      fotoUrl: usuario.fotoUrl,
      emailVerificado: usuario.emailVerificado,
      activo: usuario.activo,
      metodoAuth: usuario.metodoAuth,
      fechaCreacion: usuario.fechaCreacion,
      ultimoAcceso: usuario.ultimoAcceso,
      metadata: usuario.metadata,
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'fotoUrl': fotoUrl,
      'emailVerificado': emailVerificado,
      'activo': activo,
      'metodoAuth': metodoAuth.name,
      'fechaCreacion': fechaCreacion?.toIso8601String(),
      'ultimoAcceso': ultimoAcceso?.toIso8601String(),
      'metadata': metadata,
      'proveedoresVinculados': proveedoresVinculados,
    };
  }

  /// Convierte el modelo a un mapa para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'fotoUrl': fotoUrl,
      'emailVerificado': emailVerificado,
      'activo': activo,
      'metodoAuth': metodoAuth.name,
      'fechaCreacion': fechaCreacion != null
          ? Timestamp.fromDate(fechaCreacion!)
          : FieldValue.serverTimestamp(),
      'ultimoAcceso': FieldValue.serverTimestamp(),
      'metadata': metadata,
      'proveedoresVinculados': proveedoresVinculados,
    };
  }

  /// Convierte el modelo a la entidad de dominio
  Usuario toEntity() {
    return Usuario(
      id: id,
      email: email,
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      fotoUrl: fotoUrl,
      emailVerificado: emailVerificado,
      activo: activo,
      metodoAuth: metodoAuth,
      fechaCreacion: fechaCreacion,
      ultimoAcceso: ultimoAcceso,
      metadata: metadata,
      proveedoresVinculados: proveedoresVinculados,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  @override
  UsuarioModel copyWith({
    String? id,
    String? email,
    String? nombre,
    String? apellido,
    String? telefono,
    String? fotoUrl,
    bool? emailVerificado,
    bool? activo,
    AuthMethod? metodoAuth,
    DateTime? fechaCreacion,
    DateTime? ultimoAcceso,
    Map<String, dynamic>? metadata,
    List<String>? proveedoresVinculados,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      emailVerificado: emailVerificado ?? this.emailVerificado,
      activo: activo ?? this.activo,
      metodoAuth: metodoAuth ?? this.metodoAuth,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      metadata: metadata ?? this.metadata,
      proveedoresVinculados:
          proveedoresVinculados ?? this.proveedoresVinculados,
    );
  }

  /// Modelo vacío
  static const empty = UsuarioModel(id: '', email: '');

  /// Parsea una fecha desde diferentes formatos
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
