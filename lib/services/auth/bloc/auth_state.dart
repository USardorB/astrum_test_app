part of 'auth_bloc.dart';

final class AuthState {
  final String? error;
  final AuthUser? user;
  final bool shouldPop;
  final AuthStatus authStatus;

  const AuthState({
    this.error,
    this.user,
    this.shouldPop = false,
    required this.authStatus,
  });
  AuthState copyWith({
    AuthStatus? authStatus,
    String? error,
    AuthUser? user,
    bool? shouldPop,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      error: error ?? this.error,
      user: user ?? this.user,
      shouldPop: shouldPop ?? this.shouldPop,
    );
  }
}

enum AuthStatus { initial, signedIn, signedOut }
