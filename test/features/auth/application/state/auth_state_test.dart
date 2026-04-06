import 'package:flutter_test/flutter_test.dart';
import 'package:smartgranjaavespro/features/auth/application/state/auth_state.dart';

import '../../../../helpers/test_helpers.dart';

void main() {
  final usuario = crearUsuarioTest();

  group('AuthState — tipos', () {
    test('AuthInitial', () {
      const state = AuthInitial();
      expect(state.props, isEmpty);
    });

    test('AuthLoading con mensaje', () {
      const state = AuthLoading(mensaje: 'Cargando...');
      expect(state.mensaje, 'Cargando...');
    });

    test('AuthLoading sin mensaje', () {
      const state = AuthLoading();
      expect(state.mensaje, isNull);
    });

    test('AuthAuthenticated contiene usuario', () {
      final state = AuthAuthenticated(usuario: usuario);
      expect(state.usuario, usuario);
    });

    test('AuthUnauthenticated con mensaje', () {
      const state = AuthUnauthenticated(mensaje: 'Sesión cerrada');
      expect(state.mensaje, 'Sesión cerrada');
    });

    test('AuthError contiene mensaje y código', () {
      const state = AuthError(mensaje: 'Error', codigo: 'E001');
      expect(state.mensaje, 'Error');
      expect(state.codigo, 'E001');
    });

    test('AuthSuccess con usuario', () {
      final state = AuthSuccess(mensaje: 'Ok', usuario: usuario);
      expect(state.usuario, usuario);
    });

    test('AuthEmailEnviado', () {
      const state = AuthEmailEnviado(
        email: 'a@b.com',
        tipo: TipoEmailAuth.verificacion,
      );
      expect(state.email, 'a@b.com');
      expect(state.tipo, TipoEmailAuth.verificacion);
    });

    test('AuthAccountLinkRequired', () {
      const state = AuthAccountLinkRequired(
        email: 'a@b.com',
        existingProvider: 'password',
        pendingCredential: 'cred',
        newProvider: 'google',
      );
      expect(state.email, 'a@b.com');
      expect(state.newProvider, 'google');
    });

    test('AuthLinkingInProgress', () {
      const state = AuthLinkingInProgress(mensaje: 'Vinculando');
      expect(state.mensaje, 'Vinculando');
    });

    test('AuthLinkingSuccess', () {
      final state = AuthLinkingSuccess(
        usuario: usuario,
        linkedProvider: 'google.com',
      );
      expect(state.linkedProvider, 'google.com');
    });
  });

  group('AuthStateX — extension methods', () {
    test('isLoading', () {
      const state = AuthLoading();
      expect(state.isLoading, isTrue);
      expect(state.isAuthenticated, isFalse);
    });

    test('isAuthenticated', () {
      final state = AuthAuthenticated(usuario: usuario);
      expect(state.isAuthenticated, isTrue);
      expect(state.isUnauthenticated, isFalse);
    });

    test('isUnauthenticated', () {
      const state = AuthUnauthenticated();
      expect(state.isUnauthenticated, isTrue);
      expect(state.isAuthenticated, isFalse);
    });

    test('isError', () {
      const state = AuthError(mensaje: 'Error');
      expect(state.isError, isTrue);
    });

    test('usuario retorna usuario cuando AuthAuthenticated', () {
      final state = AuthAuthenticated(usuario: usuario);
      expect(state.usuario, usuario);
    });

    test('usuario retorna usuario desde AuthSuccess', () {
      final state = AuthSuccess(mensaje: 'Ok', usuario: usuario);
      expect(state.usuario, usuario);
    });

    test('usuario retorna null cuando AuthLoading', () {
      const AuthState state = AuthLoading();
      expect(state.usuario, isNull);
    });

    test('errorMensaje retorna mensaje cuando AuthError', () {
      const AuthState state = AuthError(mensaje: 'Algo falló');
      expect(state.errorMensaje, 'Algo falló');
    });

    test('errorMensaje retorna null cuando no es error', () {
      const AuthState state = AuthLoading();
      expect(state.errorMensaje, isNull);
    });
  });

  group('AuthState — Equatable', () {
    test('estados iguales son iguales', () {
      final s1 = AuthAuthenticated(usuario: usuario);
      final s2 = AuthAuthenticated(usuario: usuario);
      expect(s1, equals(s2));
    });

    test('estados distintos no son iguales', () {
      final s1 = AuthAuthenticated(usuario: usuario);
      const s2 = AuthError(mensaje: 'Error');
      expect(s1, isNot(equals(s2)));
    });
  });
}
