import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

class EditingService {
  Future<List<Product>> getPostings({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> postingsList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$SERVER_URI/api/my-listings'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            postingsList.add(
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
    return postingsList;
  }
}
