import 'package:flutter/material.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/models/user.dart';
import 'package:thrift_exchange/providers/user_provider.dart';
import 'dart:convert';

class CartServices {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Added product to cart!');

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void removeFromCart({    required BuildContext context,
    required Product product,
})async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$SERVER_URI/api/remove-from-cart/'+product.id.toString()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

 Future<List<Product>> fetchCartProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$SERVER_URI/api/get-cart-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void checkoutCart({
    required BuildContext context
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/checkout'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        }
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          showSnackBar(context, 'Order processed!');
          Navigator.pop(context);

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}
