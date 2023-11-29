import 'package:flutter/material.dart';
import 'package:thrift_exchange/constants/global_variables.dart';

class CustomSubBanner extends StatelessWidget {
  final String title;
  CustomSubBanner({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 26,
                color: Colors.black,
              ),
              
            ),
          ),
        ],
      ),
    );
  }
}
