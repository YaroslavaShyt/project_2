import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:project_2/app/routing/navigation_util.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:project_2/app/utils/isolate/isolate_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/data/storage/firebase_storage_repository.dart';

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
    debugPrint("UPLOADING FUNCTION STARTED");
    Map<String, dynamic> payload = {
      'path': path,
      'filePath': file.path,
    };
    try {
      _isolateHandler.computeIsolate(
          payload: payload, performAction: uploadToStorage);
      onSuccess("");
    } catch (err) {
      onError(err.toString());
      debugPrint("Error: ${err.toString()}");
    }
  }

  @override
  Stream<double> get snapshotProgressStream =>
      _storageService.snapshotProgressStream;
}

void uploadToStorage(SendPort mainIsolatePort) async {
  final uploadIsolatePort = ReceivePort();
  try {
    mainIsolatePort.send(uploadIsolatePort.sendPort);
    uploadIsolatePort.listen((message) async {
      if (message is Map) {
        await Firebase.initializeApp();

        String path = message["path"];
        String filePath = message["filePath"];

        NotificationService notificationService = NotificationService(
            deepLinkHandler: DeepLinkHandler(navigationUtil: NavigationUtil()));
        await NotificationService.initializeLocalNotifications(debug: true);

        StorageService storageService = StorageService(
            firebaseStorageRepository: FirebaseStorageRepository(
                firebaseStorage: FirebaseStorage.instance));

        final future =
            storageService.addFileToStorage(file: File(filePath), path: path);

        storageService.snapshotProgressStream.listen((newValue) async {
          debugPrint("PROGRESS IN LISTENER: $newValue");
          await notificationService.showProgressNotification(
              id: 1, currentStep: newValue * 100, maxStep: 1);
          if (newValue == 1.0) {
            Future.delayed(const Duration(seconds: 2)).then((value) async {
              await notificationService.deleteNotification(id: 1);
            });
          }
          await future.then((value) {
            uploadIsolatePort.close();
            mainIsolatePort.send("SUCCESS");
          });
        });
      }
    });
  } catch (err) {
    debugPrint("ERROR !: ${e.toString()}");
    mainIsolatePort.send(err.toString());
  }
}
