import 'dart:io';
import 'package:path/path.dart';
import 'package:project_2/data/storage/firebase_storage_repository.dart';
import 'package:project_2/domain/services/ibase_response.dart';

class StorageService {
  final FirebaseStorageRepository _firebaseStorageRepository;

  StorageService({required FirebaseStorageRepository firebaseStorageRepository})
      : _firebaseStorageRepository = firebaseStorageRepository;

  Future<IBaseResponse> addFileToStorage(
      {required File file, required String path}) async {
    final fileName = basename(file.path);
    IBaseResponse response = await _firebaseStorageRepository.upload(
        filePath: path, name: fileName, file: file);
    return response;
  }

  Stream<double> get snapshotProgressStream => _firebaseStorageRepository.snapshotProgressStream;
}
