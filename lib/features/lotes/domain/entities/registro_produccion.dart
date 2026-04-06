/// Entidad que representa un registro de producción de huevos.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';

/// Registro de producción de huevos de un lote.
class RegistroProduccion extends Equatable {
  const RegistroProduccion({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.huevosRecolectados,
    required this.huevosBuenos,
    required this.cantidadAvesActual,
    required this.edadDias,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.huevosRotos,
    this.huevosSucios,
    this.huevosDobleYema,
    this.huevosPequenos,
    this.huevosMedianos,
    this.huevosGrandes,
    this.huevosExtraGrandes,
    this.pesoPromedioHuevoGramos,
    this.observaciones,
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

  /// Fecha del registro.
  final DateTime fecha;

  /// Total de huevos recolectados.
  final int huevosRecolectados;

  /// Cantidad de huevos buenos (aptos para venta).
  final int huevosBuenos;

  /// Cantidad de huevos rotos.
  final int? huevosRotos;

  /// Cantidad de huevos sucios.
  final int? huevosSucios;

  /// Cantidad de huevos de doble yema.
  final int? huevosDobleYema;

  /// Clasificación: pequeños (< 53g).
  final int? huevosPequenos;

  /// Clasificación: medianos (53-63g).
  final int? huevosMedianos;

  /// Clasificación: grandes (63-73g).
  final int? huevosGrandes;

  /// Clasificación: extra grandes (> 73g).
  final int? huevosExtraGrandes;

  /// Peso promedio de huevos en gramos.
  final double? pesoPromedioHuevoGramos;

  /// Cantidad de aves al momento del registro.
  final int cantidadAvesActual;

  /// Edad del lote en días.
  final int edadDias;

  /// Observaciones.
  final String? observaciones;

  /// URLs de fotos (máximo 3).
  final List<String> fotosUrls;

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
    huevosRecolectados,
    huevosBuenos,
    huevosRotos,
    huevosSucios,
    huevosDobleYema,
    huevosPequenos,
    huevosMedianos,
    huevosGrandes,
    huevosExtraGrandes,
    pesoPromedioHuevoGramos,
    cantidadAvesActual,
    edadDias,
    observaciones,
    fotosUrls,
    usuarioRegistro,
    nombreUsuario,
    createdAt,
    updatedAt,
  ];

  // ==================== PROPIEDADES CALCULADAS ====================

  /// Porcentaje de postura (huevos / aves * 100).
  double get porcentajePostura {
    if (cantidadAvesActual <= 0) return 0;
    final result = (huevosRecolectados / cantidadAvesActual) * 100;
    return result.isFinite ? result : 0;
  }

  /// Porcentaje de huevos buenos.
  double get porcentajeBuenos {
    if (huevosRecolectados <= 0) return 0;
    final result = (huevosBuenos / huevosRecolectados) * 100;
    return result.isFinite ? result : 0;
  }

  /// Porcentaje de huevos rotos.
  double get porcentajeRotos {
    if (huevosRecolectados <= 0 || huevosRotos == null) return 0;
    final result = (huevosRotos! / huevosRecolectados) * 100;
    return result.isFinite ? result : 0;
  }

  /// Porcentaje de huevos sucios.
  double get porcentajeSucios {
    if (huevosRecolectados <= 0 || huevosSucios == null) return 0;
    final result = (huevosSucios! / huevosRecolectados) * 100;
    return result.isFinite ? result : 0;
  }

  /// Total de huevos clasificados por tamaño.
  int get totalClasificados {
    return (huevosPequenos ?? 0) +
        (huevosMedianos ?? 0) +
        (huevosGrandes ?? 0) +
        (huevosExtraGrandes ?? 0);
  }

  /// Si tiene clasificación completa por tamaño.
  bool get tieneClasificacionCompleta => totalClasificados == huevosBuenos;

  /// Si es un registro reciente (últimas 48 horas).
  bool get esReciente {
    final diferencia = DateTime.now().difference(createdAt);
    return diferencia.inHours <= 48;
  }

  /// Si el porcentaje de postura es bueno (> 70%).
  bool get tieneBuenaPostura => porcentajePostura >= 70;

  /// Si la calidad es aceptable (> 90% buenos).
  bool get tieneCalidadAceptable => porcentajeBuenos >= 90;

  // ==================== MÉTODOS ====================

  /// Crea una copia con campos modificados.
  RegistroProduccion copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    String? galponId,
    DateTime? fecha,
    int? huevosRecolectados,
    int? huevosBuenos,
    int? huevosRotos,
    int? huevosSucios,
    int? huevosDobleYema,
    int? huevosPequenos,
    int? huevosMedianos,
    int? huevosGrandes,
    int? huevosExtraGrandes,
    double? pesoPromedioHuevoGramos,
    int? cantidadAvesActual,
    int? edadDias,
    String? observaciones,
    List<String>? fotosUrls,
    String? usuarioRegistro,
    String? nombreUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RegistroProduccion(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      fecha: fecha ?? this.fecha,
      huevosRecolectados: huevosRecolectados ?? this.huevosRecolectados,
      huevosBuenos: huevosBuenos ?? this.huevosBuenos,
      huevosRotos: huevosRotos ?? this.huevosRotos,
      huevosSucios: huevosSucios ?? this.huevosSucios,
      huevosDobleYema: huevosDobleYema ?? this.huevosDobleYema,
      huevosPequenos: huevosPequenos ?? this.huevosPequenos,
      huevosMedianos: huevosMedianos ?? this.huevosMedianos,
      huevosGrandes: huevosGrandes ?? this.huevosGrandes,
      huevosExtraGrandes: huevosExtraGrandes ?? this.huevosExtraGrandes,
      pesoPromedioHuevoGramos:
          pesoPromedioHuevoGramos ?? this.pesoPromedioHuevoGramos,
      cantidadAvesActual: cantidadAvesActual ?? this.cantidadAvesActual,
      edadDias: edadDias ?? this.edadDias,
      observaciones: observaciones ?? this.observaciones,
      fotosUrls: fotosUrls ?? this.fotosUrls,
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
    if (huevosRecolectados < 0) {
      return ErrorMessages.get('REG_PROD_HUEVOS_NO_NEGATIVO');
    }
    if (huevosBuenos < 0) {
      return ErrorMessages.get('REG_PROD_BUENOS_NO_NEGATIVO');
    }
    if (huevosBuenos > huevosRecolectados) {
      return ErrorMessages.get('REG_PROD_BUENOS_NO_SUPERAR');
    }
    if (cantidadAvesActual <= 0) {
      return ErrorMessages.get('REG_PROD_AVES_MAYOR_CERO');
    }
    if (edadDias < 0) return ErrorMessages.get('VAL_EDAD_NEGATIVA');
    if (fotosUrls.length > 3) return ErrorMessages.get('REG_PROD_MAX_FOTOS');
    if (pesoPromedioHuevoGramos != null && pesoPromedioHuevoGramos! <= 0) {
      return ErrorMessages.get('REG_PROD_PESO_POSITIVO');
    }
    return null;
  }

  /// Si el registro es válido.
  bool get esValido => validar() == null;

  /// Factory para crear un nuevo registro de producción.
  factory RegistroProduccion.nuevo({
    required String loteId,
    required String galponId,
    required int huevosRecolectados,
    required DateTime fecha,
    required int cantidadAves,
    required int edadDias,
    int? huevosRotos,
    int? huevosSucios,
    double? pesoPromedioHuevo,
    Map<ClasificacionHuevo, int>? clasificacion,
    String? observaciones,
    String granjaId = '',
    String usuarioRegistro = '',
    String nombreUsuario = '',
  }) {
    final rotos = huevosRotos ?? 0;
    final sucios = huevosSucios ?? 0;
    final buenos = huevosRecolectados - rotos;

    return RegistroProduccion(
      id: '',
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      huevosRecolectados: huevosRecolectados,
      huevosBuenos: buenos > 0 ? buenos : 0,
      huevosRotos: rotos > 0 ? rotos : null,
      huevosSucios: sucios > 0 ? sucios : null,
      huevosPequenos: clasificacion?[ClasificacionHuevo.pequeno],
      huevosMedianos: clasificacion?[ClasificacionHuevo.mediano],
      huevosGrandes: clasificacion?[ClasificacionHuevo.grande],
      huevosExtraGrandes: clasificacion?[ClasificacionHuevo.extraGrande],
      pesoPromedioHuevoGramos: pesoPromedioHuevo,
      cantidadAvesActual: cantidadAves,
      edadDias: edadDias,
      observaciones: observaciones,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'RegistroProduccion(id: $id, huevos: $huevosRecolectados, '
        'buenos: $huevosBuenos, postura: ${porcentajePostura.toStringAsFixed(1)}%)';
  }
}
