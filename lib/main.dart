import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/currency_provider.dart';
import 'core/config/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'app/app_initializer.dart';
import 'core/network/connectivity_provider.dart';
import 'core/pages/error_page.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/theme.dart';
import 'core/storage/image_sync_service.dart';
import 'core/widgets/connectivity_banner.dart';
import 'features/auth/application/providers/auth_provider.dart';
import 'features/auth/application/state/auth_state.dart';
import 'features/notificaciones/application/services/notificacion_navigation_helper.dart';
import 'features/notificaciones/application/services/notification_service.dart';

/// Estado inicial de autenticación (determinado antes de runApp).
/// Se usa como snapshot sincrónico para evitar flash de pantalla de login.
bool _initiallyLoggedIn = false;

void main() {
  // Envolver todo el código en runZonedGuarded para que WidgetsFlutterBinding
  // se inicialice en la misma zona que runApp (evita zone mismatch)
  runZonedGuarded(
    () async {
      // Inicializar todos los servicios (incluye ensureInitialized)
      await AppInitializer.initialize();

      // Verificar si hay sesión ANTES de renderizar Flutter
      final currentUser = FirebaseAuth.instance.currentUser;
      _initiallyLoggedIn = currentUser != null;

      runApp(const ProviderScope(child: SmartGranjaAvesApp()));
    },
    (error, stack) {
      Logger().e('Error no capturado en zona', error: error, stackTrace: stack);
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
    },
  );
}

/// Notifier para refrescar el router cuando cambie el auth
class AuthNotifierForRouter extends ChangeNotifier {
  AuthNotifierForRouter(this._ref) {
    _ref.listen<AuthState>(authProvider, (previous, next) {
      // Solo notificar cuando el estado cambie de Initial a otro estado
      // o cuando cambie entre Authenticated y Unauthenticated
      if (previous is AuthInitial ||
          (previous is AuthAuthenticated && next is! AuthAuthenticated) ||
          (previous is! AuthAuthenticated && next is AuthAuthenticated)) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;

  AuthState get authState => _ref.read(authProvider);

  /// Retorna true si el usuario está logueado O si estamos en estado inicial
  /// y había usuario al iniciar la app
  bool get isLoggedIn {
    final state = authState;
    if (state is AuthAuthenticated) return true;
    if (state is AuthInitial && _initiallyLoggedIn) return true;
    return false;
  }

  /// Retorna true si el auth aún está en estado inicial
  bool get isInitializing => authState is AuthInitial;
}

/// Provider del auth notifier para el router
final authNotifierForRouterProvider = Provider<AuthNotifierForRouter>((ref) {
  return AuthNotifierForRouter(ref);
});

/// Provider para el router
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierForRouterProvider);

  // Usar el estado inicial sincrónico para la primera carga
  // Después el refreshListenable actualizará según cambios en el auth
  return GoRouter(
    // Iniciar en la ruta correcta según el estado inicial
    initialLocation: _initiallyLoggedIn ? AppRoutes.home : AppRoutes.authGate,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final path = state.uri.path;
      final isAuthRoute = path.startsWith('/auth');
      final isOnboarding = path == AppRoutes.onboarding;
      final isLoggedIn = authNotifier.isLoggedIn;

      // Si está logueado y está en auth, ir a home
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      // Si no está logueado y no está en auth
      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return AppRoutes.authGate;
      }

      return null;
    },
    errorBuilder: (context, state) =>
        ErrorPage(error: state.error?.toString() ?? S.of(context).pageNotFound),
    routes: AppRouter.routes,
  );
});

/// Widget principal de la aplicación
class SmartGranjaAvesApp extends ConsumerStatefulWidget {
  const SmartGranjaAvesApp({super.key});

  @override
  ConsumerState<SmartGranjaAvesApp> createState() => _SmartGranjaAvesAppState();
}

class _SmartGranjaAvesAppState extends ConsumerState<SmartGranjaAvesApp> {
  StreamSubscription<Map<String, dynamic>>? _notificationTapSubscription;

  @override
  void initState() {
    super.initState();
    // Diferir servicios pesados hasta después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationTapSubscription = NotificationService
          .instance
          .onNotificationTapped
          .listen(_handleNotificationTap);

      unawaited(
        AppInitializer.initializeSecondaryServices().catchError((e) {
          Logger().e('Error inicializando servicios secundarios', error: e);
        }),
      );
      // Inicializar el monitoreo de conectividad
      ref.read(connectivityProvider);

      // Inicializar sincronización de imágenes pendientes
      ref.read(imageSyncServiceProvider);
    });
  }

  void _handleNotificationTap(Map<String, dynamic> payload) {
    final router = ref.read(routerProvider);
    NotificacionNavigationHelper.navigateFromPayload(router, payload);
  }

  @override
  void dispose() {
    _notificationTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Observar el auth para que el widget se reconstruya cuando cambie
    ref.watch(authProvider);
    final router = ref.watch(routerProvider);

    // Observar estado de conectividad
    final connectivityState = ref.watch(connectivityProvider);

    // Observar idioma seleccionado
    final locale = ref.watch(localeProvider);

    // Observar moneda seleccionada (carga la preferencia guardada)
    ref.watch(currencyProvider);

    return MaterialApp.router(
      title: 'Smart Granja Aves Pro',
      debugShowCheckedModeBanner: false,

      // Localización
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      locale: locale,

      // Temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router
      routerConfig: router,

      // Configuración de scroll
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),

      // Builder para configuraciones globales incluyendo banner de conectividad
      builder: (context, child) {
        return MediaQuery(
          // Evitar que el texto escale demasiado
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: Column(
            children: [
              // Banner de conectividad global
              if (connectivityState.isOffline ||
                  connectivityState.hasPendingWrites)
                const ConnectivityBanner(),
              // Contenido principal
              Expanded(child: child ?? const SizedBox.shrink()),
            ],
          ),
        );
      },
    );
  }
}
