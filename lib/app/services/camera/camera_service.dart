import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

const _batchSizeInMilliseconds = 16;

class CameraService extends BaseChangeNotifier
    with WidgetsBindingObserver
    implements ICameraService {
  @override
  ICameraCore cameraCore;

  @override
  ICameraConfig cameraConfig;

  CameraPreview? _cameraPreview;
  CameraController? _cameraController;

  bool _isObserverAdded = false;
  bool _isCameraControllerDisposed = false;

  final StreamController<double> _recordedProgressStreamController =
      StreamController();

  final StreamController<CameraState> _cameraStateStreamController =
      StreamController();

  @override
  Stream<CameraState> get cameraStateStream =>
      _cameraStateStreamController.stream;

  XFile? _videoFile;

  Timer? _recordingTimer;

  int _currentCameraId = 0;
  double _recordedProgress = 0.0;
  int _recordedBatchesInMilliSeconds = 0;

  CameraService({required this.cameraCore, required this.cameraConfig});

  @override
  Widget get cameraPreview => _cameraPreview ?? const SizedBox();

  CameraState _cameraState = CameraState.init;
  @override
  CameraState get cameraState => _cameraState;

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
      if (Platform.isIOS) {
        await _cameraController!.prepareForVideoRecording();
      }
      _cameraPreview = CameraPreview(_cameraController!);
      _updateCameraState(CameraState.ready);
    } on CameraException catch (exception) {
      _updateCameraState(CameraState.error);
      debugPrint(exception.toString());
    }
  }

  @override
  void dispose() {
    reset();
    WidgetsBinding.instance.removeObserver(this);
    _isObserverAdded = false;
    super.dispose();
  }

  @override
  Future<void> pauseRecording() async {
    if (_recordedBatchesInMilliSeconds >= 1) {
      if (cameraState == CameraState.recording) {
        try {
          await _cameraController?.pauseVideoRecording();
          _updateCameraState(CameraState.paused);
          _dropRecordingTimer();
        } on CameraException catch (exception) {
          _dropRecordingTimer();
          _updateCameraState(CameraState.error);
          debugPrint(exception.toString());
        }
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 250), () {
        pauseRecording();
      });
    }
  }

  @override
  Size get previewSize =>
      _cameraController?.value.previewSize ?? const Size(0, 0);

  @override
  double get recordedProgress => _recordedProgress;

  @override
  Stream<double> get recordedProgressStream =>
      _recordedProgressStreamController.stream;

  List<CameraDescription> get camerasList => cameraCore.camerasList;

  @override
  Future<void> remove() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    return stopRecording().then((_) async {
      await _disposeCameraController();
      _cameraPreview = null;
      _updateCameraState(CameraState.init);
      _recordedBatchesInMilliSeconds = 0;
      _recordedProgressStreamController.add(0);
      await create();
    });
  }

  @override
  Future<void> reset() async {
    await _disposeCameraController();
    _cameraPreview = null;
    _recordedProgress = 0;
    _currentCameraId = 0;
    _recordedProgressStreamController.close();
    _cameraStateStreamController.close();
    _dropRecordingTimer();
  }

  @override
  Future<void> resumeRecording() async {
    if (cameraState == CameraState.paused) {
      try {
        await _cameraController?.resumeVideoRecording();
        _updateCameraState(CameraState.recording);
        _recordingTimer = Timer.periodic(
            const Duration(milliseconds: _batchSizeInMilliseconds),
            _onRecordTimeChanged);
      } on CameraException catch (exception) {
        _updateCameraState(CameraState.error);
        debugPrint(exception.toString());
      }
    }
  }

  @override
  void setNotifyListener(VoidCallback listener) {}

  @override
  Future<void> startRecording() async {
    deleteVideoFileIfExist();
    try {
      if (cameraState == CameraState.ready) {
        await _cameraController?.startVideoRecording();
        _updateCameraState(CameraState.recording);
        _recordingTimer = Timer.periodic(
            const Duration(milliseconds: _batchSizeInMilliseconds),
            _onRecordTimeChanged);
      }
    } on CameraException catch (exception) {
      _updateCameraState(CameraState.error);
      debugPrint(exception.toString());
    }
  }

  @override
  Future<XFile?> stopRecording() async {
    if (_cameraController!.value.isRecordingVideo) {
      try {
        _updateCameraState(CameraState.recorded);
        _recordingTimer?.cancel();
        _videoFile = await _cameraController?.stopVideoRecording();
        return _videoFile;
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
  Future<String?> takePicture() async {
    try {
      _cameraController!.setFlashMode(FlashMode.off);
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

  void _onRecordTimeChanged(Timer timer) {
    _recordedBatchesInMilliSeconds =
        _recordedBatchesInMilliSeconds + _batchSizeInMilliseconds;
    _recordedProgress = _recordedBatchesInMilliSeconds /
        cameraConfig.maxRecordingDurationMilliseconds;
    _recordedProgressStreamController.add(_recordedProgress);
  }

  void deleteVideoFileIfExist() async {
    if (_videoFile != null) {
      try {
        File original = File(_videoFile!.path);
        original.delete();
      } catch (err) {
        debugPrint(err.toString());
      }
    }
  }

  Future<void> _disposeCameraController() async {
    await _cameraController?.dispose();
    _cameraController = null;
    _isCameraControllerDisposed = true;
  }

  void _dropRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  void _updateCameraState(CameraState state) {
    _cameraState = state;
    _cameraStateStreamController.add(state);
  }
}
