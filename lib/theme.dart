import 'package:flutter/material.dart';

class MyTheme {
  static lightTheme(BuildContext context) {
    return ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle:
              TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Cairo'),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
            button: TextStyle(fontSize: 17),
            bodyText1: TextStyle(fontSize: 17, fontFamily: 'Cairo'),
            bodyText2: TextStyle(fontSize: 17, fontFamily: 'Cairo'),
            headline4: TextStyle(fontFamily: 'Cairo'),
            subtitle1: TextStyle(fontFamily: 'Cairo')));
  }
}
