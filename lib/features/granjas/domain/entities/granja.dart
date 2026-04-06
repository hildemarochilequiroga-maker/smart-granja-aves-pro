library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';
import '../value_objects/value_objects.dart';

/// Entidad que representa una granja avícola completa
///
/// Aggregate root para sus galpones avícolas.
/// Raíz de la jerarquía multi-tenant.
class Granja extends Equatable {
  const Granja({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.propietarioId,
    required this.propietarioNombre,
    required this.fechaCreacion,
    required this.estado,
    this.coordenadas,
    this.umbralesAmbientales,
    this.telefono,
    this.correo,
    this.ruc,
    this.capacidadTotalAves,
    this.areaTotalM2,
    this.numeroTotalGalpones,
    this.notas,
    this.ultimaActualizacion,
    this.imagenUrl,
  });

  /// Identificador único de la granja (Firestore document ID)
  final String id;

  /// Nombre comercial de la granja
  final String nombre;

  /// Dirección física completa de la granja
  final Direccion direccion;

  /// ID del propietario (usuario)
  final String propietarioId;

  /// Nombre del propietario o razón social
  final String propietarioNombre;

  /// Fecha de creación/registro de la granja en el sistema
  final DateTime fechaCreacion;

  /// Estado operativo actual de la granja
  final EstadoGranja estado;

  /// Coordenadas geográficas de la granja (opcional)
  final Coordenadas? coordenadas;

  /// Umbrales ambientales predeterminados para la granja
  final UmbralesAmbientales? umbralesAmbientales;

  /// Teléfono de contacto de la granja
  final String? telefono;

  /// Correo electrónico de contacto
  final String? correo;

  /// RUC de la empresa (Perú - 11 dígitos)
  final String? ruc;

  /// Capacidad total instalada de aves en toda la granja
  final int? capacidadTotalAves;

  /// Área total construida en metros cuadrados
  final double? areaTotalM2;

  /// Número total de galpones avícolas en la granja
  final int? numeroTotalGalpones;

  /// Notas o comentarios adicionales sobre la granja
  final String? notas;

  /// Fecha de última actualización de datos
  final DateTime? ultimaActualizacion;

  /// URL de imagen de la granja
  final String? imagenUrl;

  @override
  List<Object?> get props => [
    id,
    nombre,
    direccion,
    propietarioId,
    propietarioNombre,
    fechaCreacion,
    estado,
    coordenadas,
    umbralesAmbientales,
    telefono,
    correo,
    ruc,
    capacidadTotalAves,
    areaTotalM2,
    numeroTotalGalpones,
    notas,
    ultimaActualizacion,
    imagenUrl,
  ];

  /// Crea una copia con campos modificados
  Granja copyWith({
    String? id,
    String? nombre,
    Direccion? direccion,
    String? propietarioId,
    String? propietarioNombre,
    DateTime? fechaCreacion,
    EstadoGranja? estado,
    Coordenadas? coordenadas,
    UmbralesAmbientales? umbralesAmbientales,
    String? telefono,
    String? correo,
    String? ruc,
    int? capacidadTotalAves,
    double? areaTotalM2,
    int? numeroTotalGalpones,
    String? notas,
    DateTime? ultimaActualizacion,
    String? imagenUrl,
  }) {
    return Granja(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      propietarioId: propietarioId ?? this.propietarioId,
      propietarioNombre: propietarioNombre ?? this.propietarioNombre,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      estado: estado ?? this.estado,
      coordenadas: coordenadas ?? this.coordenadas,
      umbralesAmbientales: umbralesAmbientales ?? this.umbralesAmbientales,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      ruc: ruc ?? this.ruc,
      capacidadTotalAves: capacidadTotalAves ?? this.capacidadTotalAves,
      areaTotalM2: areaTotalM2 ?? this.areaTotalM2,
      numeroTotalGalpones: numeroTotalGalpones ?? this.numeroTotalGalpones,
      notas: notas ?? this.notas,
      ultimaActualizacion: ultimaActualizacion ?? this.ultimaActualizacion,
      imagenUrl: imagenUrl ?? this.imagenUrl,
    );
  }

