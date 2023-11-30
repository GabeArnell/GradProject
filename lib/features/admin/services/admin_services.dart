import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/admin/models/sales_model.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../models/views_model.dart';

class AdminServices {
  Future<Map<String, dynamic>> getEarnings(BuildContext context, String timespan) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$SERVER_URI/api/analytics/earnings/${timespan}'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'].round();
          sales = [
            Sales('Electronics', response['electronicsEarnings'].round()),
            Sales('Appliances', response['appliancesEarnings'].round()),
            Sales('Apparel', response['apparelEarnings'].round()),
            Sales('Furniture', response['furnitureEarnings'].round()),
            Sales('Other', response['otherEarnings'].round()),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  Future<Map<String, dynamic>> getViews(BuildContext context,
  String timespan) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Views> views = [];
    int totalViews = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$SERVER_URI/api/analytics/views'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalViews = response['total'];
          views = [
            Views('Electronics', response['electronics']),
            Views('Appliances', response['appliances']),
            Views('Apparel', response['apparel']),
            Views('Furniture', response['furniture']),
            Views('Other', response['other']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'views': views,
      'totalViews': totalViews,
    };
  }
}
