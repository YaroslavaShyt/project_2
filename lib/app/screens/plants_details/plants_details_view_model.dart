import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class PlantsDetailsViewModel extends BaseChangeNotifier {
  IPlant? plant;
  final String plantId;
  final IPlantsRepository _plantsRepository;
  final INavigationUtil _navigationUtil;
  final IContentHandler _contentHandler;
  final IRemoteStorageHandler _remoteStorageHandler;
  List<VideoPlayerController>? controllers;
  double currentStep = 0.0;

  PlantsDetailsViewModel(
      {required this.plantId,
      required INavigationUtil navigationUtil,
      required IContentHandler contentHandler,
      required IUserService userService,
      required IPlantsRepository plantsRepository,
      required IRemoteStorageHandler remoteStorageHandler})
      : _navigationUtil = navigationUtil,
        _contentHandler = contentHandler,
        _plantsRepository = plantsRepository,
        _remoteStorageHandler = remoteStorageHandler;

  Future<void> initControllers() async {
    controllers = plant?.videos
        .map((url) => VideoPlayerController.networkUrl(Uri.parse(url)))
        .toList();
    if (controllers != null) {
      for (var controller in controllers!) {
        await controller.initialize();
      }
      notifyListeners();
    }
  }

  void disposeControllers() {
    if (controllers != null) {
      for (var controller in controllers!) {
        controller.dispose();
      }
    }
  }

  Future<void> loadPlantData() async {
    disposeControllers();
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      await _plantsRepository.readPlant(id: plantId).then((data) async {
        if (data is IPlant) {
          plant = data;
          await initControllers();
          notifyListeners();
        }
      });
    });
  }

  Future<void> addPlantFileFromCamera(
      {required Function onError, required bool isVideo}) async {
    await _contentHandler.addFileFromCamera(
      onSuccess: () => _navigationUtil.navigateTo(
        routeCamera,
        data: {
          CameraConfigKeys.cameraTypes: {
            CameraType.photo: !isVideo,
            CameraType.video: isVideo
          },
          CameraConfigKeys.onSuccess: {
            CameraType.photo: !isVideo
                ? (XFile image) async {
                    await _remoteStorageHandler.addDataToStorage(
                      path: "$userFilesPath/ph/${plant!.id}",
                      file: image,
                      onError: onError,
                      onSuccess: (String url) {
                        _navigationUtil.navigateBack();
                        _navigationUtil.navigateBack();
                        _navigationUtil.navigateBack();
                        loadPlantData();
                      },
                    );
                  }
                : null,
            CameraType.video: isVideo
                ? (XFile video) async {
                    await _remoteStorageHandler.addDataToStorage(
                      path: "$userFilesPath/vd/${plant!.id}",
                      file: video,
                      onError: onError,
                      onSuccess: (String url) {
                        notifyListeners();
                        _navigationUtil.navigateBack();
                        _navigationUtil.navigateBack();
                        loadPlantData();
                      },
                    );
                  }
                : null,
          },
          CameraConfigKeys.onError: {
            CameraType.photo: !isVideo ? onError : null,
            CameraType.video: isVideo ? onError : null
          }
        },
      ),
      onError: onError,
    );
  }

  Future<void> addPlantFileFromGallery(
      {required Function onError, required bool isVideo}) async {
    _navigationUtil.navigateBack();
    await _contentHandler.addFileFromGallery(
        path: isVideo
            ? "$userFilesPath/vd/${plant!.id}"
            : "$userFilesPath/ph/${plant!.id}",
        onError: onError,
        onSuccess: (String url) {
          loadPlantData();
        });
  }

  void sharePlant() {
    Share.share('Подивись на цю рослину:\n'
        '$uriPlantsDetails${plant!.id}');
  }
}
