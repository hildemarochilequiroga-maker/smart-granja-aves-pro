/// Entidad que representa un lote avícola.
///
/// Un lote es un grupo de aves que ingresa al galpón en una fecha
/// específica y se maneja como una unidad productiva.
library;

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../enums/enums.dart';

/// Entidad que representa un lote de aves.
class Lote extends Equatable {
  const Lote({
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

  /// Identificador único del lote.
  final String id;

  /// ID de la granja a la que pertenece.
  final String granjaId;

  /// ID del galpón donde está alojado.
  final String galponId;

  /// Código identificador del lote (ej: LOT-2024-001).
  final String codigo;

  /// Tipo de ave del lote.
  final TipoAve tipoAve;

  /// Cantidad de aves al inicio del lote.
  final int cantidadInicial;

  /// Fecha de ingreso de las aves.
  final DateTime fechaIngreso;

  /// Estado actual del lote.
  final EstadoLote estado;

  /// Nombre descriptivo del lote (opcional).
  final String? nombre;

  /// Proveedor de las aves.
  final String? proveedor;

  /// Raza o línea genética.
  final String? raza;

  /// Edad de las aves al momento del ingreso (días).
  final int edadIngresoDias;

  /// Cantidad actual de aves (calculada o actualizada).
  final int? cantidadActual;

  /// Total de mortalidad acumulada.
  final int mortalidadAcumulada;

  /// Total de descartes acumulados.
  final int descartesAcumulados;

  /// Total de aves vendidas.
  final int ventasAcumuladas;

  /// Peso promedio actual (kg).
  final double? pesoPromedioActual;

  /// Peso promedio objetivo (kg).
  final double? pesoPromedioObjetivo;

  /// Consumo acumulado de alimento en kilogramos.
  final double? consumoAcumuladoKg;

  /// Total de huevos producidos (solo para lotes de postura).
  final int? huevosProducidos;

  /// Fecha del primer huevo (solo para postura).
  final DateTime? fechaPrimerHuevo;

  /// Fecha estimada de cierre/venta.
  final DateTime? fechaCierreEstimada;

  /// Fecha real de cierre.
  final DateTime? fechaCierreReal;

  /// Motivo del cierre del lote.
  final String? motivoCierre;

  /// Costo por ave al inicio.
  final double? costoAveInicial;

  /// Observaciones generales.
  final String? observaciones;

  /// Fecha de creación del registro.
  final DateTime? fechaCreacion;

  /// Última actualización.
  final DateTime? ultimaActualizacion;

  /// Metadatos adicionales.
  final Map<String, dynamic> metadatos;

  @override
  List<Object?> get props => [
    id,
    granjaId,
    galponId,
    codigo,
    tipoAve,
    cantidadInicial,
    fechaIngreso,
    estado,
    nombre,
    proveedor,
    raza,
    edadIngresoDias,
    cantidadActual,
    mortalidadAcumulada,
    descartesAcumulados,
    ventasAcumuladas,
    pesoPromedioActual,
    pesoPromedioObjetivo,
    consumoAcumuladoKg,
    huevosProducidos,
    fechaPrimerHuevo,
    fechaCierreEstimada,
    fechaCierreReal,
    motivoCierre,
    costoAveInicial,
    observaciones,
    fechaCreacion,
    ultimaActualizacion,
    metadatos,
  ];

  /// Crea una copia con campos modificados.
  Lote copyWith({
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
    return Lote(
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

  /// Factory para crear un lote nuevo con valores por defecto.
  factory Lote.nuevo({
    required String granjaId,
    required String galponId,
    required String codigo,
    required TipoAve tipoAve,
    required int cantidadInicial,
    required DateTime fechaIngreso,
    String? nombre,
    String? proveedor,
    String? raza,
    int edadIngresoDias = 0,
    double? pesoPromedioObjetivo,
    DateTime? fechaCierreEstimada,
    double? costoAveInicial,
    String? observaciones,
    Map<String, dynamic> metadatos = const {},
  }) {
    return Lote(
      id: '',
      granjaId: granjaId,
      galponId: galponId,
      codigo: codigo,
      tipoAve: tipoAve,
      cantidadInicial: cantidadInicial,
      fechaIngreso: fechaIngreso,
      estado: EstadoLote.activo,
      nombre: nombre,
      proveedor: proveedor,
      raza: raza,
      edadIngresoDias: edadIngresoDias,
      cantidadActual: cantidadInicial,
      pesoPromedioObjetivo: pesoPromedioObjetivo ?? tipoAve.pesoPromedioVenta,
      consumoAcumuladoKg: 0,
      huevosProducidos: tipoAve.esPonedora ? 0 : null,
      fechaCierreEstimada:
          fechaCierreEstimada ??
          fechaIngreso.add(Duration(days: tipoAve.diasCicloTipico)),
      costoAveInicial: costoAveInicial,
      observaciones: observaciones,
      fechaCreacion: DateTime.now(),
      ultimaActualizacion: DateTime.now(),
      metadatos: metadatos,
    );
  }

  // ==================== PROPIEDADES CALCULADAS ====================

  /// Cantidad actual efectiva (considerando mortalidad, descartes y ventas).
  /// Siempre calcula basándose en las bajas registradas.
  ///
  /// NOTA: Preferir usar [avesDisponibles] que es el valor canónico.
  int get avesActuales {
    return cantidadInicial -
        mortalidadAcumulada -
        descartesAcumulados -
        ventasAcumuladas;
  }

  /// Cantidad de aves disponibles actualmente en el lote.
  ///
  /// Este es el getter canónico a usar en toda la aplicación.
  /// Usa el valor calculado [avesActuales] como fuente de verdad,
  /// pero si [cantidadActual] está definido y difiere significativamente,
  /// usa el mínimo de ambos para evitar sobreestimaciones.
  int get avesDisponibles {
    final calculado = avesActuales;

    // Si cantidadActual no está definido, usar el calculado
    if (cantidadActual == null) return calculado;

    // Si cantidadActual está definido, usar el mínimo para ser conservadores
    // Esto previene sobreestimar aves disponibles
    return calculado < cantidadActual! ? calculado : cantidadActual!;
  }

  /// Edad actual del lote en días.
  int get edadActualDias {
    final diasEnGranja = DateTime.now().difference(fechaIngreso).inDays;
    return edadIngresoDias + diasEnGranja;
  }

  /// Alias para edadActualDias (compatibilidad con presentación).
  int get diasDesdeIngreso => DateTime.now().difference(fechaIngreso).inDays;

  /// Edad actual en semanas.
  int get edadActualSemanas => edadActualDias ~/ 7;

  /// Días restantes estimados hasta el cierre.
  int? get diasRestantes {
    if (fechaCierreEstimada == null) return null;
    final dias = fechaCierreEstimada!.difference(DateTime.now()).inDays;
    return dias > 0 ? dias : 0;
  }

  /// Porcentaje de mortalidad acumulada.
  double get porcentajeMortalidad {
    if (cantidadInicial <= 0) return 0;
    return (mortalidadAcumulada / cantidadInicial) * 100;
  }

  /// Porcentaje de supervivencia.
  double get porcentajeSupervivencia => 100 - porcentajeMortalidad;

  /// Porcentaje de progreso del ciclo (basado en días).
  double get porcentajeProgresoCiclo {
    final diasTotales = tipoAve.diasCicloTipico;
    final diasTranscurridos = DateTime.now().difference(fechaIngreso).inDays;
    final progreso = (diasTranscurridos / diasTotales) * 100;
    return progreso.clamp(0, 100);
  }

  /// Si el lote está activo.
  bool get estaActivo => estado == EstadoLote.activo;

  /// Si el lote está finalizado.
  bool get estaFinalizado => estado.estaFinalizado;

  /// Si el lote está en cuarentena.
  bool get estaEnCuarentena => estado == EstadoLote.cuarentena;

  /// Si el lote requiere atención.
  bool get requiereAtencion => estado.requiereAtencion;

  /// Si la mortalidad está dentro de lo esperado.
  bool get mortalidadDentroLimites {
    return porcentajeMortalidad <= tipoAve.mortalidadEsperada * 1.2;
  }

  /// Si el lote está cerca del cierre (menos de 7 días).
  bool get cercaDelCierre {
    final dias = diasRestantes;
    return dias != null && dias <= 7 && dias > 0;
  }

  /// Si el cierre está vencido.
  bool get cierreVencido {
    if (fechaCierreEstimada == null) return false;
    return DateTime.now().isAfter(fechaCierreEstimada!) && !estaFinalizado;
  }

  /// Nombre para mostrar (código o nombre).
  String get displayName => nombre ?? codigo;

  // ==================== PROPIEDADES CALCULADAS ADICIONALES ====================

  /// Índice de conversión alimenticia (ICA).
  ///
  /// ICA = kg alimento consumido / kg de peso ganado
  /// Menor ICA = mejor eficiencia
  double? get indiceConversionAlimenticia {
    if (consumoAcumuladoKg == null || pesoPromedioActual == null) return null;
    if (avesActuales == 0) return null;

    final pesoTotalKg = pesoPromedioActual! * avesActuales;
    if (pesoTotalKg <= 0) return null;

    return consumoAcumuladoKg! / pesoTotalKg;
  }

  /// Consumo promedio por ave en kg.
  double? get consumoPromedioPorAve {
    if (consumoAcumuladoKg == null || avesActuales == 0) return null;
    return consumoAcumuladoKg! / avesActuales;
  }

  /// Ganancia de peso promedio diaria en gramos (estimada).
  double? get gananciaPesoPromedioDiariaGramos {
    if (pesoPromedioActual == null || diasDesdeIngreso == 0) return null;
    // Convertir kg a gramos
    final pesoGramos = pesoPromedioActual! * 1000;
    return pesoGramos / diasDesdeIngreso;
  }

  /// Producción promedio de huevos por ave (solo postura).
  double? get huevosPorAve {
    if (!tipoAve.esPonedora || huevosProducidos == null) return null;
    if (avesActuales == 0) return null;
    return huevosProducidos! / avesActuales;
  }

  /// Edad a la primera postura en semanas (solo postura).
  int? get edadPrimeraPosturaSemanas {
    if (!tipoAve.esPonedora || fechaPrimerHuevo == null) return null;
    final diasHastaPrimerHuevo = fechaPrimerHuevo!
        .difference(fechaIngreso)
        .inDays;
    return ((edadIngresoDias + diasHastaPrimerHuevo) / 7).floor();
  }

  /// Porcentaje de postura diaria.
  ///
  /// % Postura = (huevos producidos promedio por día / aves vivas) * 100
  double? get porcentajePosturaDiaria {
    if (!tipoAve.esPonedora || huevosProducidos == null) return null;
    if (avesActuales == 0 || diasDesdeIngreso == 0) return null;

    final huevosPromedioDiarios = huevosProducidos! / diasDesdeIngreso;
    return (huevosPromedioDiarios / avesActuales) * 100;
  }

  /// Duración del ciclo en días (si está cerrado).
  int? get duracionCicloDias {
    if (fechaCierreReal == null) return null;
    return fechaCierreReal!.difference(fechaIngreso).inDays;
  }

  /// Mortalidad promedio por día.
  double get mortalidadPromedioDiaria {
    if (diasDesdeIngreso == 0) return 0.0;
    return mortalidadAcumulada / diasDesdeIngreso;
  }

  /// Verifica si el ICA está dentro de límites aceptables.
  bool? get icaDentroLimites {
    final ica = indiceConversionAlimenticia;
    if (ica == null) return null;

    // Límites según tipo de ave
    switch (tipoAve) {
      case TipoAve.polloEngorde:
        return ica <= 2.0; // ICA objetivo: 1.6-1.8, máximo aceptable 2.0
      case TipoAve.gallinaPonedora:
      case TipoAve.codorniz:
        return ica <= 2.5; // ICA típico: 2.0-2.3
      case TipoAve.reproductoraPesada:
      case TipoAve.reproductoraLiviana:
        return ica <= 3.0; // ICA típico: 2.5-2.8
      default:
        return true;
    }
  }

  /// Verifica si el peso está dentro del rango esperado para la edad.
  bool? get pesoDentroRango {
    if (pesoPromedioActual == null) return null;

    // Para engorde, verificar contra peso objetivo
    if (tipoAve == TipoAve.polloEngorde || tipoAve == TipoAve.pavo) {
      final pesoObjetivoKg = pesoPromedioObjetivo ?? tipoAve.pesoPromedioVenta;
      final edadObjetivo = tipoAve.diasCicloTipico;

      // Estimación lineal del peso esperado
      final pesoEsperado = (pesoObjetivoKg * diasDesdeIngreso) / edadObjetivo;

      // Permitir ±20% de variación
      final rangoMin = pesoEsperado * 0.8;
      final rangoMax = pesoEsperado * 1.2;

      return pesoPromedioActual! >= rangoMin && pesoPromedioActual! <= rangoMax;
    }

    // Para postura y reproductora, no aplicar validación de peso
    return true;
  }

  /// Verifica si la mortalidad requiere alerta (supera límite).
  bool get requiereAlertaMortalidad => !mortalidadDentroLimites;

  // ==================== MÉTODOS DE NEGOCIO ====================

  /// Registra mortalidad en el lote.
  Lote registrarMortalidad(int cantidad, {String? observacion}) {
    if (cantidad <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_CANTIDAD_DEBE_POSITIVA'));
    }
    if (!estado.permiteRegistros) {
      throw LoteException(
        ErrorMessages.format('LOTE_NO_PERMITE_REGISTROS', {
          'estado': estado.displayName,
        }),
      );
    }
    if (cantidad > avesActuales) {
      throw LoteException(
        ErrorMessages.format('LOTE_AVES_INSUFICIENTES', {
          'disponibles': avesActuales.toString(),
        }),
      );
    }

    return copyWith(
      mortalidadAcumulada: mortalidadAcumulada + cantidad,
      ultimaActualizacion: DateTime.now(),
      observaciones: observacion != null
          ? '${observaciones ?? ''}\n[Mortalidad: $cantidad] $observacion'
          : observaciones,
    );
  }

  /// Registra descarte en el lote.
  Lote registrarDescarte(int cantidad, {String? motivo}) {
    if (cantidad <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_CANTIDAD_DEBE_POSITIVA'));
    }
    if (!estado.permiteRegistros) {
      throw LoteException(
        ErrorMessages.format('LOTE_NO_PERMITE_REGISTROS', {
          'estado': estado.displayName,
        }),
      );
    }
    if (cantidad > avesActuales) {
      throw LoteException(
        ErrorMessages.format('LOTE_AVES_INSUFICIENTES', {
          'disponibles': avesActuales.toString(),
        }),
      );
    }

    return copyWith(
      descartesAcumulados: descartesAcumulados + cantidad,
      ultimaActualizacion: DateTime.now(),
      observaciones: motivo != null
          ? '${observaciones ?? ''}\n[Descarte: $cantidad] $motivo'
          : observaciones,
    );
  }

  /// Registra venta parcial de aves.
  Lote registrarVenta(int cantidad) {
    if (cantidad <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_CANTIDAD_DEBE_POSITIVA'));
    }
    if (!estado.permiteRegistros) {
      throw LoteException(
        ErrorMessages.format('LOTE_NO_PERMITE_REGISTROS', {
          'estado': estado.displayName,
        }),
      );
    }
    if (cantidad > avesActuales) {
      throw LoteException(
        ErrorMessages.format('LOTE_AVES_INSUFICIENTES', {
          'disponibles': avesActuales.toString(),
        }),
      );
    }

    return copyWith(
      ventasAcumuladas: ventasAcumuladas + cantidad,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza el peso promedio actual.
  Lote actualizarPeso(double nuevoPeso) {
    if (nuevoPeso <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_PESO_DEBE_POSITIVO'));
    }

    return copyWith(
      pesoPromedioActual: nuevoPeso,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Registra consumo de alimento.
  Lote registrarConsumoAlimento(double cantidadKg) {
    if (!estado.permiteRegistros) {
      throw LoteException(
        ErrorMessages.format('LOTE_CONSUMO_NO_PERMITIDO', {
          'estado': estado.displayName,
        }),
      );
    }
    if (cantidadKg <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_CANTIDAD_DEBE_POSITIVA'));
    }

    final nuevoConsumo = (consumoAcumuladoKg ?? 0) + cantidadKg;

    return copyWith(
      consumoAcumuladoKg: nuevoConsumo,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Registra producción de huevos (solo para lotes de postura).
  Lote registrarProduccionHuevos(int cantidad) {
    if (!tipoAve.esPonedora) {
      throw LoteException(ErrorMessages.get('LOTE_SOLO_POSTURA'));
    }
    if (!estado.permiteRegistros) {
      throw LoteException(
        ErrorMessages.format('LOTE_PRODUCCION_NO_PERMITIDA', {
          'estado': estado.displayName,
        }),
      );
    }
    if (cantidad <= 0) {
      throw LoteException(ErrorMessages.get('LOTE_CANTIDAD_DEBE_POSITIVA'));
    }

    final nuevosHuevos = (huevosProducidos ?? 0) + cantidad;
    final nuevaFechaPrimerHuevo = fechaPrimerHuevo ?? DateTime.now();

    return copyWith(
      huevosProducidos: nuevosHuevos,
      fechaPrimerHuevo: nuevaFechaPrimerHuevo,
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Cambia el estado del lote.
  Lote cambiarEstado(
    EstadoLote nuevoEstado, {
    String? motivo,
    bool forzar = false,
  }) {
    if (!forzar && !estado.puedeTransicionarA(nuevoEstado)) {
      throw LoteException(
        ErrorMessages.format('LOTE_CAMBIO_ESTADO_INVALIDO', {
          'estadoActual': estado.displayName,
          'estadoNuevo': nuevoEstado.displayName,
        }),
      );
    }

    return copyWith(
      estado: nuevoEstado,
      ultimaActualizacion: DateTime.now(),
      observaciones: motivo != null
          ? '${observaciones ?? ''}\n[Cambio a $nuevoEstado] $motivo'
          : observaciones,
    );
  }

  /// Pone el lote en cuarentena.
  Lote ponerEnCuarentena({required String motivo}) {
    return cambiarEstado(EstadoLote.cuarentena, motivo: motivo);
  }

  /// Cierra el lote.
  Lote cerrar({String? motivo}) {
    return copyWith(
      estado: EstadoLote.cerrado,
      fechaCierreReal: DateTime.now(),
      motivoCierre: motivo ?? ErrorMessages.get('LOTE_CIERRE_NORMAL'),
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Marca el lote como vendido.
  Lote marcarVendido({String? comprador}) {
    final restantes = avesActuales;
    return copyWith(
      estado: EstadoLote.vendido,
      ventasAcumuladas: ventasAcumuladas + restantes,
      fechaCierreReal: DateTime.now(),
      motivoCierre: comprador != null
          ? ErrorMessages.format('LOTE_VENDIDO_A', {'comprador': comprador})
          : ErrorMessages.get('LOTE_VENDIDO'),
      ultimaActualizacion: DateTime.now(),
    );
  }

  /// Transfiere el lote a otro galpón.
  Lote transferirAGalpon(String nuevoGalponId) {
    if (nuevoGalponId == galponId) {
      throw LoteException(ErrorMessages.get('LOTE_YA_EN_GALPON'));
    }

    return copyWith(
      galponId: nuevoGalponId,
      estado: EstadoLote.activo,
      ultimaActualizacion: DateTime.now(),
      observaciones:
          '${observaciones ?? ''}\n[Transferido de galpón $galponId a $nuevoGalponId]',
    );
  }

  // ==================== VALIDACIONES ====================

  /// Valida el lote.
  String? validar() {
    if (granjaId.isEmpty) {
      return ErrorMessages.get('LOTE_GRANJA_ID_REQUIRED');
    }
    if (galponId.isEmpty) {
      return ErrorMessages.get('LOTE_GALPON_ID_REQUIRED');
    }
    if (codigo.trim().isEmpty) {
      return ErrorMessages.get('LOTE_CODIGO_REQUIRED');
    }
    if (cantidadInicial <= 0) {
      return ErrorMessages.get('LOTE_CANTIDAD_POSITIVE');
    }
    if (edadIngresoDias < 0) {
      return ErrorMessages.get('LOTE_EDAD_NEGATIVE');
    }
    if (mortalidadAcumulada < 0) {
      return ErrorMessages.get('LOTE_MORTALIDAD_NEGATIVE');
    }
    if (descartesAcumulados < 0) {
      return ErrorMessages.get('LOTE_DESCARTES_NEGATIVE');
    }
    if (ventasAcumuladas < 0) {
      return ErrorMessages.get('LOTE_VENTAS_NEGATIVE');
    }
    if (avesActuales < 0) {
      return ErrorMessages.get('LOTE_BAJAS_EXCEDEN');
    }
    if (pesoPromedioActual != null && pesoPromedioActual! <= 0) {
      return ErrorMessages.get('LOTE_PESO_POSITIVE');
    }
    if (costoAveInicial != null && costoAveInicial! < 0) {
      return ErrorMessages.get('LOTE_COSTO_NEGATIVE');
    }

    return null;
  }

  /// Si el lote es válido.
  bool get esValido => validar() == null;

  @override
  String toString() {
    return 'Lote(id: $id, codigo: $codigo, '
        'tipoAve: ${tipoAve.displayName}, estado: ${estado.displayName}, '
        'aves: $avesActuales/$cantidadInicial)';
  }
}

/// Excepción personalizada para errores de negocio en Lote.
class LoteException implements Exception {
  LoteException(this.mensaje);

  final String mensaje;

  @override
  String toString() => 'LoteException: $mensaje';
}
