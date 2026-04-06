/// Tipos de reportes disponibles en la aplicación.
library;

import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Enum que define los tipos de reportes que se pueden generar.
enum TipoReporte {
  /// Reporte general de producción del lote.
  produccionLote(
    'Producción de Lote',
    'Resumen completo del rendimiento productivo',
  ),

  /// Reporte de mortalidad y análisis de causas.
  mortalidad('Mortalidad', 'Análisis detallado de mortalidad y causas'),

  /// Reporte de consumo de alimento y conversión.
  consumo(
    'Consumo de Alimento',
    'Análisis de consumo y conversión alimenticia',
  ),

  /// Reporte de pesajes y crecimiento.
  peso('Peso y Crecimiento', 'Evolución de peso y curvas de crecimiento'),

  /// Reporte financiero de costos.
  costos('Costos', 'Desglose de gastos y costos operativos'),

  /// Reporte de ventas e ingresos.
  ventas('Ventas', 'Resumen de ventas e ingresos'),

  /// Reporte de rentabilidad y margen.
  rentabilidad('Rentabilidad', 'Análisis de utilidad y márgenes'),

  /// Reporte de salud y tratamientos.
  salud('Salud', 'Historial de tratamientos y vacunaciones'),

  /// Reporte de inventario.
  inventario('Inventario', 'Estado actual del inventario'),

  /// Reporte ejecutivo consolidado.
  ejecutivo('Resumen Ejecutivo', 'Vista consolidada de indicadores clave');

  const TipoReporte(this.nombre, this.descripcion);

  /// Nombre para mostrar del tipo de reporte.
  final String nombre;

  /// Descripción breve del reporte.
  final String descripcion;

  /// Nombre localizado del tipo de reporte
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoReporte.produccionLote =>
        switch (locale) { 'es' => 'Producción de Lote', 'pt' => 'Produção de Lote', _ => 'Batch Production' },
      TipoReporte.mortalidad => switch (locale) { 'es' => 'Mortalidad', 'pt' => 'Mortalidade', _ => 'Mortality' },
      TipoReporte.consumo => switch (locale) { 'es' => 'Consumo de Alimento', 'pt' => 'Consumo de Ração', _ => 'Feed Consumption' },
      TipoReporte.peso => switch (locale) { 'es' => 'Peso y Crecimiento', 'pt' => 'Peso e Crescimento', _ => 'Weight and Growth' },
      TipoReporte.costos => switch (locale) { 'es' => 'Costos', 'pt' => 'Custos', _ => 'Costs' },
      TipoReporte.ventas => switch (locale) { 'es' => 'Ventas', 'pt' => 'Vendas', _ => 'Sales' },
      TipoReporte.rentabilidad => switch (locale) { 'es' => 'Rentabilidad', 'pt' => 'Rentabilidade', _ => 'Profitability' },
      TipoReporte.salud => switch (locale) { 'es' => 'Salud', 'pt' => 'Saúde', _ => 'Health' },
      TipoReporte.inventario => switch (locale) { 'es' => 'Inventario', 'pt' => 'Inventário', _ => 'Inventory' },
      TipoReporte.ejecutivo => switch (locale) { 'es' => 'Resumen Ejecutivo', 'pt' => 'Resumo Executivo', _ => 'Executive Summary' },
    };
  }

  /// Descripción localizada del tipo de reporte
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoReporte.produccionLote =>
        switch (locale) { 'es' => 'Resumen completo del rendimiento productivo', 'pt' => 'Resumo completo do desempenho produtivo', _ => 'Full production performance summary' },
      TipoReporte.mortalidad =>
        switch (locale) { 'es' => 'Análisis detallado de mortalidad y causas', 'pt' => 'Análise detalhada de mortalidade e causas', _ => 'Detailed mortality and cause analysis' },
      TipoReporte.consumo =>
        switch (locale) { 'es' => 'Análisis de consumo y conversión alimenticia', 'pt' => 'Análise de consumo e conversão alimentar', _ => 'Feed consumption and conversion analysis' },
      TipoReporte.peso =>
        switch (locale) { 'es' => 'Evolución de peso y curvas de crecimiento', 'pt' => 'Evolução de peso e curvas de crescimento', _ => 'Weight evolution and growth curves' },
      TipoReporte.costos =>
        switch (locale) { 'es' => 'Desglose de gastos y costos operativos', 'pt' => 'Detalhamento de despesas e custos operacionais', _ => 'Expense and operating cost breakdown' },
      TipoReporte.ventas =>
        switch (locale) { 'es' => 'Resumen de ventas e ingresos', 'pt' => 'Resumo de vendas e receitas', _ => 'Sales and revenue summary' },
      TipoReporte.rentabilidad =>
        switch (locale) { 'es' => 'Análisis de utilidad y márgenes', 'pt' => 'Análise de utilidade e margens', _ => 'Profit and margin analysis' },
      TipoReporte.salud =>
        switch (locale) { 'es' => 'Historial de tratamientos y vacunaciones', 'pt' => 'Histórico de tratamentos e vacinações', _ => 'Treatment and vaccination history' },
      TipoReporte.inventario =>
        switch (locale) { 'es' => 'Estado actual del inventario', 'pt' => 'Estado atual do inventário', _ => 'Current inventory status' },
      TipoReporte.ejecutivo =>
        switch (locale) { 'es' => 'Vista consolidada de indicadores clave', 'pt' => 'Visão consolidada de indicadores-chave', _ => 'Consolidated view of key indicators' },
    };
  }

  /// Indica si el tipo de reporte tiene generación PDF dedicada.
  /// Los tipos no implementados generan el mismo reporte ejecutivo.
  bool get isImplemented => switch (this) {
    TipoReporte.costos ||
    TipoReporte.ventas ||
    TipoReporte.produccionLote ||
    TipoReporte.ejecutivo => true,
    _ => false,
  };

  /// Icono asociado al tipo de reporte (como String de IconData code point).
  int get iconCode {
    switch (this) {
      case TipoReporte.produccionLote:
        return 0xe900; // layers_rounded
      case TipoReporte.mortalidad:
        return 0xe5c9; // trending_down
      case TipoReporte.consumo:
        return 0xe3ab; // restaurant
      case TipoReporte.peso:
        return 0xe25a; // scale
      case TipoReporte.costos:
        return 0xe227; // payments
      case TipoReporte.ventas:
        return 0xe54e; // point_of_sale
      case TipoReporte.rentabilidad:
        return 0xe6da; // analytics
      case TipoReporte.salud:
        return 0xe3f3; // health_and_safety
      case TipoReporte.inventario:
        return 0xf8ee; // inventory_2
      case TipoReporte.ejecutivo:
        return 0xe0ef; // dashboard
    }
  }
}
