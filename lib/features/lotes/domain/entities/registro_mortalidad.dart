/// Entidad que representa un registro de mortalidad.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../salud/domain/enums/causa_mortalidad.dart';

/// Registro de mortalidad de un lote.
class RegistroMortalidad extends Equatable {
  const RegistroMortalidad({
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

  /// ID único del registro.
  final String id;

  /// ID del lote al que pertenece.
  final String loteId;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón.
  final String galponId;

  /// Fecha del evento.
  final DateTime fecha;

  /// Cantidad de aves muertas.
  final int cantidad;

  /// Causa de la mortalidad.
  final CausaMortalidad causa;

  /// Descripción detallada.
  final String descripcion;

  /// URLs de fotos de evidencia (máximo 5).
  final List<String> fotosUrls;

  /// Edad de las aves en días.
  final int edadAvesDias;

  /// Cantidad de aves antes del evento.
  final int cantidadAntesEvento;

  /// UID del usuario que registró.
  final String usuarioRegistro;

  /// Nombre del usuario.
  final String nombreUsuario;

  /// Fecha de creación.
  final DateTime createdAt;

  /// Fecha de actualización.
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    galponId,
    fecha,
    cantidad,
    causa,
    descripcion,
    fotosUrls,
    edadAvesDias,
    cantidadAntesEvento,
    usuarioRegistro,
    nombreUsuario,
    createdAt,
    updatedAt,
  ];

  // ==================== PROPIEDADES CALCULADAS ====================

  /// Impacto porcentual de este evento.
  double get impactoPorcentual {
    if (cantidadAntesEvento == 0) return 0.0;
    return (cantidad / cantidadAntesEvento) * 100;
  }

  /// Si requiere atención inmediata.
  bool get requiereAtencionInmediata {
    return impactoPorcentual > 2.0 || causa.nivelGravedad >= 7;
  }

  /// Si tiene evidencia fotográfica.
  bool get tieneEvidencia => fotosUrls.isNotEmpty;

  /// Semanas de vida del lote.
  int get semanasVida => edadAvesDias ~/ 7;

  /// Si es reciente (menos de 24 horas).
  bool get esReciente {
    final diferencia = DateTime.now().difference(createdAt);
    return diferencia.inHours < 24;
  }

  /// Si la causa es contagiosa.
  bool get esCausaContagiosa => causa.esContagiosa;

  // ==================== MÉTODOS ====================

  /// Crea una copia con campos modificados.
  RegistroMortalidad copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    String? galponId,
    DateTime? fecha,
    int? cantidad,
    CausaMortalidad? causa,
    String? descripcion,
    List<String>? fotosUrls,
    int? edadAvesDias,
    int? cantidadAntesEvento,
    String? usuarioRegistro,
    String? nombreUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegistroMortalidad(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      fecha: fecha ?? this.fecha,
      cantidad: cantidad ?? this.cantidad,
      causa: causa ?? this.causa,
      descripcion: descripcion ?? this.descripcion,
      fotosUrls: fotosUrls ?? this.fotosUrls,
      edadAvesDias: edadAvesDias ?? this.edadAvesDias,
      cantidadAntesEvento: cantidadAntesEvento ?? this.cantidadAntesEvento,
      usuarioRegistro: usuarioRegistro ?? this.usuarioRegistro,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Validación del registro.
  String? validar() {
    if (loteId.isEmpty) return ErrorMessages.get('VAL_LOTE_ID_REQUIRED');
    if (granjaId.isEmpty) return ErrorMessages.get('VAL_GRANJA_ID_REQUIRED');
    if (galponId.isEmpty) return ErrorMessages.get('VAL_GALPON_ID_REQUIRED');
    if (cantidad <= 0) {
      return ErrorMessages.get('REG_MORT_CANTIDAD_MAYOR_CERO');
    }
    if (descripcion.length < 10) {
      return ErrorMessages.get('REG_MORT_DESCRIPCION_MIN');
    }
    if (fotosUrls.length > 5) return ErrorMessages.get('REG_MORT_MAX_FOTOS');
    if (edadAvesDias < 0) return ErrorMessages.get('VAL_EDAD_NEGATIVA');
    if (cantidadAntesEvento <= 0) {
      return ErrorMessages.get('REG_MORT_CANTIDAD_EVENTO_INVALIDA');
    }
    if (cantidad > cantidadAntesEvento) {
      return ErrorMessages.get('REG_MORT_EXCEDE_DISPONIBLES');
    }
    return null;
  }

  /// Si el registro es válido.
  bool get esValido => validar() == null;

  /// Factory para crear registro vacío.
  factory RegistroMortalidad.empty() {
    return RegistroMortalidad(
      id: '',
      loteId: '',
      granjaId: '',
      galponId: '',
      fecha: DateTime.now(),
      cantidad: 1,
      causa: CausaMortalidad.desconocida,
      descripcion: ErrorMessages.get('DEFAULT_NO_DESCRIPTION'),
      fotosUrls: const [],
      edadAvesDias: 0,
      cantidadAntesEvento: 0,
      usuarioRegistro: '',
      nombreUsuario: '',
      createdAt: DateTime.now(),
    );
  }

  /// Factory para crear un nuevo registro de mortalidad.
  factory RegistroMortalidad.nuevo({
    required String loteId,
    required String galponId,
    required int cantidad,
    required CausaMortalidad causa,
    required DateTime fecha,
    required int edadDias,
    String? descripcion,
    String granjaId = '',
    int cantidadAntesEvento = 0,
    String usuarioRegistro = '',
    String nombreUsuario = '',
    List<String> fotosUrls = const [],
  }) {
    return RegistroMortalidad(
      id: '',
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      cantidad: cantidad,
      causa: causa,
      descripcion: descripcion ?? ErrorMessages.get('DEFAULT_MORTALITY_RECORD'),
      fotosUrls: fotosUrls,
      edadAvesDias: edadDias,
      cantidadAntesEvento: cantidadAntesEvento,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'RegistroMortalidad(id: $id, cantidad: $cantidad, '
        'causa: ${causa.displayName}, fecha: $fecha)';
  }
}
