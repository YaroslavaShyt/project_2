import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

class CameraViewModel extends BaseChangeNotifier {
  final ICameraService _cameraService;
  final INavigationUtil _navigationUtil;
  String? capturedImagePath;

  CameraViewModel(
      {required ICameraService cameraService,
      required INavigationUtil navigationUtil})
      : _cameraService = cameraService,
        _navigationUtil = navigationUtil;

  Stream<CameraState> get cameraStateStream =>
      _cameraService.cameraStateStream;

  Widget get cameraPreview => _cameraService.cameraPreview;

  Future<void> toggleCamera() async {
    await _cameraService.toggleCamera();
    notifyListeners();
  }

  Future<void> loadCamera() async => await _cameraService.create();

  void disposeCamera() => _cameraService.dispose();

  Future<void> takePicture(
      {required Function() onSuccess,
      required Function(String) onFailure}) async {
    capturedImagePath = await _cameraService.takePicture();
    if (capturedImagePath != null) {
      onSuccess();
    } else {
      onFailure('Фото було не зроблено.');
    }
  }

  Future<void> takeVideo(
      {required Function onSuccess,
      required Function(String) onFailure}) async {}

  void navigateBack() => _navigationUtil.navigateBack();
}
