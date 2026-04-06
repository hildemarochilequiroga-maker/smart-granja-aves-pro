library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../enums/enums.dart';
import '../repositories/granja_repository.dart';

/// Orden de granjas
enum OrdenGranja {
  nombreAsc,
  nombreDesc,
  fechaCreacionAsc,
  fechaCreacionDesc,
  estadoAsc,
  estadoDesc,
}

/// Use Case para buscar granjas con filtros
class BuscarGranjasUseCase
    implements UseCase<List<Granja>, BuscarGranjasParams> {
  BuscarGranjasUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, List<Granja>>> call(BuscarGranjasParams params) async {
    try {
      Either<Failure, List<Granja>> result;

      // Obtener granjas según filtros
      if (params.estado != null) {
        result = await repository.obtenerPorEstado(
          params.usuarioId,
          params.estado!,
        );
      } else if (params.nombre != null && params.nombre!.isNotEmpty) {
        result = await repository.buscarPorNombre(
          params.usuarioId,
          params.nombre!,
        );
      } else {
        result = await repository.obtenerPorUsuario(params.usuarioId);
      }

      return result.fold((failure) => Left(failure), (granjas) {
        // Ordenar resultados
        final granjasOrdenadas = _ordenarGranjas(granjas, params.ordenarPor);
        return Right(granjasOrdenadas);
      });
    } on Exception catch (e) {
      return Left(
        ServerFailure(message: '${ErrorMessages.get('ERROR_BUSCAR_GRANJAS')}: ${e.toString()}'),
      );
    }
  }

  List<Granja> _ordenarGranjas(List<Granja> granjas, OrdenGranja? orden) {
    if (orden == null) return granjas;

    final lista = List<Granja>.from(granjas);

    switch (orden) {
      case OrdenGranja.nombreAsc:
        lista.sort((a, b) => a.nombre.compareTo(b.nombre));
      case OrdenGranja.nombreDesc:
        lista.sort((a, b) => b.nombre.compareTo(a.nombre));
      case OrdenGranja.fechaCreacionAsc:
        lista.sort((a, b) => a.fechaCreacion.compareTo(b.fechaCreacion));
      case OrdenGranja.fechaCreacionDesc:
        lista.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
      case OrdenGranja.estadoAsc:
        lista.sort((a, b) => a.estado.index.compareTo(b.estado.index));
      case OrdenGranja.estadoDesc:
        lista.sort((a, b) => b.estado.index.compareTo(a.estado.index));
    }

    return lista;
  }
}

/// Parámetros para buscar granjas
class BuscarGranjasParams extends Equatable {
  const BuscarGranjasParams({
    required this.usuarioId,
    this.nombre,
    this.estado,
    this.ordenarPor,
  });

  final String usuarioId;
  final String? nombre;
  final EstadoGranja? estado;
  final OrdenGranja? ordenarPor;

  @override
  List<Object?> get props => [usuarioId, nombre, estado, ordenarPor];
}
