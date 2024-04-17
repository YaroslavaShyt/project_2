import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/domain/user/imy_user.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/app/services/notification/notification_service.dart';

enum PhotoSourceType { gallery, camera }

class PlantsHomeViewModel extends BaseChangeNotifier {
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  final ILoginRepository _loginRepository;
  final IPlantsRepository _plantsRepository;
  final IContentHandler _contentHandler;
  final IRemoteStorageHandler _remoteStorageHandler;

  PlantsHomeViewModel(
      {required IContentHandler contentHandler,
      required IUserService userService,
      required INavigationUtil navigationUtil,
      required ILoginRepository loginRepository,
      required IPlantsRepository plantsRepository,
      required NotificationService notificationService,
      required IRemoteStorageHandler remoteStorageHandler})
      : _contentHandler = contentHandler,
        _userService = userService,
        _navigationUtil = navigationUtil,
        _loginRepository = loginRepository,
        _plantsRepository = plantsRepository,
        _remoteStorageHandler = remoteStorageHandler {
    loadUserData();
  }

  String _newPlantName = '';
  String _newPlantQuantity = '';
  String? _newPlantNameError;
  String? _newPlantQuantityError;

  IMyUser? get user => _userService.user;
  String get newPlantName => _newPlantName;
  String get newPlantQuantity => _newPlantQuantity;
  String? get newPlantNameError => _newPlantNameError;
  String? get newPlantQuantityError => _newPlantQuantityError;
  Stream<PlantsData> get getPlantsStream => _plantsRepository.plantsState();

  void navigateToPlantDetails(String plantId) {
    _navigationUtil.navigateTo(routePlantsDetails, data: plantId);
  }

  void askPermissions() =>
      getItInst.get<PermissionHandler>().askCorePermissions();

  Future<void> addProfilePhotoFromCamera({required Function onError}) async {
    await _contentHandler.addFileFromCamera(
      onSuccess: () => _navigationUtil.navigateTo(
        routeCamera,
        data: {
          CameraConfigKeys.cameraTypes: {
            CameraType.photo: true,
            CameraType.video: false
          },
          CameraConfigKeys.onSuccess: {
            CameraType.photo: (XFile image) async {
              await _remoteStorageHandler.addDataToStorage(
                file: image,
                path: "$userProfileImagesPath/${_userService.user!.id}",
                onError: onError,
                onSuccess: (String url) {
                  _userService.updateProfilePhoto(url);
                  _navigationUtil.navigateBack();
                  _navigationUtil.navigateBack();
                  notifyListeners();
                },
              );
            },
            CameraType.video: null
          },
          CameraConfigKeys.onError: {
            CameraType.photo: onError,
            CameraType.video: () {}
          }
        },
      ),
      onError: onError,
    );
  }

  Future<void> addProfilePhotoFromGalery({required Function onError}) async {
    await _contentHandler.addFileFromGallery(
      onError: onError,
      path: "$userProfileImagesPath/${_userService.user!.id}",
      onSuccess: (String url) {
        _userService.updateProfilePhoto(url);
        _navigationUtil.navigateBack();
        _navigationUtil.navigateBack();
        notifyListeners();
      },
    );
  }

  void loadUserData() async {
    _userService.loadUserData().then((value) {
      if (value != null) {
        _userService.setUser(value);
      }
      notifyListeners();
    });
  }

  void onLogoutButtonPressed() => _loginRepository.logout();

  Future<void> onAddPlantButtonPressed() async {
    final bool isValid = isNewPlantValidated();
    if (isValid) {
      await _plantsRepository.createPlant(
          data: {"name": newPlantName, "quantity": newPlantQuantity});
      newPlantName = '';
      newPlantQuantity = '';
      _navigationUtil.navigateBack();
    }
  }

  bool isNewPlantValidated() {
    if (_newPlantName.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
    } else {
      _newPlantNameError = null;
    }
    if (_newPlantQuantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
    } else {
      _newPlantQuantityError = null;
    }
    notifyListeners();
    return _newPlantNameError == null && _newPlantQuantityError == null;
  }

  void onReadPlantButtonPressed({required String id}) =>
      _plantsRepository.readPlant(id: id);

  void onUpdatePlantButtonPressed({required String id}) {
    final bool isValid = isNewPlantValidated();
    if (isValid) {
      _plantsRepository.updatePlant(
          id: id, data: {"name": newPlantName, "quantity": newPlantQuantity});
      newPlantName = '';
      newPlantQuantity = '';
      _navigationUtil.navigateBack();
    }
  }

  void onDeletePlantButtonPressed({required String id}) =>
      _plantsRepository.deletePlant(id: id);

  set newPlantName(String name) {
    if (name.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
    } else {
      _newPlantName = name;
    }
    notifyListeners();
  }

  set newPlantQuantity(String quantity) {
    if (quantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
    } else {
      _newPlantQuantity = quantity;
    }
    notifyListeners();
  }
}
