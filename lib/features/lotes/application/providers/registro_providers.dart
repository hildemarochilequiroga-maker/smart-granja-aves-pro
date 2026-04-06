/// Providers para registros del lote.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartgranjaavespro/l10n/app_localizations.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/entities.dart';
import '../../infrastructure/datasources/datasources.dart';

// ============================================================
// DATASOURCES PROVIDERS
// ============================================================

/// Provider para el datasource de registros de consumo.
final registroConsumoFirebaseDatasourceProvider =
    Provider<RegistroConsumoFirebaseDatasource>((ref) {
      return RegistroConsumoFirebaseDatasource();
    });

/// Alias corto para el datasource de consumo.
final registroConsumoDatasourceProvider =
    registroConsumoFirebaseDatasourceProvider;

/// Provider para el datasource de registros de mortalidad.
final registroMortalidadFirebaseDatasourceProvider =
    Provider<RegistroMortalidadFirebaseDatasource>((ref) {
      return RegistroMortalidadFirebaseDatasource();
    });

/// Alias corto para el datasource de mortalidad.
final registroMortalidadDatasourceProvider =
    registroMortalidadFirebaseDatasourceProvider;

/// Provider para el datasource de registros de peso.
final registroPesoFirebaseDatasourceProvider =
    Provider<RegistroPesoFirebaseDatasource>((ref) {
      return RegistroPesoFirebaseDatasource();
    });

/// Alias corto para el datasource de peso.
final registroPesoDatasourceProvider = registroPesoFirebaseDatasourceProvider;

/// Provider para el datasource de registros de producción.
final registroProduccionFirebaseDatasourceProvider =
    Provider<RegistroProduccionFirebaseDatasource>((ref) {
      return RegistroProduccionFirebaseDatasource();
    });

/// Alias corto para el datasource de producción.
final registroProduccionDatasourceProvider =
    registroProduccionFirebaseDatasourceProvider;

// ============================================================
// CONSUMO PROVIDERS
// ============================================================

/// Provider para registros de consumo de un lote.
final registrosConsumoPorLoteProvider = StreamProvider.autoDispose
    .family<List<RegistroConsumo>, String>((ref, loteId) {
      final datasource = ref.watch(registroConsumoFirebaseDatasourceProvider);
      return datasource.watchPorLote(loteId);
    });

/// Provider para el último registro de consumo de un lote.
final ultimoRegistroConsumoProvider = FutureProvider.autoDispose
    .family<RegistroConsumo?, String>((ref, loteId) async {
      final datasource = ref.watch(registroConsumoFirebaseDatasourceProvider);
      return datasource.obtenerUltimo(loteId);
    });

/// Provider para el consumo total de un lote.
final consumoTotalLoteProvider = FutureProvider.autoDispose
    .family<double, String>((ref, loteId) async {
      final datasource = ref.watch(registroConsumoFirebaseDatasourceProvider);
      return datasource.obtenerConsumoTotal(loteId);
    });

// ============================================================
// MORTALIDAD PROVIDERS
// ============================================================

/// Provider para registros de mortalidad de un lote.
final registrosMortalidadPorLoteProvider = StreamProvider.autoDispose
    .family<List<RegistroMortalidad>, String>((ref, loteId) {
      final datasource = ref.watch(
        registroMortalidadFirebaseDatasourceProvider,
      );
      return datasource.watchPorLote(loteId);
    });

/// Provider para el último registro de mortalidad de un lote.
final ultimoRegistroMortalidadProvider = FutureProvider.autoDispose
    .family<RegistroMortalidad?, String>((ref, loteId) async {
      final datasource = ref.watch(
        registroMortalidadFirebaseDatasourceProvider,
      );
      return datasource.obtenerUltimo(loteId);
    });

/// Provider para la mortalidad total de un lote.
final mortalidadTotalLoteProvider = FutureProvider.autoDispose
    .family<int, String>((ref, loteId) async {
      final datasource = ref.watch(
        registroMortalidadFirebaseDatasourceProvider,
      );
      return datasource.obtenerMortalidadTotal(loteId);
    });

