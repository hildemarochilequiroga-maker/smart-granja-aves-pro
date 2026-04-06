library;

import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para almacenamiento local con SharedPreferences
class LocalStorage {
  LocalStorage._(this._prefs);

  final SharedPreferences _prefs;

  static LocalStorage? _instance;

  /// Inicializa el almacenamiento local
  static Future<LocalStorage> init() async {
    if (_instance != null) return _instance!;

    final prefs = await SharedPreferences.getInstance();
    _instance = LocalStorage._(prefs);
    return _instance!;
  }

  /// Obtiene la instancia actual
  static LocalStorage get instance {
    if (_instance == null) {
      throw StateError(
        'LocalStorage no ha sido inicializado. '
        'Llama a LocalStorage.init() primero.',
      );
    }
    return _instance!;
  }

  // ============================================================================
  // STRING
  // ============================================================================

  /// Guarda un string
  Future<bool> setString(String key, String value) async {
    return _prefs.setString(key, value);
  }

  /// Obtiene un string
  String? getString(String key) {
    return _prefs.getString(key);
  }

  /// Obtiene un string o valor por defecto
  String getStringOrDefault(String key, [String defaultValue = '']) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // ============================================================================
  // INT
  // ============================================================================

  /// Guarda un int
  Future<bool> setInt(String key, int value) async {
    return _prefs.setInt(key, value);
  }

  /// Obtiene un int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Obtiene un int o valor por defecto
  int getIntOrDefault(String key, [int defaultValue = 0]) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  // ============================================================================
  // DOUBLE
  // ============================================================================

  /// Guarda un double
  Future<bool> setDouble(String key, double value) async {
    return _prefs.setDouble(key, value);
  }

  /// Obtiene un double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  /// Obtiene un double o valor por defecto
  double getDoubleOrDefault(String key, [double defaultValue = 0.0]) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  // ============================================================================
  // BOOL
  // ============================================================================

  /// Guarda un bool
  Future<bool> setBool(String key, bool value) async {
    return _prefs.setBool(key, value);
  }

  /// Obtiene un bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  /// Obtiene un bool o valor por defecto
  bool getBoolOrDefault(String key, [bool defaultValue = false]) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  // ============================================================================
  // STRING LIST
  // ============================================================================

  /// Guarda una lista de strings
  Future<bool> setStringList(String key, List<String> value) async {
    return _prefs.setStringList(key, value);
  }

  /// Obtiene una lista de strings
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  /// Obtiene una lista de strings o lista vacía
  List<String> getStringListOrDefault(String key) {
    return _prefs.getStringList(key) ?? [];
  }

  // ============================================================================
  // UTILITIES
  // ============================================================================

  /// Verifica si existe una clave
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Elimina una clave
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  /// Limpia todo el almacenamiento
  Future<bool> clear() async {
    return _prefs.clear();
  }

  /// Obtiene todas las claves
  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  /// Recarga desde disco
  Future<void> reload() async {
    await _prefs.reload();
  }
}
