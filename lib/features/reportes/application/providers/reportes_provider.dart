/// Providers para el módulo de reportes.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../costos/application/providers/costos_provider.dart';
import '../../../granjas/application/providers/granja_providers.dart';
import '../../../lotes/application/providers/lote_providers.dart';
import '../../../lotes/application/state/lote_state.dart';
import '../../../lotes/domain/entities/lote.dart';
import '../../../ventas/application/providers/ventas_provider.dart';
import '../../domain/entities/datos_reporte.dart';
import '../../domain/enums/enums.dart';
import '../../infrastructure/services/pdf_generator_service.dart';

// =============================================================================
// PROVIDERS DE INFRAESTRUCTURA
// =============================================================================

/// Provider del servicio de generación de PDF.
final pdfGeneratorServiceProvider = Provider<PdfGeneratorService>((ref) {
  return PdfGeneratorService();
});

// =============================================================================
// PROVIDERS DE ESTADO
// =============================================================================

/// Estado de la selección de tipo de reporte.
final tipoReporteSeleccionadoProvider = StateProvider<TipoReporte>((ref) {
  return TipoReporte.ejecutivo;
});

/// Estado del período seleccionado.
final periodoReporteSeleccionadoProvider = StateProvider<PeriodoReporte>((ref) {
  return PeriodoReporte.mes;
});

/// Estado de fechas personalizadas.
final fechaInicioReporteProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().subtract(const Duration(days: 30));
});

final fechaFinReporteProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

/// Estado de carga de generación de PDF.
final generandoPdfProvider = StateProvider<bool>((ref) => false);

// =============================================================================
// PROVIDERS DE DATOS AGREGADOS
// =============================================================================

/// Provider que obtiene datos de producción de un lote.
final datosProduccionLoteProvider = FutureProvider.autoDispose
    .family<DatosProduccionLote?, String>((ref, loteId) async {
      final loteState = ref.watch(loteNotifierProvider);

      // Buscar el lote
      Lote? lote;
      if (loteState is LoteSuccess && loteState.lote.id == loteId) {
        lote = loteState.lote;
      }

      if (lote == null) {
        // Intentar cargar el lote
        final repository = ref.read(loteRepositoryProvider);
        final result = await repository.obtenerPorId(loteId);
        lote = result.fold((l) => null, (r) => r);
      }

      if (lote == null) return null;

      // Calcular edad actual
      final ahora = DateTime.now();
      final diasEnGranja = ahora.difference(lote.fechaIngreso).inDays;
      final edadActual = lote.edadIngresoDias + diasEnGranja;

      return DatosProduccionLote(
        loteId: lote.id,
        loteCodigo: lote.codigo,
        loteNombre: lote.nombre,
        tipoAve: lote.tipoAve.displayName,
        galponNombre: ErrorMessages.get(
          'FALLBACK_GALPON',
        ), // Se puede mejorar obteniendo el nombre real
        fechaIngreso: lote.fechaIngreso,
        cantidadInicial: lote.cantidadInicial,
        cantidadActual: lote.avesActuales,
        mortalidadTotal: lote.mortalidadAcumulada,
        porcentajeMortalidad: lote.cantidadInicial > 0
            ? (lote.mortalidadAcumulada / lote.cantidadInicial) * 100
            : 0,
        descartesTotal: lote.descartesAcumulados,
        ventasTotal: lote.ventasAcumuladas,
        pesoPromedioActual: lote.pesoPromedioActual,
        pesoPromedioObjetivo: lote.pesoPromedioObjetivo,
        consumoTotalKg: lote.consumoAcumuladoKg ?? 0,
        conversionAlimenticia: _calcularConversion(lote),
        edadActualDias: edadActual,
        diasEnGranja: diasEnGranja,
        huevosProducidos: lote.huevosProducidos,
        porcentajePostura: null, // Se puede calcular si hay datos
        fechaCierreEstimada: lote.fechaCierreEstimada,
        costoTotalAves: (lote.costoAveInicial ?? 0) * lote.cantidadInicial,
        costoTotalAlimento: null, // Se obtiene de costos
        ingresosTotales: null, // Se obtiene de ventas
      );
    });

double? _calcularConversion(Lote lote) {
  if (lote.consumoAcumuladoKg == null || lote.consumoAcumuladoKg == 0) {
    return null;
  }
  if (lote.pesoPromedioActual == null || lote.pesoPromedioActual == 0) {
    return null;
  }
  if (lote.avesActuales == 0) {
    return null;
  }

  final pesoGanadoTotal = lote.pesoPromedioActual! * lote.avesActuales;
  return lote.consumoAcumuladoKg! / pesoGanadoTotal;
}

