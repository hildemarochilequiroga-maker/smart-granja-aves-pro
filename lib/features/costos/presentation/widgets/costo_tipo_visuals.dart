/// Mapeo visual único (color + icono) para cada [TipoGasto].
///
/// Fuente de verdad centralizada para la presentación de tipos de gasto.
/// Antes este mapeo estaba triplicado e inconsistente entre la lista, la card
/// y el detalle; ahora todas las vistas consumen esta extensión.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/enums/tipo_gasto.dart';

/// Acceso a los atributos visuales (color e icono) de un [TipoGasto].
extension TipoGastoVisuals on TipoGasto {
  /// Color representativo del tipo de gasto, consistente en toda la feature.
  Color get color => switch (this) {
    TipoGasto.compraAves => AppColors.teal,
    TipoGasto.alimento => AppColors.warning,
    TipoGasto.manoDeObra => AppColors.info,
    TipoGasto.energia => AppColors.amber,
    TipoGasto.medicamento => AppColors.error,
    TipoGasto.cama => AppColors.brown,
    TipoGasto.mantenimiento => AppColors.purple,
    TipoGasto.agua => AppColors.cyan,
    TipoGasto.transporte => AppColors.success,
    TipoGasto.administrativo => AppColors.outline,
    TipoGasto.depreciacion => AppColors.brown,
    TipoGasto.financiero => AppColors.indigo,
    TipoGasto.otros => AppColors.blueGrey,
  };

  /// Icono representativo del tipo de gasto.
  IconData get icon => switch (this) {
    TipoGasto.compraAves => Icons.egg_rounded,
    TipoGasto.alimento => Icons.restaurant_rounded,
    TipoGasto.manoDeObra => Icons.people_rounded,
    TipoGasto.energia => Icons.bolt_rounded,
    TipoGasto.medicamento => Icons.medical_services_rounded,
    TipoGasto.cama => Icons.grass_rounded,
    TipoGasto.mantenimiento => Icons.build_rounded,
    TipoGasto.agua => Icons.water_drop_rounded,
    TipoGasto.transporte => Icons.local_shipping_rounded,
    TipoGasto.administrativo => Icons.business_rounded,
    TipoGasto.depreciacion => Icons.trending_down_rounded,
    TipoGasto.financiero => Icons.account_balance_rounded,
    TipoGasto.otros => Icons.more_horiz_rounded,
  };
}
