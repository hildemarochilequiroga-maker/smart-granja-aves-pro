library;

/// Rutas de la aplicación
abstract final class AppRoutes {
  const AppRoutes._();

  // ============================================================================
  // RUTAS BASE
  // ============================================================================
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  // ============================================================================
  // SHELL PRINCIPAL (Bottom Navigation)
  // ============================================================================
  static const String granjasHome = '/granjas-home';
  static const String lotesHome = '/lotes-home';
  static const String perfilHome = '/perfil';

  // ============================================================================
  // AUTENTICACIÓN
  // ============================================================================
  static const String authGate = '/auth/gate';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // ============================================================================
  // DASHBOARD
  // ============================================================================
  static const String dashboard = '/dashboard';
  static const String notificaciones = '/notificaciones';

  // ============================================================================
  // GRANJAS
  // ============================================================================
  static const String granjas = '/granjas';
  static const String granjaDetalle = '/granjas/:id';
  static const String granjaCrear = '/granjas/crear';
  static const String granjaEditar = '/granjas/:id/editar';
  static const String granjaColaboradores = '/granjas/:id/colaboradores';
  static const String granjaInvitar = '/granjas/:id/invitar';
  static const String granjaInvitacionCodigo = '/granjas/:id/invitacion-codigo';
  static const String aceptarInvitacion = '/invitacion/aceptar';

  static String granjaDetalleById(String id) => '/granjas/$id';
  static String granjaEditarById(String id) => '/granjas/$id/editar';
  static String granjaColaboradoresById(String id) =>
      '/granjas/$id/colaboradores';
  static String granjaInvitarById(String id) => '/granjas/$id/invitar';
  static String granjaInvitacionCodigoById(String id) =>
      '/granjas/$id/invitacion-codigo';
  static String aceptarInvitacionConCodigo(String? codigo) => codigo != null
      ? '/invitacion/aceptar?codigo=$codigo'
      : '/invitacion/aceptar';

  // ============================================================================
  // GALPONES (Anidados dentro de granjas)
  // ============================================================================
  static const String galpones = '/granjas/:granjaId/galpones';
  static const String galponDetalle = '/granjas/:granjaId/galpones/:id';
  static const String galponCrear = '/granjas/:granjaId/galpones/crear';
  static const String galponEditar = '/granjas/:granjaId/galpones/:id/editar';

  static String galponesPorGranja(String granjaId) =>
      '/granjas/$granjaId/galpones';
  static String galponDetalleById(String granjaId, String galponId) =>
      '/granjas/$granjaId/galpones/$galponId';
  static String galponCrearEnGranja(String granjaId) =>
      '/granjas/$granjaId/galpones/crear';
  static String galponEditarById(String granjaId, String galponId) =>
      '/granjas/$granjaId/galpones/$galponId/editar';

  // ============================================================================
  // LOTES (Anidados dentro de galpones)
  // ============================================================================
  static const String lotes = '/granjas/:granjaId/galpones/:galponId/lotes';
  static const String loteDetalle =
      '/granjas/:granjaId/galpones/:galponId/lotes/:id';
  static const String loteDashboard = '/granjas/:granjaId/lotes/:id/dashboard';
  static const String loteCrear =
      '/granjas/:granjaId/galpones/:galponId/lotes/crear';
  static const String loteEditar =
      '/granjas/:granjaId/galpones/:galponId/lotes/:id/editar';
  static const String loteCerrar =
      '/granjas/:granjaId/galpones/:galponId/lotes/:id/cerrar';
  static const String loteRegistros =
      '/granjas/:granjaId/galpones/:galponId/lotes/:id/registros';
  static const String loteRegistrarPeso =
      '/granjas/:granjaId/lotes/:id/registrar-peso';
  static const String loteRegistrarConsumo =
      '/granjas/:granjaId/lotes/:id/registrar-consumo';
  static const String loteRegistrarMortalidad =
      '/granjas/:granjaId/lotes/:id/registrar-mortalidad';
  static const String loteRegistrarProduccion =
      '/granjas/:granjaId/lotes/:id/registrar-produccion';
  static const String loteHistorialPeso =
      '/granjas/:granjaId/lotes/:id/historial-peso';
  static const String loteHistorialConsumo =
      '/granjas/:granjaId/lotes/:id/historial-consumo';
  static const String loteHistorialMortalidad =
      '/granjas/:granjaId/lotes/:id/historial-mortalidad';
  static const String loteHistorialProduccion =
      '/granjas/:granjaId/lotes/:id/historial-produccion';
  static const String loteGraficosPeso =
      '/granjas/:granjaId/lotes/:id/graficos-peso';
  static const String loteGraficosConsumo =
      '/granjas/:granjaId/lotes/:id/graficos-consumo';
  static const String loteGraficosMortalidad =
      '/granjas/:granjaId/lotes/:id/graficos-mortalidad';
  static const String loteGraficosProduccion =
      '/granjas/:granjaId/lotes/:id/graficos-produccion';
  static const String loteGuiasManejo =
      '/granjas/:granjaId/lotes/:id/guias-manejo';

