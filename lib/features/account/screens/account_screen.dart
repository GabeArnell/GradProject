import 'package:flutter/material.dart';
import 'package:thrift_exchange/constants/global_variables.dart';
import 'package:thrift_exchange/features/account/widgets/below_app_bar.dart';
import 'package:thrift_exchange/features/account/widgets/orders.dart';
import 'package:thrift_exchange/features/account/widgets/top_buttons.dart';
import 'package:thrift_exchange/features/chat/screens/chat_home_page.dart';
import 'package:thrift_exchange/features/home/screens/add_product_Screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 251, 188, 0).withOpacity(0.4),
                      BlendMode.srcOver),
                  child: Image.asset(
                    'assets/images/logo_transparent.png',
                    width: 55,
                    height: 95,
                    //color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ChatHomePage.routeName);
                          //ChatHomePage();
                        },
                        icon: Icon(
                          Icons.message_outlined,
                        ),
                      ),
                    ),
                    Icon(Icons.search),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          BelowAppBar(),
          SizedBox(
            height: 10,
          ),
          TopBottons(),
          //Orders(),
        ],
      ),
    );
  }
}
