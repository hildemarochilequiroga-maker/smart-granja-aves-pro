import 'package:equatable/equatable.dart';

/// Entity que representa el registro detallado de la entrega de un pedido.
///
/// Captura información real al momento de la entrega:
/// - Peso real vs peso estimado
/// - Clasificación por peso
/// - Aves rechazadas y motivos
/// - Documentación (fotos, firma cliente)
class RegistroEntregaPedido extends Equatable {
  final String id;
  final String pedidoId;
  final DateTime fechaEntrega;
  final String responsableEntrega;

  final double pesoRealTotalKg;
  final double pesoPromedioRealKg;
  final double mermaTransportePorcentaje;

  final Map<String, int> distribucionPorPeso;
  final Map<String, double> preciosPorCategoria;

  final int avesRechazadas;
  final String? motivoRechazo;
  final double bonificacionCalidad;
  final double penalizacionDefectos;

  final TipoVentaAves tipoVenta;
  final double? rendimientoCanalPorcentaje;

  final List<String> fotosEntrega;
  final String? firmaCliente;
  final String? observacionesCliente;
  final String? observacionesEntrega;

  const RegistroEntregaPedido({
    required this.id,
    required this.pedidoId,
    required this.fechaEntrega,
    required this.responsableEntrega,
    required this.pesoRealTotalKg,
    required this.pesoPromedioRealKg,
    required this.mermaTransportePorcentaje,
    required this.distribucionPorPeso,
    required this.preciosPorCategoria,
    this.avesRechazadas = 0,
    this.motivoRechazo,
    this.bonificacionCalidad = 0.0,
    this.penalizacionDefectos = 0.0,
    required this.tipoVenta,
    this.rendimientoCanalPorcentaje,
    this.fotosEntrega = const [],
    this.firmaCliente,
    this.observacionesCliente,
    this.observacionesEntrega,
  });

  int get totalAvesEntregadas {
    return distribucionPorPeso.values.fold(
      0,
      (sum, cantidad) => sum + cantidad,
    );
  }

  int get avesAceptadas => totalAvesEntregadas - avesRechazadas;

  double get porcentajeRechazo {
    if (totalAvesEntregadas == 0) return 0;
    return (avesRechazadas / totalAvesEntregadas) * 100;
  }

  double get subtotalPorCategoria {
    double total = 0;
    distribucionPorPeso.forEach((categoria, cantidad) {
      final precio = preciosPorCategoria[categoria] ?? 0;
      total += cantidad * precio;
    });
    return total;
  }

  double get totalFinalConAjustes {
    return subtotalPorCategoria + bonificacionCalidad - penalizacionDefectos;
  }

  bool get mermaAceptable => mermaTransportePorcentaje <= 3.0;

  RegistroEntregaPedido copyWith({
    String? id,
    String? pedidoId,
    DateTime? fechaEntrega,
    String? responsableEntrega,
    double? pesoRealTotalKg,
    double? pesoPromedioRealKg,
    double? mermaTransportePorcentaje,
    Map<String, int>? distribucionPorPeso,
    Map<String, double>? preciosPorCategoria,
    int? avesRechazadas,
    String? motivoRechazo,
    double? bonificacionCalidad,
    double? penalizacionDefectos,
    TipoVentaAves? tipoVenta,
    double? rendimientoCanalPorcentaje,
    List<String>? fotosEntrega,
    String? firmaCliente,
    String? observacionesCliente,
    String? observacionesEntrega,
  }) {
    return RegistroEntregaPedido(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      responsableEntrega: responsableEntrega ?? this.responsableEntrega,
      pesoRealTotalKg: pesoRealTotalKg ?? this.pesoRealTotalKg,
      pesoPromedioRealKg: pesoPromedioRealKg ?? this.pesoPromedioRealKg,
      mermaTransportePorcentaje:
          mermaTransportePorcentaje ?? this.mermaTransportePorcentaje,
      distribucionPorPeso: distribucionPorPeso ?? this.distribucionPorPeso,
      preciosPorCategoria: preciosPorCategoria ?? this.preciosPorCategoria,
      avesRechazadas: avesRechazadas ?? this.avesRechazadas,
      motivoRechazo: motivoRechazo ?? this.motivoRechazo,
      bonificacionCalidad: bonificacionCalidad ?? this.bonificacionCalidad,
      penalizacionDefectos: penalizacionDefectos ?? this.penalizacionDefectos,
      tipoVenta: tipoVenta ?? this.tipoVenta,
      rendimientoCanalPorcentaje:
          rendimientoCanalPorcentaje ?? this.rendimientoCanalPorcentaje,
      fotosEntrega: fotosEntrega ?? this.fotosEntrega,
      firmaCliente: firmaCliente ?? this.firmaCliente,
      observacionesCliente: observacionesCliente ?? this.observacionesCliente,
      observacionesEntrega: observacionesEntrega ?? this.observacionesEntrega,
    );
  }

