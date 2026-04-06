library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../notificaciones/application/services/notification_service.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/usecases.dart';
import '../../infrastructure/datasources/datasources.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';
import '../state/auth_state.dart';

// =============================================================================
// PROVIDERS DE INFRAESTRUCTURA
// =============================================================================

/// Provider del NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfo();
});

/// Provider del LocalStorage - debe ser inicializado antes de usar
final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage.instance;
});

/// Provider del datasource de Firebase
final authFirebaseDatasourceProvider = Provider<AuthFirebaseDatasource>((ref) {
  return AuthFirebaseDatasource();
});

/// Provider del datasource local
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final storage = ref.watch(localStorageProvider);
  return AuthLocalDatasource(storage);
});

/// Provider del repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    firebaseDatasource: ref.watch(authFirebaseDatasourceProvider),
    localDatasource: ref.watch(authLocalDatasourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// =============================================================================
// PROVIDERS DE CASOS DE USO
// =============================================================================

final loginConEmailUseCaseProvider = Provider<LoginConEmailUseCase>((ref) {
  return LoginConEmailUseCase(ref.watch(authRepositoryProvider));
});

final loginConGoogleUseCaseProvider = Provider<LoginConGoogleUseCase>((ref) {
  return LoginConGoogleUseCase(ref.watch(authRepositoryProvider));
});

final loginConAppleUseCaseProvider = Provider<LoginConAppleUseCase>((ref) {
  return LoginConAppleUseCase(ref.watch(authRepositoryProvider));
});

final registrarConEmailUseCaseProvider = Provider<RegistrarConEmailUseCase>((
  ref,
) {
  return RegistrarConEmailUseCase(ref.watch(authRepositoryProvider));
});

final cerrarSesionUseCaseProvider = Provider<CerrarSesionUseCase>((ref) {
  return CerrarSesionUseCase(ref.watch(authRepositoryProvider));
});

final obtenerUsuarioActualUseCaseProvider =
    Provider<ObtenerUsuarioActualUseCase>((ref) {
      return ObtenerUsuarioActualUseCase(ref.watch(authRepositoryProvider));
    });

final verificarSesionActivaUseCaseProvider =
    Provider<VerificarSesionActivaUseCase>((ref) {
      return VerificarSesionActivaUseCase(ref.watch(authRepositoryProvider));
    });

final enviarEmailRestablecerPasswordUseCaseProvider =
    Provider<EnviarEmailRestablecerPasswordUseCase>((ref) {
      return EnviarEmailRestablecerPasswordUseCase(
        ref.watch(authRepositoryProvider),
      );
    });

final cambiarPasswordUseCaseProvider = Provider<CambiarPasswordUseCase>((ref) {
  return CambiarPasswordUseCase(ref.watch(authRepositoryProvider));
});

final actualizarPerfilUseCaseProvider = Provider<ActualizarPerfilUseCase>((
  ref,
) {
  return ActualizarPerfilUseCase(ref.watch(authRepositoryProvider));
});

final observarEstadoAutenticacionUseCaseProvider =
    Provider<ObservarEstadoAutenticacionUseCase>((ref) {
      return ObservarEstadoAutenticacionUseCase(
        ref.watch(authRepositoryProvider),
      );
    });

// =============================================================================
// PROVIDER DE ESTADO DE AUTENTICACIÓN
// =============================================================================

/// Notifier que maneja el estado de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required LoginConEmailUseCase loginConEmail,
    required LoginConGoogleUseCase loginConGoogle,
    required LoginConAppleUseCase loginConApple,
    required RegistrarConEmailUseCase registrar,
    required CerrarSesionUseCase cerrarSesion,
    required ObtenerUsuarioActualUseCase obtenerUsuario,
    required VerificarSesionActivaUseCase verificarSesion,
    required EnviarEmailRestablecerPasswordUseCase enviarEmailRestablecer,
    required CambiarPasswordUseCase cambiarPassword,
    required ActualizarPerfilUseCase actualizarPerfil,
    required ObservarEstadoAutenticacionUseCase observarEstado,
    required AuthRepository repository,
  }) : _loginConEmail = loginConEmail,
       _loginConGoogle = loginConGoogle,
       _loginConApple = loginConApple,
       _registrar = registrar,
       _cerrarSesion = cerrarSesion,
       _obtenerUsuario = obtenerUsuario,
       _verificarSesion = verificarSesion,
       _enviarEmailRestablecer = enviarEmailRestablecer,
       _cambiarPassword = cambiarPassword,
       _actualizarPerfil = actualizarPerfil,
       _observarEstado = observarEstado,
       _repository = repository,
       super(const AuthInitial()) {
    _init();
  }

  final LoginConEmailUseCase _loginConEmail;
  final LoginConGoogleUseCase _loginConGoogle;
  final LoginConAppleUseCase _loginConApple;
  final RegistrarConEmailUseCase _registrar;
  final CerrarSesionUseCase _cerrarSesion;
  final ObtenerUsuarioActualUseCase _obtenerUsuario;
  final VerificarSesionActivaUseCase _verificarSesion;
  final EnviarEmailRestablecerPasswordUseCase _enviarEmailRestablecer;
  final CambiarPasswordUseCase _cambiarPassword;
  final ActualizarPerfilUseCase _actualizarPerfil;
  final ObservarEstadoAutenticacionUseCase _observarEstado;
  final AuthRepository _repository;

  StreamSubscription<Usuario?>? _authSubscription;

  /// Inicializa el notifier
  void _init() {
    _escucharCambiosAutenticacion();
    _verificarSesionInicial();
  }

  /// Escucha cambios en el estado de autenticación
  void _escucharCambiosAutenticacion() {
    _authSubscription?.cancel();
    _authSubscription = _observarEstado().listen(
      (usuario) {
        if (usuario != null) {
          state = AuthAuthenticated(usuario: usuario);
          // Registrar token FCM para el usuario autenticado
          _registrarTokenFCM(usuario.id);
        } else if (state is! AuthInitial) {
          state = const AuthUnauthenticated();
        }
      },
      onError: (error) {
        state = AuthError(mensaje: error.toString());
      },
    );
  }

  /// Registra el token FCM para notificaciones push
  Future<void> _registrarTokenFCM(String usuarioId) async {
    try {
      await NotificationService.instance.setCurrentUser(usuarioId);
    } on Exception {
      // Ignorar errores de FCM para no afectar el flujo de auth
    }
  }

  /// Verifica la sesión inicial
  Future<void> _verificarSesionInicial() async {
    final result = await _obtenerUsuario();
    result.fold((failure) => state = const AuthUnauthenticated(), (usuario) {
      if (usuario != null) {
        state = AuthAuthenticated(usuario: usuario);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  // ===========================================================================
  // MÉTODOS PÚBLICOS
  // ===========================================================================

  /// Inicia sesión con email y contraseña
  Future<void> loginConEmail({
    required String email,
    required String password,
  }) async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_LOGIN'));

    final result = await _loginConEmail(
      LoginConEmailParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = AuthError(mensaje: failure.message),
      (usuario) => state = AuthAuthenticated(usuario: usuario),
    );
  }

  /// Inicia sesión con Google
  Future<void> loginConGoogle() async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_GOOGLE'));

    final result = await _loginConGoogle();

    result.fold((failure) {
      // Detectar si necesita vinculación de cuenta
      if (failure is AccountLinkingFailure) {
        state = AuthAccountLinkRequired(
          email: failure.email,
          existingProvider: failure.existingProvider,
          pendingCredential: failure.pendingCredential,
          newProvider: 'google',
        );
      } else {
        state = AuthError(mensaje: failure.message);
      }
    }, (usuario) => state = AuthAuthenticated(usuario: usuario));
  }

  /// Inicia sesión con Apple
  Future<void> loginConApple() async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_APPLE'));

    final result = await _loginConApple();

    result.fold((failure) {
      // Detectar si necesita vinculación de cuenta
      if (failure is AccountLinkingFailure) {
        state = AuthAccountLinkRequired(
          email: failure.email,
          existingProvider: failure.existingProvider,
          pendingCredential: failure.pendingCredential,
          newProvider: 'apple',
        );
      } else {
        state = AuthError(mensaje: failure.message);
      }
    }, (usuario) => state = AuthAuthenticated(usuario: usuario));
  }

  /// Registra un nuevo usuario
  Future<void> registrar({
    required String email,
    required String password,
    String? nombre,
    String? apellido,
  }) async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_REGISTER'));

    final result = await _registrar(
      RegistrarConEmailParams(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
      ),
    );

    result.fold(
      (failure) => state = AuthError(mensaje: failure.message),
      (usuario) => state = AuthAuthenticated(usuario: usuario),
    );
  }

  // ===========================================================================
  // ACCOUNT LINKING
  // ===========================================================================

  /// Credencial pendiente para vinculación (se guarda temporalmente)
  dynamic _pendingCredential;
  String? _pendingProvider;

  /// Inicia sesión con email para vincular después
  /// Se usa cuando el usuario ya tiene cuenta con email/password
  /// pero intenta entrar con Google/Apple
  Future<void> loginParaVincular({
    required String email,
    required String password,
    required dynamic pendingCredential,
    required String newProvider,
  }) async {
    _pendingCredential = pendingCredential;
    _pendingProvider = newProvider;

    state = AuthLinkingInProgress(
      mensaje: ErrorMessages.get('AUTH_LOADING_VERIFYING'),
    );

    final result = await _loginConEmail(
      LoginConEmailParams(email: email, password: password),
    );

    if (result.isLeft()) {
      final failure = result.fold((f) => f, (_) => null)!;
      _pendingCredential = null;
      _pendingProvider = null;
      state = AuthError(mensaje: failure.message);
      return;
    }

    // Usuario autenticado correctamente, ahora vincular la credencial pendiente
    await _vincularCredencialPendiente();
  }

  /// Vincula la credencial pendiente al usuario actual
  Future<void> _vincularCredencialPendiente() async {
    if (_pendingCredential == null) {
      state = AuthError(
        mensaje: ErrorMessages.get('AUTH_NO_PENDING_CREDENTIAL'),
      );
      return;
    }

    state = AuthLinkingInProgress(
      mensaje: ErrorMessages.format('AUTH_LOADING_LINKING', {
        'provider': _pendingProvider ?? 'proveedor',
      }),
    );

    final result = await _repository.vincularCredencial(
      pendingCredential: _pendingCredential,
    );

    final provider = _pendingProvider ?? 'proveedor';
    _pendingCredential = null;
    _pendingProvider = null;

    result.fold((failure) => state = AuthError(mensaje: failure.message), (
      usuario,
    ) {
      // Primero emitimos AuthLinkingSuccess para que el diálogo lo maneje
      state = AuthLinkingSuccess(usuario: usuario, linkedProvider: provider);
      // Luego inmediatamente cambiamos a AuthAuthenticated para que
      // la navegación funcione correctamente
      Future.microtask(() {
        state = AuthAuthenticated(usuario: usuario);
      });
    });
  }

  /// Cancela el proceso de vinculación
  void cancelarVinculacion() {
    _pendingCredential = null;
    _pendingProvider = null;
    state = const AuthUnauthenticated();
  }

  /// Cierra la sesión
  Future<void> cerrarSesion() async {
    // Obtener usuario actual antes de cerrar sesión
    final currentState = state;
    String? usuarioId;
    if (currentState is AuthAuthenticated) {
      usuarioId = currentState.usuario.id;
    }

    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_LOGOUT'));

    // Remover token FCM
    if (usuarioId != null) {
      try {
        await NotificationService.instance.removeTokenForUser(usuarioId);
      } on Exception {
        // Ignorar errores
      }
    }

    final result = await _cerrarSesion();

    result.fold(
      (failure) => state = AuthError(mensaje: failure.message),
      (_) => state = AuthUnauthenticated(
        mensaje: ErrorMessages.get('AUTH_SESSION_CLOSED'),
      ),
    );
  }

  /// Envía email para restablecer contraseña
  Future<void> enviarEmailRestablecerPassword({required String email}) async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_EMAIL'));

    final result = await _enviarEmailRestablecer(
      EnviarEmailRestablecerPasswordParams(email: email),
    );

    result.fold(
      (failure) => state = AuthError(mensaje: failure.message),
      (_) => state = AuthEmailEnviado(
        email: email,
        tipo: TipoEmailAuth.restablecerPassword,
      ),
    );
  }

  /// Cambia la contraseña del usuario actual
  Future<void> cambiarPassword({
    required String passwordActual,
    required String passwordNuevo,
  }) async {
    // Capturar usuario antes de cambiar el estado a loading
    final usuarioActual = state.usuario;
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_PASSWORD'));

    final result = await _cambiarPassword(
      CambiarPasswordParams(
        passwordActual: passwordActual,
        passwordNuevo: passwordNuevo,
      ),
    );

    result.fold((failure) => state = AuthError(mensaje: failure.message), (_) {
      state = AuthSuccess(
        mensaje: ErrorMessages.get('AUTH_PASSWORD_UPDATED'),
        usuario: usuarioActual,
      );
    });
  }

  /// Actualiza el perfil del usuario
  Future<void> actualizarPerfil({
    String? nombre,
    String? apellido,
    String? telefono,
  }) async {
    state = AuthLoading(mensaje: ErrorMessages.get('AUTH_LOADING_PROFILE'));

    final result = await _actualizarPerfil(
      ActualizarPerfilParams(
        nombre: nombre,
        apellido: apellido,
        telefono: telefono,
      ),
    );

    result.fold(
      (failure) => state = AuthError(mensaje: failure.message),
      (usuario) => state = AuthAuthenticated(usuario: usuario),
    );
  }

  /// Actualiza la foto de perfil del usuario
  Future<void> actualizarFotoPerfil({required String rutaArchivo}) async {
    final result = await _repository.actualizarFotoPerfil(
      rutaArchivo: rutaArchivo,
    );

    result.fold((failure) => state = AuthError(mensaje: failure.message), (
      _,
    ) async {
      // Refrescar el usuario para que la UI se actualice
      try {
        final userResult = await _obtenerUsuario();
        if (!mounted) return;
        userResult.fold((_) {}, (usuario) {
          if (usuario != null) {
            state = AuthAuthenticated(usuario: usuario);
          }
        });
      } on Exception {
        // Si falla la recarga, no afectar el flujo
      }
    });
  }

  /// Verifica si hay sesión activa
  Future<bool> verificarSesionActiva() async {
    final result = await _verificarSesion();
    return result.fold((_) => false, (activa) => activa);
  }

  /// Limpia el estado de error
  void limpiarError() {
    if (state is AuthError) {
      state = const AuthUnauthenticated();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

/// Provider principal del estado de autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginConEmail: ref.watch(loginConEmailUseCaseProvider),
    loginConGoogle: ref.watch(loginConGoogleUseCaseProvider),
    loginConApple: ref.watch(loginConAppleUseCaseProvider),
    registrar: ref.watch(registrarConEmailUseCaseProvider),
    cerrarSesion: ref.watch(cerrarSesionUseCaseProvider),
    obtenerUsuario: ref.watch(obtenerUsuarioActualUseCaseProvider),
    verificarSesion: ref.watch(verificarSesionActivaUseCaseProvider),
    enviarEmailRestablecer: ref.watch(
      enviarEmailRestablecerPasswordUseCaseProvider,
    ),
    cambiarPassword: ref.watch(cambiarPasswordUseCaseProvider),
    actualizarPerfil: ref.watch(actualizarPerfilUseCaseProvider),
    observarEstado: ref.watch(observarEstadoAutenticacionUseCaseProvider),
    repository: ref.watch(authRepositoryProvider),
  );
});

// =============================================================================
// PROVIDERS DE CONVENIENCIA
// =============================================================================

/// Provider que indica si el usuario está autenticado
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Provider del usuario actual (null si no está autenticado)
final currentUserProvider = Provider<Usuario?>((ref) {
  return ref.watch(authProvider).usuario;
});

/// Provider que indica si hay una operación de auth en progreso
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
