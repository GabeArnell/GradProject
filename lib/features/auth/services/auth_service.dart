
import 'package:amazon_clone_tutorial/constants/error_handling.dart';
import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:flutter/material.dart';

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

      httpErrorHandle(response: res, context: context, onSuccess: (){
        showSnackBar(context, 'Account created! Login with same credentials.');
      });

    }
    catch (error) {
    }
  }


}