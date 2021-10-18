import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id, email, fullName, userRole;
  final String? photoUrl;
  final List<dynamic> cart;

  AppUser(this.id, this.email, this.fullName, this.userRole, this.photoUrl,
      this.cart);

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data() as Map<String, dynamic>;
    print(data);
    return AppUser(data['id'], data['email'], data['fullName'],
        data['userRole'], data['photoUrl'], data['cart']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'userRole': userRole,
      'cart': cart
    };
  }
}
