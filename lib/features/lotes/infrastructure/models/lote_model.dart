import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/lote.dart';
import '../../domain/enums/enums.dart';

/// Modelo de infraestructura para la entidad Lote.
///
/// Maneja la conversión entre Firestore y la entidad del dominio.
class LoteModel {
  const LoteModel({
    required this.id,
    required this.granjaId,
    required this.galponId,
    required this.codigo,
    required this.tipoAve,
    required this.cantidadInicial,
    required this.fechaIngreso,
    required this.estado,
    this.nombre,
    this.proveedor,
    this.raza,
    this.edadIngresoDias = 0,
    this.cantidadActual,
    this.mortalidadAcumulada = 0,
    this.descartesAcumulados = 0,
    this.ventasAcumuladas = 0,
    this.pesoPromedioActual,
    this.pesoPromedioObjetivo,
    this.consumoAcumuladoKg,
    this.huevosProducidos,
    this.fechaPrimerHuevo,
    this.fechaCierreEstimada,
    this.fechaCierreReal,
    this.motivoCierre,
    this.costoAveInicial,
    this.observaciones,
    this.fechaCreacion,
    this.ultimaActualizacion,
    this.metadatos = const {},
  });

  final String id;
  final String granjaId;
  final String galponId;
  final String codigo;
  final TipoAve tipoAve;
  final int cantidadInicial;
  final DateTime fechaIngreso;
  final EstadoLote estado;
  final String? nombre;
  final String? proveedor;
  final String? raza;
  final int edadIngresoDias;
  final int? cantidadActual;
  final int mortalidadAcumulada;
  final int descartesAcumulados;
  final int ventasAcumuladas;
  final double? pesoPromedioActual;
  final double? pesoPromedioObjetivo;
  final double? consumoAcumuladoKg;
  final int? huevosProducidos;
  final DateTime? fechaPrimerHuevo;
  final DateTime? fechaCierreEstimada;
  final DateTime? fechaCierreReal;
  final String? motivoCierre;
  final double? costoAveInicial;
  final String? observaciones;
  final DateTime? fechaCreacion;
  final DateTime? ultimaActualizacion;
  final Map<String, dynamic> metadatos;

