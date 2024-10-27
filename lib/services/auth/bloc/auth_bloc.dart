import 'dart:async';
import 'package:astrum_test_app/services/auth/auth_provider.dart';
import 'package:astrum_test_app/services/auth/auth_user.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _provider;
  AuthBloc(AuthProvider provider)
      : _provider = provider,
        super(const AuthState(authStatus: AuthStatus.initial)) {
    on<AuthEventInit>(_init);
    on<AuthEventSignUp>(_signUp);
    on<AuthEventSignIn>(_signIn);
    on<AuthEventSignOut>(_signOut);
  }

  Future<void> _init(AuthEventInit event, Emitter<AuthState> emit) async {
    final user = _provider.currentUser;
    if (user != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      emit(AuthState(authStatus: AuthStatus.signedIn, user: user));
    } else {
      emit(const AuthState(authStatus: AuthStatus.signedOut));
    }
  }

  Future<void> _signUp(AuthEventSignUp event, Emitter<AuthState> emit) async {
    try {
      final user = await _provider.signUp(
        name: event.name,
        email: event.email,
        password: event.password,
      );

      emit(AuthState(
        authStatus: AuthStatus.signedIn,
        user: user,
        shouldPop: true,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error: e.code));
    } catch (e) {
      if (e.runtimeType is String) {
        emit(state.copyWith(error: e as String));
      } else {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _signIn(AuthEventSignIn event, Emitter<AuthState> emit) async {
    try {
      final user = await _provider.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthState(
        authStatus: AuthStatus.signedIn,
        user: user,
        shouldPop: true,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error: e.code));
    } catch (e) {
      if (e.runtimeType is String) {
        emit(state.copyWith(error: e as String));
      } else {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _signOut(AuthEventSignOut event, Emitter<AuthState> emit) async {
    await _provider.signOut();
    emit(const AuthState(authStatus: AuthStatus.signedOut));
  }
}
