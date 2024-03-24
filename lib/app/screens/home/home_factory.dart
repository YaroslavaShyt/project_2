import 'package:flutter/material.dart';
import 'package:project_2/app/screens/home/home_screen.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/notifications/notification_service.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/domain/services/iauth_service.dart';
import 'package:provider/provider.dart';

class HomeFactory {
  static Widget build() {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(
          notificationService: getItInst.get<NotificationService>(),
          permissionHandler: getItInst.get<PermissionHandler>(),
          authService: context.read<IAuthService>()),
      child: Consumer<HomeViewModel>(builder: (context, model, child) {
        return HomeScreen(
          homeViewModel: model,
        );
      }),
    );
  }
}
