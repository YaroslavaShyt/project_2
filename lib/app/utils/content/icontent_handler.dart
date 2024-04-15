import 'package:camera/camera.dart';
enum CameraConfigKeys { cameraTypes, onSuccess, onError }


abstract interface class IContentHandler {
  Future<void> addFileFromCamera({
    required Function onError,
    required Function onSuccess,
  });
  Future<void> addFileFromGallery({
    required Function onError,
    required Function onSuccess,
    required String path,
  });
  Future<XFile?> loadImageFromGalery();
}