// ============================================================
// PESO PROVIDERS
// ============================================================

/// Provider para registros de peso de un lote.
final registrosPesoPorLoteProvider = StreamProvider.autoDispose
    .family<List<RegistroPeso>, String>((ref, loteId) {
      final datasource = ref.watch(registroPesoFirebaseDatasourceProvider);
      return datasource.watchPorLote(loteId);
    });

/// Provider para el último registro de peso de un lote.
final ultimoRegistroPesoProvider = FutureProvider.autoDispose
    .family<RegistroPeso?, String>((ref, loteId) async {
      final datasource = ref.watch(registroPesoFirebaseDatasourceProvider);
      return datasource.obtenerUltimo(loteId);
    });

/// Provider para el último peso promedio de un lote.
final ultimoPesoPromedioLoteProvider = FutureProvider.autoDispose
    .family<double?, String>((ref, loteId) async {
      final datasource = ref.watch(registroPesoFirebaseDatasourceProvider);
      return datasource.obtenerUltimoPesoPromedio(loteId);
    });

// ============================================================
// PRODUCCIÓN PROVIDERS
// ============================================================

/// Provider para registros de producción de un lote.
final registrosProduccionPorLoteProvider = StreamProvider.autoDispose
    .family<List<RegistroProduccion>, String>((ref, loteId) {
      final datasource = ref.watch(
        registroProduccionFirebaseDatasourceProvider,
      );
      return datasource.watchPorLote(loteId);
    });

/// Provider para el último registro de producción de un lote.
final ultimoRegistroProduccionProvider = FutureProvider.autoDispose
    .family<RegistroProduccion?, String>((ref, loteId) async {
      final datasource = ref.watch(
        registroProduccionFirebaseDatasourceProvider,
      );
      return datasource.obtenerUltimo(loteId);
    });

/// Provider para el total de huevos de un lote.
final totalHuevosLoteProvider = FutureProvider.autoDispose.family<int, String>((
  ref,
  loteId,
) async {
  final datasource = ref.watch(registroProduccionFirebaseDatasourceProvider);
  return datasource.obtenerTotalHuevos(loteId);
});

/// Provider para el porcentaje de postura promedio de un lote.
final posturaPromedioLoteProvider = FutureProvider.autoDispose
    .family<double, String>((ref, loteId) async {
      final datasource = ref.watch(
        registroProduccionFirebaseDatasourceProvider,
      );
      return datasource.obtenerPosturaPromedio(loteId);
    });

// ============================================================
// REGISTROS COMBINADOS
// ============================================================

/// Modelo para mostrar registros unificados.
class RegistroReciente {
  const RegistroReciente({
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    required this.valor,
    this.color,
  });

  final TipoRegistroReciente tipo;
  final DateTime fecha;
  final String descripcion;
  final String valor;
  final Color? color;
}

/// Tipos de registros recientes.
enum TipoRegistroReciente {
  peso,
  consumo,
  mortalidad,
  produccion;

  String get displayName {
    switch (this) {
      case TipoRegistroReciente.peso:
        return 'Peso';
      case TipoRegistroReciente.consumo:
        return 'Consumo';
      case TipoRegistroReciente.mortalidad:
        return 'Mortalidad';
      case TipoRegistroReciente.produccion:
        return 'Producción';
    }
  }

  String localizedDisplayName(S l) {
    switch (this) {
      case TipoRegistroReciente.peso:
        return l.enumTipoRegistroPeso;
      case TipoRegistroReciente.consumo:
        return l.enumTipoRegistroConsumo;
      case TipoRegistroReciente.mortalidad:
        return l.enumTipoRegistroMortalidad;
      case TipoRegistroReciente.produccion:
        return l.enumTipoRegistroProduccion;
    }
  }

  IconData get icono {
    switch (this) {
      case TipoRegistroReciente.peso:
        return Icons.scale;
      case TipoRegistroReciente.consumo:
        return Icons.restaurant;
      case TipoRegistroReciente.mortalidad:
        return Icons.warning_amber;
      case TipoRegistroReciente.produccion:
        return Icons.egg;
    }
  }

