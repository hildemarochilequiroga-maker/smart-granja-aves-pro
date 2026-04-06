library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';

import '../../../auth/application/providers/auth_provider.dart';
import '../../domain/entities/granja_usuario.dart';
import '../../domain/entities/invitacion_granja.dart';
import '../../domain/enums/rol_granja_enum.dart';
import '../../domain/repositories/granja_colaboradores_repository.dart';
import '../../domain/usecases/colaboradores_usecases.dart';
import '../../infrastructure/datasources/granja_usuarios_firebase_datasource.dart';
import '../../infrastructure/repositories/granja_colaboradores_repository_impl.dart';

// =============================================================================
// DATASOURCES
// =============================================================================

final granjaUsuariosFirebaseDatasourceProvider =
    Provider<GranjaUsuariosFirebaseDatasource>((ref) {
      return GranjaUsuariosFirebaseDatasource();
    });

// =============================================================================
// REPOSITORIES
// =============================================================================

final granjaUsuariosRepositoryProvider = Provider<GranjaUsuariosRepository>((
  ref,
) {
  return GranjaUsuariosRepositoryImpl(
    datasource: ref.watch(granjaUsuariosFirebaseDatasourceProvider),
  );
});

final invitacionesGranjaRepositoryProvider =
    Provider<InvitacionesGranjaRepository>((ref) {
      return InvitacionesGranjaRepositoryImpl(
        datasource: ref.watch(granjaUsuariosFirebaseDatasourceProvider),
      );
    });

// =============================================================================
// USE CASES
// =============================================================================

final invitarUsuarioAGranjaUseCaseProvider =
    Provider<InvitarUsuarioAGranjaUseCase>((ref) {
      return InvitarUsuarioAGranjaUseCase(
        ref.watch(invitacionesGranjaRepositoryProvider),
      );
    });

final aceptarInvitacionGranjaUseCaseProvider =
    Provider<AceptarInvitacionGranjaUseCase>((ref) {
      return AceptarInvitacionGranjaUseCase(
        ref.watch(invitacionesGranjaRepositoryProvider),
      );
    });

final listarColaboradoresGranjaUseCaseProvider =
    Provider<ListarColaboradoresGranjaUseCase>((ref) {
      return ListarColaboradoresGranjaUseCase(
        ref.watch(granjaUsuariosRepositoryProvider),
      );
    });

final cambiarRolColaboradorUseCaseProvider =
    Provider<CambiarRolColaboradorUseCase>((ref) {
      return CambiarRolColaboradorUseCase(
        ref.watch(granjaUsuariosRepositoryProvider),
      );
    });

final removerColaboradorGranjaUseCaseProvider =
    Provider<RemoverColaboradorGranjaUseCase>((ref) {
      return RemoverColaboradorGranjaUseCase(
        ref.watch(granjaUsuariosRepositoryProvider),
      );
    });

final obtenerRolUsuarioEnGranjaUseCaseProvider =
    Provider<ObtenerRolUsuarioEnGranjaUseCase>((ref) {
      return ObtenerRolUsuarioEnGranjaUseCase(
        ref.watch(granjaUsuariosRepositoryProvider),
      );
    });

final obtenerGranjaIdsDelUsuarioUseCaseProvider =
    Provider<ObtenerGranjaIdsDelUsuarioUseCase>((ref) {
      return ObtenerGranjaIdsDelUsuarioUseCase(
        ref.watch(granjaUsuariosRepositoryProvider),
      );
    });

// =============================================================================
// PROVIDERS DE DATOS - USUARIOS DE UNA GRANJA
// =============================================================================

final usuariosGranjaProvider = FutureProvider.autoDispose
    .family<List<GranjaUsuario>, String>((ref, granjaId) async {
      debugPrint('👥 [ColaboradoresProvider] usuariosGranjaProvider llamado');
      debugPrint('   └─ granjaId: $granjaId');

      final useCase = ref.watch(listarColaboradoresGranjaUseCaseProvider);
      final result = await useCase(
        ListarColaboradoresParams(granjaId: granjaId),
      );

      return result.fold(
        (failure) {
          debugPrint('❌ [ColaboradoresProvider] Error: ${failure.message}');
          return [];
        },
        (usuarios) {
          debugPrint(
            '✅ [ColaboradoresProvider] ${usuarios.length} usuarios cargados',
          );
          for (final u in usuarios) {
            debugPrint(
              '   ├─ ${u.usuarioId.substring(0, 8)}... - ${u.rol.name}',
            );
          }
          return usuarios;
        },
      );
    });

// =============================================================================
// PROVIDERS DE DATOS - ROL DEL USUARIO ACTUAL EN UNA GRANJA
// =============================================================================