  @override
  List<Object?> get props => [
    id,
    pedidoId,
    fechaEntrega,
    responsableEntrega,
    pesoRealTotalKg,
    pesoPromedioRealKg,
    mermaTransportePorcentaje,
    distribucionPorPeso,
    preciosPorCategoria,
    avesRechazadas,
    motivoRechazo,
    bonificacionCalidad,
    penalizacionDefectos,
    tipoVenta,
    rendimientoCanalPorcentaje,
    fotosEntrega,
    firmaCliente,
    observacionesCliente,
    observacionesEntrega,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'fechaEntrega': fechaEntrega.toIso8601String(),
      'responsableEntrega': responsableEntrega,
      'pesoRealTotalKg': pesoRealTotalKg,
      'pesoPromedioRealKg': pesoPromedioRealKg,
      'mermaTransportePorcentaje': mermaTransportePorcentaje,
      'distribucionPorPeso': distribucionPorPeso,
      'preciosPorCategoria': preciosPorCategoria,
      'avesRechazadas': avesRechazadas,
      'motivoRechazo': motivoRechazo,
      'bonificacionCalidad': bonificacionCalidad,
      'penalizacionDefectos': penalizacionDefectos,
      'tipoVenta': tipoVenta.name,
      'rendimientoCanalPorcentaje': rendimientoCanalPorcentaje,
      'fotosEntrega': fotosEntrega,
      'firmaCliente': firmaCliente,
      'observacionesCliente': observacionesCliente,
      'observacionesEntrega': observacionesEntrega,
    };
  }

  factory RegistroEntregaPedido.fromJson(Map<String, dynamic> json) {
    return RegistroEntregaPedido(
      id: json['id'] as String,
      pedidoId: json['pedidoId'] as String,
      fechaEntrega: DateTime.parse(json['fechaEntrega'] as String),
      responsableEntrega: json['responsableEntrega'] as String,
      pesoRealTotalKg: (json['pesoRealTotalKg'] as num).toDouble(),
      pesoPromedioRealKg: (json['pesoPromedioRealKg'] as num).toDouble(),
      mermaTransportePorcentaje: (json['mermaTransportePorcentaje'] as num)
          .toDouble(),
      distribucionPorPeso: Map<String, int>.from(
        json['distribucionPorPeso'] as Map<String, dynamic>,
      ),
      preciosPorCategoria: (json['preciosPorCategoria'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      avesRechazadas: json['avesRechazadas'] as int? ?? 0,
      motivoRechazo: json['motivoRechazo'] as String?,
      bonificacionCalidad:
          (json['bonificacionCalidad'] as num?)?.toDouble() ?? 0.0,
      penalizacionDefectos:
          (json['penalizacionDefectos'] as num?)?.toDouble() ?? 0.0,
      tipoVenta: TipoVentaAves.values.firstWhere(
        (e) => e.name == json['tipoVenta'],
        orElse: () => TipoVentaAves.enPie,
      ),
      rendimientoCanalPorcentaje: (json['rendimientoCanalPorcentaje'] as num?)
          ?.toDouble(),
      fotosEntrega:
          (json['fotosEntrega'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      firmaCliente: json['firmaCliente'] as String?,
      observacionesCliente: json['observacionesCliente'] as String?,
      observacionesEntrega: json['observacionesEntrega'] as String?,
    );
  }
}

/// Enum para tipo de venta de aves
enum TipoVentaAves { enPie, enCanal }

extension TipoVentaAvesExtension on TipoVentaAves {
  String get nombre {
    switch (this) {
      case TipoVentaAves.enPie:
        return 'En Pie (Vivo)';
      case TipoVentaAves.enCanal:
        return 'En Canal (Procesado)';
    }
  }
}
