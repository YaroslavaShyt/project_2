import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';

enum Video { data, onSubmit }

class CameraViewModel extends BaseChangeNotifier{
  final ICameraService _cameraService;
  final INavigationUtil _navigationUtil;
  final PermissionHandler _permissionHandler;
  late bool isPhotoCamera;
  late bool isVideoCamera;
  late Function onPhotoCameraSuccess;
  late Function onPhotoCameraError;
  late Function onVideoCameraSuccess;
  late Function onVideoCameraError;
  String? capturedImagePath;
  XFile? capturedVideo;

  CameraViewModel(
      {required ICameraService cameraService,
      required Map<CameraConfigKeys, Map<CameraType, dynamic>> cameraConfig,
      required ICameraCore cameraCore,
      required PermissionHandler permissionHandler,
      required INavigationUtil navigationUtil})
      : _cameraService = cameraService,
        _navigationUtil = navigationUtil,
        _permissionHandler = permissionHandler {
    isPhotoCamera = cameraConfig[CameraConfigKeys.cameraTypes]?[CameraType.photo] ?? true;
    isVideoCamera =
        cameraConfig[CameraConfigKeys.cameraTypes]?[CameraType.video] ?? false;
    onPhotoCameraSuccess =
        cameraConfig[CameraConfigKeys.onSuccess]?[CameraType.photo] ?? () {};
    onPhotoCameraError =
        cameraConfig[CameraConfigKeys.onError]?[CameraType.photo] ?? () {};
    onVideoCameraSuccess =
        cameraConfig[CameraConfigKeys.onSuccess]?[CameraType.video] ?? () {};
    onVideoCameraError =
        cameraConfig[CameraConfigKeys.onError]?[CameraType.video] ?? () {};
  }

  Stream<CameraState> get cameraStateStream => _cameraService.cameraStateStream;

  Future<void> toggleCamera() async {
    await _cameraService.toggleCamera();
    notifyListeners();
  }

  Future<void> loadCamera() async {
    _permissionHandler.isCameraPermissionGranted();
    await _cameraService.create();
    notifyListeners();
  }

  

  Function get disposeCamera => _cameraService.disposeCamera;

  Widget get cameraPreview => _cameraService.cameraPreview;

  CameraState get cameraState => _cameraService.cameraState;

  bool get isVideoCameraSelected => isVideoCamera;

  void changeCaptureType() {
    _cameraService.changeCaptureType();
    notifyListeners();
  }

  Future<void> takePicture({required void Function() onPhotoTaken}) async {
    capturedImagePath = await _cameraService.takePhoto();
    if (capturedImagePath != null) {
      onPhotoTaken();
    } else {
      onPhotoCameraError("Виникла помилка!");
    }
  }

  Function get startVideo => _cameraService.startRecording;
  Function get pauseVideo => _cameraService.pauseRecording;
  Function get resumeVideo => _cameraService.resumeRecording;

  Future<void> stopVideo({required Function(String) onFailure}) async {
    capturedVideo = await _cameraService.stopRecording();
    if (capturedVideo != null) {
      _navigationUtil.navigateToAndReplace(routeVideo, data: {
        Video.data: capturedVideo,
        Video.onSubmit: onVideoCameraSuccess
      });
    } else {
      onFailure("Не вдалося зняти відео.");
    }
  }

  Function() get navigateBack => _navigationUtil.navigateBack;
}
