import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final double total;
  final String status;
  final String ownerId;
  final Map<String, double> items;
  final DateTime orderDate;

  Order(
      {required this.total,
      required this.status,
      required this.ownerId,
      required this.items,
      required this.orderDate});

  factory Order.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>?> doc) {
    Timestamp t = doc.get('orderDate');
    return Order(
      total: doc.get('total'),
      status: doc.get('status'),
      ownerId: doc.get('ownerId'),
      items: Map.from(doc.get('items')),
      orderDate: DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'status': status,
      'ownerId': ownerId,
      'items': items,
      'orderDate':
          Timestamp.fromMillisecondsSinceEpoch(orderDate.millisecondsSinceEpoch)
    };
  }
}
