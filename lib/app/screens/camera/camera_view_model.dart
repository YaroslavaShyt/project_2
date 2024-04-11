import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

class CameraViewModel extends BaseChangeNotifier {
  final ICameraService _cameraService;
  final INavigationUtil _navigationUtil;
  final PermissionHandler _permissionHandler;
  String? capturedImagePath;
  XFile? capturedVideo;
  bool isCameraDisposed = false;

  CameraViewModel(
      {required ICameraService cameraService,
      required ICameraCore cameraCore,
      required PermissionHandler permissionHandler,
      required INavigationUtil navigationUtil})
      : _cameraService = cameraService,
        _navigationUtil = navigationUtil,
        _permissionHandler = permissionHandler;

  Stream<CameraState> get cameraStateStream => _cameraService.cameraStateStream;

  Future<void> toggleCamera() async {
    await _cameraService.toggleCamera();
    notifyListeners();
  }

  Future<void> loadCamera() async {
    _permissionHandler.isCameraPermissionGranted();
    await _cameraService.create();
  }

  Function get disposeCamera => _cameraService.disposeCamera;

  Widget get cameraPreview => _cameraService.cameraPreview;

  CameraState get cameraState => _cameraService.cameraState;

  bool get isVideoCameraSelected => _cameraService.isVideoCameraSelected;

  void changeCaptureType() {
    _cameraService.changeCaptureType();
    notifyListeners();
  }

  Future<void> takePicture(
      {required Function() onSuccess,
      required Function(String) onFailure}) async {
    capturedImagePath = await _cameraService.takePhoto();
    if (capturedImagePath != null) {
      onSuccess();
    } else {
      onFailure('Фото було не зроблено.');
    }
  }

  Function get startVideo => _cameraService.startRecording;
  Function get pauseVideo => _cameraService.pauseRecording;
  Function get resumeVideo => _cameraService.resumeRecording;

  Future<void> stopVideo({required Function(String) onFailure}) async {
    capturedVideo = await _cameraService.stopRecording();
    if (capturedVideo != null) {
      _navigationUtil.navigateTo(routeVideo, data: capturedVideo);
    } else {
      onFailure("Не вдалося зняти відео.");
    }
  }

  Function() get navigateBack => _navigationUtil.navigateBack;
}
