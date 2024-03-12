import 'package:image_picker/image_picker.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/services/encryption/encryption_service.dart';
import 'package:project_2/app/services/networking/firebase_storage/firebase_storage_service.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class SMSLoginViewModel extends BaseChangeNotifier {
  final EncryptionService _encryptionService;
  final ILoginRepository _loginRepository;
  final IUserRepository _userRepository;
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  final String otp;
  final FirebaseStorageService _firebaseStorageService;

  SMSLoginViewModel(
      {required this.otp,
      required EncryptionService encryptionService,
      required IUserRepository userRepository,
      required ILoginRepository loginRepository,
      required INavigationUtil navigationUtil,
      required FirebaseStorageService firebaseStorageService,
      required IUserService userService})
      : _userRepository = userRepository,
        _encryptionService = encryptionService,
        _firebaseStorageService = firebaseStorageService,
        _loginRepository = loginRepository,
        _navigationUtil = navigationUtil,
        _userService = userService;

  String _name = '';
  String get name => _name;
  String? get nameError => _nameError;
  String? _nameError;
  String? imageUrl;
  XFile? image;

  set name(String newName) {
    _name = newName;
    _nameError = null;
  }

  void onLoginOtpButtonPressed({required Function(String) onError}) async {
    if (image != null) {
      // final IBaseResponse response = await _firebaseStorageService.uploadImage(
      //     filePath: userProfileImagesPath, image: image!);
      // if (response.error != null) {
      //   onError(response.error!);
      // } else if (response.data != null) {
      //   imageUrl = response.data!["imageURL"];

        _userRepository.readUser(id: _loginRepository.verifID).then((value) {
          if (value == null) {
            // if (imageUrl != null && name.isNotEmpty) {
            //   _userService.user = User(name: name, photo: imageUrl);
            //   _userRepository.createUser(
            //       id: _loginRepository.verifID, data: _userService.userJSON);
            // } else {
            //   onError("Заповніть форму!");
            // }
          }
          _loginRepository
              .loginOtp(otp: _encryptionService.decryptData(otp))
              .onError((error, stackTrace) => onError(error.toString()));
          _navigationUtil.navigateBack();
          _navigationUtil.navigateBack();
        });
     // }
    }
  }

  void onAddPhotoButtonPressed({required Function(String) onError}) async {
    image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512);
  }
}
