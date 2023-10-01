import 'package:amazon_clone_tutorial/features/home/screens/home_screens.dart';
import 'package:flutter/material.dart';

import 'features/auth/screens/auth_screen.dart';

Route <dynamic> generateRoute(RouteSettings routeSettings) {
  switch(routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const HomeScreen(),
      );
    default: 
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_)=> const Scaffold(
          body: Center(
            child: Text("Oops! This page does not exist, go back and try a different route.")
          )
        ),
      );
  }
}