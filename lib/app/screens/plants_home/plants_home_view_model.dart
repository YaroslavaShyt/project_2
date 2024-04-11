import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/data/user/my_user.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/user/imy_user.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/app/services/notification/notification_service.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';

enum PhotoSourceType { gallery, camera }

enum CameraConfig { cameraTypes, onSuccess, onError }

class PlantsHomeViewModel extends BaseChangeNotifier {
  final IUserService _userService;
  final StorageService _storageService;
  final INavigationUtil _navigationUtil;
  final ILoginRepository _loginRepository;
  final IPlantsRepository _plantsRepository;
  final PermissionHandler _permissionHandler;
  final NotificationService _notificationService;

  PlantsHomeViewModel({
    required IUserService userService,
    required StorageService storageService,
    required INavigationUtil navigationUtil,
    required ILoginRepository loginRepository,
    required IPlantsRepository plantsRepository,
    required PermissionHandler permissionHandler,
    required NotificationService notificationService,
  })  : _userService = userService,
        _navigationUtil = navigationUtil,
        _storageService = storageService,
        _loginRepository = loginRepository,
        _plantsRepository = plantsRepository,
        _permissionHandler = permissionHandler,
        _notificationService = notificationService {
    loadUserData();
  }

  File? _photo;
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

  Future<void> downloadPlants() async {
    await _notificationService.createNewNotification(
        title: "Plants App", body: "", layout: NotificationLayout.ProgressBar);
  }

  void askPermissions() =>
      getItInst.get<PermissionHandler>().askCorePermissions();

  Future<void> addProfilePhotoFromCamera({required Function onError}) async {
    bool isGranted;
    isGranted = await _permissionHandler.isCameraPermissionGranted();
    _navigationUtil.navigateBack();
    if (isGranted) {
      _navigationUtil.navigateTo(routeCamera, data: {
        CameraConfig.cameraTypes: {
          CameraType.photo: true,
          CameraType.video: false
        },
        CameraConfig.onSuccess: {
          CameraType.photo: (XFile image) async {
            await _addDataToStorage(image: image, onError: onError);
          },
          CameraType.video: null
        },
        CameraConfig.onError: {
          CameraType.photo: onError,
          CameraType.video: () {}
        }
      });
    } else {
      onError("Не надано доступу до камери!");
    }
  }

  Future<void> addProfilePhotoFromGalery({required Function onError}) async {
    bool isGranted;
    isGranted = await _permissionHandler.isGalleryPermissionGranted();
    if (isGranted) {
      XFile? image = await _loadImageFromGalery();
      if (image != null) {
        await _addDataToStorage(image: image, onError: onError);
      }
    } else {
      onError("Не надано доступу до галереї!");
    }
  }

  Future<void> _addDataToStorage(
      {required XFile image, required Function onError}) async {
    _photo = File(image.path);
    IBaseResponse response = await _storageService.addFileToStorage(
        file: _photo!, path: "$userProfileImagesPath/${_userService.user!.id}");
    if (response.error != null) {
      onError(response.error);
    } else {
      _userService.updateProfilePhoto(response.data!['URL']);
      notifyListeners();
      _navigationUtil.navigateBack();
      _navigationUtil.navigateBack();
    }
  }

  Future<XFile?> _loadImageFromGalery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
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
