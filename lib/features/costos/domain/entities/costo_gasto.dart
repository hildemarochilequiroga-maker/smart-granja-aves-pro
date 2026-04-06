import 'package:equatable/equatable.dart';
import 'package:smartgranjaavespro/core/errors/error_messages.dart';
import 'package:smartgranjaavespro/core/utils/formatters.dart';
import '../enums/tipo_gasto.dart';

/// Entity que representa un costo o gasto operacional de la granja.
class CostoGasto extends Equatable {
  final String id;
  final String granjaId;
  final TipoGasto tipo;
  final String concepto;
  final double monto;
  final DateTime fecha;
  final String? proveedor;
  final String? categoria;
  final String? centroCosto;
  final String? loteId;
  final String? casaId;
  final List<String> lotesAsignados;
  final bool requiereAprobacion;
  final bool aprobado;
  final String? aprobadoPor;
  final DateTime? fechaAprobacion;
  final String? motivoRechazo;
  final String? numeroFactura;
  final String? numeroRecibo;
  final String? observaciones;
  final String registradoPor;
  final DateTime fechaRegistro;

  const CostoGasto({
    required this.id,
    required this.granjaId,
    required this.tipo,
    required this.concepto,
    required this.monto,
    required this.fecha,
    this.proveedor,
    this.categoria,
    this.centroCosto,
    this.loteId,
    this.casaId,
    this.lotesAsignados = const [],
    this.requiereAprobacion = false,
    this.aprobado = true,
    this.aprobadoPor,
    this.fechaAprobacion,
    this.motivoRechazo,
    this.numeroFactura,
    this.numeroRecibo,
    this.observaciones,
    required this.registradoPor,
    required this.fechaRegistro,
  });

