import 'package:flutter/material.dart';
import 'package:recruitmentclient/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel("superadmin", "default", "defaultname", null, UserRole.superadmin);
  UserModel get user => _user;

  init() async {
  }

  setUser(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }
}
