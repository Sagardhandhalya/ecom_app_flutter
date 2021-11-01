import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/models/product.dart';
import 'package:flutter101/services/firestore_service.dart';

class CartData extends ChangeNotifier {
  late List<Product> products;
  late Map<String, int> qtyMap;
  FireStoreService firestore = FireStoreService(FirebaseFirestore.instance);
  String uid = FirebaseAuth.instance.currentUser!.uid;

  CartData({
    required this.products,
    required this.qtyMap,
  }) {
    updateProducts();
  }

  void updateProducts() async {
    qtyMap = await firestore.getUserCart(uid);
    products = await firestore.getListOfCartProduct(uid);
    notifyListeners();
  }

  double get grandTotal {
    double total = 0.0;
    for (Product p in products) {
      total += qtyMap[p.id]! * p.price;
    }
    return total;
  }

  Future<String> addToCart(Product product) async {
    try {
      await firestore.addToCart(uid, product.id);
      products.add(product);
      qtyMap[product.id] = 1;
      notifyListeners();
      return '1';
    } catch (e) {
      return 'Something went wrong try again.';
    }
  }

  updateQty(bool inc, String id) async {
    try {
      if (qtyMap[id] == 1 && inc == false) {
        await firestore.deleteFromTheCart(uid, id);
        qtyMap.remove(id);
        products = products.where((element) => element.id != id).toList();
      } else {
        await firestore.updateQty(uid, id, inc, qtyMap[id]!);
        qtyMap[id] = inc == true ? qtyMap[id]! + 1 : qtyMap[id]! - 1;
      }
      notifyListeners();
    } catch (e) {
      return 'Something went wrong try again.';
    }
  }
}
