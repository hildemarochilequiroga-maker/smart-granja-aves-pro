import 'package:equatable/equatable.dart';
import '../enums/estado_pedido.dart';
import '../value_objects/cliente.dart';

/// Entidad principal para pedidos de venta de aves.
///
/// AGGREGATE ROOT para ventas comerciales.
/// Gestiona el ciclo completo: creación → aprobación → entrega → facturación.
class VentaPedido extends Equatable {
  final String id;
  final String loteId;
  final Cliente cliente;
  final DateTime fechaPedido;
  final DateTime? fechaEntregaProgramada;
  final DateTime? fechaEntregaReal;
  final EstadoPedido estado;

  final int cantidadAves;
  final double pesoPromedioKg;
  final double precioUnitario;
  final bool preciosPorKg;

  final double descuentoPorcentaje;
  final double? impuestoIVA;
  final String? numeroGuiaSanitaria;
  final String? numeroFactura;

  final String? direccionEntrega;
  final String? transportista;
  final String? observaciones;
  final String? registroEntregaId;

  final String creadoPor;
  final String? aprobadoPor;
  final DateTime? fechaAprobacion;

  const VentaPedido({
    required this.id,
    required this.loteId,
    required this.cliente,
    required this.fechaPedido,
    this.fechaEntregaProgramada,
    this.fechaEntregaReal,
    required this.estado,
    required this.cantidadAves,
    required this.pesoPromedioKg,
    required this.precioUnitario,
    this.preciosPorKg = true,
    this.descuentoPorcentaje = 0.0,
    this.impuestoIVA,
    this.numeroGuiaSanitaria,
    this.numeroFactura,
    this.direccionEntrega,
    this.transportista,
    this.observaciones,
    this.registroEntregaId,
    required this.creadoPor,
    this.aprobadoPor,
    this.fechaAprobacion,
  });

  // Calculated properties
  double get pesoTotalKg => cantidadAves * pesoPromedioKg;

  double get subtotal {
    if (preciosPorKg) {
      return pesoTotalKg * precioUnitario;
    } else {
      return cantidadAves * precioUnitario;
    }
  }

  double get montoDescuento => subtotal * (descuentoPorcentaje / 100);
  double get subtotalConDescuento => subtotal - montoDescuento;

  double get montoIVA {
    if (impuestoIVA == null) return 0.0;
    return subtotalConDescuento * (impuestoIVA! / 100);
  }

  double get totalFinal => subtotalConDescuento + montoIVA;

  bool get esModificable {
    return estado == EstadoPedido.pendiente ||
        estado == EstadoPedido.confirmado;
  }

  VentaPedido copyWith({
    String? id,
    String? loteId,
    Cliente? cliente,
    DateTime? fechaPedido,
    DateTime? fechaEntregaProgramada,
    DateTime? fechaEntregaReal,
    EstadoPedido? estado,
    int? cantidadAves,
    double? pesoPromedioKg,
    double? precioUnitario,
    bool? preciosPorKg,
    double? descuentoPorcentaje,
    double? impuestoIVA,
    String? numeroGuiaSanitaria,
    String? numeroFactura,
    String? direccionEntrega,
    String? transportista,
    String? observaciones,
    String? registroEntregaId,
    String? creadoPor,
    String? aprobadoPor,
    DateTime? fechaAprobacion,
  }) {
    return VentaPedido(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      cliente: cliente ?? this.cliente,
      fechaPedido: fechaPedido ?? this.fechaPedido,
      fechaEntregaProgramada:
          fechaEntregaProgramada ?? this.fechaEntregaProgramada,
      fechaEntregaReal: fechaEntregaReal ?? this.fechaEntregaReal,
      estado: estado ?? this.estado,
      cantidadAves: cantidadAves ?? this.cantidadAves,
      pesoPromedioKg: pesoPromedioKg ?? this.pesoPromedioKg,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      preciosPorKg: preciosPorKg ?? this.preciosPorKg,
      descuentoPorcentaje: descuentoPorcentaje ?? this.descuentoPorcentaje,
      impuestoIVA: impuestoIVA ?? this.impuestoIVA,
      numeroGuiaSanitaria: numeroGuiaSanitaria ?? this.numeroGuiaSanitaria,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      direccionEntrega: direccionEntrega ?? this.direccionEntrega,
      transportista: transportista ?? this.transportista,
      observaciones: observaciones ?? this.observaciones,
      registroEntregaId: registroEntregaId ?? this.registroEntregaId,
      creadoPor: creadoPor ?? this.creadoPor,
      aprobadoPor: aprobadoPor ?? this.aprobadoPor,
      fechaAprobacion: fechaAprobacion ?? this.fechaAprobacion,
    );
  }

