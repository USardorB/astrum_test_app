part of 'auth_bloc.dart';

final class AuthState extends Equatable {
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

  @override
  List<Object> get props => [error ?? '', user ?? '', authStatus];
}

enum AuthStatus { initial, signedIn, signedOut }
