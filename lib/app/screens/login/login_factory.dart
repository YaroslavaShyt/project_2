import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/login/login_screen.dart';
import 'package:project_2/app/screens/login/login_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:provider/provider.dart';

class LoginFactory {
  static Widget build() {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(
          navigationUtil: context.read<INavigationUtil>(),
          userService: context.read<IUserService>(),
          loginRepository: getItInst.get<ILoginRepository>()),
      child: Consumer<LoginViewModel>(builder: (context, model, child) {
        return LoginScreen(loginViewModel: model);
      }),
    );
  }
}
