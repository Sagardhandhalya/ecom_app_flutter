import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/product.dart';

class FireStoreService {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  FireStoreService(FirebaseFirestore instance);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUsersCart(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Future<Product> getProductFromId(String id) async {
    var p =
        await FirebaseFirestore.instance.collection('products').doc(id).get();

    return Product.fromDocument(p);
  }

  List<Product> _productListFromSnapShot(
      QuerySnapshot<Map<String, dynamic>> q) {
    return q.docs.map((doc) => Product.fromDocument(doc)).toList();
  }

  Stream<List<Product>> getProductsStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .map<List<Product>>(_productListFromSnapShot);
  }

  Future<AppUser> getCurrentUserInfo(String uid) async {
    print(uid);
    var x = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return AppUser.fromDocument(x);
  }

  Future createUser(AppUser user) async {
    try {
      await _userCollectionRef.doc(user.id).set(user.toJson());
    } catch (e) {
      return e;
    }
  }

  Future<void> addToCart(String uid, String productUid) async {
    return _userCollectionRef.doc(uid).set({
      'cart': {productUid: 1}
    }, SetOptions(merge: true));
  }

  Future<void> deleteFromTheCart(String uid, String p) async {
    return _userCollectionRef.doc(uid).set({
      'cart': {p: FieldValue.delete()}
    }, SetOptions(merge: true));
  }

  Future<void> updateQty(String uid, String p, bool isAdd, int val) async {
    return _userCollectionRef.doc(uid).set({
      'cart': {p: FieldValue.increment(isAdd ? 1 : (val > 1 ? -1 : 0))}
    }, SetOptions(merge: true));
  }

  // update profile photo of a user

  Future<void> updateProfilePhoto(String uid, String url) {
    return _userCollectionRef
        .doc(uid)
        .set({'photoUrl': url}, SetOptions(merge: true));
  }
}
