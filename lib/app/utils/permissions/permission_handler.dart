import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> isGalleryPermissionGranted() async {
    PermissionStatus status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<bool> isCameraPermissionGranted() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Future<void> askCorePermissions() async {
    await isCameraPermissionGranted();
    await isGalleryPermissionGranted();
  }
}
