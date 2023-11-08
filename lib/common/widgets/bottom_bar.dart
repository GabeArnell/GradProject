import 'package:badges/badges.dart' as bd;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/screens/account_screen.dart';
import 'package:thrift_exchange/features/cart/screens/cart_screen.dart';
import 'package:thrift_exchange/features/home/screens/home_screens.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  static const String routeName = '/actual-home';
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    num userCartLength = 0;
    for (int i = 0; i < context.watch<UserProvider>().user.cart.length; i++){
      userCartLength += context.watch<UserProvider>().user.cart[i]['quantity'];
    }
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: _page == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: _page == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: _page == 2
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth),
                ),
              ),
              child: bd.Badge(
                elevation: 0,
                badgeContent: Text(userCartLength.toString()),
                badgeColor: Colors.white,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
