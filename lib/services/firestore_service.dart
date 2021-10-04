import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter101/modals/app_user.dart';

class FireStoreService {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  FireStoreService(FirebaseFirestore instance);

  Future createUser(AppUser user) async {
    try {
      await _userCollectionRef.doc(user.id).set(user.toJson());
    } catch (e) {
      return e;
    }
  }
}
