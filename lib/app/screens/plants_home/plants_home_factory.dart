import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/plants_home/plants_home_screen.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:provider/provider.dart';

class PlantsHomeFactory {
  static Widget build(routeArguments) {
    return ChangeNotifierProvider(
      create: (context) => PlantsHomeViewModel(
        userService: context.read<IUserService>(),
        navigationUtil: context.read<INavigationUtil>(),
        storageService: getItInst.get<StorageService>(),
        loginRepository: getItInst.get<ILoginRepository>(),
        plantsRepository: getItInst.get<IPlantsRepository>(),
        permissionHandler: getItInst.get<PermissionHandler>(),
        notificationService: getItInst.get<NotificationService>(),
      ),
      child: Consumer<PlantsHomeViewModel>(builder: (context, model, child) {
        return PlantsHomeScreen(
          viewModel: model,
        );
      }),
    );
  }
}
