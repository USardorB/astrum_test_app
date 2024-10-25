import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) =>
      provider.signUp(name: name, email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> signIn({required String email, required String password}) =>
      provider.signIn(email: email, password: password);

  @override
  Future<void> signOut() => provider.signOut();
}
