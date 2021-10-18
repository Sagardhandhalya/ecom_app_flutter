import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter101/modals/app_user.dart';
import 'package:flutter101/modals/product.dart';
import 'package:flutter101/modals/app_user.dart';

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

  Stream<QuerySnapshot> getProductsStream() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  Stream<QuerySnapshot> getProductsOfACategory() {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  Future<AppUser> getCurrentUserInfo(String uid) async {
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
      'cart': FieldValue.arrayUnion([
        {'productId': productUid, 'q': 1}
      ])
    }, SetOptions(merge: true));
  }

  Future<void> deleteFromTheCart(String uid, Map<String, dynamic> p) async {
    return _userCollectionRef.doc(uid).set({
      'cart': FieldValue.arrayRemove([p])
    }, SetOptions(merge: true));
  }

  Future<void> updateQty(String uid, Map<String, dynamic> p, bool isAdd) async {
    return _userCollectionRef
        .doc(uid)
        .set({'car[0].q': FieldValue.increment(1)}, SetOptions(merge: true));
  }
}


// arrayUnion([
//         {
//           'productId': p['productId'],
//           'q': isAdd ? p['q'] + 1 : (p['q'] > 1 ? p['q'] - 1 : p['q'])
//         }
//       ])