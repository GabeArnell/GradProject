import 'package:flutter/material.dart';

class GlobalVariables {
  static const appBarGradient = LinearGradient(colors: [
    Color.fromARGB(255, 251, 188, 0),
    Color.fromARGB(255, 241, 228, 175),
  ], stops: [
    0.5,
    1.0
  ]);

  static const secondaryColor = Colors.amber;
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static var selectedNavBarColor = Color.fromARGB(255, 255, 132, 0);
  static const unselectedNavBarColor = Colors.black87;
}