/// Provider de resumen ejecutivo para la granja seleccionada.
final resumenEjecutivoProvider = FutureProvider.autoDispose<ResumenEjecutivo?>((
  ref,
) async {
  final granja = ref.watch(granjaSeleccionadaProvider);
  if (granja == null) return null;

  final granjaId = granja.id;

  // Obtener lotes activos
  final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
  final lotes = lotesAsync.valueOrNull ?? [];

  final lotesActivos = lotes.where((l) => l.estado.estaOperativo).toList();

  if (lotesActivos.isEmpty) {
    return const ResumenEjecutivo(
      totalLotesActivos: 0,
      totalAvesActivas: 0,
      mortalidadPromedio: 0,
      pesoPromedioGeneral: 0,
      consumoTotal: 0,
      costosTotales: 0,
      ventasTotales: 0,
      utilidadNeta: 0,
      margenUtilidad: 0,
      conversionPromedio: 0,
    );
  }

  // Calcular totales
  int totalAves = 0;
  double sumaMortalidad = 0;
  double sumaPeso = 0;
  int lotesConPeso = 0;
  double sumaConsumo = 0;
  double sumaConversion = 0;
  int lotesConConversion = 0;

  for (final lote in lotesActivos) {
    totalAves += lote.avesActuales;

    if (lote.cantidadInicial > 0) {
      sumaMortalidad += (lote.mortalidadAcumulada / lote.cantidadInicial) * 100;
    }

    if (lote.pesoPromedioActual != null) {
      sumaPeso += lote.pesoPromedioActual!;
      lotesConPeso++;
    }

    sumaConsumo += lote.consumoAcumuladoKg ?? 0;

    final conv = _calcularConversion(lote);
    if (conv != null) {
      sumaConversion += conv;
      lotesConConversion++;
    }
  }

  // Obtener costos
  final costosAsync = ref.watch(streamCostosPorGranjaProvider(granjaId));
  final costos = costosAsync.valueOrNull ?? [];
  final totalCostos = costos.fold<double>(0, (sum, c) => sum + c.monto);

  // Obtener ventas
  final ventasAsync = ref.watch(
    streamVentasProductoPorGranjaProvider(granjaId),
  );
  final ventas = ventasAsync.valueOrNull ?? [];
  final totalVentas = ventas.fold<double>(0, (sum, v) => sum + v.totalFinal);

  final utilidad = totalVentas - totalCostos;
  final margen = totalVentas > 0 ? (utilidad / totalVentas) * 100 : 0.0;

  return ResumenEjecutivo(
    totalLotesActivos: lotesActivos.length,
    totalAvesActivas: totalAves,
    mortalidadPromedio: lotesActivos.isNotEmpty
        ? sumaMortalidad / lotesActivos.length
        : 0,
    pesoPromedioGeneral: lotesConPeso > 0 ? sumaPeso / lotesConPeso : 0,
    consumoTotal: sumaConsumo,
    costosTotales: totalCostos,
    ventasTotales: totalVentas,
    utilidadNeta: utilidad,
    margenUtilidad: margen,
    conversionPromedio: lotesConConversion > 0
        ? sumaConversion / lotesConConversion
        : 0,
  );
});

/// Provider que obtiene datos de lotes para tabla.
final datosLotesParaReporteProvider =
    FutureProvider.autoDispose<List<DatosProduccionLote>>((ref) async {
      final granja = ref.watch(granjaSeleccionadaProvider);
      if (granja == null) return [];

      final granjaId = granja.id;

      final lotesAsync = ref.watch(lotesStreamProvider(granjaId));
      final lotes = lotesAsync.valueOrNull ?? [];

      final lotesActivos = lotes.where((l) => l.estado.estaOperativo).toList();

      return lotesActivos.map((lote) {
        final ahora = DateTime.now();
        final diasEnGranja = ahora.difference(lote.fechaIngreso).inDays;
        final edadActual = lote.edadIngresoDias + diasEnGranja;

        return DatosProduccionLote(
          loteId: lote.id,
          loteCodigo: lote.codigo,
          loteNombre: lote.nombre,
          tipoAve: lote.tipoAve.displayName,
          galponNombre: ErrorMessages.get('LABEL_GALPON'),
          fechaIngreso: lote.fechaIngreso,
          cantidadInicial: lote.cantidadInicial,
          cantidadActual: lote.avesActuales,
          mortalidadTotal: lote.mortalidadAcumulada,
          porcentajeMortalidad: lote.cantidadInicial > 0
              ? (lote.mortalidadAcumulada / lote.cantidadInicial) * 100
              : 0,
          descartesTotal: lote.descartesAcumulados,
          ventasTotal: lote.ventasAcumuladas,
          pesoPromedioActual: lote.pesoPromedioActual,
          pesoPromedioObjetivo: lote.pesoPromedioObjetivo,
          consumoTotalKg: lote.consumoAcumuladoKg ?? 0,
          conversionAlimenticia: _calcularConversion(lote),
          edadActualDias: edadActual,
          diasEnGranja: diasEnGranja,
        );
      }).toList();
    });

// =============================================================================
// PROVIDERS DE DATOS PARA REPORTES ESPECÍFICOS
// =============================================================================

