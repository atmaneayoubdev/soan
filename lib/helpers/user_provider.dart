import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel user = UserModel(
    firstName: '',
    lastName: '',
    phoneNumber: '',
    apiToken: '',
    email: '',
    avatar: '',
  );

  void setUser(UserModel newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<void> clearUser() async {
    user = UserModel(
      firstName: '',
      lastName: '',
      phoneNumber: '',
      apiToken: '',
      email: '',
      avatar: '',
    );
    final prefs = await SharedPreferences.getInstance();
    prefs.clear;
    notifyListeners();
  }
}
