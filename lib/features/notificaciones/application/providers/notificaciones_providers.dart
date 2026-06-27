/// Providers para notificaciones.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../domain/entities/notificacion.dart';
import '../../infrastructure/repositories/notificaciones_repository.dart';
import '../services/notification_service.dart';
import '../services/alertas_service.dart';

/// Provider del servicio de notificaciones.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

/// Provider del servicio de alertas.
final alertasServiceProvider = Provider<AlertasService>((ref) {
  return AlertasService();
});

/// Provider del repositorio de notificaciones.
final notificacionesRepositoryProvider = Provider<NotificacionesRepository>((
  ref,
) {
  return NotificacionesRepository();
});

/// Stream de todas las notificaciones del usuario actual.
final notificacionesStreamProvider =
    StreamProvider.autoDispose<List<Notificacion>>((ref) {
      final user = ref.watch(currentUserProvider);
      if (user == null) return Stream.value([]);

      final repo = ref.watch(notificacionesRepositoryProvider);
      return repo.streamNotificaciones(user.id);
    });

/// Stream de notificaciones no leídas.
final notificacionesNoLeidasStreamProvider =
    StreamProvider.autoDispose<List<Notificacion>>((ref) {
      final user = ref.watch(currentUserProvider);
      if (user == null) return Stream.value([]);

      final repo = ref.watch(notificacionesRepositoryProvider);
      return repo.streamNotificacionesNoLeidas(user.id);
    });

/// Stream del conteo de notificaciones no leídas.
final conteoNotificacionesNoLeidasProvider = StreamProvider.autoDispose<int>((
  ref,
) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(0);

  final repo = ref.watch(notificacionesRepositoryProvider);
  return repo.streamConteoNoLeidas(user.id);
});

/// Notifier para acciones de notificaciones.
class NotificacionesNotifier extends StateNotifier<AsyncValue<void>> {
  NotificacionesNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  /// Marca una notificación como leída.
  Future<void> marcarComoLeida(String notificacionId) async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.marcarComoLeida(user.id, notificacionId);
      if (!mounted) return;
      state = const AsyncValue.data(null);
    } on Exception catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  /// Marca todas las notificaciones como leídas.
  Future<void> marcarTodasComoLeidas() async {
    if (!mounted) return;
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.marcarTodasComoLeidas(user.id);
      if (!mounted) return;
      state = const AsyncValue.data(null);
    } on Exception catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  /// Elimina una notificación.
  ///
  /// Retorna `true` si la operación fue exitosa, `false` si falló.
  Future<bool> eliminar(String notificacionId) async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.eliminar(user.id, notificacionId);
      if (mounted) state = const AsyncValue.data(null);
      return true;
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Elimina todas las notificaciones leídas.
  ///
  /// Retorna `true` si la operación fue exitosa, `false` si falló.
  Future<bool> eliminarLeidas() async {
    if (mounted) state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.eliminarLeidas(user.id);
      if (mounted) state = const AsyncValue.data(null);
      return true;
    } on Exception catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// Provider del notifier de notificaciones.
///
/// No se usa `autoDispose`: es un notifier de acciones (marcar leída, eliminar…)
/// que se invoca con `ref.read(...notifier)`. Si fuese autoDispose podría
/// destruirse mientras una acción está en curso (p.ej. al cerrar el diálogo de
/// "eliminar leídas") y lanzar "Tried to use … after dispose".
final notificacionesNotifierProvider =
    StateNotifierProvider<NotificacionesNotifier, AsyncValue<void>>((ref) {
      return NotificacionesNotifier(ref);
    });
