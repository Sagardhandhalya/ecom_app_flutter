import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id, email, fullName, userRole;

  AppUser(this.id, this.email, this.fullName, this.userRole);

  AppUser fromDocument(DocumentSnapshot doc) {
    return AppUser(doc['id'], doc['email'], doc['fullName'], doc['userRole']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'userRole': userRole
    };
  }
}
