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

import '../../../models/review.dart';
import '../../../models/user.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  Future<String> addReview({
    required BuildContext context,
    required String email,
    required String content
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/add-review'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "email": email,
          "content": content,
        })
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
            showSnackBar(context, "Review Added!");

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
          return "fail";

    }
    return "success";
  }

  Future<List<Review>> getReviews(BuildContext context, String email) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Review> reviewList = [];
    try {
      http.Response res =
        await http.post(Uri.parse('$SERVER_URI/api/get-reviews'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      },
        body: jsonEncode({
          "email": email
        }),
      
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var resList = jsonDecode(res.body);
          for (int i = 0; i < resList.length; i++) {
            reviewList.add(Review.fromJson(jsonEncode(resList[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return reviewList;
  }

  Future<String> deleteReview({
    required BuildContext context,
    required String writer,
    required String subject
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/admin/delete-review'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "writer": writer,
          "subject": subject,
        })
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
            showSnackBar(context, "Review Removed!");

        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
          return "fail";

    }
    return "success";
  }




}
