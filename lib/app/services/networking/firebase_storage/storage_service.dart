import 'dart:io';
import 'package:path/path.dart';
import 'package:project_2/data/storage/firebase_storage_repository.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class StorageService {
  final FirebaseStorageRepository _firebaseStorageRepository;

  StorageService({required FirebaseStorageRepository firebaseStorageRepository})
      : _firebaseStorageRepository = firebaseStorageRepository;

  Future<IBaseResponse> addImageToStorage(
      {required File photo, required String uid}) async {
    final fileName = basename(photo.path);
    IBaseResponse response = await _firebaseStorageRepository.uploadImage(
        filePath: "$userProfileImagesPath/$uid",
        imageName: fileName,
        image: photo);
    return response;
  }
}