  /// Convierte desde Firestore DocumentSnapshot.
  factory LoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return LoteModel.fromMap(data, doc.id);
  }

  /// Convierte desde Map (con ID opcional).
  factory LoteModel.fromMap(Map<String, dynamic> data, [String? documentId]) {
    return LoteModel(
      id: documentId ?? data['id'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      galponId: data['galponId'] as String? ?? '',
      codigo: data['codigo'] as String? ?? '',
      tipoAve:
          TipoAve.tryFromJson(data['tipoAve'] as String?) ??
          TipoAve.polloEngorde,
      cantidadInicial: data['cantidadInicial'] as int? ?? 0,
      fechaIngreso: _parseDateTime(data['fechaIngreso']) ?? DateTime.now(),
      estado:
          EstadoLote.tryFromJson(data['estado'] as String?) ??
          EstadoLote.activo,
      nombre: data['nombre'] as String?,
      proveedor: data['proveedor'] as String?,
      raza: data['raza'] as String?,
      edadIngresoDias: data['edadIngresoDias'] as int? ?? 0,
      cantidadActual: data['cantidadActual'] as int?,
      mortalidadAcumulada: data['mortalidadAcumulada'] as int? ?? 0,
      descartesAcumulados: data['descartesAcumulados'] as int? ?? 0,
      ventasAcumuladas: data['ventasAcumuladas'] as int? ?? 0,
      pesoPromedioActual: data['pesoPromedioActual'] != null
          ? (data['pesoPromedioActual'] as num).toDouble()
          : null,
      pesoPromedioObjetivo: data['pesoPromedioObjetivo'] != null
          ? (data['pesoPromedioObjetivo'] as num).toDouble()
          : null,
      consumoAcumuladoKg: data['consumoAcumuladoKg'] != null
          ? (data['consumoAcumuladoKg'] as num).toDouble()
          : null,
      huevosProducidos: data['huevosProducidos'] as int?,
      fechaPrimerHuevo: _parseDateTime(data['fechaPrimerHuevo']),
      fechaCierreEstimada: _parseDateTime(data['fechaCierreEstimada']),
      fechaCierreReal: _parseDateTime(data['fechaCierreReal']),
      motivoCierre: data['motivoCierre'] as String?,
      costoAveInicial: data['costoAveInicial'] != null
          ? (data['costoAveInicial'] as num).toDouble()
          : null,
      observaciones: data['observaciones'] as String?,
      fechaCreacion: _parseDateTime(data['fechaCreacion']),
      ultimaActualizacion: _parseDateTime(data['ultimaActualizacion']),
      metadatos: (data['metadatos'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Convierte desde la entidad de dominio.
  factory LoteModel.fromEntity(Lote lote) {
    return LoteModel(
      id: lote.id,
      granjaId: lote.granjaId,
      galponId: lote.galponId,
      codigo: lote.codigo,
      tipoAve: lote.tipoAve,
      cantidadInicial: lote.cantidadInicial,
      fechaIngreso: lote.fechaIngreso,
      estado: lote.estado,
      nombre: lote.nombre,
      proveedor: lote.proveedor,
      raza: lote.raza,
      edadIngresoDias: lote.edadIngresoDias,
      cantidadActual: lote.cantidadActual,
      mortalidadAcumulada: lote.mortalidadAcumulada,
      descartesAcumulados: lote.descartesAcumulados,
      ventasAcumuladas: lote.ventasAcumuladas,
      pesoPromedioActual: lote.pesoPromedioActual,
      pesoPromedioObjetivo: lote.pesoPromedioObjetivo,
      consumoAcumuladoKg: lote.consumoAcumuladoKg,
      huevosProducidos: lote.huevosProducidos,
      fechaPrimerHuevo: lote.fechaPrimerHuevo,
      fechaCierreEstimada: lote.fechaCierreEstimada,
      fechaCierreReal: lote.fechaCierreReal,
      motivoCierre: lote.motivoCierre,
      costoAveInicial: lote.costoAveInicial,
      observaciones: lote.observaciones,
      fechaCreacion: lote.fechaCreacion,
      ultimaActualizacion: lote.ultimaActualizacion,
      metadatos: lote.metadatos,
    );
  }

  /// Convierte a Map para Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'granjaId': granjaId,
      'galponId': galponId,
      'codigo': codigo,
      'tipoAve': tipoAve.toJson(),
      'cantidadInicial': cantidadInicial,
      'fechaIngreso': Timestamp.fromDate(fechaIngreso),
      'estado': estado.toJson(),
      if (nombre != null) 'nombre': nombre,
      if (proveedor != null) 'proveedor': proveedor,
      if (raza != null) 'raza': raza,
      'edadIngresoDias': edadIngresoDias,
      if (cantidadActual != null) 'cantidadActual': cantidadActual,
      'mortalidadAcumulada': mortalidadAcumulada,
      'descartesAcumulados': descartesAcumulados,
      'ventasAcumuladas': ventasAcumuladas,
      if (pesoPromedioActual != null) 'pesoPromedioActual': pesoPromedioActual,
      if (pesoPromedioObjetivo != null)
        'pesoPromedioObjetivo': pesoPromedioObjetivo,
      if (consumoAcumuladoKg != null) 'consumoAcumuladoKg': consumoAcumuladoKg,
      if (huevosProducidos != null) 'huevosProducidos': huevosProducidos,
      if (fechaPrimerHuevo != null)
        'fechaPrimerHuevo': Timestamp.fromDate(fechaPrimerHuevo!),
      if (fechaCierreEstimada != null)
        'fechaCierreEstimada': Timestamp.fromDate(fechaCierreEstimada!),
      if (fechaCierreReal != null)
        'fechaCierreReal': Timestamp.fromDate(fechaCierreReal!),
      if (motivoCierre != null) 'motivoCierre': motivoCierre,
      if (costoAveInicial != null) 'costoAveInicial': costoAveInicial,
      if (observaciones != null) 'observaciones': observaciones,
      if (fechaCreacion != null)
        'fechaCreacion': Timestamp.fromDate(fechaCreacion!),
      'ultimaActualizacion': FieldValue.serverTimestamp(),
      if (metadatos.isNotEmpty) 'metadatos': metadatos,
    };
  }

  /// Convierte a Map para almacenamiento local (JSON serializable).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'granjaId': granjaId,
      'galponId': galponId,
      'codigo': codigo,
      'tipoAve': tipoAve.toJson(),
      'cantidadInicial': cantidadInicial,
      'fechaIngreso': fechaIngreso.toIso8601String(),
      'estado': estado.toJson(),
      if (nombre != null) 'nombre': nombre,
      if (proveedor != null) 'proveedor': proveedor,
      if (raza != null) 'raza': raza,
      'edadIngresoDias': edadIngresoDias,
      if (cantidadActual != null) 'cantidadActual': cantidadActual,
      'mortalidadAcumulada': mortalidadAcumulada,
      'descartesAcumulados': descartesAcumulados,
      'ventasAcumuladas': ventasAcumuladas,
      if (pesoPromedioActual != null) 'pesoPromedioActual': pesoPromedioActual,
      if (pesoPromedioObjetivo != null)
        'pesoPromedioObjetivo': pesoPromedioObjetivo,
      if (consumoAcumuladoKg != null) 'consumoAcumuladoKg': consumoAcumuladoKg,
      if (huevosProducidos != null) 'huevosProducidos': huevosProducidos,
      if (fechaPrimerHuevo != null)
        'fechaPrimerHuevo': fechaPrimerHuevo!.toIso8601String(),
      if (fechaCierreEstimada != null)
        'fechaCierreEstimada': fechaCierreEstimada!.toIso8601String(),
      if (fechaCierreReal != null)
        'fechaCierreReal': fechaCierreReal!.toIso8601String(),
      if (motivoCierre != null) 'motivoCierre': motivoCierre,
      if (costoAveInicial != null) 'costoAveInicial': costoAveInicial,
      if (observaciones != null) 'observaciones': observaciones,
      if (fechaCreacion != null)
        'fechaCreacion': fechaCreacion!.toIso8601String(),
      if (ultimaActualizacion != null)
        'ultimaActualizacion': ultimaActualizacion!.toIso8601String(),
      if (metadatos.isNotEmpty) 'metadatos': metadatos,
    };
  }

  /// Convierte a entidad del dominio.
  Lote toEntity() {
    return Lote(
      id: id,
      granjaId: granjaId,
      galponId: galponId,
      codigo: codigo,
      tipoAve: tipoAve,
      cantidadInicial: cantidadInicial,
      fechaIngreso: fechaIngreso,
      estado: estado,
      nombre: nombre,
      proveedor: proveedor,
      raza: raza,
      edadIngresoDias: edadIngresoDias,
      cantidadActual: cantidadActual,
      mortalidadAcumulada: mortalidadAcumulada,
      descartesAcumulados: descartesAcumulados,
      ventasAcumuladas: ventasAcumuladas,
      pesoPromedioActual: pesoPromedioActual,
      pesoPromedioObjetivo: pesoPromedioObjetivo,
      consumoAcumuladoKg: consumoAcumuladoKg,
      huevosProducidos: huevosProducidos,
      fechaPrimerHuevo: fechaPrimerHuevo,
      fechaCierreEstimada: fechaCierreEstimada,
      fechaCierreReal: fechaCierreReal,
      motivoCierre: motivoCierre,
      costoAveInicial: costoAveInicial,
      observaciones: observaciones,
      fechaCreacion: fechaCreacion,
      ultimaActualizacion: ultimaActualizacion,
      metadatos: metadatos,
    );
  }

  /// Copia con modificaciones.
  LoteModel copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    String? codigo,
    TipoAve? tipoAve,
    int? cantidadInicial,
    DateTime? fechaIngreso,
    EstadoLote? estado,
    String? nombre,
    String? proveedor,
    String? raza,
    int? edadIngresoDias,
    int? cantidadActual,
    int? mortalidadAcumulada,
    int? descartesAcumulados,
    int? ventasAcumuladas,
    double? pesoPromedioActual,
    double? pesoPromedioObjetivo,
    double? consumoAcumuladoKg,
    int? huevosProducidos,
    DateTime? fechaPrimerHuevo,
    DateTime? fechaCierreEstimada,
    DateTime? fechaCierreReal,
    String? motivoCierre,
    double? costoAveInicial,
    String? observaciones,
    DateTime? fechaCreacion,
    DateTime? ultimaActualizacion,
    Map<String, dynamic>? metadatos,
  }) {
    return LoteModel(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      codigo: codigo ?? this.codigo,
      tipoAve: tipoAve ?? this.tipoAve,
      cantidadInicial: cantidadInicial ?? this.cantidadInicial,
      fechaIngreso: fechaIngreso ?? this.fechaIngreso,
      estado: estado ?? this.estado,
      nombre: nombre ?? this.nombre,
      proveedor: proveedor ?? this.proveedor,
      raza: raza ?? this.raza,
      edadIngresoDias: edadIngresoDias ?? this.edadIngresoDias,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      mortalidadAcumulada: mortalidadAcumulada ?? this.mortalidadAcumulada,
      descartesAcumulados: descartesAcumulados ?? this.descartesAcumulados,
      ventasAcumuladas: ventasAcumuladas ?? this.ventasAcumuladas,
      pesoPromedioActual: pesoPromedioActual ?? this.pesoPromedioActual,
      pesoPromedioObjetivo: pesoPromedioObjetivo ?? this.pesoPromedioObjetivo,
      consumoAcumuladoKg: consumoAcumuladoKg ?? this.consumoAcumuladoKg,
      huevosProducidos: huevosProducidos ?? this.huevosProducidos,
      fechaPrimerHuevo: fechaPrimerHuevo ?? this.fechaPrimerHuevo,
      fechaCierreEstimada: fechaCierreEstimada ?? this.fechaCierreEstimada,
      fechaCierreReal: fechaCierreReal ?? this.fechaCierreReal,
      motivoCierre: motivoCierre ?? this.motivoCierre,
      costoAveInicial: costoAveInicial ?? this.costoAveInicial,
      observaciones: observaciones ?? this.observaciones,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      metadatos: metadatos ?? this.metadatos,
    );
  }

  /// Parsea DateTime desde varios formatos.
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
