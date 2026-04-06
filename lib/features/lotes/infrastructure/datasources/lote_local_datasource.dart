import 'dart:convert';

import '../../../../core/storage/local_storage.dart';
import '../models/lote_model.dart';

/// Datasource local para cache de lotes.
class LoteLocalDatasource {
  LoteLocalDatasource(this._storage);

  final LocalStorage _storage;

  static const String _lotesKey = 'cached_lotes';
  static const String _lotePrefix = 'lote_';
  static const String _lotesGalponKey = 'cached_lotes_galpon';

  // ==================== LOTES ====================

  /// Guarda una lista de lotes de una granja en cache.
  Future<void> guardarLotesPorGranja(
    String granjaId,
    List<LoteModel> lotes,
  ) async {
    final key = '${_lotesKey}_granja_$granjaId';
    final data = lotes.map((l) => l.toJson()).toList();
    await _storage.setString(key, jsonEncode(data));
  }

  /// Obtiene los lotes cacheados de una granja.
  Future<List<LoteModel>?> obtenerLotesPorGranja(String granjaId) async {
    final key = '${_lotesKey}_granja_$granjaId';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((item) => LoteModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Guarda una lista de lotes de un galpón en cache.
  Future<void> guardarLotesPorGalpon(
    String galponId,
    List<LoteModel> lotes,
  ) async {
    final key = '${_lotesGalponKey}_$galponId';
    final data = lotes.map((l) => l.toJson()).toList();
    await _storage.setString(key, jsonEncode(data));
  }

  /// Obtiene los lotes cacheados de un galpón.
  Future<List<LoteModel>?> obtenerLotesPorGalpon(String galponId) async {
    final key = '${_lotesGalponKey}_$galponId';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((item) => LoteModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Guarda un lote individual.
  Future<void> guardarLote(LoteModel lote) async {
    final key = '$_lotePrefix${lote.id}';
    await _storage.setString(key, jsonEncode(lote.toJson()));
  }

  /// Obtiene un lote por ID.
  Future<LoteModel?> obtenerLote(String id) async {
    final key = '$_lotePrefix$id';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return LoteModel.fromMap(map, id);
    } catch (_) {
      return null;
    }
  }

  /// Elimina un lote del cache.
  Future<void> eliminarLote(String id) async {
    final key = '$_lotePrefix$id';
    await _storage.remove(key);
  }

  /// Limpia todo el cache de lotes de una granja.
  Future<void> limpiarCacheGranja(String granjaId) async {
    final key = '${_lotesKey}_granja_$granjaId';
    await _storage.remove(key);
  }

  /// Limpia todo el cache de lotes de un galpón.
  Future<void> limpiarCacheGalpon(String galponId) async {
    final key = '${_lotesGalponKey}_$galponId';
    await _storage.remove(key);
  }

  /// Verifica si hay datos en cache para una granja.
  bool tieneCacheValidoGranja(String granjaId) {
    final key = '${_lotesKey}_granja_$granjaId';
    return _storage.getString(key) != null;
  }

  /// Verifica si hay datos en cache para un galpón.
  bool tieneCacheValidoGalpon(String galponId) {
    final key = '${_lotesGalponKey}_$galponId';
    return _storage.getString(key) != null;
  }

  /// Limpia todo el cache de lotes.
  Future<void> limpiarTodoElCache() async {
    final allKeys = _storage.getKeys();
    final lotesKeys = allKeys.where(
      (key) =>
          key.startsWith(_lotesKey) ||
          key.startsWith(_lotePrefix) ||
          key.startsWith(_lotesGalponKey),
    );

    for (final key in lotesKeys) {
      await _storage.remove(key);
    }
  }
}
