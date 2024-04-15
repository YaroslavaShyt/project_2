import 'package:camera/camera.dart';

abstract interface class IRemoteStorageHandler{
  Future<void> addDataToStorage(
      {required XFile file,
      required Function onError,
      required String path,
      required Function onSuccess});
}