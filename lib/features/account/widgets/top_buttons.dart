import 'package:flutter/material.dart';
import 'package:thrift_exchange/features/account/widgets/account_button.dart';
import 'package:thrift_exchange/features/account/widgets/orders.dart';

class TopBottons extends StatefulWidget {
  const TopBottons({super.key});

  @override
  State<TopBottons> createState() => _TopBottonsState();
}

class _TopBottonsState extends State<TopBottons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 17,
        ),
        Row(
          children: [
            AccountButton(text: 'Your Orders', onPressed: () {}),
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
            AccountButton(text: 'Settings', onPressed: () {}),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(text: 'Your Postings', onPressed: () {}),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Row(
          children: [
            AccountButton(text: 'Log Out', onPressed: () {}),
          ],
        ),
        SizedBox(
          height: 13,
        ),
        Orders(),
      ],
    );
  }
}
