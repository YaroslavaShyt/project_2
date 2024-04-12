import 'package:camera/camera.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/utils/camera/camera_util.dart';

abstract interface class ICameraUtil {
  Future<void> addFileFromCamera(
      {required String route,
      required Function onError,
      required Map<Camera, Map<CameraType, dynamic>> data,
      });
  Future<void> addFileFromGallery(
      {required Function onError,
      required String path,
      required Function onSuccess});
  Future<void> addDataToStorage(
      {required XFile file,
      required Function onError,
      required String path,
      required Function onSuccess});
  Future<XFile?> loadImageFromGalery();
}
