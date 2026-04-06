import 'package:equatable/equatable.dart';
import '../../../../core/errors/error_messages.dart';
import '../enums/tipo_producto_venta.dart';
import '../enums/clasificacion_huevo.dart';
import '../enums/unidad_venta_pollinaza.dart';
import '../enums/estado_venta.dart';
import '../value_objects/cliente.dart';

/// Entity que representa una venta de cualquier producto de la granja.
///
/// AGGREGATE ROOT para ventas comerciales multi-producto.
/// Soporta: Aves vivas, faenadas, de descarte, Huevos, Pollinaza
class VentaProducto extends Equatable {
  final String id;
  final String loteId;
  final String granjaId;
  final Cliente cliente;
  final DateTime fechaVenta;
  final TipoProductoVenta tipoProducto;

  // Aves
  final int? cantidadAves;
  final double? pesoPromedioKg;
  final double? precioKg;
  final double? pesoVivo;
  final double? pesoFaenado;
  final double? rendimientoCanal;

  // Huevos
  final Map<ClasificacionHuevo, int>? huevosPorClasificacion;
  final Map<ClasificacionHuevo, double>? preciosPorDocena;

  // Pollinaza
  final double? cantidadPollinaza;
  final UnidadVentaPollinaza? unidadPollinaza;
  final double? precioUnitarioPollinaza;

  // Financiero
  final double descuentoPorcentaje;
  final double? impuestoIVA;
  final String? numeroFactura;
  final EstadoVenta estado;

  // Logística
  final DateTime? fechaEntrega;
  final String? direccionEntrega;
  final String? transportista;
  final String? numeroGuia;
  final String? observaciones;

  // Pesaje por jabas
  final List<PesajeJaba>? pesajesJabas;

  // Auditoría
  final String registradoPor;
  final DateTime fechaRegistro;
  final DateTime? fechaActualizacion;

  const VentaProducto({
    required this.id,
    required this.loteId,
    required this.granjaId,
    required this.cliente,
    required this.fechaVenta,
    required this.tipoProducto,
    this.cantidadAves,
    this.pesoPromedioKg,
    this.precioKg,
    this.pesoVivo,
    this.pesoFaenado,
    this.rendimientoCanal,
    this.huevosPorClasificacion,
    this.preciosPorDocena,
    this.cantidadPollinaza,
    this.unidadPollinaza,
    this.precioUnitarioPollinaza,
    this.descuentoPorcentaje = 0.0,
    this.impuestoIVA,
    this.numeroFactura,
    required this.estado,
    this.fechaEntrega,
    this.direccionEntrega,
    this.transportista,
    this.numeroGuia,
    this.observaciones,
    this.pesajesJabas,
    required this.registradoPor,
    required this.fechaRegistro,
    this.fechaActualizacion,
  });

  // Calculated properties
  double get subtotal {
    switch (tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
        if (pesajesJabas != null && pesajesJabas!.isNotEmpty) {
          final pesoTotal = pesajesJabas!.fold<double>(
            0,
            (sum, jaba) => sum + jaba.pesoKg,
          );
          return pesoTotal * (precioKg ?? 0);
        }
        final peso = (cantidadAves ?? 0) * (pesoPromedioKg ?? 0);
        return peso * (precioKg ?? 0);

      case TipoProductoVenta.avesFaenadas:
        final peso = pesoFaenado ?? 0;
        return peso * (precioKg ?? 0);

      case TipoProductoVenta.huevos:
        double total = 0;
        huevosPorClasificacion?.forEach((clasificacion, cantidad) {
          final precioDocena = preciosPorDocena?[clasificacion] ?? 0;
          final docenas = cantidad / 12;
          total += docenas * precioDocena;
        });
        return total;

      case TipoProductoVenta.pollinaza:
        return (cantidadPollinaza ?? 0) * (precioUnitarioPollinaza ?? 0);
    }
  }

