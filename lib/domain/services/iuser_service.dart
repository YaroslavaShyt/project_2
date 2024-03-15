import 'package:flutter/material.dart';
import 'package:project_2/domain/user/imy_user.dart';

abstract interface class IUserService extends ChangeNotifier {
  IMyUser? get user;

  void setUser(IMyUser user);
  Future<IMyUser?> loadUserData();
}
