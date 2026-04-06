/// Use Case para crear un nuevo lote de aves.
///
/// Responsabilidades:
/// - Validar que el galpón existe y está disponible
/// - Validar capacidad según tipo de ave
/// - Crear el lote con estado inicial consistente
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lote.dart';
import '../enums/enums.dart';
import '../repositories/lote_repository.dart';

/// Use Case para crear un nuevo lote de aves.
class CrearLoteUseCase {
  final LoteRepository _loteRepository;

  CrearLoteUseCase({required LoteRepository loteRepository})
    : _loteRepository = loteRepository;

  /// Ejecuta la creación del lote.
  Future<Either<Failure, Lote>> call(CrearLoteParams params) async {
    try {
      // 1. Validar cantidad mínima
      if (params.cantidadInicial < 10) {
        return Left(
          ValidationFailure(message: ErrorMessages.get('LOTE_CANTIDAD_MINIMA')),
        );
      }

      // 2. Verificar que no hay otro lote activo en ese galpón
      final lotesEnGalpon = await _loteRepository.obtenerPorGalpon(
        params.galponId,
      );

      final hayError = lotesEnGalpon.fold((failure) => false, (lotes) {
        final hayLoteActivo = lotes.any((l) => l.estado == EstadoLote.activo);
        return hayLoteActivo;
      });

      if (hayError) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('LOTE_ACTIVO_EN_GALPON'),
          ),
        );
      }

      // 3. Generar código si no se proporciona
      final codigo = params.codigo ?? _generarCodigo(params.tipoAve);

      // 4. Crear el lote
      final lote = Lote.nuevo(
        granjaId: params.granjaId,
        galponId: params.galponId,
        tipoAve: params.tipoAve,
        cantidadInicial: params.cantidadInicial,
        codigo: codigo,
        fechaIngreso: params.fechaIngreso ?? DateTime.now(),
        nombre: params.nombre,
        proveedor: params.proveedor,
        raza: params.raza,
        edadIngresoDias: params.edadIngresoDias ?? 0,
        pesoPromedioObjetivo: params.pesoPromedioObjetivo,
        fechaCierreEstimada: params.fechaCierreEstimada,
        costoAveInicial: params.costoAveInicial,
        observaciones: params.observaciones,
      );

      // 5. Persistir el lote
      return await _loteRepository.crear(lote);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message: ErrorMessages.format('ERROR_CREAR_LOTE_UC', {
            'detail': e.toString(),
          }),
        ),
      );
    }
  }

  /// Genera un código único para el lote.
  String _generarCodigo(TipoAve tipoAve) {
    final prefijo = tipoAve.name.substring(0, 3).toUpperCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'LOT-$prefijo-${timestamp.substring(timestamp.length - 6)}';
  }
}

/// Parámetros para CrearLoteUseCase.
class CrearLoteParams extends Equatable {
  final String granjaId;
  final String galponId;
  final int cantidadInicial;
  final TipoAve tipoAve;
  final DateTime? fechaIngreso;
  final String? codigo;
  final String? nombre;
  final String? proveedor;
  final String? raza;
  final int? edadIngresoDias;
  final double? pesoPromedioObjetivo;
  final DateTime? fechaCierreEstimada;
  final double? costoAveInicial;
  final String? observaciones;

  const CrearLoteParams({
    required this.granjaId,
    required this.galponId,
    required this.cantidadInicial,
    required this.tipoAve,
    this.fechaIngreso,
    this.codigo,
    this.nombre,
    this.proveedor,
    this.raza,
    this.edadIngresoDias,
    this.pesoPromedioObjetivo,
    this.fechaCierreEstimada,
    this.costoAveInicial,
    this.observaciones,
  });

  @override
  List<Object?> get props => [
    granjaId,
    galponId,
    cantidadInicial,
    tipoAve,
    fechaIngreso,
    codigo,
    nombre,
    proveedor,
    raza,
    edadIngresoDias,
    pesoPromedioObjetivo,
    fechaCierreEstimada,
    costoAveInicial,
    observaciones,
  ];
}