  factory CostoGasto.crear({
    required String id,
    required String granjaId,
    required TipoGasto tipo,
    required String concepto,
    required double monto,
    required String registradoPor,
    DateTime? fecha,
    String? proveedor,
    String? categoria,
    String? centroCosto,
    String? loteId,
    String? casaId,
    List<String> lotesAsignados = const [],
    bool requiereAprobacion = false,
    String? numeroFactura,
    String? observaciones,
  }) {
    if (concepto.trim().isEmpty) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_CONCEPTO_VACIO'),
      );
    }
    if (monto <= 0) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_MONTO_MAYOR_CERO'),
      );
    }

    return CostoGasto(
      id: id,
      granjaId: granjaId,
      tipo: tipo,
      concepto: concepto,
      monto: monto,
      fecha: fecha ?? DateTime.now(),
      proveedor: proveedor,
      categoria: categoria,
      centroCosto: centroCosto,
      loteId: loteId,
      casaId: casaId,
      lotesAsignados: lotesAsignados,
      requiereAprobacion: requiereAprobacion,
      aprobado: !requiereAprobacion,
      numeroFactura: numeroFactura,
      observaciones: observaciones,
      registradoPor: registradoPor,
      fechaRegistro: DateTime.now(),
    );
  }

  bool get estaPendiente =>
      requiereAprobacion && !aprobado && motivoRechazo == null;
  bool get estaRechazado => motivoRechazo != null;
  bool get esGastoVariable => tipo.esVariable;
  bool get esGastoFijo => tipo.esFijo;
  bool get estaProrrateado => lotesAsignados.isNotEmpty;
  int get numeroLotesAsignados => lotesAsignados.length;
  double get montoPorLote =>
      !estaProrrateado ? monto : monto / numeroLotesAsignados;

  String get categoriaContable {
    if (categoria != null && categoria!.isNotEmpty) return categoria!;
    return tipo.categoriaEstadoResultados;
  }

  String get centroCostoEfectivo {
    if (centroCosto != null && centroCosto!.isNotEmpty) return centroCosto!;
    final locale = Formatters.currentLocale;
    if (loteId != null) return switch (locale) { 'es' => 'Lote', 'pt' => 'Lote', _ => 'Batch' };
    if (casaId != null) return switch (locale) { 'es' => 'Casa', 'pt' => 'Galpão', _ => 'House' };
    return switch (locale) { 'es' => 'Administrativa', 'pt' => 'Administrativa', _ => 'Administrative' };
  }

  double calcularCostoPorAve(int cantidadAves) {
    if (cantidadAves <= 0) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_AVES_MAYOR_CERO'),
      );
    }
    return monto / cantidadAves;
  }

  double calcularCostoPorAveLote(int cantidadAves) {
    if (cantidadAves <= 0) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_AVES_MAYOR_CERO'),
      );
    }
    return montoPorLote / cantidadAves;
  }

  CostoGasto aprobar(String aprobadoPor) {
    if (!requiereAprobacion) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_NO_REQUIERE_APROBACION'),
      );
    }
    if (aprobado) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_YA_APROBADO'),
      );
    }
    return copyWith(
      aprobado: true,
      aprobadoPor: aprobadoPor,
      fechaAprobacion: DateTime.now(),
    );
  }

  CostoGasto rechazar({required String motivo}) {
    if (!requiereAprobacion) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_NO_REQUIERE_APROBACION'),
      );
    }
    if (motivo.trim().isEmpty) {
      throw CostoGastoException(
        ErrorMessages.get('COSTO_MOTIVO_RECHAZO_VACIO'),
      );
    }
    return copyWith(motivoRechazo: motivo);
  }

  CostoGasto copyWith({
    String? id,
    String? granjaId,
    TipoGasto? tipo,
    String? concepto,
    double? monto,
    DateTime? fecha,
    String? proveedor,
    String? categoria,
    String? centroCosto,
    String? loteId,
    String? casaId,
    List<String>? lotesAsignados,
    bool? requiereAprobacion,
    bool? aprobado,
    String? aprobadoPor,
    DateTime? fechaAprobacion,
    String? motivoRechazo,
    String? numeroFactura,
    String? numeroRecibo,
    String? observaciones,
    String? registradoPor,
    DateTime? fechaRegistro,
  }) {
    return CostoGasto(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      tipo: tipo ?? this.tipo,
      concepto: concepto ?? this.concepto,
      monto: monto ?? this.monto,
      fecha: fecha ?? this.fecha,
      proveedor: proveedor ?? this.proveedor,
      categoria: categoria ?? this.categoria,
      centroCosto: centroCosto ?? this.centroCosto,
      loteId: loteId ?? this.loteId,
      casaId: casaId ?? this.casaId,
      lotesAsignados: lotesAsignados ?? this.lotesAsignados,
      requiereAprobacion: requiereAprobacion ?? this.requiereAprobacion,
      aprobado: aprobado ?? this.aprobado,
      aprobadoPor: aprobadoPor ?? this.aprobadoPor,
      fechaAprobacion: fechaAprobacion ?? this.fechaAprobacion,
      motivoRechazo: motivoRechazo ?? this.motivoRechazo,
      numeroFactura: numeroFactura ?? this.numeroFactura,
      numeroRecibo: numeroRecibo ?? this.numeroRecibo,
      observaciones: observaciones ?? this.observaciones,
      registradoPor: registradoPor ?? this.registradoPor,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  List<Object?> get props => [
    id,
    granjaId,
    tipo,
    concepto,
    monto,
    fecha,
    proveedor,
    categoria,
    centroCosto,
    loteId,
    casaId,
    lotesAsignados,
    requiereAprobacion,
    aprobado,
    aprobadoPor,
    fechaAprobacion,
    motivoRechazo,
    numeroFactura,
    numeroRecibo,
    observaciones,
    registradoPor,
    fechaRegistro,
  ];
}

class CostoGastoException implements Exception {
  final String message;
  CostoGastoException(this.message);

  @override
  String toString() => 'CostoGastoException: $message';
}
