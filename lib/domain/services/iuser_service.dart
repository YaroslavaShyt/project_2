import 'package:flutter/material.dart';
import 'package:project_2/domain/user/iuser.dart';

abstract interface class IUserService extends ChangeNotifier{
  IUser? get user;

  void setUser(IUser user);
}