  double get montoDescuento => subtotal * (descuentoPorcentaje / 100);
  double get subtotalConDescuento => subtotal - montoDescuento;

  double get montoIVA {
    if (impuestoIVA == null) return 0.0;
    return subtotalConDescuento * (impuestoIVA! / 100);
  }

  double get totalFinal => subtotalConDescuento + montoIVA;

  int get totalHuevos {
    if (tipoProducto != TipoProductoVenta.huevos) return 0;
    return huevosPorClasificacion?.values.fold<int>(
          0,
          (sum, qty) => sum + qty,
        ) ??
        0;
  }

  VentaProducto copyWith({
    String? id,
    String? loteId,
    String? granjaId,
    Cliente? cliente,
    DateTime? fechaVenta,
    TipoProductoVenta? tipoProducto,
    int? cantidadAves,
    double? pesoPromedioKg,
    double? precioKg,
    double? pesoVivo,
    double? pesoFaenado,
    double? rendimientoCanal,
    Map<ClasificacionHuevo, int>? huevosPorClasificacion,
    Map<ClasificacionHuevo, double>? preciosPorDocena,
    double? cantidadPollinaza,
    UnidadVentaPollinaza? unidadPollinaza,
    double? precioUnitarioPollinaza,
    double? descuentoPorcentaje,
    double? impuestoIVA,
    String? numeroFactura,
    EstadoVenta? estado,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
    String? numeroGuia,
    String? observaciones,
    List<PesajeJaba>? pesajesJabas,
    String? registradoPor,
    DateTime? fechaRegistro,
    DateTime? fechaActualizacion,
  }) {
    return VentaProducto(
      id: id ?? this.id,
      loteId: loteId ?? this.loteId,
      granjaId: granjaId ?? this.granjaId,
      cliente: cliente ?? this.cliente,
      fechaVenta: fechaVenta ?? this.fechaVenta,
      tipoProducto: tipoProducto ?? this.tipoProducto,
      cantidadAves: cantidadAves ?? this.cantidadAves,
      pesoPromedioKg: pesoPromedioKg ?? this.pesoPromedioKg,
      precioKg: precioKg ?? this.precioKg,
      pesoVivo: pesoVivo ?? this.pesoVivo,
      pesoFaenado: pesoFaenado ?? this.pesoFaenado,
      rendimientoCanal: rendimientoCanal ?? this.rendimientoCanal,
      huevosPorClasificacion:
          huevosPorClasificacion ?? this.huevosPorClasificacion,
      preciosPorDocena: preciosPorDocena ?? this.preciosPorDocena,
      cantidadPollinaza: cantidadPollinaza ?? this.cantidadPollinaza,
      unidadPollinaza: unidadPollinaza ?? this.unidadPollinaza,
      precioUnitarioPollinaza:
          precioUnitarioPollinaza ?? this.precioUnitarioPollinaza,
      descuentoPorcentaje: descuentoPorcentaje ?? this.descuentoPorcentaje,
      impuestoIVA: impuestoIVA ?? this.impuestoIVA,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      estado: estado ?? this.estado,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      direccionEntrega: direccionEntrega ?? this.direccionEntrega,
      transportista: transportista ?? this.transportista,
      numeroGuia: numeroGuia ?? this.numeroGuia,
      observaciones: observaciones ?? this.observaciones,
      pesajesJabas: pesajesJabas ?? this.pesajesJabas,
      registradoPor: registradoPor ?? this.registradoPor,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      fechaActualizacion: fechaActualizacion ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    loteId,
    granjaId,
    cliente,
    fechaVenta,
    tipoProducto,
    cantidadAves,
    pesoPromedioKg,
    precioKg,
    pesoVivo,
    pesoFaenado,
    rendimientoCanal,
    huevosPorClasificacion,
    preciosPorDocena,
    cantidadPollinaza,
    unidadPollinaza,
    precioUnitarioPollinaza,
    descuentoPorcentaje,
    impuestoIVA,
    numeroFactura,
    estado,
    fechaEntrega,
    direccionEntrega,
    transportista,
    numeroGuia,
    observaciones,
    pesajesJabas,
    registradoPor,
    fechaRegistro,
    fechaActualizacion,
  ];

  // ==================== FACTORY CONSTRUCTORS ====================

  /// Crea una venta de aves vivas.
  factory VentaProducto.avesVivas({
    required String id,
    required String loteId,
    required String granjaId,
    required Cliente cliente,
    required int cantidadAves,
    required double pesoPromedioKg,
    required double precioKg,
    required String registradoPor,
    List<PesajeJaba>? pesajesJabas,
    double descuentoPorcentaje = 0.0,
    String? numeroGuia,
    String? observaciones,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
  }) {
    if (cantidadAves <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_AVES_GREATER_ZERO'),
      );
    }
    if (pesoPromedioKg <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PESO_PROMEDIO_GREATER_ZERO'),
      );
    }
    if (precioKg <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PRECIO_KG_GREATER_ZERO'),
      );
    }

    return VentaProducto(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      cliente: cliente,
      fechaVenta: DateTime.now(),
      tipoProducto: TipoProductoVenta.avesVivas,
      cantidadAves: cantidadAves,
      pesoPromedioKg: pesoPromedioKg,
      precioKg: precioKg,
      pesajesJabas: pesajesJabas,
      descuentoPorcentaje: descuentoPorcentaje,
      numeroGuia: numeroGuia,
      observaciones: observaciones,
      fechaEntrega: fechaEntrega,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      estado: EstadoVenta.pendiente,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Crea una venta de huevos.
  factory VentaProducto.huevos({
    required String id,
    required String loteId,
    required String granjaId,
    required Cliente cliente,
    required Map<ClasificacionHuevo, int> huevosPorClasificacion,
    required Map<ClasificacionHuevo, double> preciosPorDocena,
    required String registradoPor,
    double descuentoPorcentaje = 0.0,
    String? observaciones,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
  }) {
    if (huevosPorClasificacion.isEmpty) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_HUEVOS_CLASIFICACION'),
      );
    }
    if (preciosPorDocena.isEmpty) {
      throw VentaProductoException(ErrorMessages.get('VENTA_HUEVOS_PRECIOS'));
    }

    final totalHuevos = huevosPorClasificacion.values.fold<int>(
      0,
      (sum, qty) => sum + qty,
    );
    if (totalHuevos <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_HUEVOS_TOTAL_GREATER_ZERO'),
      );
    }

    return VentaProducto(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      cliente: cliente,
      fechaVenta: DateTime.now(),
      tipoProducto: TipoProductoVenta.huevos,
      huevosPorClasificacion: huevosPorClasificacion,
      preciosPorDocena: preciosPorDocena,
      descuentoPorcentaje: descuentoPorcentaje,
      observaciones: observaciones,
      fechaEntrega: fechaEntrega,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      estado: EstadoVenta.pendiente,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Crea una venta de pollinaza.
  factory VentaProducto.pollinaza({
    required String id,
    required String loteId,
    required String granjaId,
    required Cliente cliente,
    required double cantidadPollinaza,
    required UnidadVentaPollinaza unidadPollinaza,
    required double precioUnitarioPollinaza,
    required String registradoPor,
    double descuentoPorcentaje = 0.0,
    String? observaciones,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
  }) {
    if (cantidadPollinaza <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_POLLINAZA_GREATER_ZERO'),
      );
    }
    if (precioUnitarioPollinaza <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PRECIO_UNITARIO_GREATER_ZERO'),
      );
    }

    return VentaProducto(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      cliente: cliente,
      fechaVenta: DateTime.now(),
      tipoProducto: TipoProductoVenta.pollinaza,
      cantidadPollinaza: cantidadPollinaza,
      unidadPollinaza: unidadPollinaza,
      precioUnitarioPollinaza: precioUnitarioPollinaza,
      descuentoPorcentaje: descuentoPorcentaje,
      observaciones: observaciones,
      fechaEntrega: fechaEntrega,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      estado: EstadoVenta.pendiente,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Crea una venta de aves faenadas.
  factory VentaProducto.avesFaenadas({
    required String id,
    required String loteId,
    required String granjaId,
    required Cliente cliente,
    required int cantidadAves,
    required double pesoFaenado,
    required double precioKg,
    required String registradoPor,
    double? pesoVivo,
    double? rendimientoCanal,
    double descuentoPorcentaje = 0.0,
    String? numeroGuia,
    String? observaciones,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
  }) {
    if (cantidadAves <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_AVES_GREATER_ZERO'),
      );
    }
    if (pesoFaenado <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PESO_FAENADO_GREATER_ZERO'),
      );
    }
    if (precioKg <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PRECIO_KG_GREATER_ZERO'),
      );
    }

    return VentaProducto(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      cliente: cliente,
      fechaVenta: DateTime.now(),
      tipoProducto: TipoProductoVenta.avesFaenadas,
      cantidadAves: cantidadAves,
      pesoVivo: pesoVivo,
      pesoFaenado: pesoFaenado,
      rendimientoCanal: rendimientoCanal,
      precioKg: precioKg,
      descuentoPorcentaje: descuentoPorcentaje,
      numeroGuia: numeroGuia,
      observaciones: observaciones,
      fechaEntrega: fechaEntrega,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      estado: EstadoVenta.pendiente,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Crea una venta de aves de descarte.
  factory VentaProducto.avesDescarte({
    required String id,
    required String loteId,
    required String granjaId,
    required Cliente cliente,
    required int cantidadAves,
    required double pesoPromedioKg,
    required double precioKg,
    required String registradoPor,
    double descuentoPorcentaje = 0.0,
    String? numeroGuia,
    String? observaciones,
    DateTime? fechaEntrega,
    String? direccionEntrega,
    String? transportista,
  }) {
    if (cantidadAves <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_AVES_GREATER_ZERO'),
      );
    }
    if (precioKg <= 0) {
      throw VentaProductoException(
        ErrorMessages.get('VENTA_PRECIO_KG_GREATER_ZERO'),
      );
    }

    return VentaProducto(
      id: id,
      loteId: loteId,
      granjaId: granjaId,
      cliente: cliente,
      fechaVenta: DateTime.now(),
      tipoProducto: TipoProductoVenta.avesDescarte,
      cantidadAves: cantidadAves,
      pesoPromedioKg: pesoPromedioKg,
      precioKg: precioKg,
      descuentoPorcentaje: descuentoPorcentaje,
      numeroGuia: numeroGuia,
      observaciones: observaciones,
      fechaEntrega: fechaEntrega,
      direccionEntrega: direccionEntrega,
      transportista: transportista,
      estado: EstadoVenta.pendiente,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }
}

/// Value Object para pesaje por jaba.
class PesajeJaba extends Equatable {
  final int cantidadAves;
  final double pesoKg;

  const PesajeJaba({required this.cantidadAves, required this.pesoKg});

  double get pesoPromedioKg => cantidadAves > 0 ? pesoKg / cantidadAves : 0;

  bool esValido() => cantidadAves > 0 && pesoKg > 0;

  Map<String, dynamic> toJson() => {
    'cantidadAves': cantidadAves,
    'pesoKg': pesoKg,
  };

  factory PesajeJaba.fromJson(Map<String, dynamic> json) {
    return PesajeJaba(
      cantidadAves: json['cantidadAves'] as int,
      pesoKg: (json['pesoKg'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [cantidadAves, pesoKg];
}

/// Excepción para errores de validación de VentaProducto.
class VentaProductoException implements Exception {
  final String message;

  VentaProductoException(this.message);

  @override
  String toString() => 'VentaProductoException: $message';
}
