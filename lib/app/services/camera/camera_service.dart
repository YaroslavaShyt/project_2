import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

class CameraService extends BaseChangeNotifier
    with WidgetsBindingObserver
    implements ICameraService {
  @override
  ICameraCore cameraCore;

  @override
  ICameraConfig cameraConfig;

  XFile? videoFile;

  CameraPreview? _cameraPreview;
  CameraController? _cameraController;

  int _currentCameraId = 0;

  bool _isObserverAdded = false;
  bool _isVideoCameraSelected = false;
  bool _isCameraControllerDisposed = false;

  @override
  CameraState get cameraState => _cameraState;
  CameraState _cameraState = CameraState.init;

  FlashMode flashMode = FlashMode.off;

  @override
  Stream<CameraState> get cameraStateStream =>
      _cameraStateStreamController.stream;
  final StreamController<CameraState> _cameraStateStreamController =
      StreamController();

  CameraService({required this.cameraCore, required this.cameraConfig});

  @override
  Widget get cameraPreview => _cameraPreview ?? const SizedBox();

  @override
  Size get previewSize =>
      _cameraController?.value.previewSize ?? const Size(0, 0);

  @override
  List<CameraDescription> get camerasList => cameraCore.camerasList;

  @override
  bool get isVideoCameraSelected => _isVideoCameraSelected;

  @override
  void changeCaptureType() => _isVideoCameraSelected = !_isVideoCameraSelected;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      if (!_isCameraControllerDisposed) {
        dispose();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_isCameraControllerDisposed) {
        await reset();
      }
      await create();
    }
  }

  @override
  Future<void> create() async {
    if (!_isObserverAdded) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverAdded = true;
    }

    _cameraController = CameraController(
        camerasList[_currentCameraId], cameraConfig.cameraResolutionPreset,
        imageFormatGroup: ImageFormatGroup.yuv420);

    try {
      await _cameraController!.initialize();

      _cameraPreview = CameraPreview(_cameraController!);
      _updateCameraState(CameraState.ready);
    } on CameraException catch (exception) {
      _updateCameraState(CameraState.error);
      debugPrint(exception.toString());
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _isObserverAdded = false;
    super.dispose();
  }

  @override
  Future<String?> takePhoto() async {
    try {
      _cameraController!.setFlashMode(flashMode);
      XFile xFile = await _cameraController!.takePicture();
      return xFile.path;
    } on CameraException catch (exception) {
      _updateCameraState(CameraState.error);
      debugPrint(exception.toString());
      return null;
    }
  }

  @override
  Future<void> toggleCamera() async {
    _currentCameraId = _currentCameraId == 0 ? 1 : 0;
    await _disposeCameraController();
    _cameraPreview = null;
    _updateCameraState(CameraState.init);
    return await create();
  }

  @override
  Future<void> reset() async {
    await _disposeCameraController();
    _cameraPreview = null;

    _currentCameraId = 0;

    _cameraStateStreamController.close();
  }

  Future<void> _disposeCameraController() async {
    await _cameraController?.dispose();
    _cameraController = null;
    _isCameraControllerDisposed = true;
  }

  void _updateCameraState(CameraState state) {
    _cameraState = state;
    _cameraStateStreamController.add(state);
  }

  @override
  Future<void> pauseRecording() async {
    if (_cameraController!.value.isRecordingVideo) {
      try {
        await _cameraController!.pauseVideoRecording();
        _updateCameraState(CameraState.paused);
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
      }
    }
  }

  @override
  Future<void> resumeRecording() async {
    if (cameraState == CameraState.paused) {
      try {
        await _cameraController!.resumeVideoRecording();
        _updateCameraState(CameraState.recording);
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
      }
    }
  }

  @override
  Future<void> startRecording() async {
    if (cameraState == CameraState.ready) {
      try {
        if (cameraState == CameraState.ready) {
          await _cameraController!.startVideoRecording();
          _updateCameraState(CameraState.recording);
        }
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
      }
    }
  }

  @override
  Future<XFile?> stopRecording() async {
    if (cameraState == CameraState.recording) {
      try {
        _updateCameraState(CameraState.recorded);
        videoFile = await _cameraController?.stopVideoRecording();
        return videoFile;
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
        return null;
      }
    } else {
      return null;
    }
  }
}
