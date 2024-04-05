import 'package:camera/camera.dart';

abstract class ICameraCore{
  late List<CameraDescription> camerasList;

  Future<void> initialize();
}