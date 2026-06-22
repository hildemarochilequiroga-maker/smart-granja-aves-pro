/// Smart pre-fill cache for daily operational records.
///
/// Persists the most recently used values for each registro type per lote
/// in [SharedPreferences]. This enables:
///
/// - **Instant smart defaults** in registro forms (no Firestore round-trip)
/// - **"Duplicate last" quick action** from the dashboard
/// - **Faster data entry** by avoiding repetitive typing of values that
///   barely change day-to-day (cantidad de aves, tipo alimento, edad, etc.)
///
/// Cached values are non-authoritative — they are hints to fill the form
/// faster. The actual record is always validated and stored in Firestore.
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The four operational registro types covered by the cache.
enum RegistroQuickType {
  produccion('produccion'),
  peso('peso'),
  mortalidad('mortalidad'),
  consumo('consumo');

  const RegistroQuickType(this.key);
  final String key;
}

/// Service that persists last-used values per (lote, registroType).
class RegistroQuickCacheService {
  RegistroQuickCacheService(this._prefs);

  final SharedPreferences _prefs;

  static const _prefix = 'registro_quick_cache';

  String _key(String loteId, RegistroQuickType type) =>
      '${_prefix}_${type.key}_$loteId';

  /// Persist the last successful values for [type] in [loteId].
  ///
  /// [values] should be a map of JSON-encodable primitives. Non-encodable
  /// keys are silently dropped.
  Future<void> save(
    String loteId,
    RegistroQuickType type,
    Map<String, dynamic> values,
  ) async {
    final cleaned = <String, dynamic>{};
    values.forEach((k, v) {
      if (v == null) return;
      if (v is num || v is String || v is bool) {
        cleaned[k] = v;
      } else {
        cleaned[k] = v.toString();
      }
    });
    cleaned['_savedAt'] = DateTime.now().toIso8601String();
    await _prefs.setString(_key(loteId, type), jsonEncode(cleaned));
  }

  /// Read cached values for [type] in [loteId].
  ///
  /// Returns `null` when no cache exists or when the cached entry is
  /// older than [maxAge].
  Map<String, dynamic>? read(
    String loteId,
    RegistroQuickType type, {
    Duration maxAge = const Duration(days: 14),
  }) {
    final raw = _prefs.getString(_key(loteId, type));
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final savedAtRaw = decoded['_savedAt'];
      if (savedAtRaw is String) {
        final savedAt = DateTime.tryParse(savedAtRaw);
        if (savedAt != null && DateTime.now().difference(savedAt) > maxAge) {
          return null;
        }
      }
      return decoded;
    } on FormatException {
      return null;
    }
  }

  /// Remove cached entry for [type] in [loteId].
  Future<void> clear(String loteId, RegistroQuickType type) async {
    await _prefs.remove(_key(loteId, type));
  }
}

/// Provider for [RegistroQuickCacheService].
///
/// Throws if accessed before [SharedPreferences] is initialized — overrides
/// must be installed at app boot.
final registroQuickCacheServiceProvider = Provider<RegistroQuickCacheService>((
  ref,
) {
  throw UnimplementedError(
    'registroQuickCacheServiceProvider must be overridden at app start',
  );
});

/// Async fallback provider that resolves the service lazily. Useful for
/// pages that don't have access to the boot-time override.
final registroQuickCacheAsyncProvider =
    FutureProvider<RegistroQuickCacheService>((ref) async {
      final prefs = await SharedPreferences.getInstance();
      return RegistroQuickCacheService(prefs);
    });
