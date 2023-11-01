import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:thrift_exchange/providers/user_provider.dart';

class ChatServices {
  void sendMessage({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required double zipcode,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/send-message"'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: {
          "recipient": "a@gmail.com",
          "content": "Hello a, this is my message!"
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
