/// Mapeo visual único (color + icono) para los enums de ventas.
///
/// Fuente de verdad centralizada para la presentación. Antes estos mapeos
/// estaban cuadruplicados e inconsistentes entre la lista, la card, el sheet
/// y el detalle (p. ej. huevos aparecía warning o amber según la vista).
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/enums/estado_venta.dart';
import '../../domain/enums/tipo_producto_venta.dart';

/// Atributos visuales (color e icono) de un [TipoProductoVenta].
extension TipoProductoVentaVisuals on TipoProductoVenta {
  /// Color representativo del producto, consistente en toda la feature.
  Color get color => switch (this) {
    TipoProductoVenta.avesVivas => AppColors.warning,
    TipoProductoVenta.avesFaenadas => AppColors.brown,
    TipoProductoVenta.avesDescarte => AppColors.outline,
    TipoProductoVenta.huevos => AppColors.amber,
    TipoProductoVenta.pollinaza => AppColors.success,
  };

  /// Icono representativo del producto.
  IconData get icon => switch (this) {
    TipoProductoVenta.avesVivas => Icons.pets_rounded,
    TipoProductoVenta.avesFaenadas => Icons.restaurant_rounded,
    TipoProductoVenta.avesDescarte => Icons.low_priority_rounded,
    TipoProductoVenta.huevos => Icons.egg_rounded,
    TipoProductoVenta.pollinaza => Icons.grass_rounded,
  };
}

/// Atributos visuales (color) de un [EstadoVenta].
extension EstadoVentaVisuals on EstadoVenta {
  /// Color representativo del estado.
  ///
  /// Mapea a los colores de la paleta de la app, alineados con el `colorHex`
  /// del dominio para mantener una única identidad visual por estado.
  Color get color => switch (this) {
    EstadoVenta.pendiente => AppColors.warning,
    EstadoVenta.confirmada => AppColors.info,
    EstadoVenta.enPreparacion => AppColors.purple,
    EstadoVenta.listaParaDespacho => AppColors.cyan,
    EstadoVenta.enTransito => AppColors.deepOrange,
    EstadoVenta.entregada => AppColors.success,
    EstadoVenta.facturada => AppColors.lightGreen,
    EstadoVenta.cancelada => AppColors.error,
    EstadoVenta.devuelta => AppColors.pink,
  };
}
