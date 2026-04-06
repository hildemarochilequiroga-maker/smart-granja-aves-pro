import '../../domain/entities/venta_pedido.dart';
import '../../domain/enums/estado_pedido.dart';
import '../../domain/value_objects/cliente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VentaPedidoModel {
  final String id;
  final String loteId;
  final Map<String, dynamic> clienteData;
  final DateTime fechaPedido;
  final DateTime? fechaEntregaProgramada;
  final DateTime? fechaEntregaReal;
  final String estado;
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

  VentaPedidoModel({
    required this.id,
    required this.loteId,
    required this.clienteData,
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

  factory VentaPedidoModel.fromEntity(VentaPedido entity) {
    return VentaPedidoModel(
      id: entity.id,
      loteId: entity.loteId,
      clienteData: entity.cliente.toJson(),
      fechaPedido: entity.fechaPedido,
      fechaEntregaProgramada: entity.fechaEntregaProgramada,
      fechaEntregaReal: entity.fechaEntregaReal,
      estado: entity.estado.name,
      cantidadAves: entity.cantidadAves,
      pesoPromedioKg: entity.pesoPromedioKg,
      precioUnitario: entity.precioUnitario,
      preciosPorKg: entity.preciosPorKg,
      descuentoPorcentaje: entity.descuentoPorcentaje,
      impuestoIVA: entity.impuestoIVA,
      numeroGuiaSanitaria: entity.numeroGuiaSanitaria,
      numeroFactura: entity.numeroFactura,
      direccionEntrega: entity.direccionEntrega,
      transportista: entity.transportista,
      observaciones: entity.observaciones,
      registroEntregaId: entity.registroEntregaId,
      creadoPor: entity.creadoPor,
      aprobadoPor: entity.aprobadoPor,
      fechaAprobacion: entity.fechaAprobacion,
    );
  }

  VentaPedido toEntity() {
    return VentaPedido(
      id: id,
      loteId: loteId,
      cliente: Cliente.fromJson(clienteData),
      fechaPedido: fechaPedido,
      fechaEntregaProgramada: fechaEntregaProgramada,
      fechaEntregaReal: fechaEntregaReal,
      estado: EstadoPedido.values.firstWhere(
        (e) => e.name == estado,
        orElse: () => EstadoPedido.pendiente,
      ),
      cantidadAves: cantidadAves,
      pesoPromedioKg: pesoPromedioKg,
      precioUnitario: precioUnitario,
      preciosPorKg: preciosPorKg,
      descuentoPorcentaje: descuentoPorcentaje,
      impuestoIVA: impuestoIVA,
      numeroGuiaSanitaria: numeroGuiaSanitaria,
      numeroFactura: numeroFactura,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      observaciones: observaciones,
      registroEntregaId: registroEntregaId,
      creadoPor: creadoPor,
      aprobadoPor: aprobadoPor,
      fechaAprobacion: fechaAprobacion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loteId': loteId,
      'cliente': clienteData,
      'fechaPedido': fechaPedido.toIso8601String(),
      'fechaEntregaProgramada': fechaEntregaProgramada?.toIso8601String(),
      'fechaEntregaReal': fechaEntregaReal?.toIso8601String(),
      'estado': estado,
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

  factory VentaPedidoModel.fromJson(Map<String, dynamic> json) {
    return VentaPedidoModel(
      id: json['id'] as String,
      loteId: json['loteId'] as String,
      clienteData: json['cliente'] as Map<String, dynamic>,
      fechaPedido: DateTime.parse(json['fechaPedido'] as String),
      fechaEntregaProgramada: json['fechaEntregaProgramada'] != null
          ? DateTime.parse(json['fechaEntregaProgramada'] as String)
          : null,
      fechaEntregaReal: json['fechaEntregaReal'] != null
          ? DateTime.parse(json['fechaEntregaReal'] as String)
          : null,
      estado: json['estado'] as String,
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

  // Métodos para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'loteId': loteId,
      'cliente': clienteData,
      'fechaPedido': Timestamp.fromDate(fechaPedido),
      'fechaEntregaProgramada': fechaEntregaProgramada != null
          ? Timestamp.fromDate(fechaEntregaProgramada!)
          : null,
      'fechaEntregaReal': fechaEntregaReal != null
          ? Timestamp.fromDate(fechaEntregaReal!)
          : null,
      'estado': estado,
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
      'fechaAprobacion': fechaAprobacion != null
          ? Timestamp.fromDate(fechaAprobacion!)
          : null,
    };
  }

  factory VentaPedidoModel.fromFirestore(
    Map<String, dynamic> data,
    String docId,
  ) {
    return VentaPedidoModel(
      id: docId,
      loteId: data['loteId'] as String,
      clienteData: data['cliente'] as Map<String, dynamic>,
      fechaPedido: (data['fechaPedido'] as Timestamp).toDate(),
      fechaEntregaProgramada: data['fechaEntregaProgramada'] != null
          ? (data['fechaEntregaProgramada'] as Timestamp).toDate()
          : null,
      fechaEntregaReal: data['fechaEntregaReal'] != null
          ? (data['fechaEntregaReal'] as Timestamp).toDate()
          : null,
      estado: data['estado'] as String,
      cantidadAves: data['cantidadAves'] as int,
      pesoPromedioKg: (data['pesoPromedioKg'] as num).toDouble(),
      precioUnitario: (data['precioUnitario'] as num).toDouble(),
      preciosPorKg: data['preciosPorKg'] as bool? ?? true,
      descuentoPorcentaje:
          (data['descuentoPorcentaje'] as num?)?.toDouble() ?? 0.0,
      impuestoIVA: (data['impuestoIVA'] as num?)?.toDouble(),
      numeroGuiaSanitaria: data['numeroGuiaSanitaria'] as String?,
      numeroFactura: data['numeroFactura'] as String?,
      direccionEntrega: data['direccionEntrega'] as String?,
      transportista: data['transportista'] as String?,
      observaciones: data['observaciones'] as String?,
      registroEntregaId: data['registroEntregaId'] as String?,
      creadoPor: data['creadoPor'] as String,
      aprobadoPor: data['aprobadoPor'] as String?,
      fechaAprobacion: data['fechaAprobacion'] != null
          ? (data['fechaAprobacion'] as Timestamp).toDate()
          : null,
    );
  }
}
