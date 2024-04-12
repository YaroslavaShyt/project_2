import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/utils/camera/camera_util.dart';
import 'package:project_2/app/utils/camera/icamera_util.dart';
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
  final ICameraUtil _cameraUtil;
  List<VideoPlayerController>? controllers;

  PlantsDetailsViewModel(
      {required this.plantId,
      required INavigationUtil navigationUtil,
      required ICameraUtil cameraUtil,
      required IUserService userService,
      required IPlantsRepository plantsRepository})
      : _navigationUtil = navigationUtil,
        _cameraUtil = cameraUtil,
        _plantsRepository = plantsRepository;

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
    await _cameraUtil.addFileFromCamera(
      route: routeCamera,
      onError: onError,
      data: {
        Camera.cameraTypes: {
          CameraType.photo: !isVideo,
          CameraType.video: isVideo
        },
        Camera.onSuccess: {
          CameraType.photo: !isVideo
              ? (XFile image) async {
                  await _cameraUtil.addDataToStorage(
                    path: "$userFilesPath/ph/${plant!.id}",
                    file: image,
                    onError: onError,
                    onSuccess: (String url) {
                      _navigationUtil.navigateBack();
                      _navigationUtil.navigateBack();
                      loadPlantData();
                    },
                  );
                }
              : null,
          CameraType.video: isVideo
              ? (XFile video) async {
                  await _cameraUtil.addDataToStorage(
                    path: "$userFilesPath/vd/${plant!.id}",
                    file: video,
                    onError: onError,
                    onSuccess: (String url) {
                      notifyListeners();
                      _navigationUtil.navigateBack();
                      loadPlantData();
                    },
                  );
                }
              : null,
        },
        Camera.onError: {
          CameraType.photo: !isVideo ? onError : null,
          CameraType.video: isVideo ? onError : null
        }
      },
    );
  }

  Future<void> addPlantFileFromGallery(
      {required Function onError, required bool isVideo}) async {
    _navigationUtil.navigateBack();
    await _cameraUtil.addFileFromGallery(
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

  void navigateToCameraScreen() {
    _navigationUtil.navigateTo(routeCamera);
  }
}
