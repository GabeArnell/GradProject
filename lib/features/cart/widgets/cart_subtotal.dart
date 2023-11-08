import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../models/product.dart';

class CartSubtotal extends StatefulWidget {
  List<Product> products;

  CartSubtotal({super.key, required this.products});

  @override
  State<CartSubtotal> createState() => _CartSubtotalState();
}

class _CartSubtotalState extends State<CartSubtotal> {
  @override
  Widget build(BuildContext context) {
    num sum = 0;
    for (int i = 0; i < widget.products.length; i++){
      sum += widget.products[i].quantity * widget.products[i].price;
    }
    // user.cart
    //     .map((e) => sum += e['quantity'] * e['product']['price'] as int)
    //     .toList();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          const Text(
            "Subtotal ",
            style: TextStyle(
              fontSize: 21,
            ),
          ),
          Text(
            '\$$sum',
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
