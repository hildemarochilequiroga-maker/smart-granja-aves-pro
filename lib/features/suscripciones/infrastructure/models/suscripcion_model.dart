library;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/suscripcion.dart';
import '../../domain/enums/estado_suscripcion.dart';
import '../../domain/enums/origen_suscripcion.dart';
import '../../domain/enums/plan_suscripcion.dart';

/// Modelo de datos para la suscripción (serialización Firestore).
///
/// El parseo es DEFENSIVO: cualquier campo ausente o corrupto degrada a
/// valores seguros (gratis / expirada), nunca otorga capacidades de más.
class SuscripcionModel extends Suscripcion {
  const SuscripcionModel({
    required super.usuarioId,
    required super.plan,
    required super.estado,
    required super.origen,
    super.vigenteHasta,
    super.playProductId,
    super.playPurchaseToken,
    super.actualizadoEn,
  });

  /// Crea el modelo desde un mapa (con el `usuarioId` ya resuelto como id).
  factory SuscripcionModel.fromJson(Map<String, dynamic> json) {
    return SuscripcionModel(
      usuarioId: json['usuarioId'] as String? ?? json['id'] as String? ?? '',
      plan: PlanSuscripcion.fromJson(json['plan'] as String?),
      estado: EstadoSuscripcion.fromJson(json['estado'] as String?),
      origen: OrigenSuscripcion.fromJson(json['origen'] as String?),
      vigenteHasta: _parseDate(json['vigenteHasta']),
      playProductId: json['playProductId'] as String?,
      playPurchaseToken: json['playPurchaseToken'] as String?,
      actualizadoEn: _parseDate(json['actualizadoEn']),
    );
  }

  /// Crea el modelo desde un documento de Firestore. Si el documento no
  /// existe o no tiene datos, devuelve la suscripción gratis por defecto.
  factory SuscripcionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return SuscripcionModel.gratis(doc.id);
    }
    return SuscripcionModel.fromJson({'id': doc.id, ...data});
  }

  /// Suscripción gratis por defecto.
  factory SuscripcionModel.gratis(String usuarioId) => SuscripcionModel(
    usuarioId: usuarioId,
    plan: PlanSuscripcion.gratis,
    estado: EstadoSuscripcion.activa,
    origen: OrigenSuscripcion.gratis,
  );

  /// Convierte a la entidad de dominio.
  Suscripcion toEntity() => Suscripcion(
    usuarioId: usuarioId,
    plan: plan,
    estado: estado,
    origen: origen,
    vigenteHasta: vigenteHasta,
    playProductId: playProductId,
    playPurchaseToken: playPurchaseToken,
    actualizadoEn: actualizadoEn,
  );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
