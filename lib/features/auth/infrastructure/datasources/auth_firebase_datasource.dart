library;

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/error_messages.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/entities.dart';
import '../models/usuario_model.dart';

/// Fuente de datos de autenticación con Firebase
///
/// Implementa todas las operaciones de autenticación usando
/// Firebase Auth, Firestore y Storage.
class AuthFirebaseDatasource {
  AuthFirebaseDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    GoogleSignIn? googleSignIn,
  }) : _auth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final GoogleSignIn _googleSignIn;

  /// Colección de usuarios en Firestore
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('usuarios');

  // ===========================================================================
  // AUTENTICACIÓN
  // ===========================================================================

  /// Inicia sesión con email y contraseña
  Future<UsuarioModel> loginConEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_LOGIN_FAILED'),
          code: 'USER_NULL',
        );
      }

      return _obtenerOCrearUsuario(credential.user!, AuthMethod.email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Inicia sesión con Google
  Future<UsuarioModel> loginConGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_GOOGLE_LOGIN_CANCELED'),
          code: 'GOOGLE_SIGN_IN_CANCELLED',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_GOOGLE_LOGIN_FAILED'),
          code: 'GOOGLE_USER_NULL',
        );
      }

      return _obtenerOCrearUsuario(userCredential.user!, AuthMethod.google);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Manejar account-exists-with-different-credential
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email;
        final credential = e.credential;

        if (email != null) {
          // Con la protección de enumeración de email activada,
          // fetchSignInMethodsForEmail ya no es confiable.
          // Asumimos 'password' como el provider más común.
          const existingProvider = 'password';

          throw AccountLinkingException(
            email: email,
            existingProvider: existingProvider,
            pendingCredential: credential,
          );
        }
      }
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Inicia sesión con Apple
  Future<UsuarioModel> loginConApple() async {
    try {
      final appleProvider = firebase_auth.AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');

      final userCredential = await _auth.signInWithProvider(appleProvider);
      if (userCredential.user == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_APPLE_LOGIN_FAILED'),
          code: 'APPLE_USER_NULL',
        );
      }

      return _obtenerOCrearUsuario(userCredential.user!, AuthMethod.apple);
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Manejar account-exists-with-different-credential
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email;
        final credential = e.credential;

        if (email != null) {
          // Con la protección de enumeración de email activada,
          // fetchSignInMethodsForEmail ya no es confiable.
          // Asumimos 'password' como el provider más común.
          const existingProvider = 'password';

          throw AccountLinkingException(
            email: email,
            existingProvider: existingProvider,
            pendingCredential: credential,
          );
        }
      }
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Registra un nuevo usuario con email
  Future<UsuarioModel> registrarConEmail({
    required String email,
    required String password,
    String? nombre,
    String? apellido,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (credential.user == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_CREATE_ACCOUNT_FAILED'),
          code: 'USER_NULL',
        );
      }

      // Actualizar nombre de perfil en Firebase Auth
      if (nombre != null || apellido != null) {
        final displayName = [
          nombre,
          apellido,
        ].where((s) => s != null && s.isNotEmpty).join(' ');
        if (displayName.isNotEmpty) {
          await credential.user!.updateDisplayName(displayName);
        }
      }

      // Enviar email de verificación
      await credential.user!.sendEmailVerification();

      // Crear documento en Firestore
      final usuario = UsuarioModel(
        id: credential.user!.uid,
        email: email.trim(),
        nombre: nombre,
        apellido: apellido,
        emailVerificado: false,
        metodoAuth: AuthMethod.email,
        fechaCreacion: DateTime.now(),
        ultimoAcceso: DateTime.now(),
        proveedoresVinculados: const ['password'],
      );

      await _usersCollection.doc(usuario.id).set(usuario.toFirestore());

      return usuario;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Cierra la sesión actual
  Future<void> cerrarSesion() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  // ===========================================================================
  // RECUPERACIÓN DE CONTRASEÑA
  // ===========================================================================

  /// Envía email de restablecimiento de contraseña
  Future<void> enviarEmailRestablecerPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Cambia la contraseña del usuario actual
  Future<void> cambiarPassword({
    required String passwordActual,
    required String passwordNuevo,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw AuthException.noSession();
      }

      // Reautenticar usuario
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: passwordActual,
      );
      await user.reauthenticateWithCredential(credential);

      // Cambiar contraseña
      await user.updatePassword(passwordNuevo);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  // ===========================================================================
  // VERIFICACIÓN
  // ===========================================================================

  /// Envía email de verificación
  Future<void> enviarEmailVerificacion() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException.noSession();
      }
      await user.sendEmailVerification();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Recarga los datos del usuario
  Future<void> recargarUsuario() async {
    try {
      await _auth.currentUser?.reload();
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  // ===========================================================================
  // USUARIO ACTUAL
  // ===========================================================================

  /// Obtiene el usuario actual
  Future<UsuarioModel?> obtenerUsuarioActual() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _usersCollection.doc(user.uid).get();
      if (!doc.exists) {
        return _crearUsuarioDesdeFirebaseUser(
          user,
          _inferAuthMethodFromFirebaseUser(user),
        );
      }

      return UsuarioModel.fromFirestore(
        doc,
      ).copyWith(emailVerificado: user.emailVerified);
    } on Exception catch (e) {
      throw UnknownException(details: e.toString());
    }
  }

  /// Verifica si hay sesión activa
  Future<bool> verificarSesionActiva() async {
    return _auth.currentUser != null;
  }

  /// Stream de cambios en la autenticación
  Stream<UsuarioModel?> get estadoAutenticacion {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return obtenerUsuarioActual();
    });
  }

  // ===========================================================================
  // PERFIL
  // ===========================================================================

  /// Actualiza el perfil del usuario
  Future<UsuarioModel> actualizarPerfil({
    String? nombre,
    String? apellido,
    String? telefono,
    String? fotoUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException.noSession();
      }

      final updates = <String, dynamic>{
        'ultimoAcceso': FieldValue.serverTimestamp(),
      };

      if (nombre != null) updates['nombre'] = nombre;
      if (apellido != null) updates['apellido'] = apellido;
      if (telefono != null) updates['telefono'] = telefono;
      if (fotoUrl != null) updates['fotoUrl'] = fotoUrl;

      await _usersCollection.doc(user.uid).update(updates);

      // Actualizar displayName en Firebase Auth
      if (nombre != null || apellido != null) {
        final currentDoc = await _usersCollection.doc(user.uid).get();
        final data = currentDoc.data() ?? {};
        final displayName = [
          nombre ?? data['nombre'],
          apellido ?? data['apellido'],
        ].where((s) => s != null && s.isNotEmpty).join(' ');
        if (displayName.isNotEmpty) {
          await user.updateDisplayName(displayName);
        }
      }

      return (await obtenerUsuarioActual())!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Actualiza la foto de perfil
  Future<String> actualizarFotoPerfil({required String rutaArchivo}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException.noSession();
      }

      final file = File(rutaArchivo);
      if (!await file.exists()) {
        throw StorageException(
          message: ErrorMessages.get('ERR_FILE_NOT_EXISTS'),
          code: 'FILE_NOT_FOUND',
        );
      }

      // Validar tamaño (máx 5MB)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw StorageException(
          message: ErrorMessages.get('ERR_IMAGE_TOO_LARGE'),
          code: 'FILE_TOO_LARGE',
        );
      }

      // Verificar conectividad antes de intentar subir
      final results = await Connectivity().checkConnectivity();
      if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        throw StorageException(
          message: ErrorMessages.get('ERR_NO_CONNECTION_PHOTO'),
          code: 'NO_CONNECTION',
        );
      }

      final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': user.uid,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );
      await ref.putFile(file, metadata);
      final url = await ref.getDownloadURL();

      await user.updatePhotoURL(url);
      await _usersCollection.doc(user.uid).update({'fotoUrl': url});

      return url;
    } on Exception catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Elimina la cuenta del usuario
  Future<void> eliminarCuenta({required String password}) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        throw AuthException.noSession();
      }

      // Reautenticar
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Eliminar datos de Firestore
      await _usersCollection.doc(user.uid).delete();

      // Eliminar archivos de Storage
      try {
        await _storage.ref().child('users/${user.uid}').delete();
      } catch (_) {
        // Ignorar si no hay archivos
      }

      // Eliminar cuenta
      await user.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  // ===========================================================================
  // ACCOUNT LINKING
  // ===========================================================================

  /// Vincula una credencial pendiente al usuario actual
  ///
  /// Este método se usa cuando un usuario intenta iniciar sesión con un proveedor
  /// (ej: Google) pero ya tiene una cuenta con email/password.
  ///
  /// Flujo:
  /// 1. Usuario intenta Google Sign-In
  /// 2. Firebase detecta que el email ya existe con password
  /// 3. Se lanza AccountLinkingException con la credencial pendiente
  /// 4. Usuario inicia sesión con email/password
  /// 5. Se llama este método para vincular Google al usuario actual
  Future<UsuarioModel> vincularCredencial({
    required dynamic pendingCredential,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw AuthException.noSession();
      }

      if (pendingCredential == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_NO_PENDING_CREDENTIAL'),
          code: 'NO_PENDING_CREDENTIAL',
        );
      }

      // Vincular la credencial al usuario actual
      final userCredential = await user.linkWithCredential(
        pendingCredential as firebase_auth.AuthCredential,
      );

      if (userCredential.user == null) {
        throw AuthException(
          message: ErrorMessages.get('ERR_LINK_ACCOUNT_FAILED'),
          code: 'LINKING_FAILED',
        );
      }

      // Actualizar el documento en Firestore para reflejar los métodos vinculados
      final providerIds = userCredential.user!.providerData
          .map((p) => p.providerId)
          .toList();

      await _usersCollection.doc(user.uid).update({
        'proveedoresVinculados': providerIds,
        'ultimoAcceso': FieldValue.serverTimestamp(),
      });

      return (await obtenerUsuarioActual())!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw AuthException(
          message: ErrorMessages.get('ERR_GOOGLE_ALREADY_LINKED'),
          code: 'CREDENTIAL_ALREADY_IN_USE',
        );
      }
      if (e.code == 'provider-already-linked') {
        throw AuthException(
          message: ErrorMessages.get('ERR_PROVIDER_ALREADY_LINKED'),
          code: 'PROVIDER_ALREADY_LINKED',
        );
      }
      throw AuthException.fromFirebaseCode(e.code);
    } on Exception catch (e) {
      if (e is AuthException) rethrow;
      throw UnknownException(details: e.toString());
    }
  }

  /// Obtiene los proveedores de autenticación vinculados al usuario actual
  List<String> obtenerProveedoresVinculados() {
    final user = _auth.currentUser;
    if (user == null) return [];

    return user.providerData.map((p) => p.providerId).toList();
  }

  /// Verifica si el usuario tiene un proveedor específico vinculado
  bool tieneProveedorVinculado(String providerId) {
    return obtenerProveedoresVinculados().contains(providerId);
  }

  // ===========================================================================
  // MÉTODOS PRIVADOS
  // ===========================================================================

  /// Obtiene o crea un usuario en Firestore
  Future<UsuarioModel> _obtenerOCrearUsuario(
    firebase_auth.User firebaseUser,
    AuthMethod metodo,
  ) async {
    final doc = await _usersCollection.doc(firebaseUser.uid).get();

    if (doc.exists) {
      // Actualizar último acceso y proveedores vinculados
      final providerIds = firebaseUser.providerData
          .map((p) => p.providerId)
          .toList();

      await _usersCollection.doc(firebaseUser.uid).update({
        'ultimoAcceso': FieldValue.serverTimestamp(),
        'emailVerificado': firebaseUser.emailVerified,
        'proveedoresVinculados': providerIds,
      });

      return UsuarioModel.fromFirestore(doc).copyWith(
        emailVerificado: firebaseUser.emailVerified,
        ultimoAcceso: DateTime.now(),
      );
    }

    // Crear nuevo usuario
    final usuario = _crearUsuarioDesdeFirebaseUser(firebaseUser, metodo);
    await _usersCollection.doc(usuario.id).set(usuario.toFirestore());

    return usuario;
  }

  /// Crea un UsuarioModel desde un Firebase User
  UsuarioModel _crearUsuarioDesdeFirebaseUser(
    firebase_auth.User firebaseUser,
    AuthMethod metodo,
  ) {
    final nameParts = (firebaseUser.displayName ?? '').split(' ');
    final providerIds = firebaseUser.providerData
        .map((p) => p.providerId)
        .toList();

    return UsuarioModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      nombre: nameParts.isNotEmpty ? nameParts.first : null,
      apellido: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : null,
      telefono: firebaseUser.phoneNumber,
      fotoUrl: firebaseUser.photoURL,
      emailVerificado: firebaseUser.emailVerified,
      activo: true,
      metodoAuth: metodo,
      fechaCreacion: firebaseUser.metadata.creationTime ?? DateTime.now(),
      ultimoAcceso: DateTime.now(),
      proveedoresVinculados: providerIds,
    );
  }

  /// Infiere el método principal a partir de los providers disponibles.
  AuthMethod _inferAuthMethodFromFirebaseUser(firebase_auth.User firebaseUser) {
    final providerIds = firebaseUser.providerData
        .map((p) => p.providerId)
        .toSet();

    if (providerIds.contains('password')) {
      return AuthMethod.email;
    }
    if (providerIds.contains('google.com')) {
      return AuthMethod.google;
    }
    if (providerIds.contains('apple.com')) {
      return AuthMethod.apple;
    }

    return AuthMethod.email;
  }
}
