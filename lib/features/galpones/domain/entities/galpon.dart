/// Entidad que representa un galpón avícola (instalación física para aves).
///
/// Pertenece a una granja y puede contener uno o más lotes.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';
import '../../../granjas/domain/value_objects/value_objects.dart';

/// Sentinel para distinguir "no proporcionado" de "null explícito" en copyWith.
const _sentinel = Object();

/// Entidad que representa un galpón avícola.
class Galpon extends Equatable {
  const Galpon({
    required this.id,
    required this.granjaId,
    required this.codigo,
    required this.nombre,
    required this.tipo,
    required this.capacidadMaxima,
    required this.fechaCreacion,
    required this.estado,
    this.areaM2,
    this.avesActuales = 0,
    this.umbralesAmbientales,
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

  /// Identificador único del galpón.
  final String id;

  /// ID de la granja a la que pertenece.
  final String granjaId;

  /// Código identificador del galpón (ej: GAL-001).
  final String codigo;

  /// Nombre descriptivo del galpón.
  final String nombre;

  /// Tipo de galpón según su diseño y uso.
  final TipoGalpon tipo;

  /// Capacidad máxima de aves que puede albergar.
  final int capacidadMaxima;

  /// Fecha de construcción/registro del galpón.
  final DateTime fechaCreacion;

  /// Estado operativo actual del galpón.
  final EstadoGalpon estado;

  /// Área construida en metros cuadrados.
  final double? areaM2;

  /// Cantidad actual de aves en el galpón.
  final int avesActuales;

  /// Umbrales ambientales específicos de este galpón.
  final UmbralesAmbientales? umbralesAmbientales;

  /// Alias para umbralesAmbientales (compatibilidad con modelo).
  UmbralesAmbientales? get umbrales => umbralesAmbientales;

  /// ID del lote actualmente alojado (si hay uno).
  final String? loteActualId;

  /// Descripción o notas adicionales.
  final String? descripcion;

  /// Ubicación dentro de la granja.
  final String? ubicacion;

  /// Número de corrales/divisiones.
  final int? numeroCorrales;

  /// Sistema de bebederos.
  final String? sistemaBebederos;

  /// Sistema de comederos.
  final String? sistemaComederos;

  /// Sistema de ventilación.
  final String? sistemaVentilacion;

  /// Sistema de calefacción.
  final String? sistemaCalefaccion;

  /// Sistema de iluminación.
  final String? sistemaIluminacion;

  /// Si tiene balanza automática.
  final bool tieneBalanza;

  /// Si tiene sensor de temperatura.
  final bool sensorTemperatura;

  /// Si tiene sensor de humedad.
  final bool sensorHumedad;

  /// Si tiene sensor de CO2.
  final bool sensorCO2;

  /// Si tiene sensor de amoníaco.
  final bool sensorAmoniaco;

  /// Si tiene protocolo de bioseguridad activo.
  final bool protocoloBioseguridad;

  /// Si tiene control de plagas activo.
  final bool controlPlagas;

  /// Si tiene sistema de desinfección.
  final bool sistemaDesinfeccion;

  /// Áreas de acceso restringido.
  final List<String> areasAccesoRestringido;

  /// Protocolos de entrada.
  final List<String> protocolosEntrada;

  /// Fecha de la última desinfección realizada.
  final DateTime? ultimaDesinfeccion;

  /// Fecha programada para el próximo mantenimiento.
  final DateTime? proximoMantenimiento;

  /// IDs de lotes históricos que estuvieron en este galpón.
  final List<String> lotesHistoricos;

  /// Fecha de última actualización de datos.
  final DateTime? ultimaActualizacion;

  /// Metadatos adicionales.
  final Map<String, dynamic> metadatos;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    codigo,
    nombre,
    tipo,
    capacidadMaxima,
    fechaCreacion,
    estado,
    areaM2,
    avesActuales,
    umbralesAmbientales,
    loteActualId,
    descripcion,
    ubicacion,
    numeroCorrales,
    sistemaBebederos,
    sistemaComederos,
    sistemaVentilacion,
    sistemaCalefaccion,
    sistemaIluminacion,
    tieneBalanza,
    sensorTemperatura,
    sensorHumedad,
    sensorCO2,
    sensorAmoniaco,
    protocoloBioseguridad,
    controlPlagas,
    sistemaDesinfeccion,
    areasAccesoRestringido,
    protocolosEntrada,
    ultimaDesinfeccion,
    proximoMantenimiento,
    lotesHistoricos,
    ultimaActualizacion,
    metadatos,
  ];

  /// Crea una copia con campos modificados.
  ///
  /// Usa sentinel para campos nullable: pasar `null` explícitamente
  /// establece el campo en null (ej: `copyWith(loteActualId: null)`).
  Galpon copyWith({
    String? id,
    String? granjaId,
    String? codigo,
    String? nombre,
    TipoGalpon? tipo,
    int? capacidadMaxima,
    DateTime? fechaCreacion,
    EstadoGalpon? estado,
    Object? areaM2 = _sentinel,
    int? avesActuales,
    Object? umbralesAmbientales = _sentinel,
    Object? loteActualId = _sentinel,
    Object? descripcion = _sentinel,
    Object? ubicacion = _sentinel,
    Object? numeroCorrales = _sentinel,
    Object? sistemaBebederos = _sentinel,
    Object? sistemaComederos = _sentinel,
    Object? sistemaVentilacion = _sentinel,
    Object? sistemaCalefaccion = _sentinel,
    Object? sistemaIluminacion = _sentinel,
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
    Object? ultimaDesinfeccion = _sentinel,
    Object? proximoMantenimiento = _sentinel,
    List<String>? lotesHistoricos,
    Object? ultimaActualizacion = _sentinel,
    Map<String, dynamic>? metadatos,
  }) {
    return Galpon(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
      areaM2: identical(areaM2, _sentinel) ? this.areaM2 : areaM2 as double?,
      avesActuales: avesActuales ?? this.avesActuales,
      umbralesAmbientales: identical(umbralesAmbientales, _sentinel)
          ? this.umbralesAmbientales
          : umbralesAmbientales as UmbralesAmbientales?,
      loteActualId: identical(loteActualId, _sentinel)
          ? this.loteActualId
          : loteActualId as String?,
      descripcion: identical(descripcion, _sentinel)
          ? this.descripcion
          : descripcion as String?,
      ubicacion: identical(ubicacion, _sentinel)
          ? this.ubicacion
          : ubicacion as String?,
      numeroCorrales: identical(numeroCorrales, _sentinel)
          ? this.numeroCorrales
          : numeroCorrales as int?,
      sistemaBebederos: identical(sistemaBebederos, _sentinel)
          ? this.sistemaBebederos
          : sistemaBebederos as String?,
      sistemaComederos: identical(sistemaComederos, _sentinel)
          ? this.sistemaComederos
          : sistemaComederos as String?,
      sistemaVentilacion: identical(sistemaVentilacion, _sentinel)
          ? this.sistemaVentilacion
          : sistemaVentilacion as String?,
      sistemaCalefaccion: identical(sistemaCalefaccion, _sentinel)
          ? this.sistemaCalefaccion
          : sistemaCalefaccion as String?,
      sistemaIluminacion: identical(sistemaIluminacion, _sentinel)
          ? this.sistemaIluminacion
          : sistemaIluminacion as String?,
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
      ultimaDesinfeccion: identical(ultimaDesinfeccion, _sentinel)
          ? this.ultimaDesinfeccion
          : ultimaDesinfeccion as DateTime?,
      proximoMantenimiento: identical(proximoMantenimiento, _sentinel)
          ? this.proximoMantenimiento
          : proximoMantenimiento as DateTime?,
      lotesHistoricos: lotesHistoricos ?? this.lotesHistoricos,
      ultimaActualizacion: identical(ultimaActualizacion, _sentinel)
          ? this.ultimaActualizacion
          : ultimaActualizacion as DateTime?,
      metadatos: metadatos ?? this.metadatos,
    );
  }

  /// Factory para crear un galpón nuevo con valores por defecto.
  factory Galpon.nuevo({
    required String granjaId,
    required String codigo,
    required String nombre,
    required TipoGalpon tipo,
    required int capacidadMaxima,
    double? areaM2,
    String? descripcion,
    String? ubicacion,
    int? numeroCorrales,
    String? sistemaBebederos,
    String? sistemaComederos,
    String? sistemaVentilacion,
    String? sistemaCalefaccion,
    String? sistemaIluminacion,
    bool tieneBalanza = false,
    bool sensorTemperatura = false,
    bool sensorHumedad = false,
    bool sensorCO2 = false,
    bool sensorAmoniaco = false,
    bool protocoloBioseguridad = false,
    bool controlPlagas = false,
    bool sistemaDesinfeccion = false,
    List<String> areasAccesoRestringido = const [],
    List<String> protocolosEntrada = const [],
    UmbralesAmbientales? umbralesAmbientales,
    Map<String, dynamic> metadatos = const {},
  }) {
    return Galpon(
      id: '',
      granjaId: granjaId,
      codigo: codigo,
      nombre: nombre,
      tipo: tipo,
      capacidadMaxima: capacidadMaxima,
      fechaCreacion: DateTime.now(),
      estado: EstadoGalpon.activo,
      areaM2: areaM2,
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
      umbralesAmbientales: umbralesAmbientales,
      metadatos: metadatos,
      ultimaActualizacion: DateTime.now(),
    );
  }

  // ==================== MÉTODOS DE NEGOCIO ====================

  /// Verifica si el galpón está activo.
  bool get estaActivo => estado == EstadoGalpon.activo;

  /// Verifica si el galpón está disponible para recibir un nuevo lote.
  bool get estaDisponible =>
      estado.disponibleParaNuevosLotes && loteActualId == null;

  /// Verifica si el galpón tiene un lote actualmente.
  bool get tieneLoteActual => loteActualId != null;

  /// Verifica si el galpón está ocupado.
  bool get estaOcupado => tieneLoteActual;

  /// Verifica si el galpón está vacío.
  bool get estaVacio => !tieneLoteActual;

  /// Verifica si el galpón está en mantenimiento.
  bool get estaEnMantenimiento => estado == EstadoGalpon.mantenimiento;

  /// Verifica si el galpón está en desinfección.
  bool get estaEnDesinfeccion => estado == EstadoGalpon.desinfeccion;

  /// Verifica si el galpón está en cuarentena.
  bool get estaEnCuarentena => estado == EstadoGalpon.cuarentena;

  /// Verifica si el galpón está inactivo.
  bool get estaInactivo => estado == EstadoGalpon.inactivo;

  /// Verifica si requiere atención inmediata.
  bool get requiereAtencion => estado.requiereAtencion;

  /// Porcentaje de ocupación actual.
  double get porcentajeOcupacion {
    if (capacidadMaxima <= 0) return 0;
    return (avesActuales / capacidadMaxima) * 100;
  }

  /// Calcula la densidad (aves/m²) si hay área configurada.
  double? get densidadMaximaAvesM2 {
    if (areaM2 == null || areaM2! <= 0) return null;
    return capacidadMaxima / areaM2!;
  }

  /// Densidad actual de aves por metro cuadrado.
  double? get densidadActualAvesM2 {
    if (areaM2 == null || areaM2! <= 0) return null;
    return avesActuales / areaM2!;
  }

  /// Verifica si la densidad está dentro de límites recomendados.
  bool? get densidadDentroLimites {
    final densidad = densidadMaximaAvesM2;
    if (densidad == null) return null;
    final densidadMaxima = tipo.densidadMaximaAvesPorM2;
    return densidad <= densidadMaxima * 1.1;
  }

  /// Días desde la última desinfección.
  int? get diasDesdeUltimaDesinfeccion {
    if (ultimaDesinfeccion == null) return null;
    return DateTime.now().difference(ultimaDesinfeccion!).inDays;
  }

  /// Días hasta el próximo mantenimiento programado.
  int? get diasHastaProximoMantenimiento {
    if (proximoMantenimiento == null) return null;
    return proximoMantenimiento!.difference(DateTime.now()).inDays;
  }

  /// Verifica si el mantenimiento está vencido.
  bool get mantenimientoVencido {
    final dias = diasHastaProximoMantenimiento;
    if (dias == null) return false;
    return dias < 0;
  }

  /// Verifica si el mantenimiento está próximo (menos de 7 días).
  bool get mantenimientoProximo {
    final dias = diasHastaProximoMantenimiento;
    if (dias == null) return false;
    return dias >= 0 && dias <= 7;
  }

  /// Edad del galpón en años.
  double get edadEnAnios {
    final dias = DateTime.now().difference(fechaCreacion).inDays;
    return dias / 365.0;
  }

  // ==================== TRANSICIONES DE ESTADO ====================

  /// Cambia el estado del galpón validando transiciones permitidas.
  Galpon cambiarEstado(
    EstadoGalpon nuevoEstado, {
    String? motivo,
    bool forzar = false,
  }) {
    if (!forzar && !estado.puedeTransicionarA(nuevoEstado)) {
      throw GalponException(
        ErrorMessages.format('GALPON_CAMBIO_ESTADO_INVALIDO', {
          'estadoActual': estado.displayName,
          'estadoNuevo': nuevoEstado.displayName,
        }),
      );
    }

    if (nuevoEstado.debeEstarVacio && tieneLoteActual) {
      throw GalponException(
        ErrorMessages.format('GALPON_CAMBIO_CON_LOTE_ACTIVO', {
          'estadoNuevo': nuevoEstado.displayName,
        }),
      );
    }

    return copyWith(
      estado: nuevoEstado,
      descripcion: motivo != null
          ? '${descripcion ?? ''}\n$motivo'.trimLeft()
          : descripcion,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Activa el galpón.
  Galpon activar() {
    return cambiarEstado(EstadoGalpon.activo);
  }

  /// Pone el galpón en mantenimiento.
  Galpon ponerEnMantenimiento({String? motivo}) {
    return cambiarEstado(EstadoGalpon.mantenimiento, motivo: motivo);
  }

  /// Inicia desinfección del galpón.
  Galpon iniciarDesinfeccion() {
    if (tieneLoteActual) {
      throw GalponException(ErrorMessages.get('GALPON_DESINFECTAR_CON_LOTE'));
    }

    return cambiarEstado(
      EstadoGalpon.desinfeccion,
    ).copyWith(ultimaDesinfeccion: DateTime.now());
  }

  /// Pone el galpón en cuarentena.
  Galpon ponerEnCuarentena({required String motivo}) {
    return cambiarEstado(EstadoGalpon.cuarentena, motivo: motivo);
  }

  /// Inactiva el galpón.
  Galpon inactivar({String? motivo}) {
    return cambiarEstado(EstadoGalpon.inactivo, motivo: motivo);
  }

  /// Asigna un lote al galpón.
  Galpon asignarLote(String loteId) {
    if (!estaDisponible) {
      throw GalponException(ErrorMessages.get('GALPON_NO_DISPONIBLE'));
    }

    return copyWith(loteActualId: loteId, ultimaActualizacion: DateTime.now());
  }

  /// Libera el lote del galpón.
  ///
  /// Resetea las aves actuales a 0 y agrega el lote al historial.
  Galpon liberarLote() {
    final loteAnterior = loteActualId;
    return copyWith(
      loteActualId: null,
      avesActuales: 0,
      lotesHistoricos: loteAnterior != null
          ? [...lotesHistoricos, loteAnterior]
          : lotesHistoricos,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Programa el próximo mantenimiento.
  Galpon programarMantenimiento(DateTime fecha) {
    return copyWith(
      proximoMantenimiento: fecha,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza los umbrales ambientales del galpón.
  Galpon actualizarUmbrales(UmbralesAmbientales nuevosUmbrales) {
    return copyWith(
      umbralesAmbientales: nuevosUmbrales,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza la capacidad máxima.
  Galpon actualizarCapacidad(int nuevaCapacidad) {
    if (nuevaCapacidad <= 0) {
      throw GalponException(ErrorMessages.get('GALPON_CAPACIDAD_POSITIVE'));
    }

    return copyWith(
      capacidadMaxima: nuevaCapacidad,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza la cantidad actual de aves.
  Galpon actualizarAvesActuales(int cantidad) {
    if (cantidad < 0) {
      throw GalponException(ErrorMessages.get('GALPON_AVES_NEGATIVE'));
    }
    if (cantidad > capacidadMaxima) {
      throw GalponException(ErrorMessages.get('GALPON_AVES_EXCEDE_CAPACIDAD'));
    }
    return copyWith(
      avesActuales: cantidad,
      ultimaActualizacion: DateTime.now(),
    );
  }

  // ==================== VALIDACIONES ====================

  /// Valida el galpón completo.
  String? validar() {
    if (granjaId.isEmpty) {
      return ErrorMessages.get('GALPON_GRANJA_ID_REQUIRED');
    }
    if (codigo.trim().isEmpty) {
      return ErrorMessages.get('GALPON_CODIGO_REQUIRED');
    }
    if (nombre.trim().isEmpty) {
      return ErrorMessages.get('GALPON_NOMBRE_REQUIRED');
    }
    if (capacidadMaxima <= 0) {
      return ErrorMessages.get('GALPON_CAPACIDAD_POSITIVE');
    }
    if (areaM2 != null && areaM2! <= 0) {
      return ErrorMessages.get('GALPON_AREA_POSITIVE');
    }
    if (avesActuales < 0) {
      return ErrorMessages.get('GALPON_AVES_NEGATIVE');
    }
    if (avesActuales > capacidadMaxima) {
      return ErrorMessages.get('GALPON_AVES_EXCEDE_CAPACIDAD');
    }

    final densidadOk = densidadDentroLimites;
    if (densidadOk == false) {
      return ErrorMessages.format('GALPON_DENSIDAD_EXCEDE', {
        'tipo': tipo.displayName,
      });
    }

    if (umbralesAmbientales != null) {
      final errorUmbrales = umbralesAmbientales!.validar();
      if (errorUmbrales != null) {
        return ErrorMessages.format('PREFIX_UMBRALES', {
          'detail': errorUmbrales,
        });
      }
    }

    if (estado.debeEstarVacio && tieneLoteActual) {
      return ErrorMessages.format('GALPON_ESTADO_REQUIERE_VACIO', {
        'estado': estado.displayName,
      });
    }

    return null;
  }

  /// Verifica si el galpón es válido.
  bool get esValido => validar() == null;

  @override
  String toString() {
    return 'Galpon(id: $id, codigo: $codigo, nombre: $nombre, '
        'tipo: ${tipo.displayName}, estado: ${estado.displayName})';
  }
}

/// Excepción personalizada para errores de negocio en Galpon.
class GalponException implements Exception {
  GalponException(this.mensaje);

  final String mensaje;

  @override
  String toString() => 'GalponException: $mensaje';
}
