import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/camera/camera_config_data.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/services/camera/video_config_data.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

enum Video { data, onSubmit }

class CameraViewModel extends BaseChangeNotifier {
  final ICameraService _cameraService;
  final INavigationUtil _navigationUtil;
  final PermissionHandler _permissionHandler;
  final CameraConfigData _cameraConfigData;
  String? capturedImagePath;
  XFile? capturedVideo;
  int? progressRemaining;

  CameraConfigData get cameraConfigData => _cameraConfigData;

  CameraViewModel(
      {required ICameraService cameraService,
      required CameraConfigData cameraConfigData,
      required ICameraCore cameraCore,
      required PermissionHandler permissionHandler,
      required INavigationUtil navigationUtil})
      : _cameraService = cameraService,
        _navigationUtil = navigationUtil,
        _permissionHandler = permissionHandler,
        _cameraConfigData = cameraConfigData;

  Stream<CameraState> get cameraStateStream => _cameraService.cameraStateStream;
  Stream<int> get recordedVideoProgressStream =>
      _cameraService.recordedVideoProgressStream;

  Future<void> toggleCamera() async {
    await _cameraService.toggleCamera();
    notifyListeners();
  }

  Future<void> loadCamera() async {
    _permissionHandler.isCameraPermissionGranted();
    await _cameraService.create();
    progressRemaining = _cameraService.recordedVideoTimeRemaining;
    notifyListeners();
  }

  Future<void> updateRemainingProgress(
      {required int newProgress, required Function(String) onFailure}) async {
    progressRemaining = newProgress;
    notifyListeners();
    if (newProgress == 0) {
      await stopVideo(onFailure: onFailure);
    }
  }

  Function get disposeCamera => _cameraService.disposeCamera;

  Widget get cameraPreview => _cameraService.cameraPreview;

  CameraState get cameraState => _cameraService.cameraState;

  bool get isVideoCameraSelected => _cameraConfigData.isVideoCamera;

  void changeCaptureType() {
    _cameraService.changeCaptureType();
    notifyListeners();
  }

  Future<void> takePicture({required void Function() onPhotoTaken}) async {
    capturedImagePath = await _cameraService.takePhoto();
    if (capturedImagePath != null) {
      onPhotoTaken();
    } else {
      _cameraConfigData.onPhotoCameraError!("Виникла помилка!");
    }
  }

  Function get startVideo => _cameraService.startRecording;
  Function get pauseVideo => _cameraService.pauseRecording;
  Function get resumeVideo => _cameraService.resumeRecording;

  Future<void> stopVideo({required Function(String) onFailure}) async {
    capturedVideo = await _cameraService.stopRecording();
    if (capturedVideo != null) {
      _navigationUtil.navigateToAndReplace(routeVideo, data: [
        _cameraConfigData,
        VideoConfigData(
            video: capturedVideo!,
            onVideoSubmit: _cameraConfigData.onVideoCameraSuccess!)
      ]);
    } else {
      onFailure("Не вдалося зняти відео.");
    }
  }

  Function() get navigateBack => _navigationUtil.navigateBack;
}
