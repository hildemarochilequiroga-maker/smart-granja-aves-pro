library;

import 'dart:convert';

import '../../../../core/storage/local_storage.dart';
import '../models/usuario_model.dart';

/// Fuente de datos local para autenticación
///
/// Maneja el almacenamiento local de datos de sesión y usuario.
class AuthLocalDatasource {
  AuthLocalDatasource(this._storage);

  final LocalStorage _storage;

  // Claves de almacenamiento
  static const String _keyUsuario = 'auth_usuario';
  static const String _keyToken = 'auth_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUltimoEmail = 'auth_ultimo_email';
  static const String _keyRecordarEmail = 'auth_recordar_email';

  // ===========================================================================
  // USUARIO
  // ===========================================================================

  /// Guarda el usuario en cache local
  Future<void> guardarUsuario(UsuarioModel usuario) async {
    final json = usuario.toJson();
    await _storage.setString(_keyUsuario, _encodeJson(json));
  }

  /// Obtiene el usuario del cache local
  UsuarioModel? obtenerUsuario() {
    final jsonStr = _storage.getString(_keyUsuario);
    if (jsonStr == null) return null;

    try {
      final json = _decodeJson(jsonStr);
      return UsuarioModel.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  /// Elimina el usuario del cache local
  Future<void> eliminarUsuario() async {
    await _storage.remove(_keyUsuario);
  }

  // ===========================================================================
  // TOKENS
  // ===========================================================================

  /// Guarda el token de autenticación
  Future<void> guardarToken(String token) async {
    await _storage.setString(_keyToken, token);
  }

  /// Obtiene el token de autenticación
  String? obtenerToken() {
    return _storage.getString(_keyToken);
  }

  /// Guarda el refresh token
  Future<void> guardarRefreshToken(String token) async {
    await _storage.setString(_keyRefreshToken, token);
  }

  /// Obtiene el refresh token
  String? obtenerRefreshToken() {
    return _storage.getString(_keyRefreshToken);
  }

  /// Elimina los tokens
  Future<void> eliminarTokens() async {
    await Future.wait([
      _storage.remove(_keyToken),
      _storage.remove(_keyRefreshToken),
    ]);
  }

  // ===========================================================================
  // EMAIL RECORDADO
  // ===========================================================================

  /// Guarda el último email usado
  Future<void> guardarUltimoEmail(String email) async {
    await _storage.setString(_keyUltimoEmail, email);
  }

  /// Obtiene el último email usado
  String? obtenerUltimoEmail() {
    return _storage.getString(_keyUltimoEmail);
  }

  /// Establece si se debe recordar el email
  Future<void> setRecordarEmail(bool recordar) async {
    await _storage.setBool(_keyRecordarEmail, recordar);
  }

  /// Obtiene si se debe recordar el email
  bool getRecordarEmail() {
    return _storage.getBoolOrDefault(_keyRecordarEmail);
  }

  // ===========================================================================
  // LIMPIEZA
  // ===========================================================================

  /// Limpia todos los datos de autenticación local
  Future<void> limpiarDatos() async {
    await Future.wait([eliminarUsuario(), eliminarTokens()]);
    // No eliminamos último email si está configurado para recordar
  }

  /// Limpia absolutamente todos los datos
  Future<void> limpiarTodo() async {
    await Future.wait([
      eliminarUsuario(),
      eliminarTokens(),
      _storage.remove(_keyUltimoEmail),
      _storage.remove(_keyRecordarEmail),
    ]);
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _encodeJson(Map<String, dynamic> json) {
    return jsonEncode(json);
  }

  Map<String, dynamic> _decodeJson(String encoded) {
    return jsonDecode(encoded) as Map<String, dynamic>;
  }
}