final rolUsuarioActualEnGranjaProvider = FutureProvider.autoDispose
    .family<RolGranja?, String>((ref, granjaId) async {
      debugPrint('🔐 [ColaboradoresProvider] rolUsuarioActualEnGranjaProvider');
      debugPrint('   └─ granjaId: $granjaId');

      final currentUser = ref.watch(currentUserProvider);
      if (currentUser == null) {
        debugPrint('⚠️ [ColaboradoresProvider] Usuario no autenticado');
        return null;
      }
      debugPrint('   └─ usuarioId: ${currentUser.id.substring(0, 8)}...');

      final useCase = ref.watch(obtenerRolUsuarioEnGranjaUseCaseProvider);
      final result = await useCase(
        ObtenerRolUsuarioParams(granjaId: granjaId, usuarioId: currentUser.id),
      );

      return result.fold(
        (failure) {
          debugPrint('❌ [ColaboradoresProvider] Error: ${failure.message}');
          return null;
        },
        (rol) {
          debugPrint(
            '✅ [ColaboradoresProvider] Rol obtenido: ${rol?.name ?? "ninguno"}',
          );
          return rol;
        },
      );
    });

// =============================================================================
// PROVIDERS DE DATOS - GRANJAS DEL USUARIO ACTUAL
// =============================================================================

final granjasUsuarioActualProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final useCase = ref.watch(obtenerGranjaIdsDelUsuarioUseCaseProvider);
  final result = await useCase(
    ObtenerGranjaIdsDelUsuarioParams(usuarioId: currentUser.id),
  );

  return result.fold((failure) => [], (granjas) => granjas);
});

// =============================================================================
// PROVIDERS DE DATOS - GRANJAS DONDE PUEDE INVITAR
// =============================================================================

/// Provider que verifica si el usuario puede invitar en una granja específica
final puedeInvitarEnGranjaProvider = FutureProvider.autoDispose
    .family<bool, String>((ref, granjaId) async {
      final rolAsync = await ref.watch(
        rolUsuarioActualEnGranjaProvider(granjaId).future,
      );
      return rolAsync?.canInviteUsers ?? false;
    });

// =============================================================================
// PROVIDERS DE ACCIONES - CREAR INVITACIÓN
// =============================================================================

final crearInvitacionProvider = FutureProvider.autoDispose
    .family<InvitacionGranja, CrearInvitacionParams>((ref, params) async {
      debugPrint('📨 [ColaboradoresProvider] crearInvitacionProvider');
      debugPrint('   ├─ granjaId: ${params.granjaId}');
      debugPrint('   ├─ granjaNombre: ${params.granjaNombre}');
      debugPrint('   ├─ rol: ${params.rol.name}');
      debugPrint('   └─ creadoPorId: ${params.creadoPorId.substring(0, 8)}...');

      final useCase = ref.watch(invitarUsuarioAGranjaUseCaseProvider);
      final result = await useCase(
        InvitarUsuarioAGranjaParams(
          granjaId: params.granjaId,
          granjaNombre: params.granjaNombre,
          rol: params.rol,
          creadoPorId: params.creadoPorId,
          creadoPorNombre: params.creadoPorNombre,
          emailDestino: params.emailDestino,
        ),
      );

      return result.fold(
        (failure) {
          debugPrint(
            '❌ [ColaboradoresProvider] Error creando invitación: ${failure.message}',
          );
          throw Exception(failure.message);
        },
        // Las Cloud Functions manejan la notificación automáticamente
        // cuando se crea el documento de invitación en Firestore
        (invitacion) {
          debugPrint('✅ [ColaboradoresProvider] Invitación creada:');
          debugPrint('   ├─ código: ${invitacion.codigo}');
          debugPrint('   └─ expira: ${invitacion.fechaExpiracion}');
          return invitacion;
        },
      );
    });

class CrearInvitacionParams {
  const CrearInvitacionParams({
    required this.granjaId,
    required this.granjaNombre,
    required this.rol,
    required this.creadoPorId,
    required this.creadoPorNombre,
    this.emailDestino,
  });

  final String granjaId;
  final String granjaNombre;
  final RolGranja rol;
  final String creadoPorId;
  final String creadoPorNombre;
  final String? emailDestino;
}

// Alias for UI usage
typedef CrearInvitacionParamsUI = CrearInvitacionParams;

// =============================================================================
// PROVIDERS DE ACCIONES - VERIFICAR INVITACIÓN (antes de aceptar)
// =============================================================================

