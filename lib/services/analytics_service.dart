import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class Analytics {
  final FirebaseAnalytics firebaseAnalytics;

  Analytics(this.firebaseAnalytics);

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: firebaseAnalytics);

  Future<void> logEvent(String name) async {
    await firebaseAnalytics.logEvent(name: name);
  }

  Future<void> logAddToCartEvent(
      String id, String name, String cat, double price) async {
    await firebaseAnalytics.logAddToCart(
        itemId: id,
        itemName: name,
        itemCategory: cat,
        price: price,
        quantity: 1);
  }
}
