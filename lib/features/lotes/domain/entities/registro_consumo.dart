/// Entidad que representa un registro de consumo de alimento.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';

/// Registro de consumo de alimento de un lote.
class RegistroConsumo extends Equatable {
  const RegistroConsumo({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.galponId,
    required this.fecha,
    required this.cantidadKg,
    required this.tipoAlimento,
    required this.cantidadAvesActual,
    required this.edadDias,
    required this.usuarioRegistro,
    required this.nombreUsuario,
    required this.createdAt,
    this.consumoAcumuladoAnterior = 0,
    this.loteAlimento,
    this.proveedorId,
    this.costoPorKg,
    this.observaciones,
    this.updatedAt,
    this.itemInventarioId,
    this.nombreItemInventario,
  });

  /// ID único del registro.
  final String id;

  /// ID del lote al que pertenece.
  final String loteId;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón.
  final String galponId;

  /// Fecha del consumo.
  final DateTime fecha;

  /// Cantidad consumida en kg.
  final double cantidadKg;

  /// Tipo de alimento.
  final TipoAlimento tipoAlimento;

  /// Cantidad de aves al momento del registro.
  final int cantidadAvesActual;

  /// Consumo acumulado anterior en kg.
  final double consumoAcumuladoAnterior;

  /// Edad del lote en días.
  final int edadDias;

  /// Lote/batch del alimento (opcional).
  final String? loteAlimento;

  /// ID del proveedor (opcional).
  final String? proveedorId;

  /// Costo por kg (opcional).
  final double? costoPorKg;

  /// Observaciones (opcional).
  final String? observaciones;

  /// UID del usuario que registró.
  final String usuarioRegistro;

  /// Nombre del usuario.
  final String nombreUsuario;

  /// Fecha de creación.
  final DateTime createdAt;

  /// Fecha de actualización.
  final DateTime? updatedAt;

  /// ID del item de inventario vinculado (opcional).
  final String? itemInventarioId;

