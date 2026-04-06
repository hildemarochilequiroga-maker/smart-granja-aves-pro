/// Modelo y cola de subidas de imágenes pendientes para soporte offline.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../errors/error_messages.dart';

import 'image_upload_service.dart';

/// Representa una subida de imagen pendiente.
class PendingImageUpload {
  PendingImageUpload({
    required this.id,
    required this.localPath,
    required this.type,
    required this.granjaId,
    required this.entityId,
    required this.createdAt,
    this.metadata,
    this.firestoreDocPath,
    this.firestoreField,
    this.isMultiple = false,
  });

  /// ID único de la subida pendiente.
  final String id;

  /// Ruta local del archivo en el directorio de la app.
  final String localPath;

  /// Tipo de imagen (mortalidad, peso, etc.).
  final ImageUploadType type;

  /// ID de la granja.
  final String granjaId;

  /// ID de la entidad (lote, item, etc.).
  final String entityId;

  /// Fecha de creación.
  final DateTime createdAt;

  /// Metadatos adicionales.
  final Map<String, String>? metadata;

  /// Path del documento Firestore a actualizar con la URL.
  final String? firestoreDocPath;

  /// Campo del documento Firestore a actualizar.
  final String? firestoreField;

  /// Si es parte de un upload múltiple (array de URLs).
  final bool isMultiple;

  Map<String, dynamic> toJson() => {
    'id': id,
    'localPath': localPath,
    'type': type.name,
    'granjaId': granjaId,
    'entityId': entityId,
    'createdAt': createdAt.toIso8601String(),
    'metadata': metadata,
    'firestoreDocPath': firestoreDocPath,
    'firestoreField': firestoreField,
    'isMultiple': isMultiple,
  };

  factory PendingImageUpload.fromJson(Map<String, dynamic> json) {
    return PendingImageUpload(
      id: json['id'] as String,
      localPath: json['localPath'] as String,
      type: ImageUploadType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ImageUploadType.granja,
      ),
      granjaId: json['granjaId'] as String,
      entityId: json['entityId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] != null
          ? Map<String, String>.from(json['metadata'] as Map)
          : null,
      firestoreDocPath: json['firestoreDocPath'] as String?,
      firestoreField: json['firestoreField'] as String?,
      isMultiple: json['isMultiple'] as bool? ?? false,
    );
  }
}

/// Cola persistente de subidas de imágenes pendientes.
class PendingUploadQueue {
  PendingUploadQueue._();

  static final PendingUploadQueue _instance = PendingUploadQueue._();
  static PendingUploadQueue get instance => _instance;

  static const String _prefsKey = 'pending_image_uploads';

  /// Obtiene el directorio para almacenar copias locales de imágenes.
  Future<Directory> _getPendingDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final pendingDir = Directory('${appDir.path}/pending_uploads');
    if (!await pendingDir.exists()) {
      await pendingDir.create(recursive: true);
    }
    return pendingDir;
  }

  /// Copia el archivo al directorio de la app para preservarlo.
  Future<String> _copyToPendingDir(String originalPath) async {
    final pendingDir = await _getPendingDir();
    final file = File(originalPath);
    if (!await file.exists()) {
      throw Exception(
        ErrorMessages.format('ERR_FILE_NOT_EXISTS', {'path': originalPath}),
      );
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = originalPath.contains('.')
        ? originalPath.substring(originalPath.lastIndexOf('.'))
        : '.jpg';
    final newPath = '${pendingDir.path}/$timestamp$ext';

    await file.copy(newPath);
    return newPath;
  }

  /// Agrega una imagen pendiente a la cola.
  Future<PendingImageUpload> enqueue({
    required String filePath,
    required ImageUploadType type,
    required String granjaId,
    required String entityId,
    Map<String, String>? metadata,
    String? firestoreDocPath,
    String? firestoreField,
    bool isMultiple = false,
  }) async {
    // Copiar archivo al directorio persistente de la app
    final localPath = await _copyToPendingDir(filePath);

    final pending = PendingImageUpload(
      id: '${DateTime.now().millisecondsSinceEpoch}_${localPath.hashCode}',
      localPath: localPath,
      type: type,
      granjaId: granjaId,
      entityId: entityId,
      createdAt: DateTime.now(),
      metadata: metadata,
      firestoreDocPath: firestoreDocPath,
      firestoreField: firestoreField,
      isMultiple: isMultiple,
    );

    final queue = await getQueue();
    queue.add(pending);
    await _saveQueue(queue);

    debugPrint('📋 Imagen encolada para subida: ${pending.id}');
    return pending;
  }

  /// Obtiene todas las subidas pendientes.
  Future<List<PendingImageUpload>> getQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_prefsKey);
      if (jsonStr == null || jsonStr.isEmpty) return [];

      final list = jsonDecode(jsonStr) as List;
      return list
          .map((e) => PendingImageUpload.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      debugPrint('Error al leer cola de uploads: $e');
      return [];
    }
  }

  /// Elimina un item de la cola y su archivo local.
  Future<void> dequeue(String id) async {
    final queue = await getQueue();
    final item = queue.where((e) => e.id == id).firstOrNull;

    // Eliminar archivo local
    if (item != null) {
      try {
        final file = File(item.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      } on Exception catch (e) {
        debugPrint('Error eliminando archivo pendiente: $e');
      }
    }

    queue.removeWhere((e) => e.id == id);
    await _saveQueue(queue);
  }

  /// Verifica si hay subidas pendientes.
  Future<bool> hasPending() async {
    final queue = await getQueue();
    return queue.isNotEmpty;
  }

  /// Obtiene la cantidad de subidas pendientes.
  Future<int> pendingCount() async {
    final queue = await getQueue();
    return queue.length;
  }

  /// Limpia toda la cola y archivos.
  Future<void> clearAll() async {
    final queue = await getQueue();
    for (final item in queue) {
      try {
        final file = File(item.localPath);
        if (await file.exists()) {
          await file.delete();
        }
      } on Exception catch (_) {}
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<void> _saveQueue(List<PendingImageUpload> queue) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(queue.map((e) => e.toJson()).toList());
    await prefs.setString(_prefsKey, jsonStr);
  }
}
