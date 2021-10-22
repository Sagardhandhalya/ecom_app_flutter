import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/product.dart';

class FireStoreService {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');

  FireStoreService(FirebaseFirestore instance);

  Product? _productFromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic>? data = doc.data();
    if (data != null) {
      return Product(
          id: doc.id,
          image: data['image'],
          title: data['title'],
          price: data['price'],
          description: data['description'],
          color: data['color'],
          category: data['category']);
    }
  }

  Stream<Product?> getProductFromId(String id) {
    return FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .snapshots()
        .map<Product?>(_productFromSnapshot);
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

  Stream<AppUser?> getCurrentUserInfo(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_getAppUserFromSnapshot);
  }

  AppUser? _getAppUserFromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data();
    if (data != null) {
      return AppUser(
          data['id']! as String,
          data['email']! as String,
          data['fullName']! as String,
          data['userRole']! as String,
          data['photoURL'],
          Map<String, int>.from(data['cart']! as Map<dynamic, dynamic>));
    } else {
      return null;
    }
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
        .set({'photoURL': url}, SetOptions(merge: true));
  }
}
