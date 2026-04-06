/// Tipos de movimientos en el inventario.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Clasificación de movimientos de inventario.
enum TipoMovimiento {
  /// Entrada por compra.
  compra('Compra', 'Ingreso por adquisición', true),

  /// Entrada por donación o transferencia.
  donacion('Donación', 'Ingreso por donación', true),

  /// Entrada por devolución.
  devolucion('Devolución', 'Ingreso por devolución de uso', true),

  /// Entrada por ajuste positivo.
  ajustePositivo('Ajuste (+)', 'Ajuste de inventario positivo', true),

  /// Salida por consumo en lote.
  consumoLote('Consumo Lote', 'Salida por alimentación de aves', false),

  /// Salida por tratamiento médico.
  tratamiento('Tratamiento', 'Salida por aplicación de medicamento', false),

  /// Salida por vacunación.
  vacunacion('Vacunación', 'Salida por aplicación de vacuna', false),

  /// Salida por merma o pérdida.
  merma('Merma', 'Pérdida por deterioro o vencimiento', false),

  /// Salida por ajuste negativo.
  ajusteNegativo('Ajuste (-)', 'Ajuste de inventario negativo', false),

  /// Salida por transferencia.
  transferencia('Transferencia', 'Traslado a otra ubicación', false),

  /// Salida por uso general.
  usoGeneral('Uso General', 'Salida por uso operativo', false),

  /// Salida por venta de productos.
  venta('Venta', 'Salida por venta de productos', false);

  const TipoMovimiento(this.nombre, this.descripcion, this.esEntrada);

  /// Nombre legible.
  final String nombre;

  /// Descripción del movimiento.
  final String descripcion;

  /// true = entrada (suma stock), false = salida (resta stock).
  final bool esEntrada;

  /// Verifica si es una salida.
  bool get esSalida => !esEntrada;

  /// Nombre del movimiento localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoMovimiento.compra => switch (locale) { 'es' => 'Compra', 'pt' => 'Compra', _ => 'Purchase' },
      TipoMovimiento.donacion => switch (locale) { 'es' => 'Donación', 'pt' => 'Doação', _ => 'Donation' },
      TipoMovimiento.devolucion => switch (locale) { 'es' => 'Devolución', 'pt' => 'Devolução', _ => 'Return' },
      TipoMovimiento.ajustePositivo => switch (locale) { 'es' => 'Ajuste (+)', 'pt' => 'Ajuste (+)', _ => 'Adjustment (+)' },
      TipoMovimiento.consumoLote => switch (locale) { 'es' => 'Consumo Lote', 'pt' => 'Consumo Lote', _ => 'Batch Consumption' },
      TipoMovimiento.tratamiento => switch (locale) { 'es' => 'Tratamiento', 'pt' => 'Tratamento', _ => 'Treatment' },
      TipoMovimiento.vacunacion => switch (locale) { 'es' => 'Vacunación', 'pt' => 'Vacinação', _ => 'Vaccination' },
      TipoMovimiento.merma => switch (locale) { 'es' => 'Merma', 'pt' => 'Perda', _ => 'Shrinkage' },
      TipoMovimiento.ajusteNegativo => switch (locale) { 'es' => 'Ajuste (-)', 'pt' => 'Ajuste (-)', _ => 'Adjustment (-)' },
      TipoMovimiento.transferencia => switch (locale) { 'es' => 'Transferencia', 'pt' => 'Transferência', _ => 'Transfer' },
      TipoMovimiento.usoGeneral => switch (locale) { 'es' => 'Uso General', 'pt' => 'Uso Geral', _ => 'General Use' },
      TipoMovimiento.venta => switch (locale) { 'es' => 'Venta', 'pt' => 'Venda', _ => 'Sale' },
    };
  }

  /// Descripción del movimiento localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoMovimiento.compra =>
        switch (locale) { 'es' => 'Ingreso por adquisición', 'pt' => 'Entrada por aquisição', _ => 'Entry by acquisition' },
      TipoMovimiento.donacion =>
        switch (locale) { 'es' => 'Ingreso por donación', 'pt' => 'Entrada por doação', _ => 'Entry by donation' },
      TipoMovimiento.devolucion =>
        switch (locale) { 'es' => 'Ingreso por devolución de uso', 'pt' => 'Entrada por devolução de uso', _ => 'Entry by return of use' },
      TipoMovimiento.ajustePositivo =>
        switch (locale) { 'es' => 'Ajuste de inventario positivo', 'pt' => 'Ajuste de inventário positivo', _ => 'Positive inventory adjustment' },
      TipoMovimiento.consumoLote =>
        switch (locale) { 'es' => 'Salida por alimentación de aves', 'pt' => 'Saída para alimentação de aves', _ => 'Exit for bird feeding' },
      TipoMovimiento.tratamiento =>
        switch (locale) { 'es' => 'Salida por aplicación de medicamento', 'pt' => 'Saída para aplicação de medicamento', _ => 'Exit for medicine application' },
      TipoMovimiento.vacunacion =>
        switch (locale) { 'es' => 'Salida por aplicación de vacuna', 'pt' => 'Saída para aplicação de vacina', _ => 'Exit for vaccine application' },
      TipoMovimiento.merma =>
        switch (locale) { 'es' => 'Pérdida por deterioro o vencimiento', 'pt' => 'Perda por deterioração ou vencimento', _ => 'Loss from deterioration or expiry' },
      TipoMovimiento.ajusteNegativo =>
        switch (locale) { 'es' => 'Ajuste de inventario negativo', 'pt' => 'Ajuste de inventário negativo', _ => 'Negative inventory adjustment' },
      TipoMovimiento.transferencia =>
        switch (locale) { 'es' => 'Traslado a otra ubicación', 'pt' => 'Transferência para outra localização', _ => 'Transfer to another location' },
      TipoMovimiento.usoGeneral =>
        switch (locale) { 'es' => 'Salida por uso operativo', 'pt' => 'Saída para uso operacional', _ => 'Exit for operational use' },
      TipoMovimiento.venta =>
        switch (locale) { 'es' => 'Salida por venta de productos', 'pt' => 'Saída por venda de produtos', _ => 'Exit for product sales' },
    };
  }

  /// Serialización a JSON.
  String toJson() => name;

  /// Deserialización desde JSON.
  static TipoMovimiento fromJson(String json) {
    return TipoMovimiento.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoMovimiento.usoGeneral,
    );
  }
}
