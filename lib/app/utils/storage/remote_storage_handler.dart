import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/isolate/isolate_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/domain/services/ibase_response.dart';

enum UploadDataParams { file, path, sendPort }

// Background isolates do not support setMessageHandler().
// Messages from the host platform always go to the root isolate.

class RemoteStorageHandler implements IRemoteStorageHandler {
  final StorageService _storageService;
  final IsolateHandler _isolateHandler;
  late File newFile;
  late String newPath;

  RemoteStorageHandler(
      {required StorageService storageService,
      required IsolateHandler isolateHandler})
      : _storageService = storageService,
        _isolateHandler = isolateHandler;

  @override
  Future<void> addDataToStorage(
      {required XFile file,
      required Function onError,
      required String path,
      required Function onSuccess}) async {
    newFile = File(file.path);
    newPath = path;
    // try {
    //   var response = await _isolateHandler.computeIsolate(addToStorage);
    //   print(response);
    // } catch(err){
    //   debugPrint("Isolate Failed");
    // }

    IBaseResponse response =
        await _storageService.addFileToStorage(file: newFile, path: path);
 
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

  Future<int> addToStorage() async {
    var a = 0;
    for (var i = 0; i < 200000000; i++) {
      a += i;
    }
    //_storageService.addFileToStorage(file: newFile, path: newPath);
    print("ISOLATE WORKED: $a");
    return a;
  }

  @override
  Stream<double> get snapshotProgressStream =>
      _storageService.snapshotProgressStream;
}
