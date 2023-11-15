import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/order_screen.dart';
import 'package:thrift_exchange/features/account/screens/postings.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/features/account/widgets/account_button.dart';
import 'package:thrift_exchange/features/account/widgets/orders.dart';
import 'package:thrift_exchange/features/auth/screens/auth_screen.dart';

class TopBottons extends StatefulWidget {
  const TopBottons({super.key});

  @override
  State<TopBottons> createState() => _TopBottonsState();
}

class _TopBottonsState extends State<TopBottons> {
  void navigateToProfileScreen() {
    Navigator.pushNamed(context, ProfilePage.routeName);
  }

  void navigateToPostingsScreen() {
    Navigator.pushNamed(context, PostingsPage.routeName);
  }

  void navigateToOrdersScreen() {
    Navigator.pushNamed(context, OrdersScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 17,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Your Orders',
                onPressed: () {
                  navigateToOrdersScreen();
                }),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(text: 'Your Wishlist', onPressed: () {}),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Your Profile', onPressed: navigateToProfileScreen),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Your Postings', onPressed: navigateToPostingsScreen),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Log Out',
                onPressed: () async {
                  try {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    await sharedPreferences.setString('x-auth-token', '');
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AuthScreen.routeName,
                      (route) => false,
                    );
                  } catch (e) {
                    showSnackBar(context, e.toString());
                  }
                }),
          ],
        ),
        SizedBox(
          height: 13,
        ),
      ],
    );
  }
}
