import 'package:flutter/material.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser.dart';

class UserService extends ChangeNotifier implements IUserService {
  IUser? _user;

  @override
  IUser? get user => _user;
  @override
  void setUser(IUser user) {
    _user = user;
    notifyListeners();
  }
}
