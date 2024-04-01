import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/data/storage/firebase_storage_repository.dart';
import 'package:project_2/app/services/networking/firestore/firestore_service.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/data/login/login_repository.dart';
import 'package:project_2/data/plants/plants_repository.dart';
import 'package:project_2/data/user/user_repository.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

final getItInst = GetIt.I;

void initGetItFunctions(INavigationUtil util) {
  initCloudFunctions();
  initNetworkService();
  initRepos();
  initStorageService();
  initPermissionHandler();
  initNotificationService();
  initDeepLinking(util);
}

void initCloudFunctions() {
  getItInst.registerFactory<FirebaseFunctionsService>(
      () => FirebaseFunctionsService());
}

void initNetworkService() {
  getItInst.registerFactory<INetworkService>(
      () => FirestoreService(firestore: FirebaseFirestore.instance));
}

void initPermissionHandler() {
  getItInst.registerFactory<PermissionHandler>(() => PermissionHandler());
}

void initRepos() {
  getItInst.registerFactory<IPlantsRepository>(() => PlantsRepository(
      networkService: getItInst.get<INetworkService>(),
      firebaseFunctionsService: getItInst.get<FirebaseFunctionsService>()));

  getItInst.registerFactory<ILoginRepository>(
      () => LoginRepository(firebaseAuth: FirebaseAuth.instance));

  getItInst.registerFactory<IUserRepository>(
      () => UserRepository(networkService: getItInst.get<INetworkService>()));

  getItInst.registerFactory<FirebaseStorageRepository>(() =>
      FirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance));
}

void initStorageService() {
  getItInst.registerFactory<StorageService>(() => StorageService(
      firebaseStorageRepository: getItInst.get<FirebaseStorageRepository>()));
}

void initNotificationService() {
  getItInst.registerSingleton<NotificationService>(NotificationService());
}

void initDeepLinking(INavigationUtil util) {
  getItInst.registerSingleton<DeepLinkHandler>(
      DeepLinkHandler(navigationUtil: util));
}
