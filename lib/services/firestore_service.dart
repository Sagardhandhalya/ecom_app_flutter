import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter101/models/app_user.dart';
import 'package:flutter101/models/order.dart';
import 'package:flutter101/models/product.dart';

class FireStoreService {
  final CollectionReference _userCollectionRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _orderCollectionRef =
      FirebaseFirestore.instance.collection('orders');

  FireStoreService(FirebaseFirestore instance);

  Future<Product> _getProductFromdoc(String pid) async {
    var p =
        await FirebaseFirestore.instance.collection('products').doc(pid).get();
    return Product.fromDocument(p);
  }

  Future<Map<String, int>> getUserCart(String uid) async {
    var userF = await _userCollectionRef.doc(uid).get()
        as DocumentSnapshot<Map<String, dynamic>>;
    AppUser? user = _getAppUserFromSnapshot(userF);
    return user != null ? user.cart : {};
  }

  Future<List<Product>> getListOfCartProduct(String uid) async {
    var userF = await _userCollectionRef.doc(uid).get()
        as DocumentSnapshot<Map<String, dynamic>>;
    AppUser? user = _getAppUserFromSnapshot(userF);
    if (user != null) {
      var productFutures =
          user.cart.keys.map((pid) => _getProductFromdoc(pid)).toList();
      return Future.wait(productFutures);
    } else {
      return [];
    }
  }

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
      var doc = await _userCollectionRef.doc(user.id).get();
      if (!doc.exists) {
        await _userCollectionRef.doc(user.id).set(user.toJson());
      }
    } catch (e) {
      return e;
    }
  }

  Future<void> addToCart(String uid, String productUid) async {
    return _userCollectionRef.doc(uid).set({
      'cart': {productUid: 1}
    }, SetOptions(merge: true));
  }

  Future<void> resetCart(String uid) async {
    return _userCollectionRef
        .doc(uid)
        .set({'cart': {}}, SetOptions(merge: true));
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

  // place new order
  Future<void> placeOrder(Map<String, dynamic> order) async {
    try {
      await _orderCollectionRef.add(order);
    } catch (e) {
      print(e.toString());
    }
  }

  List<Order> _orderListFromSnapShot(QuerySnapshot<Object?> q) {
    return q.docs
        .map((doc) => Order.fromDocumentSnapshot(
            doc as QueryDocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Stream<List<Order>> getMyOrders(String uid) {
    return _orderCollectionRef
        .where('ownerId', isEqualTo: uid)
        .orderBy('orderDate')
        .snapshots()
        .map<List<Order>>(_orderListFromSnapShot);
  }
}
