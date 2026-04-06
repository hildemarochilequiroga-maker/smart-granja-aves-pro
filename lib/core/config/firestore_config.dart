/// Configuración y utilidades de Firestore para soporte offline.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Configuración de Firestore para la aplicación.
///
/// Esta clase configura el comportamiento offline de Firestore,
/// incluyendo persistencia de datos y tamaño de caché.
abstract final class FirestoreConfig {
  const FirestoreConfig._();

  /// Tamaño de caché por defecto: 100 MB
  static const int defaultCacheSizeBytes = 100 * 1024 * 1024; // 100 MB

  /// Configura Firestore con soporte offline optimizado.
  ///
  /// Debe llamarse ANTES de cualquier operación de Firestore.
  /// Idealmente en la inicialización de la app.
  static Future<void> configure({
    int? cacheSizeBytes,
    bool enablePersistence = true,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Configurar settings
      firestore.settings = Settings(
        // Habilitar persistencia (por defecto está habilitada en móvil)
        persistenceEnabled: enablePersistence,

        // Tamaño de caché - usar CACHE_SIZE_UNLIMITED para no limitar
        // o especificar un tamaño mínimo de 1 MB
        cacheSizeBytes: cacheSizeBytes ?? defaultCacheSizeBytes,
      );

      debugPrint('✅ Firestore configurado:');
      debugPrint('   ├─ Persistencia: $enablePersistence');
      debugPrint(
        '   └─ Caché: ${(cacheSizeBytes ?? defaultCacheSizeBytes) ~/ (1024 * 1024)} MB',
      );
    } on Exception catch (e) {
      debugPrint('⚠️ Error configurando Firestore: $e');
      // No lanzar excepción - la app puede funcionar con configuración por defecto
    }
  }

  /// Configura Firestore con caché ilimitado.
  ///
  /// Útil para apps que necesitan almacenar muchos datos offline.
  static Future<void> configureUnlimitedCache() async {
    try {
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      debugPrint('✅ Firestore configurado con caché ilimitado');
    } on Exception catch (e) {
      debugPrint('⚠️ Error configurando caché ilimitado: $e');
    }
  }

  /// Limpia todos los datos persistidos en el caché.
  ///
  /// ⚠️ CUIDADO: Esto eliminará todos los datos locales no sincronizados.
  /// Solo usar cuando el usuario cierre sesión o en casos de error crítico.
  static Future<void> clearCache() async {
    try {
      await FirebaseFirestore.instance.clearPersistence();
      debugPrint('🗑️ Caché de Firestore limpiado');
    } on Exception catch (e) {
      debugPrint('⚠️ Error limpiando caché: $e');
    }
  }

  /// Deshabilita temporalmente el acceso a la red.
  ///
  /// Útil para testing del modo offline o para operaciones
  /// que solo deben usar datos locales.
  static Future<void> disableNetwork() async {
    await FirebaseFirestore.instance.disableNetwork();
    debugPrint('🔌 Red deshabilitada');
  }

  /// Habilita el acceso a la red.
  static Future<void> enableNetwork() async {
    await FirebaseFirestore.instance.enableNetwork();
    debugPrint('🌐 Red habilitada');
  }

  /// Verifica si Firestore tiene escrituras pendientes.
  ///
  /// Retorna true si hay datos locales que no se han sincronizado.
  static Future<bool> hasPendingWrites() async {
    try {
      // Intentar leer un documento para verificar el estado de la conexión
      final snapshot = await FirebaseFirestore.instance
          .collection('_app_status')
          .doc('check')
          .get();

      return snapshot.metadata.hasPendingWrites;
    } on Exception {
      // Si hay error, asumir que puede haber datos pendientes
      return true;
    }
  }

  /// Espera a que todas las escrituras pendientes se sincronicen.
  ///
  /// Útil antes de cerrar sesión o realizar operaciones críticas.
  static Future<void> waitForPendingWrites() async {
    await FirebaseFirestore.instance.waitForPendingWrites();
    debugPrint('✅ Todas las escrituras sincronizadas');
  }

  /// Termina la instancia de Firestore.
  ///
  /// Debe llamarse cuando la app se cierra o el usuario cierra sesión.
  static Future<void> terminate() async {
    await FirebaseFirestore.instance.terminate();
    debugPrint('🛑 Firestore terminado');
  }
}

/// Extensión para facilitar el uso de metadata en snapshots.
extension FirestoreSnapshotExtension<T extends Object?> on DocumentSnapshot<T> {
  /// Si los datos vienen del caché local.
  bool get isFromCache => metadata.isFromCache;

  /// Si hay escrituras pendientes para este documento.
  bool get pendingWrites => metadata.hasPendingWrites;

  /// Descripción del origen de los datos.
  String get sourceDescription => isFromCache ? 'caché local' : 'servidor';
}

/// Extensión para QuerySnapshot.
extension FirestoreQuerySnapshotExtension<T extends Object?>
    on QuerySnapshot<T> {
  /// Si los datos vienen del caché local.
  bool get isFromCache => metadata.isFromCache;

  /// Si hay escrituras pendientes.
  bool get pendingWrites => metadata.hasPendingWrites;
}
