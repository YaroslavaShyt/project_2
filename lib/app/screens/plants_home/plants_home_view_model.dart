import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/routing/routes.dart';
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

  Future<void> onAddProfileImage(
      {required Function onError,
      PhotoSourceType type = PhotoSourceType.gallery}) async {
    bool isGranted;
    if (type == PhotoSourceType.gallery) {
      isGranted = await _permissionHandler.isGalleryPermissionGranted();
    } else {
      isGranted = await _permissionHandler.isCameraPermissionGranted();
    }
    if (isGranted) {
      loadImage(type: PhotoSourceType.gallery).then((value) {
        if (value != null) {
          _photo = File(value.path);
          _storageService
              .addImageToStorage(photo: _photo!, uid: _userService.user!.id)
              .then((response) {
            if (response.error != null) {
              onError(response.error!);
            } else {
              _userService.user!.profilePhoto = response.data!['imageURL'];
              notifyListeners();
              _navigationUtil.navigateBack();
            }
          }).onError((error, stackTrace) => onError(error.toString()));
        }
      }).onError((error, stackTrace) => onError(error.toString()));
    } else {
      onError("Не надано доступу!");
    }
  }

  Future<XFile?> loadImage(
      {PhotoSourceType type = PhotoSourceType.gallery}) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: type == PhotoSourceType.gallery
            ? ImageSource.gallery
            : ImageSource.camera);
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
