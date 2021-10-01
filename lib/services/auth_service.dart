import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final String samir = "my name is sagar";
  final FirebaseAuth _auth;
  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<String> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> logOut() async {
    try {
      await _auth.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
