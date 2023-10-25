import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift_exchange/common/widgets/bottom_bar.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../constants/server_path.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

class UpdateService {
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