  static String lotesPorGalpon(String granjaId, String galponId) =>
      '/granjas/$granjaId/galpones/$galponId/lotes';
  static String loteDetalleById(
    String granjaId,
    String galponId,
    String loteId,
  ) => '/granjas/$granjaId/galpones/$galponId/lotes/$loteId';
  static String loteDashboardById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/dashboard';
  static String loteCrearEnGalpon(String granjaId, String galponId) =>
      '/granjas/$granjaId/galpones/$galponId/lotes/crear';
  static String loteEditarById(
    String granjaId,
    String galponId,
    String loteId,
  ) => '/granjas/$granjaId/galpones/$galponId/lotes/$loteId/editar';
  static String loteCerrarById(
    String granjaId,
    String galponId,
    String loteId,
  ) => '/granjas/$granjaId/galpones/$galponId/lotes/$loteId/cerrar';
  static String loteRegistrosById(
    String granjaId,
    String galponId,
    String loteId,
  ) => '/granjas/$granjaId/galpones/$galponId/lotes/$loteId/registros';
  static String loteRegistrarPesoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/registrar-peso';
  static String loteRegistrarConsumoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/registrar-consumo';
  static String loteRegistrarMortalidadById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/registrar-mortalidad';
  static String loteRegistrarProduccionById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/registrar-produccion';
  static String loteHistorialPesoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/historial-peso';
  static String loteHistorialConsumoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/historial-consumo';
  static String loteHistorialMortalidadById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/historial-mortalidad';
  static String loteHistorialProduccionById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/historial-produccion';
  static String loteGraficosPesoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/graficos-peso';
  static String loteGraficosConsumoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/graficos-consumo';
  static String loteGraficosMortalidadById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/graficos-mortalidad';
  static String loteGraficosProduccionById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/graficos-produccion';
  static String loteGuiasManejoById(String granjaId, String loteId) =>
      '/granjas/$granjaId/lotes/$loteId/guias-manejo';

  // ============================================================================
  // SALUD
  // ============================================================================
  static const String salud = '/salud';
  static const String saludPorLote = '/salud/lote/:loteId';
  static const String saludDetalle = '/salud/:id';
  static const String vacunaciones = '/vacunaciones';
  static const String vacunacionesPorLote = '/vacunaciones/lote/:loteId';
  static const String vacunacionDetalle = '/vacunaciones/:id';
  static const String registrarTratamiento = '/salud/registrar';
  static const String programarVacunacion = '/vacunaciones/programar';

  // Nuevas rutas profesionales de salud avícola
  static const String catalogoEnfermedades = '/salud/enfermedades';
  static const String inspeccionBioseguridad = '/salud/bioseguridad/:granjaId';
  static const String nuevaInspeccionBioseguridad =
      '/salud/bioseguridad/:granjaId/nueva';

  // Helper simple para bioseguridad
  static String bioseguridadPorGranja(String granjaId) =>
      '/salud/bioseguridad/$granjaId';

  static String saludPorLoteId(String loteId, String granjaId) =>
      '/salud/lote/$loteId?granjaId=$granjaId';
  static String saludDetalleById(String id) => '/salud/$id';
  static String vacunacionesPorLoteId(String loteId, String granjaId) =>
      '/vacunaciones/lote/$loteId?granjaId=$granjaId';
  static String vacunacionDetalleById(String id) => '/vacunaciones/$id';
  static String registrarTratamientoConLote(String loteId, String granjaId) =>
      '/salud/registrar?loteId=$loteId&granjaId=$granjaId';
  static String programarVacunacionConLote(String loteId, String granjaId) =>
      '/vacunaciones/programar?loteId=$loteId&granjaId=$granjaId';

