import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:project_2/app/routing/navigation_util.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:project_2/app/utils/isolate/isolate_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/data/storage/firebase_storage_repository.dart';
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
    debugPrint("UPLOADING FUNCTION STARTED");
    final ReceivePort mainIsolatePort = ReceivePort();
    try {
      Map payload = {'path': path, 'filePath': file.path};
      final FlutterIsolate uploadIsolate = await FlutterIsolate.spawn(
          _uploadToStorage, mainIsolatePort.sendPort);
      mainIsolatePort.listen((message) {
        if (message is SendPort) {
          debugPrint("COMMUNICATION SETUP SUCCESS");
          message.send(payload);
          debugPrint("SENT INPUT PAYLOAD TO UPLOAD ISOLATE");
        }
        if (message is String) {
          debugPrint("GOT THE PAYLOAD FROM UPLOAD ISOLATE: $message");
          uploadIsolate.kill();
          mainIsolatePort.close();
        }
      });
    } catch (err) {
      mainIsolatePort.close();
    } finally {
      debugPrint("WE ARE HERE");
    }

    // try {
    //  // await computeIsolate(performedAction: addToStorage);
    //   //print(response);
    // } catch (err) {
    //   debugPrint("Isolate Failed");
    // }

    // IBaseResponse response =
    //     await _storageService.addFileToStorage(file: newFile, path: path);

    // if (response.error != null) {
    //   onError(response.error);
    // } else {
    //   if (response.data != null) {
    //     if (response.data!["URL"] != null) {
    //       onSuccess(response.data!['URL']);
    //     } else {
    //       onError("Трапилась помилка.");
    //     }
    //   } else {
    //     onError("Трапилась помилка.");
    //   }
  }

  @override
  Stream<double> get snapshotProgressStream =>
      _storageService.snapshotProgressStream;
}

_uploadToStorage(SendPort mainIsolatePort) {
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
        //.then((value) async {
        storageService.snapshotProgressStream.listen((newValue) async {
          debugPrint("PROGRESS IN LISTENER: $newValue");
          if (newValue == 1.0) {
            await notificationService.deleteNotification(id: 1);
          } else {
            await notificationService.showProgressNotification(
                id: 1, currentStep: newValue * 100, maxStep: 1);
          }

          // });

          await future;
          uploadIsolatePort.close();
          mainIsolatePort.send("SUCCESS");
        });
      }
    });
  } catch (err) {
    debugPrint("ERROR !: ${e.toString()}");
    mainIsolatePort.send(err.toString());
  }
}

Future<int> addToStorage(File newFile, String newPath) async {
  var response = 0;
  for (var i = 0; i < 300000000; i++) {
    response += i;
  }
  // StorageService storageService = StorageService(
  //   firebaseStorageRepository:
  //       FirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance),
  // );
  // RemoteStorageHandler remoteStorageHandler = RemoteStorageHandler(
  //     storageService: storageService, isolateHandler: IsolateHandler());
  // await Firebase.initializeApp();

  // NotificationService notificationService = NotificationService(
  //     deepLinkHandler: DeepLinkHandler(navigationUtil: NavigationUtil()));
  // Future<IBaseResponse> response =
  //     storageService.addFileToStorage(file: newFile, path: newPath);

  // remoteStorageHandler.snapshotProgressStream
  //     .asBroadcastStream()
  //     .listen((event) async {
  //   await notificationService.showProgressNotification(
  //     // id:
  //     Random().nextInt(100),
  //     // currentStep: currentStep,
  //     // maxStep: 1,
  //     // fragmentation: 4
  //   );
  // });
  // await response;
  print("ISOLATE WORKED: ");
  return response;
}
