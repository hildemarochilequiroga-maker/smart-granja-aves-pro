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

/// Provider para marcar notificación como leída.
final marcarNotificacionLeidaProvider = FutureProvider.autoDispose
    .family<void, String>((ref, notificacionId) async {
      final user = ref.watch(currentUserProvider);
      if (user == null) return;

      final repo = ref.watch(notificacionesRepositoryProvider);
      await repo.marcarComoLeida(user.id, notificacionId);
    });

/// Provider para marcar todas como leídas.
final marcarTodasLeidasProvider = FutureProvider.autoDispose<void>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return;

  final repo = ref.watch(notificacionesRepositoryProvider);
  await repo.marcarTodasComoLeidas(user.id);
});

/// Provider para eliminar notificación.
final eliminarNotificacionProvider = FutureProvider.autoDispose
    .family<void, String>((ref, notificacionId) async {
      final user = ref.watch(currentUserProvider);
      if (user == null) return;

      final repo = ref.watch(notificacionesRepositoryProvider);
      await repo.eliminar(user.id, notificacionId);
    });

/// Provider para eliminar notificaciones leídas.
final eliminarNotificacionesLeidasProvider = FutureProvider.autoDispose<void>((
  ref,
) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return;

  final repo = ref.watch(notificacionesRepositoryProvider);
  await repo.eliminarLeidas(user.id);
});

/// Notifier para acciones de notificaciones.
class NotificacionesNotifier extends StateNotifier<AsyncValue<void>> {
  NotificacionesNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  /// Marca una notificación como leída.
  Future<void> marcarComoLeida(String notificacionId) async {
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
  Future<void> eliminar(String notificacionId) async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.eliminar(user.id, notificacionId);
      if (!mounted) return;
      state = const AsyncValue.data(null);
    } on Exception catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }

  /// Elimina todas las notificaciones leídas.
  Future<void> eliminarLeidas() async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      if (user == null) {
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final repo = _ref.read(notificacionesRepositoryProvider);
      await repo.eliminarLeidas(user.id);
      if (!mounted) return;
      state = const AsyncValue.data(null);
    } on Exception catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider del notifier de notificaciones.
final notificacionesNotifierProvider =
    StateNotifierProvider.autoDispose<NotificacionesNotifier, AsyncValue<void>>(
      (ref) {
        return NotificacionesNotifier(ref);
      },
    );