  // Nuevas rutas profesionales de salud avícola - helpers
  static String inspeccionBioseguridadPorGranja(
    String granjaId, {
    String? inspectorId,
    String? inspectorNombre,
    String? galponId,
  }) {
    final params = <String>[];
    if (inspectorId != null) params.add('inspectorId=$inspectorId');
    if (inspectorNombre != null) {
      params.add('inspectorNombre=${Uri.encodeComponent(inspectorNombre)}');
    }
    if (galponId != null) params.add('galponId=$galponId');
    final query = params.isNotEmpty ? '?${params.join('&')}' : '';
    return '/salud/bioseguridad/$granjaId$query';
  }

  static String nuevaInspeccionBioseguridadPorGranja(
    String granjaId, {
    String? inspectorId,
    String? inspectorNombre,
    String? galponId,
  }) {
    final params = <String>[];
    if (inspectorId != null) params.add('inspectorId=$inspectorId');
    if (inspectorNombre != null) {
      params.add('inspectorNombre=${Uri.encodeComponent(inspectorNombre)}');
    }
    if (galponId != null) params.add('galponId=$galponId');
    final query = params.isNotEmpty ? '?${params.join('&')}' : '';
    return '/salud/bioseguridad/$granjaId/nueva$query';
  }

  // ============================================================================
  // COSTOS
  // ============================================================================
  static const String costos = '/costos';
  static const String costosPorLote = '/costos/lote/:loteId';
  static const String costoRegistrar = '/costos/registrar';
  static const String costoDetalle = '/costos/:id';

  static String costosPorLoteId(String loteId) => '/costos/lote/$loteId';
  static String costoDetalleById(String id) => '/costos/$id';
  static String costoRegistrarConLote(String loteId, String granjaId) =>
      '/costos/registrar?loteId=$loteId&granjaId=$granjaId';

  // ============================================================================
  // VENTAS
  // ============================================================================
  static const String ventas = '/ventas';
  static const String ventasPorLote = '/ventas/lote/:loteId';
  static const String ventaRegistrar = '/ventas/registrar';
  static const String ventaDetalle = '/ventas/:id';
  static const String ventaEditar = '/ventas/:id/editar';

  static String ventasPorLoteId(String loteId) => '/ventas/lote/$loteId';
  static String ventaDetalleById(String id) => '/ventas/$id';
  static String ventaEditarById(String id) => '/ventas/$id/editar';
  static String ventaRegistrarConLote(String loteId, String granjaId) =>
      '/ventas/registrar?loteId=$loteId&granjaId=$granjaId';

  // ============================================================================
  // REPORTES
  // ============================================================================
  static const String reportes = '/reportes';

  // ============================================================================
  // INVENTARIO
  // ============================================================================
  static const String inventario = '/inventario';
  static const String inventarioCrearItem = '/inventario/crear';
  static const String inventarioItemDetalle = '/inventario/item/:id';
  static const String inventarioEditarItem = '/inventario/item/:id/editar';
  static const String inventarioPorGranja = '/inventario/granja/:granjaId';
  static const String inventarioHistorialMovimientos =
      '/inventario/item/:id/movimientos';

  static String inventarioPorGranjaId(String granjaId) =>
      '/inventario/granja/$granjaId';
  static String inventarioItemDetalleById(String id) => '/inventario/item/$id';
  static String inventarioEditarItemById(String id) =>
      '/inventario/item/$id/editar';
  static String inventarioCrearItemConGranja(String granjaId) =>
      '/inventario/crear?granjaId=$granjaId';
  static String inventarioHistorialMovimientosById(String id) =>
      '/inventario/item/$id/movimientos';

  // ============================================================================
  // CONFIGURACIÓN Y PERFIL
  // ============================================================================
  static const String configuracion = '/configuracion';
  static const String editarPerfil = '/perfil/editar';
  static const String notificacionesConfig = '/configuracion/notificaciones';

  // ============================================================================
  // VETERINARIO VIRTUAL (IA)
  // ============================================================================
  static const String veterinarioVirtual = '/veterinario-virtual';
  static const String veterinarioChat = '/veterinario-virtual/chat';

  // ============================================================================
  // LEGAL
  // ============================================================================
  static const String legalPrivacidad = '/legal/privacidad';
  static const String legalTerminos = '/legal/terminos';

  // ============================================================================
  // ERRORES
  // ============================================================================
  static const String error = '/error';
}
