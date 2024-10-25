part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class AuthEventInit implements AuthEvent {
  const AuthEventInit();
}

class AuthEventSignUp implements AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthEventSignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthEventSignIn implements AuthEvent {
  final String email;
  final String password;

  const AuthEventSignIn({required this.email, required this.password});
}

class AuthEventSignOut implements AuthEvent {
  const AuthEventSignOut();
}
