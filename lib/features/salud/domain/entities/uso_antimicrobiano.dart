/// Entidad para seguimiento de uso de antimicrobianos (Stewardship).
/// Basado en principios IPC y OIE de uso responsable.
library;

import 'package:equatable/equatable.dart';
import '../enums/enums.dart';

/// Registro de uso de un antimicrobiano.
class UsoAntimicrobiano extends Equatable {
  const UsoAntimicrobiano({
    required this.id,
    required this.granjaId,
    required this.galponId,
    required this.loteId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.antimicrobiano,
    required this.principioActivo,
    required this.familia,
    required this.categoriaOms,
    required this.dosis,
    required this.unidadDosis,
    required this.viaAdministracion,
    required this.motivoUso,
    this.diagnostico,
    this.enfermedadTratada,
    required this.avesAfectadas,
    required this.tiempoRetiro,
    required this.fechaLiberacion,
    this.veterinarioId,
    this.veterinarioNombre,
    this.numeroReceta,
    this.proveedor,
    this.loteProducto,
    this.fechaVencimiento,
    required this.creadoPor,
    required this.fechaCreacion,
    this.observaciones,
  });

  /// ID único del registro.
  final String id;

  /// ID de la granja.
  final String granjaId;

  /// ID del galpón.
  final String galponId;

  /// ID del lote tratado.
  final String loteId;

  /// Fecha de inicio del tratamiento.
  final DateTime fechaInicio;

  /// Fecha de fin del tratamiento.
  final DateTime fechaFin;

  /// Nombre comercial del antimicrobiano.
  final String antimicrobiano;

  /// Principio activo.
  final String principioActivo;

  /// Familia de antimicrobianos.
  final FamiliaAntimicrobiano familia;

  /// Categoría OMS (CIA/HPCIA).
  final CategoriaOmsAntimicrobiano categoriaOms;

  /// Dosis administrada.
  final double dosis;

  /// Unidad de la dosis (mg/kg, ml/L, etc.).
  final String unidadDosis;

  /// Vía de administración.
  final ViaAdministracion viaAdministracion;

  /// Motivo del uso.
  final MotivoUsoAntimicrobiano motivoUso;

  /// Diagnóstico asociado.
  final String? diagnostico;

  /// Enfermedad tratada (si aplica).
  final EnfermedadAvicola? enfermedadTratada;

  /// Número de aves afectadas/tratadas.
  final int avesAfectadas;

  /// Tiempo de retiro en días.
  final int tiempoRetiro;

  /// Fecha de liberación (después de retiro).
  final DateTime fechaLiberacion;

  /// ID del veterinario que recetó.
  final String? veterinarioId;

  /// Nombre del veterinario.
  final String? veterinarioNombre;

  /// Número de receta veterinaria.
  final String? numeroReceta;

  /// Proveedor del producto.
  final String? proveedor;

  /// Lote del producto.
  final String? loteProducto;

  /// Fecha de vencimiento del producto.
  final DateTime? fechaVencimiento;

  /// Usuario que creó el registro.
  final String creadoPor;

  /// Fecha de creación del registro.
  final DateTime fechaCreacion;

  /// Observaciones adicionales.
  final String? observaciones;

  // ==================== CÁLCULOS ====================

  /// Duración del tratamiento en días.
  int get duracionTratamiento => fechaFin.difference(fechaInicio).inDays + 1;

  /// Indica si el período de retiro ya pasó.
  bool get retiroCumplido => DateTime.now().isAfter(fechaLiberacion);

  /// Días restantes de retiro.
  int get diasRestantesRetiro {
    if (retiroCumplido) return 0;
    return fechaLiberacion.difference(DateTime.now()).inDays;
  }

  /// Es un antimicrobiano críticamente importante.
  bool get esAntimicrobianoCritico =>
      categoriaOms == CategoriaOmsAntimicrobiano.criticamente ||
      categoriaOms == CategoriaOmsAntimicrobiano.altamente;

