library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../errors/error_messages.dart';
import '../../l10n/app_localizations.dart';
import '../../features/auth/presentation/pages/pages.dart';
import '../../features/costos/presentation/pages/costos_list_page.dart';
import '../../features/costos/presentation/pages/registrar_costo_page.dart';
import '../../features/costos/presentation/pages/costo_detail_page.dart';
import '../../features/ventas/presentation/pages/ventas_list_page.dart';
import '../../features/ventas/presentation/pages/registrar_venta_page.dart';
import '../../features/ventas/presentation/pages/venta_detail_page.dart';
import '../../features/ventas/presentation/pages/editar_venta_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/inventario/presentation/pages/pages.dart';
import '../../features/inventario/domain/entities/entities.dart';
import '../../features/perfil/presentation/pages/perfil_page.dart';
import '../../features/perfil/presentation/pages/editar_perfil_page.dart';
import '../../features/perfil/presentation/pages/configuracion_page.dart';
import '../../features/perfil/presentation/pages/notificaciones_config_page.dart';
import '../../features/reportes/presentation/pages/reportes_page.dart';
import '../../features/salud/presentation/pages/salud_list_page.dart';
import '../../features/salud/presentation/pages/salud_detail_page.dart';
import '../../features/salud/presentation/pages/vacunacion_list_page.dart';
import '../../features/salud/presentation/pages/vacunacion_detail_page.dart';
import '../../features/salud/presentation/pages/registrar_tratamiento_page.dart';
import '../../features/salud/presentation/pages/programar_vacunacion_page.dart';
import '../../features/salud/presentation/pages/catalogo_enfermedades_page.dart';
import '../../features/salud/presentation/pages/bioseguridad_overview_page.dart';
import '../../features/salud/presentation/pages/inspeccion_bioseguridad_page.dart';
import '../../features/galpones/galpones.dart';
import '../../features/granjas/granjas.dart';
import '../../features/guias_manejo/presentation/pages/guias_manejo_page.dart';
import '../../features/lotes/lotes.dart';
import '../../features/notificaciones/presentation/pages/notificaciones_page.dart';
import '../../features/veterinario_virtual/presentation/pages/veterinario_home_page.dart';
import '../../features/veterinario_virtual/presentation/pages/chat_consulta_page.dart';
import '../../features/veterinario_virtual/application/services/contexto_builder.dart';
import '../../features/veterinario_virtual/domain/entities/tipo_consulta.dart';
import '../navigation/main_shell_page.dart';
import '../pages/error_page.dart';
import '../pages/legal_page.dart';
import 'app_routes.dart';

/// Configuración del router de la aplicación.
///
/// Clase utilitaria que expone solo las rutas estáticas.
/// La creación del GoRouter se maneja en el provider de routing.
abstract final class AppRouter {
  /// Lista de rutas de la aplicación
  static List<RouteBase> get routes => [
    // Onboarding
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const _PlaceholderPage(title: 'Onboarding'),
    ),

    // Auth Gate (elegir método de autenticación)
    GoRoute(
      path: AppRoutes.authGate,
      name: 'authGate',
      builder: (context, state) => const AuthGatePage(),
    ),

