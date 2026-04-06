import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/error_messages.dart';
import '../../domain/entities/costo_gasto.dart';
import '../../domain/enums/tipo_gasto.dart';

class CostoGastoModel {
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

  const CostoGastoModel({
    required this.id,
    required this.granjaId,
    required this.tipo,
    required this.concepto,
    required this.monto,
    required this.fecha,
    required this.registradoPor,
    required this.fechaRegistro,
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
  });

  factory CostoGastoModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError(ErrorMessages.format('ERR_DOC_NO_DATA', {'id': doc.id}));
    }
    return CostoGastoModel(
      id: doc.id,
      granjaId: data['granjaId'] as String? ?? '',
      tipo: TipoGasto.fromJson(data['tipo'] as String? ?? 'Operativos'),
      concepto: data['concepto'] as String? ?? '',
      monto: (data['monto'] as num?)?.toDouble() ?? 0.0,
      fecha: data['fecha'] != null
          ? (data['fecha'] as Timestamp).toDate()
          : DateTime.now(),
      proveedor: data['proveedor'] as String?,
      categoria: data['categoria'] as String?,
      centroCosto: data['centroCosto'] as String?,
      loteId: data['loteId'] as String?,
      casaId: data['casaId'] as String?,
      lotesAsignados:
          (data['lotesAsignados'] as List<dynamic>?)?.cast<String>() ?? [],
      requiereAprobacion: data['requiereAprobacion'] as bool? ?? false,
      aprobado: data['aprobado'] as bool? ?? true,
      aprobadoPor: data['aprobadoPor'] as String?,
      fechaAprobacion: data['fechaAprobacion'] != null
          ? (data['fechaAprobacion'] as Timestamp).toDate()
          : null,
      motivoRechazo: data['motivoRechazo'] as String?,
      numeroFactura: data['numeroFactura'] as String?,
      numeroRecibo: data['numeroRecibo'] as String?,
      observaciones: data['observaciones'] as String?,
      registradoPor: data['registradoPor'] as String? ?? '',
      fechaRegistro: data['fechaRegistro'] != null
          ? (data['fechaRegistro'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'granjaId': granjaId,
      'tipo': tipo.toJson(),
      'concepto': concepto,
      'monto': monto,
      'fecha': Timestamp.fromDate(fecha),
      if (proveedor != null) 'proveedor': proveedor,
      if (categoria != null) 'categoria': categoria,
      if (centroCosto != null) 'centroCosto': centroCosto,
      if (loteId != null) 'loteId': loteId,
      if (casaId != null) 'casaId': casaId,
      if (lotesAsignados.isNotEmpty) 'lotesAsignados': lotesAsignados,
      'requiereAprobacion': requiereAprobacion,
      'aprobado': aprobado,
      if (aprobadoPor != null) 'aprobadoPor': aprobadoPor,
      if (fechaAprobacion != null)
        'fechaAprobacion': Timestamp.fromDate(fechaAprobacion!),
      if (motivoRechazo != null) 'motivoRechazo': motivoRechazo,
      if (numeroFactura != null) 'numeroFactura': numeroFactura,
      if (numeroRecibo != null) 'numeroRecibo': numeroRecibo,
      if (observaciones != null) 'observaciones': observaciones,
      'registradoPor': registradoPor,
      'fechaRegistro': Timestamp.fromDate(fechaRegistro),
    };
  }

  CostoGasto toEntity() {
    return CostoGasto(
      id: id,
      granjaId: granjaId,
      tipo: tipo,
      concepto: concepto,
      monto: monto,
      fecha: fecha,
      proveedor: proveedor,
      categoria: categoria,
      centroCosto: centroCosto,
      loteId: loteId,
      casaId: casaId,
      lotesAsignados: lotesAsignados,
      requiereAprobacion: requiereAprobacion,
      aprobado: aprobado,
      aprobadoPor: aprobadoPor,
      fechaAprobacion: fechaAprobacion,
      motivoRechazo: motivoRechazo,
      numeroFactura: numeroFactura,
      numeroRecibo: numeroRecibo,
      observaciones: observaciones,
      registradoPor: registradoPor,
      fechaRegistro: fechaRegistro,
    );
  }

  factory CostoGastoModel.fromEntity(CostoGasto gasto) {
    return CostoGastoModel(
      id: gasto.id,
      granjaId: gasto.granjaId,
      tipo: gasto.tipo,
      concepto: gasto.concepto,
      monto: gasto.monto,
      fecha: gasto.fecha,
      proveedor: gasto.proveedor,
      categoria: gasto.categoria,
      centroCosto: gasto.centroCosto,
      loteId: gasto.loteId,
      casaId: gasto.casaId,
      lotesAsignados: gasto.lotesAsignados,
      requiereAprobacion: gasto.requiereAprobacion,
      aprobado: gasto.aprobado,
      aprobadoPor: gasto.aprobadoPor,
      fechaAprobacion: gasto.fechaAprobacion,
      motivoRechazo: gasto.motivoRechazo,
      numeroFactura: gasto.numeroFactura,
      numeroRecibo: gasto.numeroRecibo,
      observaciones: gasto.observaciones,
      registradoPor: gasto.registradoPor,
      fechaRegistro: gasto.fechaRegistro,
    );
  }
}
