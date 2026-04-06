/// Servicio de sincronización de imágenes pendientes.
///
/// Escucha cambios de conectividad y procesa la cola de subidas
/// cuando se restaura la conexión.
library;

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity_provider.dart';
import 'image_upload_service.dart';
import 'pending_image_upload.dart';

/// Servicio que sincroniza imágenes pendientes cuando hay conexión.
class ImageSyncService {
  ImageSyncService(this._ref) {
    _init();
  }

  final Ref _ref;
  bool _isSyncing = false;
  StreamSubscription<AppConnectivityState>? _connectivitySub;

  void _init() {
    // Escuchar cambios de conectividad
    _connectivitySub = _ref.read(connectivityProvider.notifier).stream.listen((
      state,
    ) {
      if (state.isOnline && !_isSyncing) {
        syncPendingUploads();
      }
    });

    // Intentar sincronizar al iniciar si ya estamos online
    final currentState = _ref.read(connectivityProvider);
    if (currentState.isOnline) {
      syncPendingUploads();
    }
  }

  /// Procesa todas las subidas pendientes.
  Future<int> syncPendingUploads() async {
    if (_isSyncing) return 0;
    _isSyncing = true;

    try {
      final queue = PendingUploadQueue.instance;
      final pending = await queue.getQueue();

      if (pending.isEmpty) {
        debugPrint('✅ No hay imágenes pendientes de sincronizar');
        return 0;
      }

      debugPrint('🔄 Sincronizando ${pending.length} imágenes pendientes...');
      int syncedCount = 0;

      for (final item in pending) {
        try {
          final file = File(item.localPath);
          if (!await file.exists()) {
            debugPrint(
              '⚠️ Archivo no encontrado, eliminando de cola: ${item.id}',
            );
            await queue.dequeue(item.id);
            continue;
          }

          // Subir imagen
          final uploadService = ImageUploadService.instance;
          final result = await uploadService.uploadImage(
            file: file,
            type: item.type,
            granjaId: item.granjaId,
            entityId: item.entityId,
            metadata: item.metadata,
          );

          // Actualizar documento Firestore si se especificó
          if (item.firestoreDocPath != null && item.firestoreField != null) {
            await _updateFirestoreDoc(
              docPath: item.firestoreDocPath!,
              field: item.firestoreField!,
              url: result.url,
              isMultiple: item.isMultiple,
            );
          }

          // Eliminar de la cola
          await queue.dequeue(item.id);
          syncedCount++;

          debugPrint('✅ Imagen sincronizada: ${item.id}');
        } on Exception catch (e) {
          debugPrint('❌ Error sincronizando imagen ${item.id}: $e');
          // No eliminar de la cola — se reintentará
        }
      }

      debugPrint('🔄 Sincronización completa: $syncedCount/${pending.length}');
      return syncedCount;
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _updateFirestoreDoc({
    required String docPath,
    required String field,
    required String url,
    required bool isMultiple,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.doc(docPath);

      if (isMultiple) {
        // Agregar URL al array existente
        await docRef.update({
          field: FieldValue.arrayUnion([url]),
        });
      } else {
        // Reemplazar el campo con la URL
        await docRef.update({field: url});
      }

      debugPrint('✅ Firestore actualizado: $docPath.$field');
    } on Exception catch (e) {
      debugPrint('❌ Error actualizando Firestore: $e');
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}

/// Provider para el servicio de sincronización de imágenes.
final imageSyncServiceProvider = Provider<ImageSyncService>((ref) {
  final service = ImageSyncService(ref);
  ref.onDispose(service.dispose);
  return service;
});

/// Provider que expone la cantidad de subidas pendientes.
final pendingUploadsCountProvider = FutureProvider<int>((ref) async {
  // Dependemos del sync service para que exista
  ref.watch(imageSyncServiceProvider);
  return PendingUploadQueue.instance.pendingCount();
});
