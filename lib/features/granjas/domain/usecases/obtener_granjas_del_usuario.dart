library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/entities.dart';
import '../repositories/granja_repository.dart';

/// Use Case para obtener todas las granjas del usuario
class ObtenerGranjasDelUsuarioUseCase implements UseCase<List<Granja>, String> {
  ObtenerGranjasDelUsuarioUseCase({required this.repository});

  final GranjaRepository repository;

  @override
  Future<Either<Failure, List<Granja>>> call(String usuarioId) async {
    return repository.obtenerPorUsuario(usuarioId);
  }
}
