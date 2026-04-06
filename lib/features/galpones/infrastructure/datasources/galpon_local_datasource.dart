import 'dart:convert';

import '../../../../core/storage/local_storage.dart';
import '../models/galpon_model.dart';
import '../models/galpon_evento_model.dart';

/// Datasource local para cache de galpones.
class GalponLocalDatasource {
  GalponLocalDatasource(this._storage);

  final LocalStorage _storage;

  static const String _galponesKey = 'cached_galpones';
  static const String _galponPrefix = 'galpon_';
  static const String _eventosKey = 'cached_galpon_eventos';

  // ==================== GALPONES ====================

  /// Guarda una lista de galpones en cache.
  Future<void> guardarGalpones(
    String granjaId,
    List<GalponModel> galpones,
  ) async {
    final key = '${_galponesKey}_$granjaId';
    final data = galpones.map((g) => g.toJson()).toList();
    await _storage.setString(key, jsonEncode(data));
  }

  /// Obtiene los galpones cacheados de una granja.
  Future<List<GalponModel>?> obtenerGalpones(String granjaId) async {
    final key = '${_galponesKey}_$granjaId';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map((item) => GalponModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Guarda un galpón individual.
  Future<void> guardarGalpon(GalponModel galpon) async {
    final key = '$_galponPrefix${galpon.id}';
    await _storage.setString(key, jsonEncode(galpon.toJson()));
  }

  /// Obtiene un galpón por ID.
  Future<GalponModel?> obtenerGalpon(String id) async {
    final key = '$_galponPrefix$id';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final map = jsonDecode(data) as Map<String, dynamic>;
      return GalponModel.fromMap(map, id);
    } catch (_) {
      return null;
    }
  }

  /// Elimina un galpón del cache.
  Future<void> eliminarGalpon(String id) async {
    final key = '$_galponPrefix$id';
    await _storage.remove(key);
  }

  /// Limpia todo el cache de galpones de una granja.
  Future<void> limpiarCache(String granjaId) async {
    final key = '${_galponesKey}_$granjaId';
    await _storage.remove(key);
  }

  /// Verifica si hay datos en cache.
  bool tieneCacheValido(String granjaId) {
    final key = '${_galponesKey}_$granjaId';
    return _storage.getString(key) != null;
  }

  // ==================== EVENTOS ====================

  /// Guarda eventos de un galpón en cache.
  Future<void> guardarEventos(
    String galponId,
    List<GalponEventoModel> eventos,
  ) async {
    final key = '${_eventosKey}_$galponId';
    final data = eventos.map((e) => e.toJson()).toList();
    await _storage.setString(key, jsonEncode(data));
  }

  /// Obtiene los eventos cacheados de un galpón.
  Future<List<GalponEventoModel>?> obtenerEventos(String galponId) async {
    final key = '${_eventosKey}_$galponId';
    final data = _storage.getString(key);
    if (data == null) return null;

    try {
      final list = jsonDecode(data) as List<dynamic>;
      return list
          .map(
            (item) => GalponEventoModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  /// Limpia eventos de un galpón del cache.
  Future<void> limpiarEventos(String galponId) async {
    final key = '${_eventosKey}_$galponId';
    await _storage.remove(key);
  }
}
