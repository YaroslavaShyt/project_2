import 'package:flutter/material.dart';
import 'package:project_2/domain/user/iuser.dart';

class UserService extends ChangeNotifier {
  IUser? _user;

  IUser? get user => _user;

  void setUser(IUser user) {
    _user = user;
    notifyListeners();
  }
}
