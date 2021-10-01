import 'package:flutter/material.dart';

class MyTheme {
  static lightTheme(BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black54),
          titleTextStyle: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
            button: TextStyle(fontSize: 17),
            bodyText1: TextStyle(fontSize: 17)));
  }
}
