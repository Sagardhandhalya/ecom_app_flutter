import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter101/screens/login/login.dart';
import 'package:flutter101/services/auth_service.dart';
import 'package:flutter101/theme.dart';
import 'package:provider/provider.dart';
import 'screens/Home/home.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance),
          ),
          StreamProvider(
              initialData: null,
              create: (context) => context.read<AuthService>().authStateChanges)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: MyTheme.lightTheme(context),
          home: const AuthContainer(),
          routes: {
            '/home': (context) => const Home(),
            '/login': (context) => const Login()
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
      return const Home();
    } else {
      return const Login();
    }
  }
}
