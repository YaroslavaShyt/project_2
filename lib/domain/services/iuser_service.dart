import 'package:flutter/material.dart';
import 'package:project_2/domain/user/iuser.dart';

abstract interface class IUserService extends ChangeNotifier {
  IUser? get user;

  Map<String, dynamic> get userJSON =>
      {"name": user?.name, "photo": user?.photo};

  set user(IUser? user);

  Future<void> initUser();
}
