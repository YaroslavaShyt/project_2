import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/app/services/encryption/encryption_service.dart';
import 'package:project_2/app/services/networking/firebase_storage/firebase_storage_service.dart';
import 'package:project_2/app/services/networking/firestore/firestore_service.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:project_2/data/plants/plants_repository.dart';
import 'package:project_2/data/user/user_repository.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

final getItInst = GetIt.I;

void initCloudFunctions() {
  getItInst.registerFactory<FirebaseFunctionsService>(
      () => FirebaseFunctionsService());
}

void initNetworkService() {
  getItInst.registerFactory<INetworkService>(
      () => FirestoreService(firestore: FirebaseFirestore.instance));
  getItInst.registerFactory<FirebaseStorageService>(
      () => FirebaseStorageService(firebaseStorage: FirebaseStorage.instance));
}

void initEncodingService(String key) {
  getItInst.registerFactory<EncryptionService>(
      () => EncryptionService(passphrase: key));
}

void initRepos() {
  getItInst.registerFactory<IPlantsRepository>(() => PlantsRepository(
      networkService: getItInst.get<INetworkService>(),
      firebaseFunctionsService: getItInst.get<FirebaseFunctionsService>()));

  getItInst.registerSingleton<ILoginRepository>(
      LoginRepository(firebaseAuth: FirebaseAuth.instance));

  getItInst.registerFactory<IUserRepository>(
      () => UserRepository(networkService: getItInst.get<INetworkService>()));
}
