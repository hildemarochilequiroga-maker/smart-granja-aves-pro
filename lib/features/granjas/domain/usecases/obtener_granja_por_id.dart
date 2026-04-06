library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';

/// Use Case para obtener una granja por ID
class ObtenerGranjaPorIdUseCase implements UseCase<Granja?, String> {
  ObtenerGranjaPorIdUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, Granja?>> call(String granjaId) async {
    return repository.obtenerPorId(granjaId);
  }
}
