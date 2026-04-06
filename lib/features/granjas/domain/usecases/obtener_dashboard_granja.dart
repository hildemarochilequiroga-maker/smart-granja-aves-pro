library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../galpones/domain/repositories/galpon_repository.dart';
import '../../../lotes/domain/repositories/lote_repository.dart';
import '../repositories/granja_repository.dart';

/// Use Case para obtener dashboard completo de una granja.
///
/// **Responsabilidad:** Agregar datos de múltiples fuentes para mostrar
/// el estado general de una granja.
///
/// **Fuentes de Datos:**
/// - GranjaRepository: Datos básicos y configuración
/// - LoteRepository: Lotes activos y cantidad de aves
/// - GalponRepository: Estado de galpones
///
/// **Lógica de Negocio:**
/// - Calcula ocupación total (aves/capacidad)
/// - Identifica alertas (sobrepoblación, datos desactualizados)
/// - Agrupa estadísticas por secciones
class ObtenerDashboardGranjaUseCase
    implements UseCase<Map<String, dynamic>, String> {
  const ObtenerDashboardGranjaUseCase({
    required this.granjaRepository,
    required this.loteRepository,
    required this.galponRepository,
  });

  final GranjaRepository granjaRepository;
  final LoteRepository loteRepository;
  final GalponRepository galponRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String granjaId) async {
    try {
      final granjaResult = await granjaRepository.obtenerPorId(granjaId);

      return await granjaResult.fold((failure) => Left(failure), (
        granja,
      ) async {
        if (granja == null) {
          return Left(
            ServerFailure(
              message: ErrorMessages.get('GRANJA_NO_ENCONTRADA_DASHBOARD'),
              code: 'GRANJA_NOT_FOUND',
            ),
          );
        }

        // Obtener lotes activos
        final lotesActivosResult = await loteRepository.obtenerActivos(
          granjaId,
        );

        return await lotesActivosResult.fold((failure) => Left(failure), (
          lotesActivos,
        ) async {
          var totalAves = 0;
          for (final lote in lotesActivos) {
            totalAves += lote.avesActuales;
          }

          // Obtener galpones
          final galponesResult = await galponRepository.obtenerPorGranja(
            granjaId,
          );

          return galponesResult.fold((failure) => Left(failure), (galpones) {
            final galponesActivos = galpones.where((g) => g.estaActivo).length;
            final galponesEnMantenimiento = galpones
                .where((g) => g.estaEnMantenimiento)
                .length;

            final capacidadMaxima = granja.capacidadTotalAves ?? 0;
            final porcentajeOcupacion = capacidadMaxima > 0
                ? (totalAves / capacidadMaxima) * 100
                : 0.0;

            final dashboard = {
              'granja': {
                'id': granja.id,
                'nombre': granja.nombre,
                'estado': granja.estado.displayName,
                'propietario': granja.propietarioNombre,
              },
              'capacidad': {
                'totalAves': totalAves,
                'capacidadMaxima': capacidadMaxima,
                'porcentajeOcupacion': porcentajeOcupacion,
                'densidadPromedio': granja.densidadPromedioAvesM2,
              },
              'lotes': {'activos': lotesActivos.length, 'totalAves': totalAves},
              'galpones': {
                'total': galpones.length,
                'activos': galponesActivos,
                'enMantenimiento': galponesEnMantenimiento,
              },
              'alertas': {
                'sobrepoblacion': totalAves > capacidadMaxima,
                'datosDesactualizados': granja.datosDesactualizados,
                'sinLotes': lotesActivos.isEmpty && galpones.isNotEmpty,
              },
            };

            return Right(dashboard);
          });
        });
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_OBTENER_DASHBOARD')}: ${e.toString()}'),
      );
    }
  }
}