  /// Factory para crear una granja nueva con valores por defecto
  factory Granja.nueva({
    required String id,
    required String nombre,
    required Direccion direccion,
    required String propietarioId,
    required String propietarioNombre,
    Coordenadas? coordenadas,
    String? telefono,
    String? correo,
    String? ruc,
  }) {
    return Granja(
      id: id,
      nombre: nombre,
      direccion: direccion,
      propietarioId: propietarioId,
      propietarioNombre: propietarioNombre,
      fechaCreacion: DateTime.now(),
      estado: EstadoGranja.activo,
      coordenadas: coordenadas,
      umbralesAmbientales: UmbralesAmbientales.engordeAdulto(),
      telefono: telefono,
      correo: correo,
      ruc: ruc,
      ultimaActualizacion: DateTime.now(),
    );
  }

  // ==================== MÉTODOS DE NEGOCIO ====================

  /// Verifica si la granja está activa y operativa
  bool get estaActiva => estado == EstadoGranja.activo;

  /// Verifica si la granja está suspendida
  bool get estaSuspendida => estado == EstadoGranja.inactivo;

  /// Verifica si la granja está en mantenimiento
  bool get estaEnMantenimiento => estado == EstadoGranja.mantenimiento;

  /// Verifica si la granja puede operar
  bool get puedeOperar => estado.permiteModificaciones;

  /// Verifica si se pueden crear nuevos lotes en la granja
  bool get puedeCrearLotes => estado.permiteNuevosLotes;

  /// Verifica si el RUC es válido (11 dígitos numéricos)
  bool get tieneRucValido {
    if (ruc == null) return false;
    return ruc!.length == 11 && int.tryParse(ruc!) != null;
  }

  /// Verifica si el correo es válido
  bool get tieneCorreoValido {
    if (correo == null) return false;
    final regexCorreo = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return regexCorreo.hasMatch(correo!);
  }

  /// Verifica si tiene coordenadas GPS configuradas
  bool get tieneGeolocalizacion => coordenadas != null;

  /// Verifica si tiene umbrales ambientales configurados
  bool get tieneUmbralesConfigurados => umbralesAmbientales != null;

  /// Calcula la densidad promedio (aves/m²)
  double? get densidadPromedioAvesM2 {
    if (capacidadTotalAves == null || areaTotalM2 == null) return null;
    if (areaTotalM2! <= 0) return null;
    return capacidadTotalAves! / areaTotalM2!;
  }

  /// Calcula la capacidad promedio por galpón
  double? get capacidadPromedioPorGalpon {
    if (capacidadTotalAves == null || numeroTotalGalpones == null) return null;
    if (numeroTotalGalpones! <= 0) return null;
    return capacidadTotalAves! / numeroTotalGalpones!;
  }

  /// Calcula los días desde la creación de la granja
  int get diasDesdeCreacion {
    return DateTime.now().difference(fechaCreacion).inDays;
  }

  /// Calcula los días desde la última actualización
  int? get diasDesdeUltimaActualizacion {
    if (ultimaActualizacion == null) return null;
    return DateTime.now().difference(ultimaActualizacion!).inDays;
  }

  /// Verifica si los datos de la granja están desactualizados (más de 30 días)
  bool get datosDesactualizados {
    final dias = diasDesdeUltimaActualizacion;
    if (dias == null) return true;
    return dias > 30;
  }

  // ==================== TRANSICIONES DE ESTADO ====================

  /// Activa la granja
  Granja activar() {
    if (estado == EstadoGranja.activo) {
      throw GranjaException(ErrorMessages.get('GRANJA_YA_ACTIVA'));
    }

    final now = DateTime.now();
    final fecha = _formatearFecha(now);
    final nuevaNota = 'Granja activada el $fecha';
    final notasActualizadas = _agregarNota(nuevaNota);

    return copyWith(
      estado: EstadoGranja.activo,
      notas: notasActualizadas,
      ultimaActualizacion: now,
    );
  }

  /// Suspende la granja temporalmente
  Granja suspender({String? razon}) {
    if (estado != EstadoGranja.activo) {
      throw GranjaException(ErrorMessages.get('GRANJA_SOLO_SUSPENDER_ACTIVA'));
    }

    final now = DateTime.now();
    final fecha = _formatearFecha(now);
    final nuevaNota = razon != null
        ? 'Granja suspendida el $fecha - Motivo: $razon'
        : 'Granja suspendida el $fecha';
    final notasActualizadas = _agregarNota(nuevaNota);

    return copyWith(
      estado: EstadoGranja.inactivo,
      notas: notasActualizadas,
      ultimaActualizacion: now,
    );
  }

