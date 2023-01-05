import 'package:flutter/material.dart';
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

  void clearUser() {
    user = UserModel(
      firstName: '',
      lastName: '',
      phoneNumber: '',
      apiToken: '',
      email: '',
      avatar: '',
    );
    notifyListeners();
  }
}
