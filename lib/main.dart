import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/screens/cart/cart_page.dart';
import 'package:flutter101/screens/checkout/checkout_page.dart';
import 'package:flutter101/screens/login/login.dart';
import 'package:flutter101/screens/myorders/orders.dart';
import 'package:flutter101/screens/profile/profile.dart';
import 'package:flutter101/services/analytics_service.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:flutter101/services/firebase_storage_service.dart';
import 'package:flutter101/services/firestore_service.dart';
import 'package:flutter101/services/flutterfire.dart';
import 'package:flutter101/theme.dart';
import 'package:provider/provider.dart';
import 'screens/Home/home.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'services/messaging_service.dart';
import 'models/cart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapeFlutterFire();
  initilizeFirebaseMessageService();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final Analytics _analytics = Analytics(FirebaseAnalytics());

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (context) => AuthService(FirebaseAuth.instance),
          ),
          Provider<FireStoreService>(
            create: (_) => FireStoreService(
              FirebaseFirestore.instance,
            ),
          ),
          Provider<Analytics>(
            create: (_) => Analytics(FirebaseAnalytics()),
          ),
          Provider<Storage>(create: (_) => Storage(FirebaseStorage.instance)),
          StreamProvider<User?>(
              initialData: null,
              create: (context) =>
                  context.read<AuthService>().authStateChanges),
          ChangeNotifierProvider<CartData>(create: (_) {
            return CartData(
              products: [],
              qtyMap: {},
            );
          })
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.lightTheme(context),
          home: const AuthContainer(),
          navigatorObservers: <NavigatorObserver>[MyApp._analytics.observer],
          routes: {
            'home': (context) => const Home(),
            'login_page': (context) => const Login(),
            'cart_page': (context) => const Cart(),
            'profile_page': (context) => const Profile(),
            'checkout_page': (context) => const CheckoutPage(),
            'orders_page': (context) => const Orders(),
          },
        ));
  }
}

class AuthContainer extends StatelessWidget {
  const AuthContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      context.read<CartData>().updateProducts();
      manageToken();
      return const Home();
    } else {
      return const Login();
    }
  }
}
