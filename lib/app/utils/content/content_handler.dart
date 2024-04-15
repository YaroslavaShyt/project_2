import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/permissions/permission_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';

class ContentHandler implements IContentHandler {
  final PermissionHandler _permissionHandler;
  final IRemoteStorageHandler _remoteStorageHandler;

  ContentHandler(
      {required PermissionHandler permissionHandler,
      required IRemoteStorageHandler remoteStorageHandler})
      : _permissionHandler = permissionHandler,
        _remoteStorageHandler = remoteStorageHandler;

  @override
  Future<void> addFileFromCamera({
    required Function onError,
    required Function onSuccess,
  }) async {
    bool isGranted = await _permissionHandler.isCameraPermissionGranted();
    if (isGranted) {
      onSuccess();
    } else {
      onError("Не надано доступу до камери!");
    }
  }

  @override
  Future<void> addFileFromGallery({
    required Function onError,
    required Function onSuccess,
    required String path,
  }) async {
    bool isGranted = await _permissionHandler.isGalleryPermissionGranted();
    if (isGranted) {
      XFile? image = await loadImageFromGalery();
      if (image != null) {
        await _remoteStorageHandler.addDataToStorage(
            file: image, onError: onError, onSuccess: onSuccess, path: path);
      }
    } else {
      onError("Не надано доступу до галереї!");
    }
  }

  @override
  Future<XFile?> loadImageFromGalery() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }
}
