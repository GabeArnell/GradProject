import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift_exchange/common/widgets/bottom_bar.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/models/order.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../constants/server_path.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

class UpdateService {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$SERVER_URI/api/orders/me'),
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
            orderList.add(
              Order.fromJson(
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
    return orderList;
  }

  void updateProfilePicture({
    required BuildContext context,
    required File? image,
    required Function(String) onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String imageUrl = '';
    try {
      final cloudinary = CloudinaryPublic('dyczsvdgt', 'irpg0kb6');

      CloudinaryResponse result = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(image!.path, folder: 'profile'),
      );
      imageUrl = result.secureUrl;
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/profile/update-details'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "type": "image",
          "detail": imageUrl,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess(imageUrl);
          showSnackBar(context, 'Profile Picture Updated Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$SERVER_URI/api/orders/listings'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
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
    return orderList;
  }

  void updateDetails({
    required BuildContext context,
    required String type,
    required String detail,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/profile/update-details'),
        body: jsonEncode({
          'type': type,
          'detail': detail,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Updated ${type} Successfully');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
