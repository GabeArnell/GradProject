
import 'dart:convert';

import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:amazon_clone_tutorial/features/home/screens/home_screens.dart';
import 'package:amazon_clone_tutorial/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  })

  async {
    try {
      User user = User(id: '', name: name, password: password, email: email, address: '', type: '', token: '');
      http.Response res = await http.post(
      Uri.parse('$SERVER_URI/api/signup'), 
      body: user.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      );

      // ignore: use_build_context_synchronously
      httpErrorHandle(response: res, context: context, onSuccess: (){
        showSnackBar(context, 'Account created! Login with same credentials.');
      });

    }
    catch (error) {
      // TODO ADD ERROR HERE
    }
  }


// Sign In The User
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  })

  async {
    try {

      User user = User(id: '', name: '', password: password, email: email, address: '', type: '', token: '');
      http.Response res = await http.post(
      Uri.parse('$SERVER_URI/api/signin'), 
      body: user.toJson(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      );
      
      // ignore: use_build_context_synchronously
      httpErrorHandle(response: res, context: context, onSuccess: (){
        SharedPreferences.getInstance().then((prefs){
          prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          prefs.setString('x-auth-token', jsonDecode(res.body)[
            'token'
          ]).then((value) => {
            Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false)
          });
        });
      });

    }
    catch (error) {
    }
  }


  // Get User data
  void getUserData({
    required BuildContext context
  })
  async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token == null){
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

      if (tokenIsValid == true){
        http.Response userResponse = await http.get(Uri.parse('$SERVER_URI/api/getuserdata'),
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

    }
    catch (error) {
    }
  }


}