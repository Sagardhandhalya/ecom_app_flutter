import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id, email, fullName, userRole;
  final String? photoURL;
  final Map<String, int> cart;

  AppUser(this.id, this.email, this.fullName, this.userRole, this.photoURL,
      this.cart);

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data() as Map<String, dynamic>;
    return AppUser(
        data['id']! as String,
        data['email']! as String,
        data['fullName']! as String,
        data['userRole']! as String,
        data['photoURL'],
        Map<String, int>.from(data['cart']! as Map<dynamic, dynamic>));
  }
  // AppUser.fromJson(Map<String, Object?> json)
  //     : this(
  //         json['id']! as String,
  //         json['email']! as String,
  //         json['fullName']! as String,
  //         json['userRole']! as String,
  //         json['photoUrl']! as String,
  //         Map<String, int>.from(json['cart']! as Map<dynamic, dynamic>),
  //       );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'userRole': userRole,
      'cart': cart,
      'photoURL': photoURL
    };
  }
}