  /// Pone la granja en mantenimiento
  Granja ponerEnMantenimiento({String? razon}) {
    if (estado != EstadoGranja.activo) {
      throw GranjaException(
        ErrorMessages.get('GRANJA_SOLO_MANTENIMIENTO_ACTIVA'),
      );
    }

    final now = DateTime.now();
    final fecha = _formatearFecha(now);
    final nuevaNota = razon != null
        ? ErrorMessages.format('GRANJA_MAINTENANCE_NOTE_REASON', {'date': fecha, 'reason': razon})
        : ErrorMessages.format('GRANJA_MAINTENANCE_NOTE', {'date': fecha});
    final notasActualizadas = _agregarNota(nuevaNota);

    return copyWith(
      estado: EstadoGranja.mantenimiento,
      notas: notasActualizadas,
      ultimaActualizacion: now,
    );
  }

  /// Actualiza los umbrales ambientales de la granja
  Granja actualizarUmbrales(UmbralesAmbientales nuevosUmbrales) {
    return copyWith(
      umbralesAmbientales: nuevosUmbrales,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza la información de contacto
  Granja actualizarContacto({String? telefono, String? correo}) {
    return copyWith(
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza las estadísticas de capacidad
  Granja actualizarEstadisticas({
    int? capacidadTotalAves,
    double? areaTotalM2,
    int? numeroTotalGalpones,
  }) {
    return copyWith(
      capacidadTotalAves: capacidadTotalAves ?? this.capacidadTotalAves,
      areaTotalM2: areaTotalM2 ?? this.areaTotalM2,
      numeroTotalGalpones: numeroTotalGalpones ?? this.numeroTotalGalpones,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Marca los datos como actualizados
  Granja marcarActualizado() {
    return copyWith(ultimaActualizacion: DateTime.now());
  }

  // ==================== VALIDACIONES ====================

  /// Valida la granja completa
  String? validar() {
    if (id.isEmpty) {
      return ErrorMessages.get('GRANJA_ID_REQUIRED');
    }
    if (nombre.trim().isEmpty) {
      return ErrorMessages.get('GRANJA_NOMBRE_REQUIRED');
    }
    if (nombre.length < 3) {
      return ErrorMessages.get('GRANJA_NOMBRE_MIN_LENGTH');
    }
    if (propietarioNombre.trim().isEmpty) {
      return ErrorMessages.get('GRANJA_PROPIETARIO_REQUIRED');
    }

    final errorDireccion = direccion.validar();
    if (errorDireccion != null) {
      return ErrorMessages.format('PREFIX_DIRECCION', {
        'detail': errorDireccion,
      });
    }

    if (coordenadas != null) {
      final errorCoordenadas = coordenadas!.validar();
      if (errorCoordenadas != null) {
        return ErrorMessages.format('PREFIX_COORDENADAS', {
          'detail': errorCoordenadas,
        });
      }
    }

    if (umbralesAmbientales != null) {
      final errorUmbrales = umbralesAmbientales!.validar();
      if (errorUmbrales != null) {
        return ErrorMessages.format('PREFIX_UMBRALES', {
          'detail': errorUmbrales,
        });
      }
    }

    if (ruc != null && ruc!.isNotEmpty && !tieneRucValido) {
      return ErrorMessages.get('GRANJA_RUC_INVALID');
    }

    if (correo != null && correo!.isNotEmpty && !tieneCorreoValido) {
      return ErrorMessages.get('GRANJA_EMAIL_INVALID');
    }

    if (capacidadTotalAves != null && capacidadTotalAves! < 0) {
      return ErrorMessages.get('GRANJA_CAPACIDAD_NEGATIVE');
    }

    if (areaTotalM2 != null && areaTotalM2! <= 0) {
      return ErrorMessages.get('GRANJA_AREA_POSITIVE');
    }

    if (numeroTotalGalpones != null && numeroTotalGalpones! < 0) {
      return ErrorMessages.get('GRANJA_GALPONES_NEGATIVE');
    }

    return null;
  }

  /// Verifica si la granja es válida
  bool get esValida => validar() == null;

  // ==================== MÉTODOS PRIVADOS ====================

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year} '
        '${fecha.hour.toString().padLeft(2, '0')}:'
        '${fecha.minute.toString().padLeft(2, '0')}';
  }

  String _agregarNota(String nuevaNota) {
    if (notas == null || notas!.isEmpty) {
      return nuevaNota;
    }
    return '$notas\n$nuevaNota';
  }

  @override
  String toString() => 'Granja(id: $id, nombre: $nombre, estado: $estado)';
}

/// Excepción personalizada para errores de negocio en Granja
class GranjaException implements Exception {
  GranjaException(this.mensaje);

  final String mensaje;

  @override
  String toString() => 'GranjaException: $mensaje';
}