final verificarInvitacionProvider = FutureProvider.autoDispose
    .family<InvitacionGranja?, String>((ref, codigo) async {
      debugPrint('🔍 [ColaboradoresProvider] verificarInvitacionProvider');
      debugPrint('   └─ codigo: $codigo');

      final repository = ref.watch(invitacionesGranjaRepositoryProvider);
      final result = await repository.obtenerInvitacionPorCodigo(
        codigo: codigo,
      );

      return result.fold(
        (failure) {
          debugPrint(
            '❌ [ColaboradoresProvider] Error verificando: ${failure.message}',
          );
          throw Exception(failure.message);
        },
        (invitacion) {
          if (invitacion != null) {
            debugPrint('✅ [ColaboradoresProvider] Invitación verificada:');
            debugPrint('   ├─ granjaNombre: ${invitacion.granjaNombre}');
            debugPrint('   ├─ rol: ${invitacion.rol.name}');
            debugPrint('   ├─ esValida: ${invitacion.esValida}');
            debugPrint('   └─ diasRestantes: ${invitacion.diasRestantes}');
          } else {
            debugPrint('⚠️ [ColaboradoresProvider] Invitación no encontrada');
          }
          return invitacion;
        },
      );
    });

// =============================================================================
// PROVIDERS DE ACCIONES - ACEPTAR INVITACIÓN
// =============================================================================

final aceptarInvitacionProvider = FutureProvider.autoDispose
    .family<GranjaUsuario, AceptarInvitacionParamsUI>((ref, params) async {
      debugPrint('✅ [ColaboradoresProvider] aceptarInvitacionProvider');
      debugPrint('   └─ codigo: ${params.codigo}');

      final currentUser = ref.watch(currentUserProvider);
      if (currentUser == null) {
        debugPrint('❌ [ColaboradoresProvider] Usuario no autenticado');
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }
      debugPrint('   └─ usuarioId: ${currentUser.id.substring(0, 8)}...');

      final useCase = ref.watch(aceptarInvitacionGranjaUseCaseProvider);
      final result = await useCase(
        AceptarInvitacionParams(
          codigo: params.codigo,
          usuarioId: currentUser.id,
          nombreCompleto: currentUser.nombreCompleto,
          email: currentUser.email,
        ),
      );

      return result.fold(
        (failure) {
          debugPrint(
            '❌ [ColaboradoresProvider] Error aceptando: ${failure.message}',
          );
          throw Exception(failure.message);
        },
        (usuario) {
          debugPrint('✅ [ColaboradoresProvider] Invitación aceptada!');
          debugPrint('   ├─ granjaId: ${usuario.granjaId}');
          debugPrint('   └─ rol asignado: ${usuario.rol.name}');
          return usuario;
        },
      );
    });

class AceptarInvitacionParamsUI {
  const AceptarInvitacionParamsUI({required this.codigo});

  final String codigo;
}

// =============================================================================
// PROVIDERS DE ACCIONES - CAMBIAR ROL
// =============================================================================

final cambiarRolProvider = FutureProvider.autoDispose
    .family<GranjaUsuario, CambiarRolParamsUI>((ref, params) async {
      debugPrint('🔄 [ColaboradoresProvider] cambiarRolProvider');
      debugPrint('   ├─ granjaId: ${params.granjaId}');
      debugPrint('   ├─ usuarioId: ${params.usuarioId.substring(0, 8)}...');
      debugPrint('   └─ nuevoRol: ${params.nuevoRol.name}');

      // Verificar que el usuario actual tiene permisos
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser == null) {
        debugPrint('❌ [ColaboradoresProvider] Usuario no autenticado');
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final rolActual = await ref.watch(
        rolUsuarioActualEnGranjaProvider(params.granjaId).future,
      );
      debugPrint(
        '   ├─ Rol del usuario actual: ${rolActual?.name ?? "ninguno"}',
      );

      if (rolActual == null || !rolActual.canChangeRoles) {
        debugPrint('❌ [ColaboradoresProvider] Sin permisos para cambiar roles');
        throw Exception(ErrorMessages.get('PERM_NO_CHANGE_ROLE'));
      }

      // No se puede cambiar a rol owner
      if (params.nuevoRol == RolGranja.owner) {
        debugPrint('❌ [ColaboradoresProvider] Intento de asignar rol owner');
        throw Exception(ErrorMessages.get('PERM_NO_ASSIGN_OWNER'));
      }

      final useCase = ref.watch(cambiarRolColaboradorUseCaseProvider);
      final result = await useCase(
        CambiarRolColaboradorParams(
          granjaId: params.granjaId,
          usuarioId: params.usuarioId,
          nuevoRol: params.nuevoRol,
        ),
      );

      return result.fold(
        (failure) {
          debugPrint(
            '❌ [ColaboradoresProvider] Error cambiando rol: ${failure.message}',
          );
          throw Exception(failure.message);
        },
        (usuario) {
          debugPrint('✅ [ColaboradoresProvider] Rol cambiado exitosamente');
          return usuario;
        },
      );
    });

