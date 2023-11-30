import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/models/user.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class ProductServices {
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

  void rateProduct({
    required BuildContext context,
    required Product product,
    required num rating
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'itemID': product.id,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
            showSnackBar(context, 'Gave the product ${rating.round()} stars!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<double> getRating({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    double result = -10;
    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/calculate-product-rating'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'itemID': product.id
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
            result = jsonDecode(res.body);
            result = result.toDouble();
        },
      );
    } catch (e) {
      //showSnackBar(context, e.toString());
    }
    return result.toDouble();
  }

  void incrementViews({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/analytics/viewed-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'itemID': product.id
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
            print("Viewed product");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getSellerInfo({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Map<String, dynamic> info = {
      "name": "Loading",
      "email": "email",
      "image": ""
    };

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/view-profile'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'email': product.email,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          info = jsonDecode(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return info;
  }
}
