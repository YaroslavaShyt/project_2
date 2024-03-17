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

  Future<bool> isNotificationPermissionGranted() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