  Color get color {
    switch (this) {
      case TipoRegistroReciente.peso:
        return AppColors.purple;
      case TipoRegistroReciente.consumo:
        return AppColors.success;
      case TipoRegistroReciente.mortalidad:
        return AppColors.error;
      case TipoRegistroReciente.produccion:
        return AppColors.warning;
    }
  }
}

/// Provider para obtener los últimos registros combinados de un lote.
final ultimosRegistrosProvider = FutureProvider.autoDispose
    .family<List<RegistroReciente>, String>((ref, loteId) async {
      final registros = <RegistroReciente>[];

      try {
        // Obtener últimos registros de cada tipo usando read para evitar problemas de suscripción
        final pesoFuture = ref.read(ultimoRegistroPesoProvider(loteId).future);
        final consumoFuture = ref.read(
          ultimoRegistroConsumoProvider(loteId).future,
        );
        final mortalidadFuture = ref.read(
          ultimoRegistroMortalidadProvider(loteId).future,
        );
        final produccionFuture = ref.read(
          ultimoRegistroProduccionProvider(loteId).future,
        );

        // Esperar todos los futures en paralelo
        final results = await Future.wait([
          pesoFuture.catchError((_) => null),
          consumoFuture.catchError((_) => null),
          mortalidadFuture.catchError((_) => null),
          produccionFuture.catchError((_) => null),
        ]);

        final ultimoPeso = results[0] as RegistroPeso?;
        final ultimoConsumo = results[1] as RegistroConsumo?;
        final ultimaMortalidad = results[2] as RegistroMortalidad?;
        final ultimaProduccion = results[3] as RegistroProduccion?;

        // Agregar peso
        if (ultimoPeso != null) {
          registros.add(
            RegistroReciente(
              tipo: TipoRegistroReciente.peso,
              fecha: ultimoPeso.fecha,
              descripcion: ErrorMessages.format('REG_CARD_PESO_DESC', {
                'aves': '${ultimoPeso.cantidadAvesPesadas}',
                'gdp': ultimoPeso.gananciaDialiaPromedio.toStringAsFixed(1),
              }),
              valor:
                  '${(ultimoPeso.pesoPromedio / 1000).toStringAsFixed(2)} kg',
            ),
          );
        }

        // Agregar consumo
        if (ultimoConsumo != null) {
          registros.add(
            RegistroReciente(
              tipo: TipoRegistroReciente.consumo,
              fecha: ultimoConsumo.fecha,
              descripcion: ErrorMessages.format('REG_CARD_CONSUMO_DESC', {
                'tipo': ultimoConsumo.tipoAlimento.displayName,
                'aves': '${ultimoConsumo.cantidadAvesActual}',
              }),
              valor: '${ultimoConsumo.cantidadKg.toStringAsFixed(1)} kg',
            ),
          );
        }

        // Agregar mortalidad
        if (ultimaMortalidad != null) {
          registros.add(
            RegistroReciente(
              tipo: TipoRegistroReciente.mortalidad,
              fecha: ultimaMortalidad.fecha,
              descripcion: ErrorMessages.format('REG_CARD_MORT_DESC', {
                'causa': ultimaMortalidad.causa.localizedDisplay,
                'impacto': ultimaMortalidad.impactoPorcentual.toStringAsFixed(
                  1,
                ),
              }),
              valor: ErrorMessages.format('REG_CARD_MORT_VALOR', {
                'cantidad': '${ultimaMortalidad.cantidad}',
              }),
              color: ultimaMortalidad.requiereAtencionInmediata
                  ? AppColors.error
                  : AppColors.warning,
            ),
          );
        }

        // Agregar producción
        if (ultimaProduccion != null) {
          registros.add(
            RegistroReciente(
              tipo: TipoRegistroReciente.produccion,
              fecha: ultimaProduccion.fecha,
              descripcion: ErrorMessages.format('REG_CARD_PROD_DESC', {
                'postura': ultimaProduccion.porcentajePostura.toStringAsFixed(
                  1,
                ),
                'buenos': ultimaProduccion.porcentajeBuenos.toStringAsFixed(1),
              }),
              valor: ErrorMessages.format('REG_CARD_PROD_VALOR', {
                'cantidad': '${ultimaProduccion.huevosRecolectados}',
              }),
            ),
          );
        }

        // Ordenar por fecha descendente
        registros.sort((a, b) => b.fecha.compareTo(a.fecha));
      } on Exception {
        // En caso de error, retornar lista vacía
        return [];
      }

      // Retornar máximo 5 registros
      return registros.take(5).toList();
    });

