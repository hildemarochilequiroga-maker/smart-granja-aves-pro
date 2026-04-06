import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/galpon.dart';
import '../../domain/enums/estado_galpon.dart';
import '../../domain/enums/tipo_galpon.dart';
import '../../../granjas/domain/value_objects/umbrales_ambientales.dart';

/// Modelo de infraestructura para la entidad Galpon.
///
/// Maneja la conversión entre Firestore y la entidad del dominio.
class GalponModel {
  const GalponModel({
    required this.id,
    required this.granjaId,
    required this.codigo,
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.capacidadMaxima,
    required this.fechaCreacion,
    this.areaM2,
    this.avesActuales = 0,
    this.umbrales,
    this.loteActualId,
    this.descripcion,
    this.ubicacion,
    this.numeroCorrales,
    this.sistemaBebederos,
    this.sistemaComederos,
    this.sistemaVentilacion,
    this.sistemaCalefaccion,
    this.sistemaIluminacion,
    this.tieneBalanza = false,
    this.sensorTemperatura = false,
    this.sensorHumedad = false,
    this.sensorCO2 = false,
    this.sensorAmoniaco = false,
    this.protocoloBioseguridad = false,
    this.controlPlagas = false,
    this.sistemaDesinfeccion = false,
    this.areasAccesoRestringido = const [],
    this.protocolosEntrada = const [],
    this.ultimaDesinfeccion,
    this.proximoMantenimiento,
    this.lotesHistoricos = const [],
    this.ultimaActualizacion,
    this.metadatos = const {},
  });

  final String id;
  final String granjaId;
  final String codigo;
  final String nombre;
  final TipoGalpon tipo;
  final EstadoGalpon estado;
  final int capacidadMaxima;
  final DateTime fechaCreacion;
  final double? areaM2;
  final int avesActuales;
  final UmbralesAmbientales? umbrales;
  final String? loteActualId;
  final String? descripcion;
  final String? ubicacion;
  final int? numeroCorrales;
  final String? sistemaBebederos;
  final String? sistemaComederos;
  final String? sistemaVentilacion;
  final String? sistemaCalefaccion;
  final String? sistemaIluminacion;
  final bool tieneBalanza;
  final bool sensorTemperatura;
  final bool sensorHumedad;
  final bool sensorCO2;
  final bool sensorAmoniaco;
  final bool protocoloBioseguridad;
  final bool controlPlagas;
  final bool sistemaDesinfeccion;
  final List<String> areasAccesoRestringido;
  final List<String> protocolosEntrada;
  final DateTime? ultimaDesinfeccion;
  final DateTime? proximoMantenimiento;
  final List<String> lotesHistoricos;
  final DateTime? ultimaActualizacion;
  final Map<String, dynamic> metadatos;