    // Auth routes
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),

    // =========================================================================
    // SHELL PRINCIPAL CON BOTTOM NAVIGATION BAR
    // =========================================================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home/Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Branch 1: Granjas
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.granjasHome,
              name: 'granjasHome',
              builder: (context, state) => const GranjasListPage(),
            ),
          ],
        ),
        // Branch 2: Lotes
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.lotesHome,
              name: 'lotesHome',
              builder: (context, state) => const LotesHomePage(),
            ),
          ],
        ),
        // Branch 3: Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.perfilHome,
              name: 'perfilHome',
              builder: (context, state) => const PerfilPage(),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AppRoutes.dashboard,
      name: 'dashboard',
      builder: (context, state) => const _PlaceholderPage(title: 'Dashboard'),
    ),

    // Notificaciones
    GoRoute(
      path: AppRoutes.notificaciones,
      name: 'notificaciones',
      builder: (context, state) => const NotificacionesPage(),
    ),

    // Granjas
    GoRoute(
      path: AppRoutes.granjas,
      name: 'granjas',
      builder: (context, state) => const GranjasListPage(),
    ),
    GoRoute(
      path: AppRoutes.granjaCrear,
      name: 'granjaCrear',
      builder: (context, state) => const CrearGranjaPage(),
    ),
    GoRoute(
      path: AppRoutes.granjaDetalle,
      name: 'granjaDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GranjaDetailPage(granjaId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.granjaEditar,
      name: 'granjaEditar',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return EditarGranjaPage(granjaId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.granjaColaboradores,
      name: 'granjaColaboradores',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        final granjaNombre = extra?['granjaNombre'] as String? ?? 'Granja';
        return GestionarColaboradoresPage(
          granjaId: id,
          granjaNombre: granjaNombre,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.granjaInvitar,
      name: 'granjaInvitar',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        final granjaNombre = extra?['granjaNombre'] as String? ?? 'Granja';
        return SeleccionarRolInvitacionPage(
          granjaId: id,
          granjaNombre: granjaNombre,
        );
      },
    ),
    GoRoute(
      path: '/granjas/:id/invitacion-codigo',
      name: 'invitacionCodigo',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_INVITATION_NOT_FOUND'),
          );
        }
        final invitacion = extra['invitacion'] as InvitacionGranja;
        final granjaNombre = extra['granjaNombre'] as String;
        final rol = extra['rol'] as RolGranja;
        return CodigoInvitacionPage(
          invitacion: invitacion,
          granjaNombre: granjaNombre,
          rol: rol,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.aceptarInvitacion,
      name: 'aceptarInvitacion',
      builder: (context, state) {
        final codigo = state.uri.queryParameters['codigo'];
        return AceptarInvitacionGranjaPage(codigo: codigo);
      },
    ),

    // Galpones (anidados dentro de granjas)
    GoRoute(
      path: AppRoutes.galpones,
      name: 'galpones',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        return GalponesListPage(granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.galponCrear,
      name: 'galponCrear',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        return CrearGalponPage(granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.galponDetalle,
      name: 'galponDetalle',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final galponId = state.pathParameters['id']!;
        return GalponDetailPage(granjaId: granjaId, galponId: galponId);
      },
    ),
    GoRoute(
      path: AppRoutes.galponEditar,
      name: 'galponEditar',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final galponId = state.pathParameters['id']!;
        return EditarGalponPage(granjaId: granjaId, galponId: galponId);
      },
    ),

    // Lotes (anidados dentro de galpones)
    GoRoute(
      path: AppRoutes.lotes,
      name: 'lotes',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final galponId = state.pathParameters['galponId']!;
        return LotesListPage(granjaId: granjaId, galponId: galponId);
      },
    ),
    GoRoute(
      path: AppRoutes.loteCrear,
      name: 'loteCrear',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final galponId = state.pathParameters['galponId']!;
        return CrearLotePage(granjaId: granjaId, galponId: galponId);
      },
    ),
    GoRoute(
      path: AppRoutes.loteDetalle,
      name: 'loteDetalle',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final loteId = state.pathParameters['id']!;
        return LoteDetailPage(granjaId: granjaId, loteId: loteId);
      },
    ),
    GoRoute(
      path: AppRoutes.loteDashboard,
      name: 'loteDashboard',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final loteId = state.pathParameters['id']!;
        return LoteDashboardPage(granjaId: granjaId, loteId: loteId);
      },
    ),
    GoRoute(
      path: AppRoutes.loteEditar,
      name: 'loteEditar',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final loteId = state.pathParameters['id']!;
        return EditarLotePage(granjaId: granjaId, loteId: loteId);
      },
    ),
    GoRoute(
      path: AppRoutes.loteCerrar,
      name: 'loteCerrar',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return CerrarLotePage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteRegistrarPeso,
      name: 'loteRegistrarPeso',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return RegistrarPesoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteRegistrarConsumo,
      name: 'loteRegistrarConsumo',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return RegistrarConsumoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteRegistrarMortalidad,
      name: 'loteRegistrarMortalidad',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return RegistrarMortalidadPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteRegistrarProduccion,
      name: 'loteRegistrarProduccion',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return RegistrarProduccionPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteHistorialPeso,
      name: 'loteHistorialPeso',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return HistorialPesoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteHistorialConsumo,
      name: 'loteHistorialConsumo',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return HistorialConsumoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteHistorialMortalidad,
      name: 'loteHistorialMortalidad',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return HistorialMortalidadPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteHistorialProduccion,
      name: 'loteHistorialProduccion',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return HistorialProduccionPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteGraficosPeso,
      name: 'loteGraficosPeso',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return GraficosPesoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteGraficosConsumo,
      name: 'loteGraficosConsumo',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return GraficosConsumoPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteGraficosMortalidad,
      name: 'loteGraficosMortalidad',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return GraficosMortalidadPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteGraficosProduccion,
      name: 'loteGraficosProduccion',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return GraficosProduccionPage(lote: lote);
      },
    ),
    GoRoute(
      path: AppRoutes.loteGuiasManejo,
      name: 'loteGuiasManejo',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        if (lote == null) {
          return ErrorPage(
            error: ErrorMessages.get('ROUTER_BATCH_INFO_MISSING'),
          );
        }
        return GuiasManejoPage(lote: lote);
      },
    ),

    // Salud
    GoRoute(
      path: AppRoutes.salud,
      name: 'saludGeneral',
      builder: (context, state) {
        final granjaId = state.uri.queryParameters['granjaId'];
        return SaludListPage(
          granjaId: granjaId?.isNotEmpty == true ? granjaId : null,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.saludPorLote,
      name: 'saludPorLote',
      builder: (context, state) {
        final loteId = state.pathParameters['loteId']!;
        final granjaId = state.uri.queryParameters['granjaId'];
        return SaludListPage(loteId: loteId, granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.vacunaciones,
      name: 'vacunaciones',
      builder: (context, state) => const VacunacionListPage(),
    ),
    GoRoute(
      path: AppRoutes.vacunacionesPorLote,
      name: 'vacunacionesPorLote',
      builder: (context, state) {
        final loteId = state.pathParameters['loteId']!;
        final granjaId = state.uri.queryParameters['granjaId'];
        return VacunacionListPage(loteId: loteId, granjaId: granjaId);
      },
    ),
    // Rutas estáticas ANTES de las dinámicas con :id
    GoRoute(
      path: AppRoutes.registrarTratamiento,
      name: 'registrarTratamiento',
      builder: (context, state) {
        final loteId = state.uri.queryParameters['loteId'];
        final granjaId = state.uri.queryParameters['granjaId'];
        return RegistrarTratamientoPage(
          loteId: loteId?.isNotEmpty == true ? loteId : null,
          granjaId: granjaId?.isNotEmpty == true ? granjaId : null,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.programarVacunacion,
      name: 'programarVacunacion',
      builder: (context, state) {
        final loteId = state.uri.queryParameters['loteId'] ?? '';
        final granjaId = state.uri.queryParameters['granjaId'] ?? '';
        return ProgramarVacunacionPage(loteId: loteId, granjaId: granjaId);
      },
    ),
    // Catálogo de enfermedades (ruta estática ANTES de /salud/:id)
    GoRoute(
      path: AppRoutes.catalogoEnfermedades,
      name: 'catalogoEnfermedades',
      builder: (context, state) => const CatalogoEnfermedadesPage(),
    ),
    // Detalle de vacunación (ruta dinámica después de las estáticas)
    GoRoute(
      path: AppRoutes.vacunacionDetalle,
      name: 'vacunacionDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VacunacionDetailPage(vacunacionId: id);
      },
    ),
    // Detalle de registro de salud (ruta dinámica después de las estáticas)
    GoRoute(
      path: AppRoutes.saludDetalle,
      name: 'saludDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return SaludDetailPage(registroId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.inspeccionBioseguridad,
      name: 'inspeccionBioseguridad',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        return BioseguridadOverviewPage(granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.nuevaInspeccionBioseguridad,
      name: 'nuevaInspeccionBioseguridad',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        final inspectorId = state.uri.queryParameters['inspectorId'] ?? '';
        final inspectorNombre =
            state.uri.queryParameters['inspectorNombre'] ?? 'Inspector';
        final galponId = state.uri.queryParameters['galponId'];
        return InspeccionBioseguridadPage(
          granjaId: granjaId,
          inspectorId: inspectorId,
          inspectorNombre: inspectorNombre,
          galponId: galponId,
        );
      },
    ),

    // Costos
    GoRoute(
      path: AppRoutes.costos,
      name: 'costosGeneral',
      builder: (context, state) => const CostosListPage(),
    ),
    GoRoute(
      path: AppRoutes.costosPorLote,
      name: 'costosPorLote',
      builder: (context, state) {
        final loteId = state.pathParameters['loteId']!;
        final granjaId = state.uri.queryParameters['granjaId'];
        return CostosListPage(loteId: loteId, granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.costoRegistrar,
      name: 'costoRegistrar',
      builder: (context, state) {
        final granjaId = state.uri.queryParameters['granjaId'];
        final loteId = state.uri.queryParameters['loteId'];
        // Nota: Para edición, el costo se carga en la página usando costoId
        // El costoExistente se pasa como extra si está disponible
        final costoExistente = state.extra as dynamic;
        return RegistrarCostoPage(
          granjaId: granjaId?.isNotEmpty == true ? granjaId : null,
          loteId: loteId?.isNotEmpty == true ? loteId : null,
          costoExistente: costoExistente is Map ? null : costoExistente,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.costoDetalle,
      name: 'costoDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return CostoDetailPage(costoId: id);
      },
    ),

    // Ventas
    GoRoute(
      path: AppRoutes.ventas,
      name: 'ventasGeneral',
      builder: (context, state) => const VentasListPage(),
    ),
    GoRoute(
      path: AppRoutes.ventasPorLote,
      name: 'ventasPorLote',
      builder: (context, state) {
        final loteId = state.pathParameters['loteId']!;
        final granjaId = state.uri.queryParameters['granjaId'];
        return VentasListPage(loteId: loteId, granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.ventaRegistrar,
      name: 'ventaRegistrar',
      builder: (context, state) {
        final granjaId = state.uri.queryParameters['granjaId'];
        final loteId = state.uri.queryParameters['loteId'];
        final ventaExistente = state.extra as dynamic;
        return RegistrarVentaPage(
          granjaId: granjaId?.isNotEmpty == true ? granjaId : null,
          loteId: loteId?.isNotEmpty == true ? loteId : null,
          ventaExistente: ventaExistente is Map ? null : ventaExistente,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.ventaDetalle,
      name: 'ventaDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return VentaDetailPage(ventaId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.ventaEditar,
      name: 'ventaEditar',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final granjaId = state.uri.queryParameters['granjaId'] ?? '';
        final loteId = state.uri.queryParameters['loteId'];
        return EditarVentaPage(
          ventaId: id,
          granjaId: granjaId,
          loteId: loteId?.isNotEmpty == true ? loteId : null,
        );
      },
    ),

    // =========================================================================
    // INVENTARIO
    // =========================================================================
    GoRoute(
      path: AppRoutes.inventario,
      name: 'inventario',
      builder: (context, state) => const InventarioPage(),
    ),

    // =========================================================================
    // REPORTES
    // =========================================================================
    GoRoute(
      path: AppRoutes.reportes,
      name: 'reportes',
      builder: (context, state) => const ReportesPage(),
    ),

    GoRoute(
      path: AppRoutes.inventarioPorGranja,
      name: 'inventarioPorGranja',
      builder: (context, state) {
        final granjaId = state.pathParameters['granjaId']!;
        return InventarioPage(granjaId: granjaId);
      },
    ),
    GoRoute(
      path: AppRoutes.inventarioCrearItem,
      name: 'inventarioCrearItem',
      builder: (context, state) {
        final granjaId = state.uri.queryParameters['granjaId'] ?? '';
        final extra = state.extra;
        final itemExistente = extra is ItemInventario ? extra : null;
        return CrearItemInventarioPage(
          granjaId: granjaId,
          itemExistente: itemExistente,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.inventarioItemDetalle,
      name: 'inventarioItemDetalle',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ItemDetalleInventarioPage(itemId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.inventarioEditarItem,
      name: 'inventarioEditarItem',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final granjaId = state.uri.queryParameters['granjaId'] ?? '';
        final extra = state.extra;
        final itemExistente = extra is ItemInventario ? extra : null;
        return CrearItemInventarioPage(
          granjaId: granjaId,
          itemExistente: itemExistente,
          itemId: id,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.inventarioHistorialMovimientos,
      name: 'inventarioHistorialMovimientos',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return HistorialMovimientosPage(itemId: id);
      },
    ),

    // Configuración
    GoRoute(
      path: AppRoutes.configuracion,
      name: 'configuracion',
      builder: (context, state) => const ConfiguracionPage(),
    ),

    // Editar Perfil
    GoRoute(
      path: AppRoutes.editarPerfil,
      name: 'editarPerfil',
      builder: (context, state) => const EditarPerfilPage(),
    ),

    // Notificaciones Config
    GoRoute(
      path: AppRoutes.notificacionesConfig,
      name: 'notificacionesConfig',
      builder: (context, state) => const NotificacionesConfigPage(),
    ),

    // Veterinario Virtual (IA)
    GoRoute(
      path: AppRoutes.veterinarioVirtual,
      name: 'veterinarioVirtual',
      builder: (context, state) {
        final lote = state.extra as Lote?;
        return VeterinarioHomePage(lote: lote);
      },
    ),

    // Veterinario Virtual - Chat Consulta
    GoRoute(
      path: AppRoutes.veterinarioChat,
      name: 'veterinarioChat',
      builder: (context, state) {
        final extra =
            state.extra as ({TipoConsulta tipo, ContextoGranja contexto});
        return ChatConsultaPage(tipo: extra.tipo, contexto: extra.contexto);
      },
    ),

    // Legal
    GoRoute(
      path: AppRoutes.legalPrivacidad,
      name: 'legalPrivacidad',
      builder: (context, state) =>
          const LegalPage(tipo: TipoDocumentoLegal.privacidad),
    ),
    GoRoute(
      path: AppRoutes.legalTerminos,
      name: 'legalTerminos',
      builder: (context, state) =>
          const LegalPage(tipo: TipoDocumentoLegal.terminos),
    ),

    // Error
    GoRoute(
      path: AppRoutes.error,
      name: 'error',
      builder: (context, state) {
        final error = state.extra as String? ?? S.of(context).errorUnknown;
        return ErrorPage(error: error);
      },
    ),
  ];
}

/// Página placeholder temporal
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Página: $title\n(En construcción)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
