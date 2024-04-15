import 'dart:io';
import 'package:camera/camera.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class RemoteStorageHandler implements IRemoteStorageHandler {
  final StorageService _storageService;

  RemoteStorageHandler({required StorageService storageService})
      : _storageService = storageService;

  @override
  Future<void> addDataToStorage(
      {required XFile file,
      required Function onError,
      required String path,
      required Function onSuccess}) async {
    File photo = File(file.path);
    IBaseResponse response =
        await _storageService.addFileToStorage(file: photo, path: path);
    if (response.error != null) {
      onError(response.error);
    } else {
      if (response.data != null) {
        if (response.data!["URL"] != null) {
          onSuccess(response.data!['URL']);
        } else {
          onError("Трапилась помилка.");
        }
      } else {
        onError("Трапилась помилка.");
      }
    }
  }
}
