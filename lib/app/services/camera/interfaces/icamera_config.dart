import 'package:camera/camera.dart';

const cameraResolutionPreset = ResolutionPreset.high;
const maxRecordingDuration = 15;


abstract class ICameraConfig {
  final ResolutionPreset cameraResolutionPreset;
  final int maxRecordingDurationSeconds;

  ICameraConfig(
      {required this.cameraResolutionPreset,
      required this.maxRecordingDurationSeconds});
}
