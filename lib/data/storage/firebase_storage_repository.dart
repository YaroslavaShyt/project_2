import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_2/app/routing/navigation_util.dart';
import 'package:project_2/app/services/networking/base_response.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  UploadTask? task;
  StreamController<double> streamController = StreamController();
  NotificationService notificationService = NotificationService(
      deepLinkHandler: DeepLinkHandler(navigationUtil: NavigationUtil()));
  FirebaseStorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  Stream<double> get snapshotProgressStream => streamController.stream;

  Future<IBaseResponse> upload(
      {required String filePath,
      required String name,
      required File file}) async {
    try {
      final ref = _firebaseStorage.ref(filePath).child(name);
      task = ref.putFile(file);
      task?.snapshotEvents.listen((TaskSnapshot snapshot) async {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print("PROGRESS: $progress");
        // await notificationService.createNewNotification(
        //     title: "notif", body: progress.toString());
        // showProgressNotification(
        //     id: Random().nextInt(100), currentStep: progress, maxStep: 1);
        print("adding progress...");
        streamController.add(progress);
        print("added progress");
      }, onError: (err) {
        print("ERROR: ${err.toString()}");
      });
      await task;
      final url = await ref.getDownloadURL();
      return BaseResponse(data: {"URL": url});
    } catch (err) {
      print(err.toString());
      return BaseResponse(error: err.toString());
    }
  }
}
