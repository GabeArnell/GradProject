import 'package:flutter/material.dart';

class GlobalVariables {
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB (255, 29, 201, 192),
      Color.fromARGB (255, 125, 221, 216),
    ],
    stops: [0.5, 1.0]
  );

  static const secondaryColor = Colors.amber;
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan;
  static const unselectedNavBarColor = Colors.black87;

}