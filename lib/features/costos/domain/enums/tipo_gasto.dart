import 'package:smartgranjaavespro/core/utils/formatters.dart';

/// Clasificación de gastos operativos en la granja avícola.
enum TipoGasto {
  alimento('Alimento', 'Concentrados y granos', '#FF9800'),
  manoDeObra('Mano de Obra', 'Salarios y beneficios', '#2196F3'),
  energia('Energía', 'Electricidad y combustible', '#FFC107'),
  medicamento('Medicamento', 'Sanidad animal', '#F44336'),
  mantenimiento('Mantenimiento', 'Reparaciones y limpieza', '#607D8B'),
  agua('Agua', 'Consumo de agua', '#03A9F4'),
  transporte('Transporte', 'Logística y movilización', '#9C27B0'),
  administrativo('Administrativo', 'Gastos generales', '#795548'),
  depreciacion('Depreciación', 'Desgaste de activos', '#9E9E9E'),
  financiero('Financiero', 'Intereses y comisiones', '#E91E63'),
  otros('Otros', 'Gastos varios', '#9E9E9E');

  const TipoGasto(this.nombre, this.descripcion, this.colorHex);

  final String nombre;
  final String descripcion;
  final String colorHex;

  /// Verifica si el gasto es directamente asignable a un lote.
  bool get esDirecto =>
      this == TipoGasto.alimento || this == TipoGasto.medicamento;

  /// Verifica si el gasto es fijo (no varía con producción).
  bool get esFijo =>
      this == TipoGasto.manoDeObra ||
      this == TipoGasto.administrativo ||
      this == TipoGasto.depreciacion;

  /// Verifica si el gasto es variable (varía con producción).
  bool get esVariable => !esFijo;

  /// Verifica si es un gasto monetario (implica salida de efectivo).
  bool get esMonetario => this != TipoGasto.depreciacion;

  /// Nombre del gasto localizado.
  String get displayName {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoGasto.alimento => switch (locale) { 'es' => 'Alimento', 'pt' => 'Ração', _ => 'Feed' },
      TipoGasto.manoDeObra => switch (locale) { 'es' => 'Mano de Obra', 'pt' => 'Mão de Obra', _ => 'Labor' },
      TipoGasto.energia => switch (locale) { 'es' => 'Energía', 'pt' => 'Energia', _ => 'Energy' },
      TipoGasto.medicamento => switch (locale) { 'es' => 'Medicamento', 'pt' => 'Medicamento', _ => 'Medicine' },
      TipoGasto.mantenimiento => switch (locale) { 'es' => 'Mantenimiento', 'pt' => 'Manutenção', _ => 'Maintenance' },
      TipoGasto.agua => switch (locale) { 'es' => 'Agua', 'pt' => 'Água', _ => 'Water' },
      TipoGasto.transporte => switch (locale) { 'es' => 'Transporte', 'pt' => 'Transporte', _ => 'Transport' },
      TipoGasto.administrativo => switch (locale) { 'es' => 'Administrativo', 'pt' => 'Administrativo', _ => 'Administrative' },
      TipoGasto.depreciacion => switch (locale) { 'es' => 'Depreciación', 'pt' => 'Depreciação', _ => 'Depreciation' },
      TipoGasto.financiero => switch (locale) { 'es' => 'Financiero', 'pt' => 'Financeiro', _ => 'Financial' },
      TipoGasto.otros => switch (locale) { 'es' => 'Otros', 'pt' => 'Outros', _ => 'Other' },
    };
  }

  /// Descripción del gasto localizada.
  String get displayDescripcion {
    final locale = Formatters.currentLocale;
    return switch (this) {
      TipoGasto.alimento =>
        switch (locale) { 'es' => 'Concentrados y granos', 'pt' => 'Concentrados e grãos', _ => 'Concentrates and grains' },
      TipoGasto.manoDeObra =>
        switch (locale) { 'es' => 'Salarios y beneficios', 'pt' => 'Salários e benefícios', _ => 'Salaries and benefits' },
      TipoGasto.energia =>
        switch (locale) { 'es' => 'Electricidad y combustible', 'pt' => 'Eletricidade e combustível', _ => 'Electricity and fuel' },
      TipoGasto.medicamento => switch (locale) { 'es' => 'Sanidad animal', 'pt' => 'Sanidade animal', _ => 'Animal health' },
      TipoGasto.mantenimiento =>
        switch (locale) { 'es' => 'Reparaciones y limpieza', 'pt' => 'Reparos e limpeza', _ => 'Repairs and cleaning' },
      TipoGasto.agua => switch (locale) { 'es' => 'Consumo de agua', 'pt' => 'Consumo de água', _ => 'Water consumption' },
      TipoGasto.transporte =>
        switch (locale) { 'es' => 'Logística y movilización', 'pt' => 'Logística e transporte', _ => 'Logistics and transportation' },
      TipoGasto.administrativo =>
        switch (locale) { 'es' => 'Gastos generales', 'pt' => 'Despesas gerais', _ => 'General expenses' },
      TipoGasto.depreciacion =>
        switch (locale) { 'es' => 'Desgaste de activos', 'pt' => 'Desgaste de ativos', _ => 'Asset depreciation' },
      TipoGasto.financiero =>
        switch (locale) { 'es' => 'Intereses y comisiones', 'pt' => 'Juros e comissões', _ => 'Interest and fees' },
      TipoGasto.otros => switch (locale) { 'es' => 'Gastos varios', 'pt' => 'Despesas diversas', _ => 'Miscellaneous expenses' },
    };
  }

  /// Categoría para estado de resultados.
  String get categoriaEstadoResultados {
    final locale = Formatters.currentLocale;
    switch (this) {
      case TipoGasto.alimento:
      case TipoGasto.medicamento:
        return switch (locale) { 'es' => 'Costo de Producción', 'pt' => 'Custo de Produção', _ => 'Production Cost' };
      case TipoGasto.manoDeObra:
        return switch (locale) { 'es' => 'Gastos de Personal', 'pt' => 'Despesas de Pessoal', _ => 'Personnel Expenses' };
      case TipoGasto.energia:
      case TipoGasto.agua:
      case TipoGasto.mantenimiento:
        return switch (locale) { 'es' => 'Gastos Operativos', 'pt' => 'Despesas Operacionais', _ => 'Operating Expenses' };
      case TipoGasto.transporte:
        return switch (locale) { 'es' => 'Gastos de Distribución', 'pt' => 'Despesas de Distribuição', _ => 'Distribution Expenses' };
      case TipoGasto.administrativo:
        return switch (locale) { 'es' => 'Gastos Administrativos', 'pt' => 'Despesas Administrativas', _ => 'Administrative Expenses' };
      case TipoGasto.depreciacion:
        return switch (locale) { 'es' => 'Depreciación y Amortización', 'pt' => 'Depreciação e Amortização', _ => 'Depreciation and Amortization' };
      case TipoGasto.financiero:
        return switch (locale) { 'es' => 'Gastos Financieros', 'pt' => 'Despesas Financeiras', _ => 'Financial Expenses' };
      case TipoGasto.otros:
        return switch (locale) { 'es' => 'Otros Gastos', 'pt' => 'Outras Despesas', _ => 'Other Expenses' };
    }
  }

  String toJson() => name;

  static TipoGasto fromJson(String json) {
    return TipoGasto.values.firstWhere(
      (e) => e.name == json,
      orElse: () => TipoGasto.alimento,
    );
  }
}
