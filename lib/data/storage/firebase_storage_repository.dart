import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_2/app/services/networking/base_response.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  UploadTask? task;
  StreamController<double> streamController = StreamController();
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
      task?.snapshotEvents.asBroadcastStream().listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print("PROGRESS: $progress");
        streamController.add(progress);
      });
      await task;
      final url = await ref.getDownloadURL();
      return BaseResponse(data: {"URL": url});
    } catch (err) {
      return BaseResponse(error: err.toString());
    }
  }
}