class CambiarRolParamsUI {
  const CambiarRolParamsUI({
    required this.granjaId,
    required this.usuarioId,
    required this.nuevoRol,
  });

  final String granjaId;
  final String usuarioId;
  final RolGranja nuevoRol;
}

// =============================================================================
// PROVIDERS DE ACCIONES - REMOVER COLABORADOR
// =============================================================================

final removerColaboradorProvider = FutureProvider.autoDispose
    .family<void, RemoverColaboradorParamsUI>((ref, params) async {
      debugPrint('🗑️ [ColaboradoresProvider] removerColaboradorProvider');
      debugPrint('   ├─ granjaId: ${params.granjaId}');
      debugPrint('   └─ usuarioId: ${params.usuarioId.substring(0, 8)}...');

      // Verificar que el usuario actual tiene permisos
      final currentUser = ref.watch(currentUserProvider);
      if (currentUser == null) {
        debugPrint('❌ [ColaboradoresProvider] Usuario no autenticado');
        throw Exception(ErrorMessages.get('AUTH_USER_NOT_AUTHENTICATED'));
      }

      final rolActual = await ref.watch(
        rolUsuarioActualEnGranjaProvider(params.granjaId).future,
      );
      debugPrint(
        '   ├─ Rol del usuario actual: ${rolActual?.name ?? "ninguno"}',
      );

      // Caso 1: El usuario se está removiendo a sí mismo (abandonar)
      final esAbandonar = currentUser.id == params.usuarioId;
      debugPrint('   ├─ Es abandonar: $esAbandonar');

      if (esAbandonar) {
        // Un usuario siempre puede abandonar (excepto el owner, pero eso se valida en el backend)
        debugPrint('   ├─ Usuario abandonando granja...');
        final repository = ref.watch(granjaUsuariosRepositoryProvider);
        final result = await repository.abandonarGranja(
          granjaId: params.granjaId,
          usuarioId: params.usuarioId,
        );
        return result.fold(
          (failure) {
            debugPrint(
              '❌ [ColaboradoresProvider] Error abandonando: ${failure.message}',
            );
            throw Exception(failure.message);
          },
          (_) {
            debugPrint('✅ [ColaboradoresProvider] Usuario abandonó la granja');
            return null;
          },
        );
      }

      // Caso 2: Removiendo a otro usuario - verificar permisos
      if (rolActual == null || !rolActual.canRemoveUsers) {
        debugPrint(
          '❌ [ColaboradoresProvider] Sin permisos para remover usuarios',
        );
        throw Exception(ErrorMessages.get('PERM_NO_REMOVE_USER'));
      }

      debugPrint('   ├─ Removiendo usuario...');
      final useCase = ref.watch(removerColaboradorGranjaUseCaseProvider);
      final result = await useCase(
        RemoverColaboradorParams(
          granjaId: params.granjaId,
          usuarioId: params.usuarioId,
        ),
      );

      return result.fold(
        (failure) {
          debugPrint(
            '❌ [ColaboradoresProvider] Error removiendo: ${failure.message}',
          );
          throw Exception(failure.message);
        },
        (_) {
          debugPrint('✅ [ColaboradoresProvider] Usuario removido exitosamente');
          return null;
        },
      );
    });

class RemoverColaboradorParamsUI {
  const RemoverColaboradorParamsUI({
    required this.granjaId,
    required this.usuarioId,
  });

  final String granjaId;
  final String usuarioId;
}

// =============================================================================
// PROVIDERS DE ACCIONES - ABANDONAR GRANJA (usuario sale voluntariamente)
// =============================================================================

final abandonarGranjaProvider = FutureProvider.autoDispose
    .family<void, AbandonarGranjaParamsUI>((ref, params) async {
      final repository = ref.watch(granjaUsuariosRepositoryProvider);
      final result = await repository.abandonarGranja(
        granjaId: params.granjaId,
        usuarioId: params.usuarioId,
      );

      return result.fold(
        (failure) => throw Exception(failure.message),
        (_) => null,
      );
    });

class AbandonarGranjaParamsUI {
  const AbandonarGranjaParamsUI({
    required this.granjaId,
    required this.usuarioId,
  });

  final String granjaId;
  final String usuarioId;
}

// =============================================================================
// PROVIDERS DE DATOS - INVITACIONES PENDIENTES
// =============================================================================

final invitacionesPendientesProvider =
    FutureProvider.family<List<InvitacionGranja>, String>((
      ref,
      granjaId,
    ) async {
      final repository = ref.watch(invitacionesGranjaRepositoryProvider);
      final result = await repository.obtenerInvitacionesPorGranja(
        granjaId: granjaId,
        soloValidas: true,
      );

      return result.fold((failure) => [], (invitaciones) => invitaciones);
    });