// ============================================================
// ALIASES PARA COMPATIBILIDAD CON PÁGINAS DE HISTORIAL/GRÁFICOS
// ============================================================

/// Alias para registros de consumo (compatibilidad con graficos/historial pages)
final registrosConsumoStreamProvider = registrosConsumoPorLoteProvider;

/// Alias para registros de peso (compatibilidad con graficos/historial pages)
final registrosPesoStreamProvider = registrosPesoPorLoteProvider;

/// Alias para registros de mortalidad (compatibilidad con graficos/historial pages)
final registrosMortalidadStreamProvider = registrosMortalidadPorLoteProvider;

/// Alias para registros de producción (compatibilidad con graficos/historial pages)
final registrosProduccionStreamProvider = registrosProduccionPorLoteProvider;

/// Provider para estadísticas de peso de un lote
final registrosPesoStatsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, loteId) async {
      final registrosAsync = await ref.watch(
        registrosPesoPorLoteProvider(loteId).future,
      );

      if (registrosAsync.isEmpty) {
        return {
          'totalRegistros': 0,
          'ultimoPesoPromedio': 0.0,
          'gananciaDialiaPromedio': 0.0,
          'coeficienteVariacionPromedio': 0.0,
          'pesoMinimo': 0.0,
          'pesoMaximo': 0.0,
        };
      }

      // Ordenar por fecha para obtener el más reciente
      final registrosOrdenados = registrosAsync.toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha));

      final ultimoRegistro = registrosOrdenados.first;
      final ultimoPesoPromedio = ultimoRegistro.pesoPromedio;

      // Calcular GDP promedio de todos los registros
      final gdpList = registrosAsync
          .map((r) => r.gananciaDialiaPromedio)
          .where((gdp) => gdp > 0)
          .toList();
      final gdpPromedio = gdpList.isNotEmpty
          ? gdpList.reduce((a, b) => a + b) / gdpList.length
          : 0.0;

      // Calcular CV promedio de todos los registros
      final cvList = registrosAsync
          .map((r) => r.coeficienteVariacion)
          .where((cv) => cv > 0)
          .toList();
      final cvPromedio = cvList.isNotEmpty
          ? cvList.reduce((a, b) => a + b) / cvList.length
          : 0.0;

      // Peso mínimo y máximo
      final pesos = registrosAsync.map((r) => r.pesoPromedio).toList();
      final pesoMinimo = pesos.reduce((a, b) => a < b ? a : b);
      final pesoMaximo = pesos.reduce((a, b) => a > b ? a : b);

      return {
        'totalRegistros': registrosAsync.length,
        'ultimoPesoPromedio': ultimoPesoPromedio,
        'gananciaDialiaPromedio': gdpPromedio,
        'coeficienteVariacionPromedio': cvPromedio,
        'pesoMinimo': pesoMinimo,
        'pesoMaximo': pesoMaximo,
      };
    });

