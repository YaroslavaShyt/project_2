import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

enum CameraState { init, ready, recording, recorded, paused, dispose, error }

abstract class ICameraService {
  Size get previewSize;
  Widget get cameraPreview;
  CameraState get cameraState;
  bool get isVideoCameraSelected;
  int get recordedVideoTimeRemaining;
  List<CameraDescription> get camerasList;
  Stream<CameraState> get cameraStateStream;
  Stream<int> get recordedVideoProgressStream;

  Future<void> reset();
  Future<void> create();
  Future<void> toggleCamera();
  void changeCaptureType();
  Future<String?> takePhoto();

  Future<void> startRecording();
  Future<XFile?> stopRecording();
  Future<void> pauseRecording();
  Future<void> resumeRecording();

  void initTimer();
  void stopTimer(Timer timer);
  void pauseTimer(Timer timer);
  void resetTimer();

  void disposeCamera();
}