  @override
  List<Object?> get props => [
    id,
    loteId,
    cliente,
    fechaPedido,
    fechaEntregaProgramada,
    fechaEntregaReal,
    estado,
    cantidadAves,
    pesoPromedioKg,
    precioUnitario,
    preciosPorKg,
    descuentoPorcentaje,
    impuestoIVA,
    numeroGuiaSanitaria,
    numeroFactura,
    direccionEntrega,
    transportista,
    observaciones,
    registroEntregaId,
    creadoPor,
    aprobadoPor,
    fechaAprobacion,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loteId': loteId,
      'cliente': cliente.toJson(),
      'fechaPedido': fechaPedido.toIso8601String(),
      'fechaEntregaProgramada': fechaEntregaProgramada?.toIso8601String(),
      'fechaEntregaReal': fechaEntregaReal?.toIso8601String(),
      'estado': estado.name,
      'cantidadAves': cantidadAves,
      'pesoPromedioKg': pesoPromedioKg,
      'precioUnitario': precioUnitario,
      'preciosPorKg': preciosPorKg,
      'descuentoPorcentaje': descuentoPorcentaje,
      'impuestoIVA': impuestoIVA,
      'numeroGuiaSanitaria': numeroGuiaSanitaria,
      'numeroFactura': numeroFactura,
      'direccionEntrega': direccionEntrega,
      'transportista': transportista,
      'observaciones': observaciones,
      'registroEntregaId': registroEntregaId,
      'creadoPor': creadoPor,
      'aprobadoPor': aprobadoPor,
      'fechaAprobacion': fechaAprobacion?.toIso8601String(),
    };
  }

  factory VentaPedido.fromJson(Map<String, dynamic> json) {
    return VentaPedido(
      id: json['id'] as String,
      loteId: json['loteId'] as String,
      cliente: Cliente.fromJson(json['cliente'] as Map<String, dynamic>),
      fechaPedido: DateTime.parse(json['fechaPedido'] as String),
      fechaEntregaProgramada: json['fechaEntregaProgramada'] != null
          ? DateTime.parse(json['fechaEntregaProgramada'] as String)
          : null,
      fechaEntregaReal: json['fechaEntregaReal'] != null
          ? DateTime.parse(json['fechaEntregaReal'] as String)
          : null,
      estado: EstadoPedido.values.firstWhere((e) => e.name == json['estado']),
      cantidadAves: json['cantidadAves'] as int,
      pesoPromedioKg: (json['pesoPromedioKg'] as num).toDouble(),
      precioUnitario: (json['precioUnitario'] as num).toDouble(),
      preciosPorKg: json['preciosPorKg'] as bool? ?? true,
      descuentoPorcentaje:
          (json['descuentoPorcentaje'] as num?)?.toDouble() ?? 0.0,
      impuestoIVA: (json['impuestoIVA'] as num?)?.toDouble(),
      numeroGuiaSanitaria: json['numeroGuiaSanitaria'] as String?,
      numeroFactura: json['numeroFactura'] as String?,
      direccionEntrega: json['direccionEntrega'] as String?,
      transportista: json['transportista'] as String?,
      observaciones: json['observaciones'] as String?,
      registroEntregaId: json['registroEntregaId'] as String?,
      creadoPor: json['creadoPor'] as String,
      aprobadoPor: json['aprobadoPor'] as String?,
      fechaAprobacion: json['fechaAprobacion'] != null
          ? DateTime.parse(json['fechaAprobacion'] as String)
          : null,
    );
  }
}
