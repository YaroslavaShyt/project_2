import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_2/app/services/networking/base_response.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class FirebaseStorageRepository {
  final FirebaseStorage _firebaseStorage;

  FirebaseStorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  Future<IBaseResponse> uploadImage(
      {required String filePath, required String imageName, required File image}) async {
    try {
      final ref = _firebaseStorage.ref(filePath).child(imageName);
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      return BaseResponse(data: {"imageURL": url});
    } catch (err) {
      return BaseResponse(error: err.toString());
    }
  }
}
