library;

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../core/config/firestore_config.dart';
import '../core/storage/local_storage.dart';
import '../features/notificaciones/application/services/notification_service.dart';
import '../firebase_options.dart';

/// Inicializador de la aplicación
///
/// Centraliza toda la lógica de inicialización de servicios
/// y configuraciones necesarias antes de ejecutar la app.
class AppInitializer {
  const AppInitializer._();

  /// Inicializa solo los servicios CRÍTICOS para mostrar la UI.
  ///
  /// Esto reduce el tiempo de inicio significativamente al diferir
  /// servicios pesados como notificaciones para después del primer frame.
  static Future<void> initialize() async {
    // Asegurar que Flutter esté inicializado
    WidgetsFlutterBinding.ensureInitialized();

    // Solo inicializar lo CRÍTICO para mostrar la UI
    await Future.wait([
      _initializeOrientation(),
      _initializeFirebase(),
      _initializeDateFormatting(),
    ]);

    // Configurar Firestore para soporte offline
    // IMPORTANTE: Debe hacerse DESPUÉS de Firebase.initializeApp()
    // pero ANTES de cualquier operación de Firestore
    await FirestoreConfig.configure(
      // 100 MB de caché - suficiente para datos de granjas
      cacheSizeBytes: 100 * 1024 * 1024,
      enablePersistence: true,
    );

    // Activar App Check para proteger las APIs de Firebase
    await _initializeAppCheck();

    // LocalStorage es crítico para auth providers
    await LocalStorage.init();

    // Configurar manejo de errores (síncrono, no bloquea)
    _setupErrorHandling();
  }

  /// Inicializa servicios secundarios DESPUÉS de que la UI se renderice.
  ///
  /// Llamar esto desde el widget principal después del primer frame
  /// para evitar bloquear el hilo principal durante el startup.
  static Future<void> initializeSecondaryServices() async {
    // Notificaciones es lo más pesado - diferir al final
    await _initializeNotifications();
  }

  /// Inicializa el servicio de notificaciones.
  static Future<void> _initializeNotifications() async {
    try {
      await NotificationService.instance.initialize();
    } on Exception catch (e) {
      debugPrint('Error inicializando notificaciones: $e');
    }
  }

  /// Configura la orientación de la pantalla
  static Future<void> _initializeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Inicializa Firebase
  static Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// Activa Firebase App Check para proteger las APIs de abuso.
  static Future<void> _initializeAppCheck() async {
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode
          ? AppleProvider.debug
          : AppleProvider.deviceCheck,
    );
  }

  /// Inicializa el formato de fechas para español
  static Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('es_ES', null);
  }

  /// Configura el manejo global de errores
  static void _setupErrorHandling() {
    // Manejo de errores de Flutter
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      }
    };

    // Manejo de errores asíncronos
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Error asíncrono: $error');
        debugPrint('Stack: $stack');
      } else {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      }
      return true;
    };
  }
}
