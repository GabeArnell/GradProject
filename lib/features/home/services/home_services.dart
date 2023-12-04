import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:thrift_exchange/common/temp_image.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/server_path.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/account/screens/profile_screen.dart';
import 'package:thrift_exchange/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../models/alert.dart';

class HomeServices {
  var logger = Logger();
  void submitProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String zipcode,
    required String category,
    required List<TempImage> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool result = true;
    try {
      final cloudinary = CloudinaryPublic('dyczsvdgt', 'irpg0kb6');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {

        CloudinaryFile newFile = CloudinaryFile.fromBytesData(images[i].bytes, identifier: "${userProvider.user.email}-${images[i].name}");
        CloudinaryResponse res = await cloudinary.uploadFile(
          newFile
        );
        imageUrls.add(res.secureUrl);
      }
      if (imageUrls.length != 0) {
        ProfilePage();
      }
      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price,
          zipcode: zipcode,
          views: 0,
          email: '');
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product Added Successfully!');
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

  Future<bool> editProduct({
    required BuildContext context,
    required String id,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String zipcode,
    required String category,
    required List<TempImage> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool success = false;
    try {
      final cloudinary = CloudinaryPublic('dyczsvdgt', 'irpg0kb6');
      List<String> imageUrls = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryFile newFile = CloudinaryFile.fromBytesData(images[i].bytes, identifier: "${userProvider.user.email}-${images[i].name}");
        CloudinaryResponse res = await cloudinary.uploadFile(
          newFile
        );
        imageUrls.add(res.secureUrl);
      }
      Product product = Product(
          id: id,
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price,
          zipcode: zipcode,
          views: -1,
          email: '');
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/edit-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          success = true;
          showSnackBar(context, 'Product Edited Successfully!');
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    return success;
  }

  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$SERVER_URI/api/listings'), headers: {
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

  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$SERVER_URI/api/products/category/$category'),
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

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<String> descriptionHelp({
    required BuildContext context,
    required String name,
    required String description,
    required String price,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      showSnackBar(context, 'Generating description.');

      http.Response res =
          await http.post(Uri.parse('$SERVER_URI/api/chatbot/description-gen'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': userProvider.user.token,
              },
              body: jsonEncode({
                'name': name,
                'description': description,
                'price': price,
              }));
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Description generated.');
        },
      );
      print(jsonDecode(res.body));
      return jsonDecode(res.body);
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
      return "Could not connect to Service";
    }
  }

  Future<bool> submitAlert({
    required BuildContext context,
    required String name,
    required String zipcode,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/set-alert'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'name': name,
          'zipcode': zipcode,
          'category': category,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Alert has been set Successfully!');
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
          return true;

  }

 Future<List<Alert>> getAlerts({
    required BuildContext context
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Alert> list = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$SERVER_URI/api/get-alerts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var jsonList = jsonDecode(res.body);
          for (int i = 0; i < jsonList.length; i++){
            list.add(Alert.fromJson(jsonEncode(jsonList[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        "alert get "+e.toString(),
      );
    }

    return list;
  }

Future<bool> deleteAlert({
    required BuildContext context,
    required Alert alert,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/delete-alert'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'alertID': alert.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Alert deleted successfully.');
        },
      );
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
          return true;

  }

}
