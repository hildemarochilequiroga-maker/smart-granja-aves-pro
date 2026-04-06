/// Modelo Firestore para RegistroMortalidad.
library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/registro_mortalidad.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';

/// Modelo de datos para registros de mortalidad en Firestore.
class RegistroMortalidadModel {
  const RegistroMortalidadModel({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.cantidad,
    required this.causa,
    required this.descripcion,
    required this.edadAvesDias,
    required this.cantidadAntesEvento,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.fotosUrls = const [],
    this.updatedAt,
  });

  final String id;
  final String loteId;
  final String granjaId;
  final String galponId;
  final DateTime fecha;
  final int cantidad;
  final CausaMortalidad causa;
  final String descripcion;
  final List<String> fotosUrls;
  final int edadAvesDias;
  final int cantidadAntesEvento;
  final String usuarioRegistro;
  final String nombreUsuario;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Convierte a mapa para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'loteId': loteId,
      'granjaId': granjaId,
      'galponId': galponId,
      'fecha': Timestamp.fromDate(fecha),
      'cantidad': cantidad,
      'causa': causa.toJson(),
      'descripcion': descripcion,
      'fotosUrls': fotosUrls,
      'edadAvesDias': edadAvesDias,
      'cantidadAntesEvento': cantidadAntesEvento,
      'usuarioRegistro': usuarioRegistro,
      'nombreUsuario': nombreUsuario,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
    };
  }

  /// Crea desde snapshot de Firestore.
  factory RegistroMortalidadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RegistroMortalidadModel(
      id: doc.id,
      loteId: data['loteId'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cantidad: data['cantidad'] as int? ?? 0,
      causa: CausaMortalidad.fromJson(
        data['causa'] as String? ?? 'desconocida',
      ),
      descripcion: data['descripcion'] as String? ?? '',
      fotosUrls: List<String>.from(data['fotosUrls'] as List? ?? []),
      edadAvesDias: data['edadAvesDias'] as int? ?? 0,
      cantidadAntesEvento: data['cantidadAntesEvento'] as int? ?? 0,
      usuarioRegistro: data['usuarioRegistro'] as String? ?? '',
      nombreUsuario: data['nombreUsuario'] as String? ?? 'Desconocido',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Crea desde entidad.
  factory RegistroMortalidadModel.fromEntity(RegistroMortalidad entity) {
    return RegistroMortalidadModel(
      id: entity.id,
      loteId: entity.loteId,
      granjaId: entity.granjaId,
      galponId: entity.galponId,
      fecha: entity.fecha,
      cantidad: entity.cantidad,
      causa: entity.causa,
      descripcion: entity.descripcion,
      fotosUrls: entity.fotosUrls,
      edadAvesDias: entity.edadAvesDias,
      cantidadAntesEvento: entity.cantidadAntesEvento,
      usuarioRegistro: entity.usuarioRegistro,
      nombreUsuario: entity.nombreUsuario,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convierte a entidad de dominio.
  RegistroMortalidad toEntity() {
    return RegistroMortalidad(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      cantidad: cantidad,
      causa: causa,
      descripcion: descripcion,
      fotosUrls: fotosUrls,
      edadAvesDias: edadAvesDias,
      cantidadAntesEvento: cantidadAntesEvento,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
