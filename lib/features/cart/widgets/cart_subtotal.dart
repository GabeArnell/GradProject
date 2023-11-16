import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../models/product.dart';
import '../services/cart_services.dart';

class CartSubtotal extends StatefulWidget {
  List<Product> products;
  String promoCode = '';
  num postPromoSum = 0;

  CartSubtotal({super.key, required this.products});

  @override
  State<CartSubtotal> createState() => _CartSubtotalState();
}

class _CartSubtotalState extends State<CartSubtotal> {
  int flatDiscount = 0;
  int percentDiscount = 0;
  int promoMinPrice = 0;

  final TextEditingController _promoController = TextEditingController();
  final CartServices cartServices = CartServices();

  String formatMoney(num m){
    int expand = (m*100).round();
    String result = "${expand/100}";
    return result;
  }


  @override
  Widget build(BuildContext context) {
    num sum = 0;
    for (int i = 0; i < widget.products.length; i++){
      sum += widget.products[i].quantity * widget.products[i].price;
    }
    widget.postPromoSum = sum;
    if (flatDiscount > 0 && sum > promoMinPrice){
      widget.postPromoSum = widget.postPromoSum - flatDiscount;
    }
    if (percentDiscount > 0 && sum > promoMinPrice){
      widget.postPromoSum = widget.postPromoSum * ((100-percentDiscount)/100);
    }
    // user.cart
    //     .map((e) => sum += e['quantity'] * e['product']['price'] as int)
    //     .toList();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
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
          const SizedBox(
            height: 10,
          ),
          TextFormField(
                maxLines: 1,
                controller: _promoController,
                onFieldSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    String responseBody = await cartServices.checkPromotion(
                        context: context,
                        promoCode: value);

                    if (responseBody == ""){
                      print("Bad promo code");
                      return;
                    };

                    flatDiscount = jsonDecode(responseBody)['flatdiscount'] ?? 0;
                    percentDiscount = jsonDecode(responseBody)['percentdiscount'] ?? 0;
                    promoMinPrice = jsonDecode(responseBody)['minprice'] ?? 0;
                    widget.promoCode = jsonDecode(responseBody)['code'] ?? '';
                    print("Flat Discount: "+flatDiscount.toString());
                    print("response body" + responseBody);
                    setState(() {
                      
                    });
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'Promo Code',
                    border:  OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    )),
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.black38,
                    ))),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Enter a promo code';
                  }

                  return null;
                },
              ),
          if (flatDiscount > 0 && sum >= promoMinPrice)
            Row(
              children: [
                const Text(
                  "Discount ",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '- \$$flatDiscount',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 186, 6),

                  ),
                ),
              ],
            ),
          if (percentDiscount > 0 && sum >= promoMinPrice)
            Row(
              children: [
                const Text(
                  "Discount ",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '- ${percentDiscount}%',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 186, 6),

                  ),
                ),
              ],
            ),
          if (widget.postPromoSum != sum)
            Row(
              children: [
                const Text(
                  "With Promotion: ",
                  style: TextStyle(
                    fontSize: 21,
                  ),
                ),
                Text(
                  '\$${formatMoney(widget.postPromoSum)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 186, 6),

                  ),
                ),
              ],
            ),


        ],
      ),
    );
  }
}
