import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../entities/venta_producto.dart';
import '../enums/estado_venta.dart';
import '../enums/tipo_producto_venta.dart';
import '../repositories/venta_repository.dart';

/// Use case para registrar una nueva venta de producto.
///
/// Incluye validaciones de negocio antes de persistir.
class RegistrarVentaProductoUseCase {
  final VentaRepository repository;

  RegistrarVentaProductoUseCase(this.repository);

  Future<Either<Failure, VentaProducto>> call(VentaProducto venta) async {
    try {
      // Validaciones de negocio
      final errorValidacion = _validarVenta(venta);
      if (errorValidacion != null) {
        return Left(
          ValidationFailure(message: errorValidacion, code: 'VALIDACION_VENTA'),
        );
      }

      final ventaGuardada = await repository.registrarVentaProducto(venta);
      return Right(ventaGuardada);
    } on VentaProductoException catch (e) {
      return Left(
        ValidationFailure(message: e.message, code: 'VENTA_EXCEPTION'),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }

  String? _validarVenta(VentaProducto venta) {
    if (venta.loteId.isEmpty) {
      return ErrorMessages.get('VENTA_SELECT_LOTE');
    }
    if (venta.granjaId.isEmpty) {
      return ErrorMessages.get('VENTA_SELECT_GRANJA');
    }
    if (venta.cliente.nombre.isEmpty) {
      return ErrorMessages.get('VENTA_SELECT_CLIENTE');
    }

    // Validaciones específicas por tipo de producto
    switch (venta.tipoProducto) {
      case TipoProductoVenta.avesVivas:
      case TipoProductoVenta.avesDescarte:
        if ((venta.cantidadAves ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_AVES_GREATER_ZERO');
        }
        if ((venta.precioKg ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_PRECIO_KG_GREATER_ZERO');
        }
        break;
      case TipoProductoVenta.avesFaenadas:
        if ((venta.cantidadAves ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_AVES_GREATER_ZERO');
        }
        if ((venta.pesoFaenado ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_PESO_FAENADO_GREATER_ZERO');
        }
        if ((venta.precioKg ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_PRECIO_KG_GREATER_ZERO');
        }
        break;
      case TipoProductoVenta.huevos:
        if (venta.huevosPorClasificacion == null ||
            venta.huevosPorClasificacion!.isEmpty) {
          return ErrorMessages.get('VENTA_HUEVOS_CLASIFICACION');
        }
        if (venta.totalHuevos <= 0) {
          return ErrorMessages.get('VENTA_HUEVOS_TOTAL_GREATER_ZERO');
        }
        break;
      case TipoProductoVenta.pollinaza:
        if ((venta.cantidadPollinaza ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_POLLINAZA_GREATER_ZERO');
        }
        if ((venta.precioUnitarioPollinaza ?? 0) <= 0) {
          return ErrorMessages.get('VENTA_PRECIO_UNITARIO_GREATER_ZERO');
        }
        break;
    }

    return null;
  }
}

/// Use case para actualizar una venta de producto existente.
class ActualizarVentaProductoUseCase {
  final VentaRepository repository;

  ActualizarVentaProductoUseCase(this.repository);

  Future<Either<Failure, Unit>> call(VentaProducto venta) async {
    try {
      // Verificar que la venta existe
      final ventaExistente = await repository.obtenerVentaProductoPorId(
        venta.id,
      );
      if (ventaExistente == null) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VENTA_NOT_EXISTS'),
            code: 'VENTA_NOT_EXISTS',
          ),
        );
      }

      // No permitir modificar ventas completadas o canceladas
      if (ventaExistente.estado.esCompletada ||
          ventaExistente.estado == EstadoVenta.cancelada) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.format('VENTA_CANNOT_MODIFY', {
              'estado': ventaExistente.estado.nombre,
            }),
            code: 'VENTA_CANNOT_MODIFY',
          ),
        );
      }

      await repository.actualizarVentaProducto(venta);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para obtener ventas de producto por lote.
class ObtenerVentasProductoPorLoteUseCase {
  final VentaRepository repository;

  ObtenerVentasProductoPorLoteUseCase(this.repository);

  Future<Either<Failure, List<VentaProducto>>> call(String loteId) async {
    try {
      if (loteId.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VENTA_LOTE_ID_REQUIRED'),
            code: 'VENTA_LOTE_ID_REQUIRED',
          ),
        );
      }

      final ventas = await repository.obtenerVentasProductoPorLote(loteId);
      return Right(ventas);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para obtener todas las ventas de producto.
class ObtenerTodasVentasProductoUseCase {
  final VentaRepository repository;

  ObtenerTodasVentasProductoUseCase(this.repository);

  Future<Either<Failure, List<VentaProducto>>> call() async {
    try {
      final ventas = await repository.obtenerTodasVentasProductos();
      return Right(ventas);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}

/// Use case para eliminar una venta de producto.
class EliminarVentaProductoUseCase {
  final VentaRepository repository;

  EliminarVentaProductoUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String id) async {
    try {
      if (id.isEmpty) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VENTA_ID_REQUIRED'),
            code: 'VENTA_ID_REQUIRED',
          ),
        );
      }

      // Verificar que la venta existe y puede eliminarse
      final venta = await repository.obtenerVentaProductoPorId(id);
      if (venta == null) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VENTA_NOT_EXISTS'),
            code: 'VENTA_NOT_EXISTS',
          ),
        );
      }

      // No permitir eliminar ventas completadas
      if (venta.estado.esCompletada) {
        return Left(
          ValidationFailure(
            message: ErrorMessages.get('VENTA_CANNOT_DELETE_COMPLETED'),
            code: 'VENTA_CANNOT_DELETE_COMPLETED',
          ),
        );
      }

      await repository.eliminarVentaProducto(id);
      return const Right(unit);
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          message:
              '${ErrorMessages.get('GENERIC_SERVER_ERROR')}: ${e.toString()}',
        ),
      );
    }
  }
}
