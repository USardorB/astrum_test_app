import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthUser {
  final String id;
  final String name;
  final String email;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
  });

  static AuthUser? fromFirebase(User? user) {
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
    );
  }
}
