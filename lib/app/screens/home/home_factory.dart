import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/home/home_screen.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/services/user_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:provider/provider.dart';

class HomeFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
          navigationUtil: context.read<INavigationUtil>(),
          loginRepository: context.read<ILoginRepository>()),
      child: Consumer<HomeViewModel>(builder: (context, model, child) {
        return HomeScreen(
          homeViewModel: model,
          userService: context.read<UserService>(),
        );
      }),
    );
  }
}
