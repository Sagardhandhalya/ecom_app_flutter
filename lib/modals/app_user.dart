import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id, email, fullName, userRole;
  final String? photoUrl;
  final Map<String, int> cart;

  AppUser(this.id, this.email, this.fullName, this.userRole, this.photoUrl,
      this.cart);

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data() as Map<String, dynamic>;
    return AppUser(
        data['id'],
        data['email'],
        data['fullName'],
        data['userRole'],
        data['photoUrl'],
        Map<String, int>.from(data['cart']));
  }
  AppUser.fromJson(Map<String, Object?> json)
      : this(
          json['id']! as String,
          json['email']! as String,
          json['fullName']! as String,
          json['userRole']! as String,
          json['photoUrl']! as String,
          Map<String, int>.from(json['cart']! as Map<dynamic, dynamic>),
        );

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
