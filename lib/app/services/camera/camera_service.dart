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
  final ICameraCore _cameraCore;
  final ICameraConfig _cameraConfig;

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
  StreamController<CameraState> _cameraStateStreamController =
      StreamController();

  @override
  Stream<int> get recordedVideoProgressStream =>
      _recordedVideoProgressStreamController.stream;
  StreamController<int> _recordedVideoProgressStreamController =
      StreamController.broadcast();

  Timer? _timer;
  int? _recordedVideoTimeRemaining;
  @override
  int get recordedVideoTimeRemaining => _recordedVideoTimeRemaining!;

  CameraService(
      {required ICameraCore cameraCore, required ICameraConfig cameraConfig})
      : _cameraConfig = cameraConfig,
        _cameraCore = cameraCore {
    _recordedVideoTimeRemaining = cameraConfig.maxRecordingDurationSeconds;
  }

  @override
  Widget get cameraPreview => _cameraPreview ?? const SizedBox();

  @override
  Size get previewSize =>
      _cameraController?.value.previewSize ?? const Size(0, 0);

  @override
  List<CameraDescription> get camerasList => _cameraCore.camerasList;

  @override
  bool get isVideoCameraSelected => _isVideoCameraSelected;

  @override
  void changeCaptureType() => _isVideoCameraSelected = !_isVideoCameraSelected;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final CameraController? controller = _cameraController;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      await controller.dispose();
    }
  }

  @override
  Future<void> create() async {
    if (!_isObserverAdded) {
      WidgetsBinding.instance.addObserver(this);
      _isObserverAdded = true;
    }

    _cameraStateStreamController = StreamController();
    _recordedVideoProgressStreamController = StreamController.broadcast();

    final CameraController controller = CameraController(
        camerasList[_currentCameraId], _cameraConfig.cameraResolutionPreset,
        imageFormatGroup: ImageFormatGroup.yuv420);
    _cameraController = controller;
    _isCameraControllerDisposed = false;
    try {
      await controller.initialize();

      _cameraPreview = CameraPreview(controller);
      _updateCameraState(CameraState.ready);
    } on CameraException catch (exception) {
      _updateCameraState(CameraState.error);
      debugPrint(exception.toString());
    }
  }

  @override
  void disposeCamera() {
    reset();
    WidgetsBinding.instance.removeObserver(this);
    _isObserverAdded = false;
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

    if (_timer != null) {
      resetTimer();
      stopTimer(_timer!);
      _recordedVideoProgressStreamController.close();
    }

    _cameraPreview = null;
    _currentCameraId = 0;
    _cameraStateStreamController.close();
  }

  Future<void> _disposeCameraController() async {
    if (!_isCameraControllerDisposed) {
      await _cameraController?.dispose();
      _cameraController = null;
      _isCameraControllerDisposed = true;
      _updateCameraState(CameraState.init);
    }
  }

  void _updateCameraState(CameraState state) {
    _cameraState = state;
    _cameraStateStreamController.add(state);
  }

  @override
  Future<void> pauseRecording() async {
    if (cameraState == CameraState.recording) {
      try {
        await _cameraController!.pauseVideoRecording();
        pauseTimer(_timer!);
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
        initTimer();
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
          initTimer();
        }
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
      }
    }
  }

  @override
  Future<XFile?> stopRecording() async {
    if (cameraState == CameraState.recording ||
        cameraState == CameraState.paused) {
      try {
        _updateCameraState(CameraState.recorded);
        stopTimer(_timer!);
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

  @override
  void initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerChanged);
  }

  @override
  void resetTimer() {
    _recordedVideoTimeRemaining = _cameraConfig.maxRecordingDurationSeconds;
  }

  @override
  void stopTimer(Timer timer) {
    timer.cancel();
    resetTimer();
  }

  @override
  void pauseTimer(Timer timer) {
    timer.cancel();
  }

  void _onTimerChanged(Timer timer) {
    if (_recordedVideoTimeRemaining == 0) {
      stopTimer(timer);
      stopRecording();
    } else {
      _recordedVideoTimeRemaining = _recordedVideoTimeRemaining! - 1;
      _recordedVideoProgressStreamController.add(_recordedVideoTimeRemaining!);
    }
  }
}