/// Provider para estadísticas de mortalidad de un lote
final estadisticasMortalidadProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, loteId) async {
      final registrosAsync = await ref.watch(
        registrosMortalidadPorLoteProvider(loteId).future,
      );

      if (registrosAsync.isEmpty) {
        return {
          'totalMuertes': 0,
          'totalEventos': 0,
          'promedioPorEvento': 0.0,
          'porcentajeAcumulado': 0.0,
          'causaPrincipal': 'N/A',
          'tendencia': 'estable',
          'distribucionPorCausa': <String, dynamic>{},
        };
      }

      final totalEventos = registrosAsync.length;
      final totalMuertes = registrosAsync.fold<int>(
        0,
        (sum, r) => sum + r.cantidad,
      );
      final promedioPorEvento = totalEventos > 0
          ? totalMuertes / totalEventos
          : 0.0;

      // Calcular porcentaje acumulado basado en la cantidad inicial del lote
      final cantidadInicial = registrosAsync.isNotEmpty
          ? registrosAsync.first.cantidadAntesEvento
          : 0;
      final porcentajeAcumulado = cantidadInicial > 0
          ? (totalMuertes / cantidadInicial) * 100
          : 0.0;

      // Encontrar causa principal y distribución por causa
      final causas = <String, int>{};
      for (final registro in registrosAsync) {
        final causa = registro
            .causa
            .name; // Usar el nombre del enum en lugar de displayName
        causas[causa] = (causas[causa] ?? 0) + registro.cantidad;
      }

      final causaPrincipal = causas.isNotEmpty
          ? causas.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : 'N/A';

      // Distribución por causa para gráfico de torta
      final distribucionPorCausa = Map<String, dynamic>.from(causas);

      // Calcular tendencia (comparar últimos 7 días vs anteriores)
      final ahora = DateTime.now();
      final registrosRecientes = registrosAsync
          .where((r) => ahora.difference(r.fecha).inDays <= 7)
          .toList();
      final registrosAnteriores = registrosAsync
          .where(
            (r) =>
                ahora.difference(r.fecha).inDays > 7 &&
                ahora.difference(r.fecha).inDays <= 14,
          )
          .toList();

      final muertesRecientes = registrosRecientes.fold<int>(
        0,
        (sum, r) => sum + r.cantidad,
      );
      final muertesAnteriores = registrosAnteriores.fold<int>(
        0,
        (sum, r) => sum + r.cantidad,
      );

      String tendencia = ErrorMessages.get('TREND_STABLE');
      if (muertesRecientes > muertesAnteriores * 1.2) {
        tendencia = ErrorMessages.get('TREND_INCREASING');
      } else if (muertesRecientes < muertesAnteriores * 0.8) {
        tendencia = ErrorMessages.get('TREND_DECREASING');
      }

      return {
        'totalMuertes': totalMuertes,
        'totalEventos': totalEventos,
        'promedioPorEvento': promedioPorEvento,
        'porcentajeAcumulado': porcentajeAcumulado,
        'causaPrincipal': causaPrincipal,
        'tendencia': tendencia,
        'distribucionPorCausa': distribucionPorCausa,
      };
    });

/// Provider para estadísticas de consumo de un lote
final registrosConsumoStatsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, loteId) async {
      final registrosAsync = await ref.watch(
        registrosConsumoPorLoteProvider(loteId).future,
      );

      if (registrosAsync.isEmpty) {
        return {
          'totalConsumo': 0.0,
          'promedioDiario': 0.0,
          'consumoPorAve': 0.0,
          'totalRegistros': 0,
          'tendencia': 'estable',
        };
      }

      // Total consumido
      final totalConsumo = registrosAsync.fold<double>(
        0,
        (sum, r) => sum + r.cantidadKg,
      );

      // Calcular días únicos para promedio diario real
      final fechasUnicas = registrosAsync
          .map((r) => DateTime(r.fecha.year, r.fecha.month, r.fecha.day))
          .toSet();
      final diasConRegistro = fechasUnicas.length;
      final promedioDiario = diasConRegistro > 0
          ? totalConsumo / diasConRegistro
          : 0.0;

      // Consumo por ave acumulado (usando el último registro que tiene el acumulado)
      final registrosOrdenados = registrosAsync.toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha));
      final ultimoRegistro = registrosOrdenados.first;
      final consumoPorAve =
          ultimoRegistro.consumoAcumulado > 0 &&
              ultimoRegistro.cantidadAvesActual > 0
          ? ultimoRegistro.consumoAcumulado / ultimoRegistro.cantidadAvesActual
          : 0.0;

      // Calcular tendencia
      final ahora = DateTime.now();
      final registrosRecientes = registrosAsync
          .where((r) => ahora.difference(r.fecha).inDays <= 7)
          .toList();
      final registrosAnteriores = registrosAsync
          .where(
            (r) =>
                ahora.difference(r.fecha).inDays > 7 &&
                ahora.difference(r.fecha).inDays <= 14,
          )
          .toList();

      final consumoReciente = registrosRecientes.fold<double>(
        0,
        (sum, r) => sum + r.cantidadKg,
      );
      final consumoAnterior = registrosAnteriores.fold<double>(
        0,
        (sum, r) => sum + r.cantidadKg,
      );

      String tendencia = ErrorMessages.get('TREND_STABLE');
      if (consumoReciente > consumoAnterior * 1.1) {
        tendencia = ErrorMessages.get('TREND_INCREASING');
      } else if (consumoReciente < consumoAnterior * 0.9) {
        tendencia = ErrorMessages.get('TREND_DECREASING');
      }

      return {
        'totalConsumo': totalConsumo,
        'promedioDiario': promedioDiario,
        'consumoPorAve': consumoPorAve,
        'totalRegistros': registrosAsync.length,
        'tendencia': tendencia,
      };
    });

