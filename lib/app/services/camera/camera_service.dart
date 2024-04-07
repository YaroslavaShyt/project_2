import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

class CameraService extends BaseChangeNotifier with WidgetsBindingObserver {
  final ICameraCore _cameraCore;
  final ICameraConfig _cameraConfig;
  CameraController? cameraController;
  CameraDescription? currentCamera;
  CameraPreview? _cameraPreview;
  bool _isCameraInitialized = false;
  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  FlashMode? _currentFlashMode;

  CameraState _cameraState = CameraState.init;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;

  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;

  StreamController<CameraState> _cameraStateStreamController = StreamController();

  Stream<CameraState> get cameraStateStream =>
      _cameraStateStreamController!.stream;
  CameraState get cameraState => _cameraState;

  CameraService(
      {required ICameraCore cameraCore, required ICameraConfig cameraConfig})
      : _cameraCore = cameraCore,
        _cameraConfig = cameraConfig;

  void initCamera() async {
    currentCamera = _cameraCore.camerasList[0];
  }

  void changeIneractionType() {
    _isVideoCameraSelected = !_isVideoCameraSelected;
  }

  Widget get cameraPreview => _cameraPreview ?? const SizedBox();

  Future<void> onNeWCameraSelected(CameraDescription description) async {
    final CameraController? previousCameraController = cameraController;
    final CameraController controller = CameraController(
        description, currentResolutionPreset,
        imageFormatGroup: ImageFormatGroup.jpeg);

    await previousCameraController?.dispose();

    try {
      await controller.initialize();
      _isCameraInitialized = controller.value.isInitialized;
      cameraController = controller;
      controller.getMaxZoomLevel().then((value) => _maxAvailableZoom = value);

      controller.getMinZoomLevel().then((value) => _minAvailableZoom = value);

      controller
          .getMinExposureOffset()
          .then((value) => _minAvailableExposureOffset = value);

      controller
          .getMaxExposureOffset()
          .then((value) => _maxAvailableExposureOffset = value);

      _currentFlashMode = controller.value.flashMode;
      _cameraStateStreamController = StreamController();
      _cameraPreview = CameraPreview(controller);
      _updateCameraState(CameraState.ready);
    } catch (err) {
      debugPrint(err.toString());
      _updateCameraState(CameraState.error);
    }
  }

  Future<String?> takePhoto() async {
    final CameraController? controller = cameraController;
    if (controller!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await controller.takePicture();
      return file.path;
    } catch (err) {
      debugPrint(err.toString());
      _updateCameraState(CameraState.error);
      return null;
    }
  }

  void toggleCamera() {
    _isCameraInitialized = false;
    _updateCameraState(CameraState.init);
    onNeWCameraSelected(_cameraCore.camerasList[_isRearCameraSelected ? 0 : 1]);
    _isRearCameraSelected = !_isRearCameraSelected;
  }

  @override
  void dispose() {
    cameraController?.dispose();
    _cameraStateStreamController?.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNeWCameraSelected(controller.description);
    }
  }

  void _updateCameraState(CameraState state) {
    _cameraState = state;
    _cameraStateStreamController?.add(state);
  }
}
