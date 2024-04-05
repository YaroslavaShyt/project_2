import 'package:camera/camera.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';

class CameraCore implements ICameraCore {
  @override
  late List<CameraDescription> camerasList;

  @override
  Future<void> initialize() async {
    camerasList = await availableCameras();
  }
}
