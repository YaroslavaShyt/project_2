import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/camera/camera_screen.dart';
import 'package:project_2/app/screens/camera/camera_view_model.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

import 'package:provider/provider.dart';

class CameraFactory {
  static Widget build() {
    return ChangeNotifierProvider(
      create: (context) => CameraViewModel(
          permissionHandler: getItInst.get<PermissionHandler>(),
          cameraService: getItInst.get<ICameraService>(),
          cameraCore: getItInst.get<ICameraCore>(),
          navigationUtil: context.read<INavigationUtil>()),
      child: Consumer<CameraViewModel>(builder: (context, model, child) {
        return CameraScreen(
          viewModel: model,
        );
      }),
    );
  }
}
