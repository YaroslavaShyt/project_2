import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/camera/camera_service.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

class CameraViewModel extends BaseChangeNotifier {
  final CameraService _cameraService;
  final ICameraCore _cameraCore;
  final INavigationUtil _navigationUtil;
  String? capturedImagePath;
  XFile? capturedVideo;

  CameraViewModel(
      {required CameraService cameraService,
      required ICameraCore cameraCore,
      required INavigationUtil navigationUtil})
      : _cameraService = cameraService,
        _cameraCore = cameraCore,
        _navigationUtil = navigationUtil;

  Stream<CameraState> get cameraStateStream => _cameraService.cameraStateStream;

  void toggleCamera() {
    _cameraService.toggleCamera();
    notifyListeners();
  }

  Future<void> loadCamera() async => await _cameraService.create();

  void disposeCamera() => _cameraService.dispose();

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
      _navigationUtil.navigateToAndReplace(routeVideo, data: capturedVideo);
    } else {
      onFailure("Не вдалося зняти відео.");
    }
  }

  Function() get navigateBack => _navigationUtil.navigateBack;
}