  /// Requiere supervisión veterinaria obligatoria.
  bool get requiereSupervisionVeterinaria =>
      esAntimicrobianoCritico ||
      motivoUso == MotivoUsoAntimicrobiano.profilaxis ||
      motivoUso == MotivoUsoAntimicrobiano.metafilaxis;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    loteId,
    fechaInicio,
    fechaFin,
    antimicrobiano,
    principioActivo,
    familia,
    categoriaOms,
    dosis,
    unidadDosis,
    viaAdministracion,
    motivoUso,
    diagnostico,
    enfermedadTratada,
    avesAfectadas,
    tiempoRetiro,
    fechaLiberacion,
    veterinarioId,
    veterinarioNombre,
    numeroReceta,
    proveedor,
    loteProducto,
    fechaVencimiento,
    creadoPor,
    fechaCreacion,
    observaciones,
  ];

  UsoAntimicrobiano copyWith({
    String? id,
    String? granjaId,
    String? galponId,
    String? loteId,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? antimicrobiano,
    String? principioActivo,
    FamiliaAntimicrobiano? familia,
    CategoriaOmsAntimicrobiano? categoriaOms,
    double? dosis,
    String? unidadDosis,
    ViaAdministracion? viaAdministracion,
    MotivoUsoAntimicrobiano? motivoUso,
    String? diagnostico,
    EnfermedadAvicola? enfermedadTratada,
    int? avesAfectadas,
    int? tiempoRetiro,
    DateTime? fechaLiberacion,
    String? veterinarioId,
    String? veterinarioNombre,
    String? numeroReceta,
    String? proveedor,
    String? loteProducto,
    DateTime? fechaVencimiento,
    String? creadoPor,
    DateTime? fechaCreacion,
    String? observaciones,
  }) {
    return UsoAntimicrobiano(
      id: id ?? this.id,
      granjaId: granjaId ?? this.granjaId,
      galponId: galponId ?? this.galponId,
      loteId: loteId ?? this.loteId,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      antimicrobiano: antimicrobiano ?? this.antimicrobiano,
      principioActivo: principioActivo ?? this.principioActivo,
      familia: familia ?? this.familia,
      categoriaOms: categoriaOms ?? this.categoriaOms,
      dosis: dosis ?? this.dosis,
      unidadDosis: unidadDosis ?? this.unidadDosis,
      viaAdministracion: viaAdministracion ?? this.viaAdministracion,
      motivoUso: motivoUso ?? this.motivoUso,
      diagnostico: diagnostico ?? this.diagnostico,
      enfermedadTratada: enfermedadTratada ?? this.enfermedadTratada,
      avesAfectadas: avesAfectadas ?? this.avesAfectadas,
      tiempoRetiro: tiempoRetiro ?? this.tiempoRetiro,
      fechaLiberacion: fechaLiberacion ?? this.fechaLiberacion,
      veterinarioId: veterinarioId ?? this.veterinarioId,
      veterinarioNombre: veterinarioNombre ?? this.veterinarioNombre,
      numeroReceta: numeroReceta ?? this.numeroReceta,
      proveedor: proveedor ?? this.proveedor,
      loteProducto: loteProducto ?? this.loteProducto,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
      creadoPor: creadoPor ?? this.creadoPor,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'granjaId': granjaId,
    'galponId': galponId,
    'loteId': loteId,
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaFin': fechaFin.toIso8601String(),
    'antimicrobiano': antimicrobiano,
    'principioActivo': principioActivo,
    'familia': familia.toJson(),
    'categoriaOms': categoriaOms.toJson(),
    'dosis': dosis,
    'unidadDosis': unidadDosis,
    'viaAdministracion': viaAdministracion.toJson(),
    'motivoUso': motivoUso.toJson(),
    'diagnostico': diagnostico,
    'enfermedadTratada': enfermedadTratada?.toJson(),
    'avesAfectadas': avesAfectadas,
    'tiempoRetiro': tiempoRetiro,
    'fechaLiberacion': fechaLiberacion.toIso8601String(),
    'veterinarioId': veterinarioId,
    'veterinarioNombre': veterinarioNombre,
    'numeroReceta': numeroReceta,
    'proveedor': proveedor,
    'loteProducto': loteProducto,
    'fechaVencimiento': fechaVencimiento?.toIso8601String(),
    'creadoPor': creadoPor,
    'fechaCreacion': fechaCreacion.toIso8601String(),
    'observaciones': observaciones,
  };

  factory UsoAntimicrobiano.fromJson(Map<String, dynamic> json) {
    return UsoAntimicrobiano(
      id: json['id'] as String,
      granjaId: json['granjaId'] as String,
      galponId: json['galponId'] as String,
      loteId: json['loteId'] as String,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaFin: DateTime.parse(json['fechaFin'] as String),
      antimicrobiano: json['antimicrobiano'] as String,
      principioActivo: json['principioActivo'] as String,
      familia: FamiliaAntimicrobiano.fromJson(json['familia'] as String),
      categoriaOms: CategoriaOmsAntimicrobiano.fromJson(
        json['categoriaOms'] as String,
      ),
      dosis: (json['dosis'] as num).toDouble(),
      unidadDosis: json['unidadDosis'] as String,
      viaAdministracion: ViaAdministracion.fromJson(
        json['viaAdministracion'] as String,
      ),
      motivoUso: MotivoUsoAntimicrobiano.fromJson(json['motivoUso'] as String),
      diagnostico: json['diagnostico'] as String?,
      enfermedadTratada: json['enfermedadTratada'] != null
          ? EnfermedadAvicola.fromJson(json['enfermedadTratada'] as String)
          : null,
      avesAfectadas: json['avesAfectadas'] as int,
      tiempoRetiro: json['tiempoRetiro'] as int,
      fechaLiberacion: DateTime.parse(json['fechaLiberacion'] as String),
      veterinarioId: json['veterinarioId'] as String?,
      veterinarioNombre: json['veterinarioNombre'] as String?,
      numeroReceta: json['numeroReceta'] as String?,
      proveedor: json['proveedor'] as String?,
      loteProducto: json['loteProducto'] as String?,
      fechaVencimiento: json['fechaVencimiento'] != null
          ? DateTime.parse(json['fechaVencimiento'] as String)
          : null,
      creadoPor: json['creadoPor'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      observaciones: json['observaciones'] as String?,
    );
  }
}

/// Reporte de uso de antimicrobianos para un período.
class ReporteAntimicrobianos extends Equatable {
  const ReporteAntimicrobianos({
    required this.granjaId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.registros,
    required this.totalTratamientos,
    required this.totalAvesTratadas,
    required this.usoPorFamilia,
    required this.usoPorCategoria,
    required this.usoPorMotivo,
  });

  final String granjaId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final List<UsoAntimicrobiano> registros;
  final int totalTratamientos;
  final int totalAvesTratadas;
  final Map<FamiliaAntimicrobiano, int> usoPorFamilia;
  final Map<CategoriaOmsAntimicrobiano, int> usoPorCategoria;
  final Map<MotivoUsoAntimicrobiano, int> usoPorMotivo;

  /// Porcentaje de uso de antimicrobianos críticos.
  double get porcentajeUsoAntimicrobianosCriticos {
    if (totalTratamientos == 0) return 0;
    final usosCriticos =
        (usoPorCategoria[CategoriaOmsAntimicrobiano.criticamente] ?? 0) +
        (usoPorCategoria[CategoriaOmsAntimicrobiano.altamente] ?? 0);
    return (usosCriticos / totalTratamientos) * 100;
  }

  /// Indica si hay uso excesivo de antimicrobianos críticos.
  bool get alertaUsoCritico => porcentajeUsoAntimicrobianosCriticos > 20;

  @override
  List<Object?> get props => [
    granjaId,
    fechaInicio,
    fechaFin,
    registros,
    totalTratamientos,
    totalAvesTratadas,
    usoPorFamilia,
    usoPorCategoria,
    usoPorMotivo,
  ];
}
