import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/order_screen.dart';
import 'package:thrift_exchange/features/account/screens/postings.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/features/account/widgets/account_button.dart';
import 'package:thrift_exchange/features/account/widgets/orders.dart';
import 'package:thrift_exchange/features/auth/screens/auth_screen.dart';

import '../../../providers/user_provider.dart';
import '../../home/services/product_services.dart';
import '../screens/seller_screen.dart';

class TopBottons extends StatefulWidget {
  final String email;
  const TopBottons({super.key, required this.email});

  @override
  State<TopBottons> createState() => _TopBottonsState();
}

class _TopBottonsState extends State<TopBottons> {
  ProductServices prodServices = ProductServices();

  Map<String, dynamic> sellerInfo = {
    "name": "name",
    "email": "email",
    "image": "",
    "averagestars": -1
  };


  void navigateToProfileScreen() {
    Navigator.pushNamed(context, ProfilePage.routeName);
  }

  void navigateToPostingsScreen() {
    Navigator.pushNamed(context, PostingsPage.routeName);
  }

  void navigateToOrdersScreen() {
    Navigator.pushNamed(context, OrdersScreen.routeName);
  }
  void loadSellerInfo()async{
    sellerInfo = await prodServices.getSellerInfo(context: context, email: widget.email);
    setState(() {
      
    });
  }

  @override
  void initState(){
    super.initState();
    loadSellerInfo();
  }

  void navigateToSellerProfile(){
    Navigator.push(context,
    MaterialPageRoute(builder: (context) {
      return SellerScreen(email: sellerInfo['email'].toString(),
        name:sellerInfo['name'].toString(),
        image: sellerInfo['image'].toString(),
        averageStars: sellerInfo['averagestars'] ?? -1,
      );
    }));
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
            AccountButton(
                text: 'Your Seller Profile', onPressed: navigateToSellerProfile),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(
                text: 'Edit Profile', onPressed: navigateToProfileScreen),
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
