import 'package:flutter/material.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class UserService extends ChangeNotifier implements IUserService {
  final IUserRepository _userRepository;
  final ILoginRepository _loginRepository;
  UserService(
      {required IUserRepository userRepository,
      required ILoginRepository loginRepository})
      : _userRepository = userRepository,
        _loginRepository = loginRepository;
  
  @override
  IUser? user;

  @override
  Map<String, dynamic> get userJSON =>
      {"name": user?.name, "photo": user?.photo};

  @override
  Future initUser() async {
    if (_loginRepository.googleUser != null) {
      user =
          await _userRepository.readUser(id: _loginRepository.googleUser!.uid);
    }
  }
}
