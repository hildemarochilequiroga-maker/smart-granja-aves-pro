library;

import 'package:go_router/go_router.dart';

import '../../../../core/routes/app_routes.dart';

/// Helper para resolver y navegar a destinos de notificaciones.
///
/// Soporta rutas actuales y rutas legacy almacenadas en `accionUrl`.
abstract final class NotificacionNavigationHelper {
  const NotificacionNavigationHelper._();

  /// Navega usando un `payload` recibido desde push/local notification.
  static bool navigateFromPayload(
    GoRouter router,
    Map<String, dynamic> payload,
  ) {
    final actionUrl = payload['accionUrl'] as String?;
    return navigateFromActionUrl(router, actionUrl);
  }

  /// Navega usando un `accionUrl` de una notificación.
  static bool navigateFromActionUrl(GoRouter router, String? actionUrl) {
    final route = resolveRoute(actionUrl);
    if (route == null) return false;

    router.push(route);
    return true;
  }

  /// Resuelve la ruta interna válida a partir de un `accionUrl`.
  static String? resolveRoute(String? actionUrl) {
    if (actionUrl == null || actionUrl.trim().isEmpty) {
      return null;
    }

    final raw = actionUrl.trim();
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return null;
    }

    Uri uri;
    try {
      uri = Uri.parse(raw);
    } catch (_) {
      return null;
    }

    final path = uri.path;
    final segments = uri.pathSegments;

    if (path == '/aceptar-invitacion') {
      return AppRoutes.aceptarInvitacion;
    }

    if (path == '/granjas' || path == AppRoutes.granjas) {
      return AppRoutes.granjas;
    }

    if (path == '/onboarding') {
      return AppRoutes.onboarding;
    }

    if (segments.length >= 3 &&
        segments[0] == 'granjas' &&
        segments[2] == 'inventario') {
      return AppRoutes.inventarioPorGranjaId(segments[1]);
    }

    if (segments.length >= 3 &&
        segments[0] == 'granjas' &&
        segments[2] == 'dashboard') {
      return AppRoutes.home;
    }

    if (segments.length >= 3 &&
        segments[0] == 'granjas' &&
        segments[2] == 'alertas') {
      return AppRoutes.notificaciones;
    }

    if (segments.length >= 3 &&
        segments[0] == 'granjas' &&
        segments[2] == 'colaboradores') {
      return AppRoutes.granjaColaboradoresById(segments[1]);
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'costos') {
      if (segments.length == 4) {
        return AppRoutes.costoDetalleById(segments[3]);
      }
      return AppRoutes.costos;
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'galpones') {
      return AppRoutes.galponDetalleById(segments[1], segments[3]);
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'lotes') {
      final granjaId = segments[1];
      final loteId = segments[3];

      if (segments.length == 4) {
        return AppRoutes.loteDashboardById(granjaId, loteId);
      }

      if (segments.length >= 5 && segments[4] == 'salud') {
        return AppRoutes.saludPorLoteId(loteId, granjaId);
      }

      if (segments.length >= 5 && segments[4] == 'produccion') {
        return AppRoutes.loteDashboardById(granjaId, loteId);
      }

      return AppRoutes.loteDashboardById(granjaId, loteId);
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'ventas') {
      if (segments[3] == 'pedidos') {
        return AppRoutes.ventas;
      }
      return AppRoutes.ventaDetalleById(segments[3]);
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'salud' &&
        segments[3] == 'vacunaciones') {
      return AppRoutes.vacunaciones;
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'bioseguridad' &&
        segments[3] == 'inspecciones') {
      return AppRoutes.bioseguridadPorGranja(segments[1]);
    }

    if (segments.length >= 4 &&
        segments[0] == 'granjas' &&
        segments[2] == 'reportes') {
      return AppRoutes.reportes;
    }

    if (segments.length == 2 && segments[0] == 'granjas') {
      return AppRoutes.granjaDetalleById(segments[1]);
    }

    return raw.startsWith('/') ? raw : null;
  }
}
