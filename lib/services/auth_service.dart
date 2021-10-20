import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AuthService(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Stream<AppUser?> get getCurrentUser =>
  //     _auth.authStateChanges().map((User? user) {
  //       debugPrint('Hi from getcurrentuser !!');
  //       debugPrint(user.toString());
  //       debugPrint((user != null).toString());

  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user != null ? user.uid : 'user')
  //           .snapshots()
  //           .map<AppUser?>((user) => _appUserFromSnapshot(user));
  //     });

  // AppUser? _appUserFromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
  //   Map<String, dynamic>? user = doc.data();
  //   debugPrint(user.toString());
  //   return user != null
  //       ? AppUser(user['id'], user['email'], user['fullName'], user['userRole'],
  //           user['photoUrl'], Map<String, int>.from(user['cart']))
  //       : null;
  // }

  Future<String> signUp(
      String email, String password, String fullName, String userRole) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String?> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      var res = await _auth.signInWithCredential(credential);
      User? user = res.user;
      if (user != null) {
        FireStoreService(FirebaseFirestore.instance).createUser(AppUser(
            user.uid,
            user.email.toString(),
            user.displayName.toString(),
            'user',
            user.photoURL, {}));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
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
      await _googleSignIn.signOut();
      return 'success';
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
