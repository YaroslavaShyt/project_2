import 'package:flutter/material.dart';
import 'package:project_2/app/screens/login/login_screen.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/services/user_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:provider/provider.dart';

class LoginFactory {
  static Widget build() {
    return ChangeNotifierProvider(
      create: (context) =>
          LoginViewModel(
            userService: context.read<UserService>(),
            loginRepository: context.read<ILoginRepository>()),
      child: Consumer<LoginViewModel>(builder: (context, model, child) {
        return LoginScreen(loginViewModel: model);
      }),
    );
  }
}
