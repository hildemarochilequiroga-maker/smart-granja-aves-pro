library;

import 'dart:convert';

import '../../../../core/storage/local_storage.dart';
import '../models/granja_model.dart';

/// Datasource local para cache de granjas
class GranjaLocalDatasource {
  GranjaLocalDatasource(this._storage);

  final LocalStorage _storage;

  static const String _granjasKey = 'cached_granjas';
  static const String _granjaPrefix = 'granja_';

  /// Guarda una lista de granjas en cache
  Future<void> guardarGranjas(
    String usuarioId,
    List<GranjaModel> granjas,
  ) async {
    final key = '${_granjasKey}_$usuarioId';
    final data = granjas.map((g) => g.toJson()).toList();
    await _storage.setString(key, jsonEncode(data));
  }

  /// Obtiene las granjas cacheadas del usuario
  Future<List<GranjaModel>?> obtenerGranjas(String usuarioId) async {
    final key = '${_granjasKey}_$usuarioId';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((item) => GranjaModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Guarda una granja individual
  Future<void> guardarGranja(GranjaModel granja) async {
    final key = '$_granjaPrefix${granja.id}';
    await _storage.setString(key, jsonEncode(granja.toJson()));
  }

  /// Obtiene una granja por ID
  Future<GranjaModel?> obtenerGranja(String id) async {
    final key = '$_granjaPrefix$id';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return GranjaModel.fromMap(map, id);
    } catch (_) {
      return null;
    }
  }

  /// Elimina una granja del cache
  Future<void> eliminarGranja(String id) async {
    final key = '$_granjaPrefix$id';
    await _storage.remove(key);
  }

  /// Limpia todo el cache de granjas del usuario
  Future<void> limpiarCache(String usuarioId) async {
    final key = '${_granjasKey}_$usuarioId';
    await _storage.remove(key);
  }

  /// Verifica si hay datos en cache
  bool tieneCacheValido(String usuarioId) {
    final key = '${_granjasKey}_$usuarioId';
    return _storage.getString(key) != null;
  }
}