  /// Convierte desde Firestore DocumentSnapshot.
  factory GalponModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GalponModel.fromMap(data, doc.id);
  }

  /// Convierte desde Map (con ID opcional).
  factory GalponModel.fromMap(Map<String, dynamic> data, [String? documentId]) {
    return GalponModel(
      id: documentId ?? data['id'] as String? ?? '',
      granjaId: data['granjaId'] as String? ?? '',
      codigo: data['codigo'] as String? ?? '',
      nombre: data['nombre'] as String? ?? '',
      tipo:
          TipoGalpon.tryFromJson(data['tipo'] as String?) ?? TipoGalpon.engorde,
      estado:
          EstadoGalpon.tryFromJson(data['estado'] as String?) ??
          EstadoGalpon.activo,
      capacidadMaxima: data['capacidadMaxima'] as int? ?? 0,
      fechaCreacion: _parseDateTime(data['fechaCreacion']) ?? DateTime.now(),
      areaM2: data['areaM2'] != null
          ? (data['areaM2'] as num).toDouble()
          : null,
      avesActuales: data['avesActuales'] as int? ?? 0,
      umbrales: data['umbrales'] != null
          ? UmbralesAmbientales.fromJson(
              data['umbrales'] as Map<String, dynamic>,
            )
          : null,
      loteActualId: data['loteActualId'] as String?,
      descripcion: data['descripcion'] as String?,
      ubicacion: data['ubicacion'] as String?,
      numeroCorrales: data['numeroCorrales'] as int?,
      sistemaBebederos: data['sistemaBebederos'] as String?,
      sistemaComederos: data['sistemaComederos'] as String?,
      sistemaVentilacion: data['sistemaVentilacion'] as String?,
      sistemaCalefaccion: data['sistemaCalefaccion'] as String?,
      sistemaIluminacion: data['sistemaIluminacion'] as String?,
      tieneBalanza: data['tieneBalanza'] as bool? ?? false,
      sensorTemperatura: data['sensorTemperatura'] as bool? ?? false,
      sensorHumedad: data['sensorHumedad'] as bool? ?? false,
      sensorCO2: data['sensorCO2'] as bool? ?? false,
      sensorAmoniaco: data['sensorAmoniaco'] as bool? ?? false,
      protocoloBioseguridad: data['protocoloBioseguridad'] as bool? ?? false,
      controlPlagas: data['controlPlagas'] as bool? ?? false,
      sistemaDesinfeccion: data['sistemaDesinfeccion'] as bool? ?? false,
      areasAccesoRestringido:
          (data['areasAccesoRestringido'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      protocolosEntrada:
          (data['protocolosEntrada'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ultimaDesinfeccion: _parseDateTime(data['ultimaDesinfeccion']),
      proximoMantenimiento: _parseDateTime(data['proximoMantenimiento']),
      lotesHistoricos:
          (data['lotesHistoricos'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ultimaActualizacion: _parseDateTime(data['ultimaActualizacion']),
      metadatos: (data['metadatos'] as Map<String, dynamic>?) ?? const {},
    );
  }

  /// Convierte desde la entidad de dominio.
  factory GalponModel.fromEntity(Galpon galpon) {
    return GalponModel(
      id: galpon.id,
      granjaId: galpon.granjaId,
      codigo: galpon.codigo,
      nombre: galpon.nombre,
      tipo: galpon.tipo,
      estado: galpon.estado,
      capacidadMaxima: galpon.capacidadMaxima,
      fechaCreacion: galpon.fechaCreacion,
      areaM2: galpon.areaM2,
      avesActuales: galpon.avesActuales,
      umbrales: galpon.umbralesAmbientales,
      loteActualId: galpon.loteActualId,
      descripcion: galpon.descripcion,
      ubicacion: galpon.ubicacion,
      numeroCorrales: galpon.numeroCorrales,
      sistemaBebederos: galpon.sistemaBebederos,
      sistemaComederos: galpon.sistemaComederos,
      sistemaVentilacion: galpon.sistemaVentilacion,
      sistemaCalefaccion: galpon.sistemaCalefaccion,
      sistemaIluminacion: galpon.sistemaIluminacion,
      tieneBalanza: galpon.tieneBalanza,
      sensorTemperatura: galpon.sensorTemperatura,
      sensorHumedad: galpon.sensorHumedad,
      sensorCO2: galpon.sensorCO2,
      sensorAmoniaco: galpon.sensorAmoniaco,
      protocoloBioseguridad: galpon.protocoloBioseguridad,
      controlPlagas: galpon.controlPlagas,
      sistemaDesinfeccion: galpon.sistemaDesinfeccion,
      areasAccesoRestringido: galpon.areasAccesoRestringido,
      protocolosEntrada: galpon.protocolosEntrada,
      ultimaDesinfeccion: galpon.ultimaDesinfeccion,
      proximoMantenimiento: galpon.proximoMantenimiento,
      lotesHistoricos: galpon.lotesHistoricos,
      ultimaActualizacion: galpon.ultimaActualizacion,
      metadatos: galpon.metadatos,
    );
  }

  /// Convierte a Map para Firestore.
  ///
  /// Siempre incluye campos nullable para que `.update()` pueda limpiarlos.
  Map<String, dynamic> toFirestore() {
    return {
      'granjaId': granjaId,
      'codigo': codigo,
      'nombre': nombre,
      'tipo': tipo.toJson(),
      'estado': estado.toJson(),
      'capacidadMaxima': capacidadMaxima,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'areaM2': areaM2,
      'avesActuales': avesActuales,
      'umbrales': umbrales?.toJson(),
      'loteActualId': loteActualId,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'numeroCorrales': numeroCorrales,
      'sistemaBebederos': sistemaBebederos,
      'sistemaComederos': sistemaComederos,
      'sistemaVentilacion': sistemaVentilacion,
      'sistemaCalefaccion': sistemaCalefaccion,
      'sistemaIluminacion': sistemaIluminacion,
      'tieneBalanza': tieneBalanza,
      'sensorTemperatura': sensorTemperatura,
      'sensorHumedad': sensorHumedad,
      'sensorCO2': sensorCO2,
      'sensorAmoniaco': sensorAmoniaco,
      'protocoloBioseguridad': protocoloBioseguridad,
      'controlPlagas': controlPlagas,
      'sistemaDesinfeccion': sistemaDesinfeccion,
      'areasAccesoRestringido': areasAccesoRestringido,
      'protocolosEntrada': protocolosEntrada,
      'ultimaDesinfeccion': ultimaDesinfeccion != null
          ? Timestamp.fromDate(ultimaDesinfeccion!)
          : null,
      'proximoMantenimiento': proximoMantenimiento != null
          ? Timestamp.fromDate(proximoMantenimiento!)
          : null,
      'lotesHistoricos': lotesHistoricos,
      'ultimaActualizacion': FieldValue.serverTimestamp(),
      'metadatos': metadatos,
    };
  }

  /// Convierte a Map para almacenamiento local (JSON serializable).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'granjaId': granjaId,
      'codigo': codigo,
      'nombre': nombre,
      'tipo': tipo.toJson(),
      'estado': estado.toJson(),
      'capacidadMaxima': capacidadMaxima,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'areaM2': areaM2,
      'avesActuales': avesActuales,
      if (umbrales != null) 'umbrales': umbrales!.toJson(),
      'loteActualId': loteActualId,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'numeroCorrales': numeroCorrales,
      'sistemaBebederos': sistemaBebederos,
      'sistemaComederos': sistemaComederos,
      'sistemaVentilacion': sistemaVentilacion,
      'sistemaCalefaccion': sistemaCalefaccion,
      'sistemaIluminacion': sistemaIluminacion,
      'tieneBalanza': tieneBalanza,
      'sensorTemperatura': sensorTemperatura,
      'sensorHumedad': sensorHumedad,
      'sensorCO2': sensorCO2,
      'sensorAmoniaco': sensorAmoniaco,
      'protocoloBioseguridad': protocoloBioseguridad,
      'controlPlagas': controlPlagas,
      'sistemaDesinfeccion': sistemaDesinfeccion,
      'areasAccesoRestringido': areasAccesoRestringido,
      'protocolosEntrada': protocolosEntrada,
      if (ultimaDesinfeccion != null)
        'ultimaDesinfeccion': ultimaDesinfeccion!.toIso8601String(),
      if (proximoMantenimiento != null)
        'proximoMantenimiento': proximoMantenimiento!.toIso8601String(),
      'lotesHistoricos': lotesHistoricos,
      if (ultimaActualizacion != null)
        'ultimaActualizacion': ultimaActualizacion!.toIso8601String(),
      'metadatos': metadatos,
    };
  }

  /// Convierte a entidad del dominio.
  Galpon toEntity() {
    return Galpon(
      id: id,
      granjaId: granjaId,
      codigo: codigo,
      nombre: nombre,
      tipo: tipo,
      estado: estado,
      capacidadMaxima: capacidadMaxima,
      fechaCreacion: fechaCreacion,
      areaM2: areaM2,
      avesActuales: avesActuales,
      umbralesAmbientales: umbrales,
      loteActualId: loteActualId,
      descripcion: descripcion,
      ubicacion: ubicacion,
      numeroCorrales: numeroCorrales,
      sistemaBebederos: sistemaBebederos,
      sistemaComederos: sistemaComederos,
      sistemaVentilacion: sistemaVentilacion,
      sistemaCalefaccion: sistemaCalefaccion,
      sistemaIluminacion: sistemaIluminacion,
      tieneBalanza: tieneBalanza,
      sensorTemperatura: sensorTemperatura,
      sensorHumedad: sensorHumedad,
      sensorCO2: sensorCO2,
      sensorAmoniaco: sensorAmoniaco,
      protocoloBioseguridad: protocoloBioseguridad,
      controlPlagas: controlPlagas,
      sistemaDesinfeccion: sistemaDesinfeccion,
      areasAccesoRestringido: areasAccesoRestringido,
      protocolosEntrada: protocolosEntrada,
      ultimaDesinfeccion: ultimaDesinfeccion,
      proximoMantenimiento: proximoMantenimiento,
      lotesHistoricos: lotesHistoricos,
      ultimaActualizacion: ultimaActualizacion,
      metadatos: metadatos,
    );
  }

  /// Copia con modificaciones.
  GalponModel copyWith({
    String? id,
    String? granjaId,
    String? codigo,
    String? nombre,
    TipoGalpon? tipo,
    EstadoGalpon? estado,
    int? capacidadMaxima,
    DateTime? fechaCreacion,
    double? areaM2,
    int? avesActuales,
    UmbralesAmbientales? umbrales,
    String? loteActualId,
    String? descripcion,
    String? ubicacion,
    int? numeroCorrales,
    String? sistemaBebederos,
    String? sistemaComederos,
    String? sistemaVentilacion,
    String? sistemaCalefaccion,
    String? sistemaIluminacion,
    bool? tieneBalanza,
    bool? sensorTemperatura,
    bool? sensorHumedad,
    bool? sensorCO2,
    bool? sensorAmoniaco,
    bool? protocoloBioseguridad,
    bool? controlPlagas,
    bool? sistemaDesinfeccion,
    List<String>? areasAccesoRestringido,
    List<String>? protocolosEntrada,
    DateTime? ultimaDesinfeccion,
    DateTime? proximoMantenimiento,
    List<String>? lotesHistoricos,
    DateTime? ultimaActualizacion,
    Map<String, dynamic>? metadatos,
  }) {
    return GalponModel(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      estado: estado ?? this.estado,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      areaM2: areaM2 ?? this.areaM2,
      avesActuales: avesActuales ?? this.avesActuales,
      umbrales: umbrales ?? this.umbrales,
      loteActualId: loteActualId ?? this.loteActualId,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      numeroCorrales: numeroCorrales ?? this.numeroCorrales,
      sistemaBebederos: sistemaBebederos ?? this.sistemaBebederos,
      sistemaComederos: sistemaComederos ?? this.sistemaComederos,
      sistemaVentilacion: sistemaVentilacion ?? this.sistemaVentilacion,
      sistemaCalefaccion: sistemaCalefaccion ?? this.sistemaCalefaccion,
      sistemaIluminacion: sistemaIluminacion ?? this.sistemaIluminacion,
      tieneBalanza: tieneBalanza ?? this.tieneBalanza,
      sensorTemperatura: sensorTemperatura ?? this.sensorTemperatura,
      sensorHumedad: sensorHumedad ?? this.sensorHumedad,
      sensorCO2: sensorCO2 ?? this.sensorCO2,
      sensorAmoniaco: sensorAmoniaco ?? this.sensorAmoniaco,
      protocoloBioseguridad:
          protocoloBioseguridad ?? this.protocoloBioseguridad,
      controlPlagas: controlPlagas ?? this.controlPlagas,
      sistemaDesinfeccion: sistemaDesinfeccion ?? this.sistemaDesinfeccion,
      areasAccesoRestringido:
          areasAccesoRestringido ?? this.areasAccesoRestringido,
      protocolosEntrada: protocolosEntrada ?? this.protocolosEntrada,
      ultimaDesinfeccion: ultimaDesinfeccion ?? this.ultimaDesinfeccion,
      proximoMantenimiento: proximoMantenimiento ?? this.proximoMantenimiento,
      lotesHistoricos: lotesHistoricos ?? this.lotesHistoricos,
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