/// Provider para estadísticas de producción de un lote
final registrosProduccionStatsProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, String>((ref, loteId) async {
      final registrosAsync = await ref.watch(
        registrosProduccionPorLoteProvider(loteId).future,
      );

      if (registrosAsync.isEmpty) {
        return {
          'totalHuevos': 0,
          'promedioPostura': 0.0,
          'promedioDiario': 0.0,
          'totalRegistros': 0,
          'porcentajeBuenosPromedio': 0.0,
          'tendencia': 'estable',
        };
      }

      // Total de huevos
      final totalHuevos = registrosAsync.fold<int>(
        0,
        (sum, r) => sum + r.huevosRecolectados,
      );

      // Postura promedio
      final promedioPostura =
          registrosAsync
              .map((r) => r.porcentajePostura)
              .reduce((a, b) => a + b) /
          registrosAsync.length;

      // Calcular días únicos para promedio diario real
      final fechasUnicas = registrosAsync
          .map((r) => DateTime(r.fecha.year, r.fecha.month, r.fecha.day))
          .toSet();
      final diasConRegistro = fechasUnicas.length;
      final promedioDiario = diasConRegistro > 0
          ? totalHuevos / diasConRegistro
          : 0.0;

      // Porcentaje buenos promedio
      final buenosPromedio =
          registrosAsync
              .map((r) => r.porcentajeBuenos)
              .reduce((a, b) => a + b) /
          registrosAsync.length;

      // Calcular tendencia
      final ahora = DateTime.now();
      final registrosRecientes = registrosAsync
          .where((r) => ahora.difference(r.fecha).inDays <= 7)
          .toList();
      final registrosAnteriores = registrosAsync
          .where(
            (r) =>
                ahora.difference(r.fecha).inDays > 7 &&
                ahora.difference(r.fecha).inDays <= 14,
          )
          .toList();

      final posturaReciente = registrosRecientes.isNotEmpty
          ? registrosRecientes
                    .map((r) => r.porcentajePostura)
                    .reduce((a, b) => a + b) /
                registrosRecientes.length
          : 0.0;
      final posturaAnterior = registrosAnteriores.isNotEmpty
          ? registrosAnteriores
                    .map((r) => r.porcentajePostura)
                    .reduce((a, b) => a + b) /
                registrosAnteriores.length
          : 0.0;

      String tendencia = ErrorMessages.get('TREND_STABLE');
      if (posturaReciente > posturaAnterior * 1.05) {
        tendencia = ErrorMessages.get('TREND_INCREASING');
      } else if (posturaReciente < posturaAnterior * 0.95) {
        tendencia = ErrorMessages.get('TREND_DECREASING');
      }

      return {
        'totalHuevos': totalHuevos,
        'promedioPostura': promedioPostura,
        'promedioDiario': promedioDiario,
        'totalRegistros': registrosAsync.length,
        'porcentajeBuenosPromedio': buenosPromedio,
        'tendencia': tendencia,
      };
    });
