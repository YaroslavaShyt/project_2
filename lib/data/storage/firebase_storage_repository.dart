import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_2/app/services/networking/base_response.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _firebaseStorage;
  late Stream<TaskSnapshot> _taskSnapshotStream;

  FirebaseStorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  Stream<TaskSnapshot> get taskSnapshotStream => _taskSnapshotStream;

  Future<IBaseResponse> upload(
      {required String filePath,
      required String name,
      required File file}) async {
    try {
      final ref = _firebaseStorage.ref(filePath).child(name);
      UploadTask task = ref.putFile(file);
      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        int percentage = (progress * 100).round();
        print(percentage);
      });
      await task;
      final url = await ref.getDownloadURL();
      return BaseResponse(data: {"URL": url});
    } catch (err) {
      return BaseResponse(error: err.toString());
    }
  }
}
