import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/services/camera_service/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera_service/interfaces/icamera_core.dart';

enum CameraState { init, ready, recording, recorded, paused, dispose, error }

abstract class ICameraService {
  final ICameraCore cameraCore;
  final ICameraConfig cameraConfig;

  ICameraService({required this.cameraCore, required this.cameraConfig});

  Size get previewSize;
  Widget get cameraPreview;
  CameraState get cameraState;
  double get recordedProgress;
  Stream<double> get recordedProgressStream;

  Future<void> reset();
  Future<void> create();
  
  Future<void> toggleCamera();

  Future<String?> takePicture();
  
  Future<void> startRecording();
  Future<void> pauseRecording();
  Future<void> resumeRecording();
  Future<XFile?> stopRecording();

  Future<void> remove();

  void setNotifyListener(VoidCallback listener);

  void dispose();
}
