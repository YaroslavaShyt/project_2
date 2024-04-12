import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/camera/camera_screen.dart';
import 'package:project_2/app/screens/camera/camera_view_model.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/utils/camera/camera_util.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

import 'package:provider/provider.dart';

enum CameraType { photo, video }

class CameraFactory {
  static Widget build(RouteSettings settings) {
    return ChangeNotifierProvider(
      create: (context) => CameraViewModel(
          cameraConfig: settings.arguments as Map<Camera, Map<CameraType, dynamic>>,
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
