import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thrift_exchange/common/widgets/bottom_bar.dart';
import 'package:thrift_exchange/constants/error_handling.dart';
import 'package:thrift_exchange/constants/utils.dart';
import 'package:thrift_exchange/features/admin/screens/admin_screen.dart';
import 'package:thrift_exchange/providers/user_provider.dart';

import '../../../constants/server_path.dart';

import '../../../models/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Sign Up The User
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        image: '',
        token: '',
        cart: [],
        usedPromotions: [],
      );
      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(
                context, 'Account created! Login with same credentials.');
          });
    } catch (error) {
      // TODO ADD ERROR HERE
    }
  }

// Sign In The User
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: '',
        password: password,
        email: email,
        address: '',
        type: '',
        image: '',
        token: '',
        cart: [],
        usedPromotions: [],
      );

      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/signin'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences.getInstance().then((prefs) {
              prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
              Provider.of<UserProvider>(context, listen: false)
                  .setUser(res.body);
              prefs
                  .setString('x-auth-token', jsonDecode(res.body)['token'])
                  .then((value) => {
                    if (Provider.of<UserProvider>(context, listen: false).user.type != 'Admin'){
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            BottomBar.routeName, (route) => false)
                    }
                    else{
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AdminScreen.routeName, (route) => false)

                    }
                  });
            });
          });
    } catch (error) {
      print("Auth Error");
      print(error);

    }
  }

// Sign In The User
  void resetUser({
    required BuildContext context,
    required String email,
  }) async {
    try {

      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/api/reset-password'),
        body: jsonEncode({
          "email": email
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            showSnackBar(
                context, 'Password has been reset, check email.');
          });
    } catch (error) {
      print("Reset Error");
      print(error);

    }
  }

  // Get User data
  void getUserData({required BuildContext context}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token == null) {
        preferences.setString('x-auth-token', '');
      }

      // User user = User(id: '', name: '', password: password, email: email, address: '', type: '', token: '');
      http.Response rawResponse = await http.post(
        Uri.parse('$SERVER_URI/api/validateToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var tokenIsValid = jsonDecode(rawResponse.body);

      if (tokenIsValid == true) {
        http.Response userResponse = await http.get(
          Uri.parse('$SERVER_URI/api/getuserdata'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userResponse.body);
      }

      // // ignore: use_build_context_synchronously
      // httpErrorHandle(response: res, context: context, onSuccess: (){
      //   SharedPreferences.getInstance().then((prefs){
      //     prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
      //     Provider.of<UserProvider>(context, listen: false).setUser(res.body);
      //     prefs.setString('x-auth-token', jsonDecode(res.body)[
      //       'token'
      //     ]).then((value) => {
      //       Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false)
      //     });
      //   });
      // });
    } catch (error) {}
  }

// Get User data as Admin
  Future<User> adminUserSearch({required BuildContext context,
    required String userID,
  }) async {
    User result = User(id: "0", name: "requesting", 
    password: "", 
    email: "requesting", 
    address: "", 
    type: "", 
    image: "", 
    token: "", 
    cart: [], 
    usedPromotions: 
    []);
    try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

      http.Response res = await http.post(
        Uri.parse('$SERVER_URI/admin/get-user-data'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          "userID": userID
        })
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(response: res, context: context, onSuccess: (){
          result = User.fromMap(jsonDecode(res.body));
          print("My Result is " + result.email);
          print(result);
      });
    } catch (error) {
      print("Search eror");
      print(error);
    }
    return result;
  }

}
