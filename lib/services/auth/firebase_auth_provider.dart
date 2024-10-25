import 'package:astrum_test_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'auth_provider.dart';
import 'auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  static Future<void> initializeFirebase() async =>
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

  @override
  Future<AuthUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Creating a user and updating its name
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .then((user) async => await user.user?.updateDisplayName(name));

      final user = currentUser;
      if (user != null) return user;
      throw 'User Not Logged In';
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) return AuthUser.fromFirebase(user);
    return null;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) return user;
      throw 'User Not Logged In';
    } on FirebaseAuthException catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async => await FirebaseAuth.instance.signOut();
}
