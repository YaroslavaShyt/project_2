import 'package:camera/camera.dart';

const cameraResolutionPreset = ResolutionPreset.high;
const maxRecordingDuration = 60*1000;


abstract class ICameraConfig {
  final ResolutionPreset cameraResolutionPreset;
  final int maxRecordingDurationMilliseconds;

  ICameraConfig(
      {required this.cameraResolutionPreset,
      required this.maxRecordingDurationMilliseconds});
}