/// Provider que obtiene datos de costos para reporte.
final datosCostosParaReporteProvider =
    FutureProvider.autoDispose<List<DatosCostos>>((ref) async {
      final granja = ref.watch(granjaSeleccionadaProvider);
      if (granja == null) return [];

      final granjaId = granja.id;
      final costosAsync = ref.watch(streamCostosPorGranjaProvider(granjaId));
      final costos = costosAsync.valueOrNull ?? [];

      final periodo = ref.watch(periodoReporteSeleccionadoProvider);
      final fechaInicio = periodo == PeriodoReporte.personalizado
          ? ref.watch(fechaInicioReporteProvider)
          : periodo.fechaInicio;
      final fechaFin = periodo == PeriodoReporte.personalizado
          ? ref.watch(fechaFinReporteProvider)
          : periodo.fechaFin;

      // Filtrar por período
      final costosFiltrados = costos.where((c) {
        return c.fecha.isAfter(fechaInicio.subtract(const Duration(days: 1))) &&
            c.fecha.isBefore(fechaFin.add(const Duration(days: 1)));
      }).toList();

      return costosFiltrados
          .map(
            (c) => DatosCostos(
              categoria: c.categoria ?? c.tipo.displayName,
              concepto: c.concepto,
              monto: c.monto,
              fecha: c.fecha,
              proveedor: c.proveedor,
              numeroFactura: c.numeroFactura,
            ),
          )
          .toList();
    });

/// Provider que calcula totales de costos por categoría.
final costosPorCategoriaProvider =
    FutureProvider.autoDispose<Map<String, double>>((ref) async {
      final datosCostos = await ref.watch(
        datosCostosParaReporteProvider.future,
      );
      final mapa = <String, double>{};
      for (final c in datosCostos) {
        mapa[c.categoria] = (mapa[c.categoria] ?? 0) + c.monto;
      }
      return mapa;
    });

/// Provider que obtiene datos de ventas para reporte.
final datosVentasParaReporteProvider =
    FutureProvider.autoDispose<List<DatosVentas>>((ref) async {
      final granja = ref.watch(granjaSeleccionadaProvider);
      if (granja == null) return [];

      final granjaId = granja.id;
      final ventasAsync = ref.watch(
        streamVentasProductoPorGranjaProvider(granjaId),
      );
      final ventas = ventasAsync.valueOrNull ?? [];

      final periodo = ref.watch(periodoReporteSeleccionadoProvider);
      final fechaInicio = periodo == PeriodoReporte.personalizado
          ? ref.watch(fechaInicioReporteProvider)
          : periodo.fechaInicio;
      final fechaFin = periodo == PeriodoReporte.personalizado
          ? ref.watch(fechaFinReporteProvider)
          : periodo.fechaFin;

      // Filtrar por período
      final ventasFiltradas = ventas.where((v) {
        return v.fechaVenta.isAfter(
              fechaInicio.subtract(const Duration(days: 1)),
            ) &&
            v.fechaVenta.isBefore(fechaFin.add(const Duration(days: 1)));
      }).toList();

      return ventasFiltradas.map((v) {
        String unidad;
        double cantidad;

        switch (v.tipoProducto.name) {
          case 'avesVivas':
          case 'avesFaenadas':
          case 'avesDescarte':
            cantidad = (v.cantidadAves ?? 0).toDouble();
            unidad = ErrorMessages.get('UNIT_AVES');
          case 'huevos':
            cantidad = v.totalHuevos.toDouble();
            unidad = ErrorMessages.get('UNIT_UNIDADES');
          case 'pollinaza':
            cantidad = v.cantidadPollinaza ?? 0;
            unidad =
                v.unidadPollinaza?.displayName ??
                ErrorMessages.get('UNIT_SACOS');
          default:
            cantidad = (v.cantidadAves ?? 0).toDouble();
            unidad = ErrorMessages.get('UNIT_UNIDADES');
        }

        // Calcular precio unitario aproximado
        final precioUnitario = cantidad > 0 ? v.subtotal / cantidad : 0.0;

        return DatosVentas(
          tipoProducto: v.tipoProducto.displayName,
          cantidad: cantidad,
          unidad: unidad,
          precioUnitario: precioUnitario,
          subtotal: v.totalFinal,
          fecha: v.fechaVenta,
          cliente: v.cliente.nombre,
          estado: v.estado.displayName,
        );
      }).toList();
    });

/// Provider que calcula totales de ventas por tipo de producto.
final ventasPorProductoProvider =
    FutureProvider.autoDispose<Map<String, double>>((ref) async {
      final datosVentas = await ref.watch(
        datosVentasParaReporteProvider.future,
      );
      final mapa = <String, double>{};
      for (final v in datosVentas) {
        mapa[v.tipoProducto] = (mapa[v.tipoProducto] ?? 0) + v.subtotal;
      }
      return mapa;
    });