  /// Nombre del item de inventario (para referencia).
  final String? nombreItemInventario;

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    galponId,
    fecha,
    cantidadKg,
    tipoAlimento,
    cantidadAvesActual,
    consumoAcumuladoAnterior,
    edadDias,
    loteAlimento,
    proveedorId,
    costoPorKg,
    observaciones,
    usuarioRegistro,
    nombreUsuario,
    createdAt,
    updatedAt,
    itemInventarioId,
    nombreItemInventario,
  ];

  // ==================== PROPIEDADES CALCULADAS ====================

  /// Consumo acumulado total (anterior + actual).
  double get consumoAcumulado => consumoAcumuladoAnterior + cantidadKg;

  /// Consumo por ave en este registro (kg/ave).
  double get consumoPorAve {
    if (cantidadAvesActual <= 0) return 0;
    return cantidadKg / cantidadAvesActual;
  }

  /// Consumo promedio por ave por día (kg/ave/día).
  double get consumoPorAveDia {
    if (edadDias == 0 || cantidadAvesActual <= 0) return consumoPorAve;
    return consumoAcumulado / (cantidadAvesActual * edadDias);
  }

  /// Costo total de este registro.
  double? get costoTotal {
    if (costoPorKg == null) return null;
    return cantidadKg * costoPorKg!;
  }

  /// Verifica si el tipo de alimento es apropiado para la edad.
  bool get tieneAlimentoApropiado => tipoAlimento.esApropiado(edadDias);

  /// Verifica si es un registro reciente (últimas 48 horas).
  bool get esReciente {
    final diferencia = DateTime.now().difference(createdAt);
    return diferencia.inHours <= 48;
  }

  // ==================== MÉTODOS ====================

  /// Crea una copia con campos modificados.
  RegistroConsumo copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    String? galponId,
    DateTime? fecha,
    double? cantidadKg,
    TipoAlimento? tipoAlimento,
    int? cantidadAvesActual,
    double? consumoAcumuladoAnterior,
    int? edadDias,
    String? loteAlimento,
    String? proveedorId,
    double? costoPorKg,
    String? observaciones,
    String? usuarioRegistro,
    String? nombreUsuario,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? itemInventarioId,
    String? nombreItemInventario,
  }) {
    return RegistroConsumo(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      fecha: fecha ?? this.fecha,
      cantidadKg: cantidadKg ?? this.cantidadKg,
      tipoAlimento: tipoAlimento ?? this.tipoAlimento,
      cantidadAvesActual: cantidadAvesActual ?? this.cantidadAvesActual,
      consumoAcumuladoAnterior:
          consumoAcumuladoAnterior ?? this.consumoAcumuladoAnterior,
      edadDias: edadDias ?? this.edadDias,
      loteAlimento: loteAlimento ?? this.loteAlimento,
      proveedorId: proveedorId ?? this.proveedorId,
      costoPorKg: costoPorKg ?? this.costoPorKg,
      observaciones: observaciones ?? this.observaciones,
      usuarioRegistro: usuarioRegistro ?? this.usuarioRegistro,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      itemInventarioId: itemInventarioId ?? this.itemInventarioId,
      nombreItemInventario: nombreItemInventario ?? this.nombreItemInventario,
    );
  }

  /// Validación del registro.
  String? validar() {
    if (loteId.isEmpty) return ErrorMessages.get('VAL_LOTE_ID_REQUIRED');
    if (granjaId.isEmpty) return ErrorMessages.get('VAL_GRANJA_ID_REQUIRED');
    if (galponId.isEmpty) return ErrorMessages.get('VAL_GALPON_ID_REQUIRED');
    if (cantidadKg <= 0) {
      return ErrorMessages.get('REG_CONSUMO_CANTIDAD_MAYOR_CERO');
    }
    if (cantidadAvesActual <= 0) {
      return ErrorMessages.get('REG_CONSUMO_AVES_MINIMA');
    }
    if (edadDias < 0) return ErrorMessages.get('VAL_EDAD_NEGATIVA');
    if (costoPorKg != null && costoPorKg! < 0) {
      return ErrorMessages.get('REG_CONSUMO_COSTO_NO_NEGATIVO');
    }
    if (usuarioRegistro.isEmpty) {
      return ErrorMessages.get('REG_CONSUMO_USUARIO_REQUIRED');
    }
    if (nombreUsuario.isEmpty) {
      return ErrorMessages.get('REG_CONSUMO_NOMBRE_REQUIRED');
    }
    if (fecha.isAfter(DateTime.now())) {
      return ErrorMessages.get('REG_CONSUMO_FECHA_NO_FUTURA');
    }
    return null;
  }

  /// Si el registro es válido.
  bool get esValido => validar() == null;

  /// Factory para crear un nuevo registro de consumo.
  factory RegistroConsumo.nuevo({
    required String loteId,
    required String galponId,
    required TipoAlimento tipoAlimento,
    required double cantidadKg,
    required DateTime fecha,
    required int cantidadAves,
    required int edadDias,
    double? costoTotal,
    String? loteAlimento,
    String? observaciones,
    String granjaId = '',
    String usuarioRegistro = '',
    String nombreUsuario = '',
    String? itemInventarioId,
    String? nombreItemInventario,
  }) {
    return RegistroConsumo(
      id: '',
      loteId: loteId,
      granjaId: granjaId,
      galponId: galponId,
      fecha: fecha,
      cantidadKg: cantidadKg,
      tipoAlimento: tipoAlimento,
      cantidadAvesActual: cantidadAves,
      edadDias: edadDias,
      loteAlimento: loteAlimento,
      costoPorKg: costoTotal != null && cantidadKg > 0
          ? costoTotal / cantidadKg
          : null,
      observaciones: observaciones,
      usuarioRegistro: usuarioRegistro,
      nombreUsuario: nombreUsuario,
      createdAt: DateTime.now(),
      itemInventarioId: itemInventarioId,
      nombreItemInventario: nombreItemInventario,
    );
  }

  @override
  String toString() {
    return 'RegistroConsumo(id: $id, cantidad: ${cantidadKg}kg, '
        'tipo: ${tipoAlimento.displayName}, fecha: $fecha)';
  }
}
