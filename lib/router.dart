import 'package:flutter/material.dart';
import 'package:thrift_exchange/common/widgets/bottom_bar.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/features/home/screens/products_screens.dart';
import 'package:thrift_exchange/features/home/search/screens/search_screen.dart';
import 'package:thrift_exchange/models/product.dart';

import 'features/auth/screens/auth_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );
    case ProductsScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductsScreen(
          product: product,
        ),
      );
    case ProfilePage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProfilePage(),
      );
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const BottomBar(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
            body: Center(
                child: Text(
                    "Oops! This page does not exist, go back and try a different route."))),
      );
  }
}
