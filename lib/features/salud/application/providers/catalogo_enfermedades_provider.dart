/// Providers para el catálogo de enfermedades avícolas.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/enums/enums.dart';

/// Provider del catálogo completo de enfermedades.
final catalogoEnfermedadesProvider = Provider<List<EnfermedadAvicola>>((ref) {
  return EnfermedadAvicola.values;
});

/// Provider de enfermedades filtradas por categoría.
final enfermedadesPorCategoriaProvider =
    Provider.family<List<EnfermedadAvicola>, CategoriaEnfermedad>((
      ref,
      categoria,
    ) {
      return EnfermedadAvicola.values
          .where((e) => e.categoria == categoria)
          .toList();
    });

/// Provider de enfermedades por severidad.
final enfermedadesPorGravedadProvider =
    Provider.family<List<EnfermedadAvicola>, GravedadEnfermedad>((
      ref,
      gravedad,
    ) {
      return EnfermedadAvicola.values
          .where((e) => e.gravedad == gravedad)
          .toList();
    });

/// Provider de enfermedades de notificación obligatoria.
final enfermedadesNotificacionObligatoriaProvider =
    Provider<List<EnfermedadAvicola>>((ref) {
      return EnfermedadAvicola.values
          .where((e) => e.esNotificacionObligatoria)
          .toList();
    });

/// Provider de enfermedades prevenibles por vacunación.
final enfermedadesPreveniblesVacunacionProvider =
    Provider<List<EnfermedadAvicola>>((ref) {
      return EnfermedadAvicola.values
          .where((e) => e.esPreveniblePorVacuna)
          .toList();
    });

/// Estado para búsqueda de enfermedades.
class BusquedaEnfermedadesState {
  final String termino;
  final CategoriaEnfermedad? categoriaFiltro;
  final GravedadEnfermedad? gravedadFiltro;
  final List<EnfermedadAvicola> resultados;

  const BusquedaEnfermedadesState({
    this.termino = '',
    this.categoriaFiltro,
    this.gravedadFiltro,
    this.resultados = const [],
  });

  BusquedaEnfermedadesState copyWith({
    String? termino,
    CategoriaEnfermedad? categoriaFiltro,
    GravedadEnfermedad? gravedadFiltro,
    List<EnfermedadAvicola>? resultados,
  }) {
    return BusquedaEnfermedadesState(
      termino: termino ?? this.termino,
      categoriaFiltro: categoriaFiltro ?? this.categoriaFiltro,
      gravedadFiltro: gravedadFiltro ?? this.gravedadFiltro,
      resultados: resultados ?? this.resultados,
    );
  }
}

/// Notifier para búsqueda y filtrado de enfermedades.
class BusquedaEnfermedadesNotifier
    extends StateNotifier<BusquedaEnfermedadesState> {
  BusquedaEnfermedadesNotifier()
    : super(
        const BusquedaEnfermedadesState(resultados: EnfermedadAvicola.values),
      );

  /// Busca enfermedades por término.
  void buscar(String termino) {
    state = state.copyWith(termino: termino);
    _aplicarFiltros();
  }

  /// Filtra por categoría.
  void filtrarPorCategoria(CategoriaEnfermedad? categoria) {
    state = state.copyWith(categoriaFiltro: categoria);
    _aplicarFiltros();
  }

  /// Filtra por gravedad.
  void filtrarPorGravedad(GravedadEnfermedad? gravedad) {
    state = state.copyWith(gravedadFiltro: gravedad);
    _aplicarFiltros();
  }

  /// Limpia todos los filtros.
  void limpiarFiltros() {
    state = const BusquedaEnfermedadesState(
      resultados: EnfermedadAvicola.values,
    );
  }

  void _aplicarFiltros() {
    var resultados = EnfermedadAvicola.values.toList();

    // Filtrar por término de búsqueda
    if (state.termino.isNotEmpty) {
      final terminoLower = state.termino.toLowerCase();
      resultados = resultados.where((e) {
        return e.nombreComun.toLowerCase().contains(terminoLower) ||
            e.nombreCientifico.toLowerCase().contains(terminoLower) ||
            e.agenteCausal.toLowerCase().contains(terminoLower) ||
            e.sintomasPrincipales.any(
              (s) => s.toLowerCase().contains(terminoLower),
            );
      }).toList();
    }

    // Filtrar por categoría
    if (state.categoriaFiltro != null) {
      resultados = resultados
          .where((e) => e.categoria == state.categoriaFiltro)
          .toList();
    }

    // Filtrar por gravedad
    if (state.gravedadFiltro != null) {
      resultados = resultados
          .where((e) => e.gravedad == state.gravedadFiltro)
          .toList();
    }

    state = state.copyWith(resultados: resultados);
  }
}

/// Provider del notifier de búsqueda de enfermedades.
final busquedaEnfermedadesProvider =
    StateNotifierProvider.autoDispose<
      BusquedaEnfermedadesNotifier,
      BusquedaEnfermedadesState
    >((ref) => BusquedaEnfermedadesNotifier());
