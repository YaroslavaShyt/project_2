import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';

enum CameraState { init, ready, recording, recorded, paused, dispose, error }

abstract class ICameraService {
  final ICameraCore cameraCore;
  final ICameraConfig cameraConfig;

  ICameraService({required this.cameraCore, required this.cameraConfig});

  
  
}
