import 'package:camera/camera.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';

class CameraConfig implements ICameraConfig {
  @override
  final ResolutionPreset cameraResolutionPreset;

  @override
  final int maxRecordingDurationMilliseconds;

  CameraConfig(
      {required this.cameraResolutionPreset,
      required this.maxRecordingDurationMilliseconds});
}
