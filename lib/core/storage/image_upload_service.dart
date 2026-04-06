/// Servicio centralizado para subida de imágenes a Firebase Storage.
library;

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import 'pending_image_upload.dart';

/// Tipo de imagen para organizar en Firebase Storage.
enum ImageUploadType {
  peso('peso'),
  produccion('produccion'),
  mortalidad('mortalidad'),
  consumo('consumo'),
  inventario('inventario'),
  lote('lotes'),
  granja('granjas'),
  perfil('perfiles'),
  salud('salud'),
  galpon('galpones');

  final String folder;
  const ImageUploadType(this.folder);
}

/// Resultado de subida de imagen.
class ImageUploadResult {
  final String url;
  final String path;
  final int sizeBytes;

  const ImageUploadResult({
    required this.url,
    required this.path,
    required this.sizeBytes,
  });
}

/// Callback para progreso de subida.
typedef UploadProgressCallback = void Function(int uploaded, int total);

/// Servicio para subir imágenes a Firebase Storage.
class ImageUploadService {
  ImageUploadService._();

  static final ImageUploadService _instance = ImageUploadService._();
  static ImageUploadService get instance => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Tamaño máximo de archivo.
  static const int maxFileSizeBytes = AppConstants.maxImageSizeBytes;

  /// Comprime una imagen antes de subirla.
  ///
  /// Redimensiona a máximo 1280px de ancho, calidad JPEG 75%.
  /// Retorna el archivo comprimido o el original si falla.
  Future<File> _compressImage(File file) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        '${file.parent.path}/compressed_${file.uri.pathSegments.last}',
        minWidth: 1280,
        minHeight: 720,
        quality: 75,
        format: CompressFormat.jpeg,
      );
      if (result != null) {
        final compressed = File(result.path);
        final originalSize = await file.length();
        final compressedSize = await compressed.length();
        debugPrint(
          '🗜️ Imagen comprimida: '
          '${(originalSize / 1024).toStringAsFixed(0)}KB → '
          '${(compressedSize / 1024).toStringAsFixed(0)}KB '
          '(${((1 - compressedSize / originalSize) * 100).toStringAsFixed(0)}% reducción)',
        );
        return compressed;
      }
    } on Exception catch (e) {
      debugPrint('⚠️ Compresión falló, usando original: $e');
    }
    return file;
  }

  /// Verifica que haya conexión a internet.
  ///
  /// Firebase Storage NO funciona offline. Retorna `true` si hay conexión.
  Future<bool> isOnline() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty && !results.contains(ConnectivityResult.none);
    } on Exception {
      return false;
    }
  }

  /// Extrae la extensión de un path de archivo.
  static String _getExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1 || lastDot == filePath.length - 1) return '';
    return filePath.substring(lastDot).toLowerCase();
  }

  /// Detecta el content type según la extensión del archivo.
  static String _contentTypeFromPath(String filePath) {
    final ext = _getExtension(filePath);
    switch (ext) {
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
      case '.heif':
        return 'image/heic';
      case '.jpg':
      case '.jpeg':
      default:
        return 'image/jpeg';
    }
  }

  /// Obtiene la extensión adecuada del archivo.
  static String _extensionFromPath(String filePath) {
    final ext = _getExtension(filePath);
    if (ext.isNotEmpty) return ext;
    return '.jpg';
  }

  /// Sube una imagen a Firebase Storage.
  ///
  /// [file] - Archivo de imagen a subir.
  /// [type] - Tipo de imagen para organización.
  /// [granjaId] - ID de la granja.
  /// [entityId] - ID de la entidad (lote, item, etc.).
  /// [metadata] - Metadatos adicionales opcionales.
  /// [firestoreDocPath] - Path del documento Firestore a actualizar cuando
  ///   se suba offline (ej: 'granjas/abc123/lotes/xyz789').
  /// [firestoreField] - Campo del documento a actualizar con la URL.
  ///
  /// Retorna [ImageUploadResult] con URL y path.
  /// Si no hay conexión, encola la imagen y retorna un resultado con URL vacía.
  /// Lanza excepción si el archivo excede el tamaño máximo.
  Future<ImageUploadResult> uploadImage({
    required File file,
    required ImageUploadType type,
    required String granjaId,
    required String entityId,
    Map<String, String>? metadata,
    String? firestoreDocPath,
    String? firestoreField,
  }) async {
    // Validar tamaño
    final fileSize = await file.length();
    if (fileSize > maxFileSizeBytes) {
      throw Exception(
        'El archivo excede el tamaño máximo permitido '
        '(${(maxFileSizeBytes / 1024 / 1024).toStringAsFixed(0)}MB)',
      );
    }

    // Verificar conectividad — si no hay, encolar para después
    if (!await isOnline()) {
      final pending = await PendingUploadQueue.instance.enqueue(
        filePath: file.path,
        type: type,
        granjaId: granjaId,
        entityId: entityId,
        metadata: metadata,
        firestoreDocPath: firestoreDocPath,
        firestoreField: firestoreField,
      );
      debugPrint('📋 Sin conexión — imagen encolada: ${pending.id}');
      return ImageUploadResult(
        url: 'pending:${pending.localPath}',
        path: 'pending/${pending.id}',
        sizeBytes: fileSize,
      );
    }

    // Comprimir imagen antes de subir
    final compressedFile = await _compressImage(file);
    final uploadSize = await compressedFile.length();

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = _extensionFromPath(compressedFile.path);
    final path = '${type.folder}/$granjaId/$entityId/$timestamp$ext';

    final ref = _storage.ref().child(path);

    // Configurar metadatos
    final settableMetadata = SettableMetadata(
      contentType: _contentTypeFromPath(compressedFile.path),
      cacheControl: 'public, max-age=31536000',
      customMetadata: {
        'granjaId': granjaId,
        'entityId': entityId,
        'timestamp': timestamp.toString(),
        'type': type.name,
        ...?metadata,
      },
    );

    // Subir archivo — si falla por red o permisos, encolar
    try {
      await ref.putFile(compressedFile, settableMetadata);
    } on SocketException {
      final pending = await PendingUploadQueue.instance.enqueue(
        filePath: file.path,
        type: type,
        granjaId: granjaId,
        entityId: entityId,
        metadata: metadata,
        firestoreDocPath: firestoreDocPath,
        firestoreField: firestoreField,
      );
      debugPrint('📋 Error de red — imagen encolada: ${pending.id}');
      return ImageUploadResult(
        url: 'pending:${pending.localPath}',
        path: 'pending/${pending.id}',
        sizeBytes: fileSize,
      );
    } on FirebaseException {
      final pending = await PendingUploadQueue.instance.enqueue(
        filePath: file.path,
        type: type,
        granjaId: granjaId,
        entityId: entityId,
        metadata: metadata,
        firestoreDocPath: firestoreDocPath,
        firestoreField: firestoreField,
      );
      debugPrint('📋 Error Firebase — imagen encolada: ${pending.id}');
      return ImageUploadResult(
        url: 'pending:${pending.localPath}',
        path: 'pending/${pending.id}',
        sizeBytes: fileSize,
      );
    }

    // Obtener URL de descarga
    final url = await ref.getDownloadURL();

    debugPrint('✅ Imagen subida: $path');

    return ImageUploadResult(url: url, path: path, sizeBytes: uploadSize);
  }

  /// Sube múltiples imágenes.
  ///
  /// [files] - Lista de archivos XFile.
  /// [type] - Tipo de imagen.
  /// [granjaId] - ID de la granja.
  /// [entityId] - ID de la entidad.
  /// [onProgress] - Callback opcional para progreso.
  /// [metadata] - Metadatos adicionales opcionales.
  /// [firestoreDocPath] - Path del documento Firestore a actualizar offline.
  /// [firestoreField] - Campo del documento (array) a actualizar.
  ///
  /// Retorna lista de URLs de las imágenes subidas.
  /// Si no hay conexión, encola las imágenes y retorna lista vacía.
  Future<List<String>> uploadMultipleImages({
    required List<XFile> files,
    required ImageUploadType type,
    required String granjaId,
    required String entityId,
    UploadProgressCallback? onProgress,
    Map<String, String>? metadata,
    String? firestoreDocPath,
    String? firestoreField,
  }) async {
    // Verificar conectividad — si no hay, encolar todas las imágenes
    final online = await isOnline();
    if (!online) {
      int queued = 0;
      for (final xfile in files) {
        try {
          final file = File(xfile.path);
          final fileSize = await file.length();
          if (fileSize > maxFileSizeBytes) continue;

          await PendingUploadQueue.instance.enqueue(
            filePath: xfile.path,
            type: type,
            granjaId: granjaId,
            entityId: entityId,
            metadata: metadata,
            firestoreDocPath: firestoreDocPath,
            firestoreField: firestoreField,
            isMultiple: true,
          );
          queued++;
        } on Exception catch (e) {
          debugPrint('❌ Error encolando imagen: $e');
        }
      }
      debugPrint('📋 Sin conexión — $queued imágenes encoladas');
      // Retornar lista vacía — las fotos se subirán después
      return [];
    }

    final urls = <String>[];
    int uploadedCount = 0;

    for (int i = 0; i < files.length; i++) {
      try {
        final file = File(files[i].path);
        final fileSize = await file.length();

        // Saltar archivos muy grandes
        if (fileSize > maxFileSizeBytes) {
          debugPrint(
            '⚠️ Imagen $i excede ${(maxFileSizeBytes / 1024 / 1024).toStringAsFixed(0)}MB, saltando...',
          );
          continue;
        }

        // Comprimir imagen antes de subir
        final compressedFile = await _compressImage(file);

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = _extensionFromPath(compressedFile.path);
        final path = '${type.folder}/$granjaId/$entityId/$timestamp-$i$ext';

        final ref = _storage.ref().child(path);

        final settableMetadata = SettableMetadata(
          contentType: _contentTypeFromPath(compressedFile.path),
          cacheControl: 'public, max-age=31536000',
          customMetadata: {
            'granjaId': granjaId,
            'entityId': entityId,
            'timestamp': timestamp.toString(),
            'type': type.name,
            'index': i.toString(),
            ...?metadata,
          },
        );

        await ref.putFile(compressedFile, settableMetadata);
        final url = await ref.getDownloadURL();
        urls.add(url);

        uploadedCount++;
        onProgress?.call(uploadedCount, files.length);

        debugPrint('✅ Imagen ${i + 1}/${files.length} subida');
      } on SocketException {
        // Conexión perdida durante la subida — encolar restantes
        debugPrint('⚠️ Conexión perdida, encolando imagen $i...');
        try {
          await PendingUploadQueue.instance.enqueue(
            filePath: files[i].path,
            type: type,
            granjaId: granjaId,
            entityId: entityId,
            metadata: metadata,
            firestoreDocPath: firestoreDocPath,
            firestoreField: firestoreField,
            isMultiple: true,
          );
        } on Exception catch (e) {
          debugPrint('❌ Error encolando imagen: $e');
        }
      } on FirebaseException catch (e) {
        // Error de Firebase (permisos, cuota, etc.) — encolar para reintento
        debugPrint('⚠️ FirebaseException imagen $i: $e — encolando...');
        try {
          await PendingUploadQueue.instance.enqueue(
            filePath: files[i].path,
            type: type,
            granjaId: granjaId,
            entityId: entityId,
            metadata: metadata,
            firestoreDocPath: firestoreDocPath,
            firestoreField: firestoreField,
            isMultiple: true,
          );
        } on Exception catch (enqueueErr) {
          debugPrint('❌ Error encolando imagen: $enqueueErr');
        }
      } on Exception catch (e) {
        debugPrint('❌ Error subiendo imagen $i: $e');
        // Encolar para reintento posterior
        try {
          await PendingUploadQueue.instance.enqueue(
            filePath: files[i].path,
            type: type,
            granjaId: granjaId,
            entityId: entityId,
            metadata: metadata,
            firestoreDocPath: firestoreDocPath,
            firestoreField: firestoreField,
            isMultiple: true,
          );
        } on Exception catch (enqueueErr) {
          debugPrint('❌ Error encolando imagen: $enqueueErr');
        }
      }
    }

    return urls;
  }

  /// Elimina una imagen de Firebase Storage.
  Future<void> deleteImage(String path) async {
    try {
      await _storage.ref().child(path).delete();
      debugPrint('🗑️ Imagen eliminada: $path');
    } on Exception catch (e) {
      debugPrint('❌ Error eliminando imagen: $e');
    }
  }

  /// Elimina múltiples imágenes.
  Future<void> deleteMultipleImages(List<String> paths) async {
    for (final path in paths) {
      await deleteImage(path);
    }
  }

  /// Obtiene URL de descarga de una imagen.
  Future<String?> getDownloadUrl(String path) async {
    try {
      return await _storage.ref().child(path).getDownloadURL();
    } on Exception catch (e) {
      debugPrint('❌ Error obteniendo URL: $e');
      return null;
    }
  }
}

/// Provider para el servicio de subida de imágenes.
final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService.instance;
});
