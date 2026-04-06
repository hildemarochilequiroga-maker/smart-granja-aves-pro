library;

/// **Estado de estadísticas de granjas.**
///
/// **Propósito:** Contener las estadísticas agregadas de todas las granjas.
///
/// **Uso:** Se utiliza en la vista principal de granjas para mostrar
/// información general del sistema.
class GranjaStatsState {
  const GranjaStatsState({
    required this.totalGranjas,
    required this.granjasActivas,
    required this.capacidadTotal,
    required this.areaTotalHa,
    required this.avesActuales,
    required this.porcentajeOcupacion,
  });

  final int totalGranjas;
  final int granjasActivas;
  final int capacidadTotal;
  final double areaTotalHa;
  final int avesActuales;
  final double porcentajeOcupacion;

  @override
  String toString() {
    return 'GranjaStatsState('
        'totalGranjas: $totalGranjas, '
        'granjasActivas: $granjasActivas, '
        'capacidadTotal: $capacidadTotal, '
        'areaTotalHa: $areaTotalHa, '
        'avesActuales: $avesActuales, '
        'porcentajeOcupacion: $porcentajeOcupacion'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GranjaStatsState &&
        other.totalGranjas == totalGranjas &&
        other.granjasActivas == granjasActivas &&
        other.capacidadTotal == capacidadTotal &&
        other.areaTotalHa == areaTotalHa &&
        other.avesActuales == avesActuales &&
        other.porcentajeOcupacion == porcentajeOcupacion;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalGranjas,
      granjasActivas,
      capacidadTotal,
      areaTotalHa,
      avesActuales,
      porcentajeOcupacion,
    );
  }

  GranjaStatsState copyWith({
    int? totalGranjas,
    int? granjasActivas,
    int? capacidadTotal,
    double? areaTotalHa,
    int? avesActuales,
    double? porcentajeOcupacion,
  }) {
    return GranjaStatsState(
      totalGranjas: totalGranjas ?? this.totalGranjas,
      granjasActivas: granjasActivas ?? this.granjasActivas,
      capacidadTotal: capacidadTotal ?? this.capacidadTotal,
      areaTotalHa: areaTotalHa ?? this.areaTotalHa,
      avesActuales: avesActuales ?? this.avesActuales,
      porcentajeOcupacion: porcentajeOcupacion ?? this.porcentajeOcupacion,
    );
  }
}
