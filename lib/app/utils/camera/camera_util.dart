import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/camera/icamera_util.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/domain/services/ibase_response.dart';

enum Camera { cameraTypes, onSuccess, onError }

class CameraUtil implements ICameraUtil {
  final PermissionHandler _permissionHandler;
  final INavigationUtil _navigationUtil;
  final StorageService _storageService;

  File? _photo;

  CameraUtil(
      {required PermissionHandler permissionHandler,
      required StorageService storageService,
      required INavigationUtil navigationUtil})
      : _navigationUtil = navigationUtil,
        _permissionHandler = permissionHandler,
        _storageService = storageService;

  @override
  Future<void> addFileFromCamera(
      {required String route,
      required Function onError,
      required Map<Camera, Map<CameraType, dynamic>> data,
      }) async {
    bool isGranted;
    isGranted = await _permissionHandler.isCameraPermissionGranted();
    _navigationUtil.navigateBack();
    if (isGranted) {
      _navigationUtil.navigateTo(route, data: data);
    } else {
      onError("Не надано доступу до камери!");
    }
  }

  @override
  Future<void> addFileFromGallery(
      {required Function onError,
      required Function onSuccess,
      required String path,
      }) async {
    bool isGranted;
    isGranted = await _permissionHandler.isGalleryPermissionGranted();
    if (isGranted) {
      XFile? image = await loadImageFromGalery();
      if (image != null) {
        await addDataToStorage(
            file: image, onError: onError, onSuccess: onSuccess, path: path);
      }
    } else {
      onError("Не надано доступу до галереї!");
    }
  }

  @override
  Future<void> addDataToStorage(
      {required XFile file,
      required Function onError,
      required String path,
      required Function onSuccess}) async {
    _photo = File(file.path);
    IBaseResponse response = await _storageService.addFileToStorage(
        file: _photo!, path: path);
    if (response.error != null) {
      onError(response.error);
    } else {
      if (response.data != null) {
        if (response.data!["URL"] != null) {
          onSuccess(response.data!['URL']);
          
        } else {
          onError("Трапилась помилка.");
        }
      } else {
        onError("Трапилась помилка.");
      }
    }
  }

  @override
  Future<XFile?> loadImageFromGalery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
