import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/services/camera/camera_config.dart';
import 'package:project_2/app/services/camera/camera_core.dart';
import 'package:project_2/app/services/camera/camera_service.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_config.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_core.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/utils/content/content_handler.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/utils/isolate/isolate_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/app/utils/storage/remote_storage_handler.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:project_2/app/utils/video_player/video_player_handler.dart';
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
  initIsolateHandler();
  initStorageService();
  initPermissionHandler();
  initDeepLinking(util);
  initNotificationService(util);
  initCamera(util);
  initVideoPlayer();
  initContentHandler();
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
  getItInst.registerFactory<IRemoteStorageHandler>(
    () => RemoteStorageHandler(
        storageService: getItInst.get<StorageService>(),
        isolateHandler: getItInst.get<IsolateHandler>()),
  );
}

void initNotificationService(INavigationUtil navigationUtil) {
  getItInst.registerSingleton<NotificationService>(NotificationService(
     // navigationUtil: navigationUtil,
      deepLinkHandler: getItInst.get<DeepLinkHandler>()));
}

void initDeepLinking(INavigationUtil util) {
  getItInst.registerSingleton<DeepLinkHandler>(
      DeepLinkHandler(navigationUtil: util));
}

void initCamera(INavigationUtil util) {
  getItInst.registerSingleton<ICameraCore>(CameraCore());
  getItInst.registerFactory<ICameraConfig>(() => CameraConfig(
      cameraResolutionPreset: cameraResolutionPreset,
      maxRecordingDurationSeconds: maxRecordingDuration));
  getItInst.registerSingleton<ICameraService>(CameraService(
      cameraCore: getItInst.get<ICameraCore>(),
      cameraConfig: getItInst.get<ICameraConfig>()));
}

void initVideoPlayer() {
  getItInst.registerFactory<IVideoPlayer>(() => VideoPlayerHandler());
}

void initContentHandler() {
  getItInst.registerFactory<IContentHandler>(
    () => ContentHandler(
        remoteStorageHandler: getItInst.get<IRemoteStorageHandler>(),
        permissionHandler: getItInst.get<PermissionHandler>()),
  );
}

void initIsolateHandler() {
  getItInst.registerFactory<IsolateHandler>(() => IsolateHandler());
}


