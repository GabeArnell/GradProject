import '../models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    password: '',
    email: '',
    address: '',
    type: '',
    image: '',
    token: '',
    cart: [],
    usedPromotions: []
  );

  User get user => _user;

  void setUser(String user) {
    _user = User.fromJson(user);
    notifyListeners();
  }

  void resetUser(){
    _user = User(
      id: '',
      name: '',
      password: '',
      email: '',
      address: '',
      type: '',
      image: '',
      token: '',
      cart: [],
      usedPromotions: []
    );
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
