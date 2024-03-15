import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/services/networking/firebase_storage/firebase_storage_service.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/imy_user.dart';

class PlantsHomeViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IPlantsRepository _plantsRepository;
  final INavigationUtil _navigationUtil;
  final IUserService _userService;
  final FirebaseStorageService _firebaseStorageService;
  final PermissionHandler _permissionHandler;

  PlantsHomeViewModel(
      {required INavigationUtil navigationUtil,
      required FirebaseStorageService firebaseStorageService,
      required IUserService userService,
      required IPlantsRepository plantsRepository,
      required PermissionHandler permissionHandler,
      required ILoginRepository loginRepository})
      : _navigationUtil = navigationUtil,
        _userService = userService,
        _permissionHandler = permissionHandler,
        _plantsRepository = plantsRepository,
        _firebaseStorageService = firebaseStorageService,
        _loginRepository = loginRepository {
    loadUserData();
  }

  String _newPlantName = '';
  String _newPlantQuantity = '';
  String? _newPlantNameError;
  String? _newPlantQuantityError;
  File? _photo;

  String get newPlantName => _newPlantName;
  String get newPlantQuantity => _newPlantQuantity;

  String? get newPlantNameError => _newPlantNameError;
  String? get newPlantQuantityError => _newPlantQuantityError;

  IMyUser? get user => _userService.user;

  set newPlantName(String name) {
    if (name.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
      notifyListeners();
    } else {
      _newPlantName = name;
    }
  }

  set newPlantQuantity(String quantity) {
    if (quantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
      notifyListeners();
    } else {
      _newPlantQuantity = quantity;
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

  Stream<PlantsData> get getPlantsStream => _plantsRepository.plantsState();

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

  Future<void> onAddProfileImage(
      {required Function onError, String type = 'Galery'}) async {
    bool isGranted;
    if (type == 'Galery') {
      isGranted = await _permissionHandler.isGalleryPermissionGranted();
    } else {
      isGranted = await _permissionHandler.isCameraPermissionGranted();
    }
    if (isGranted) {
      loadImage(type: type).then((value) {
        if (value != null) {
          _photo = File(value.path);
          addImageToStorage().then((response) {
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

  Future<XFile?> loadImage({String type = 'Galery'}) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: type == 'Galery' ? ImageSource.gallery : ImageSource.camera);
    return pickedFile;
  }

  Future<IBaseResponse> addImageToStorage() async {
    final fileName = basename(_photo!.path);
    IBaseResponse response = await _firebaseStorageService.uploadImage(
        filePath: "$userProfileImagesPath/${_userService.user!.id}",
        imageName: fileName,
        image: _photo!);
    return response;
  }
}
