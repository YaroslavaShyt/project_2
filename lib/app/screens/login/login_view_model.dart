import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/encryption/encryption_service.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class LoginViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IUserRepository _userRepository;
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  final EncryptionService _encryptionService;
  bool isFormDataValid = true;

  String _phoneNumber = '';
  String _otp = '';

  String? _phoneNumberError;

  LoginViewModel(
      {required EncryptionService encryptionService,
      required IUserRepository userRepository,
      required ILoginRepository loginRepository,
      required INavigationUtil navigationUtil,
      required IUserService userService})
      : _encryptionService = encryptionService,
        _userRepository = userRepository,
        _loginRepository = loginRepository,
        _navigationUtil = navigationUtil,
        _userService = userService;

  String get phoneNumber => _phoneNumber;

  String? get phoneNumberError => _phoneNumberError;

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    _phoneNumberError = null;
  }

  set otp(String newOtp) {
    _otp = _encryptionService.encryptData(newOtp);
  }

  String get otp => _otp;

  bool isValidatedPhone() {
    if (_phoneNumber.isEmpty) {
      _phoneNumberError = "Provide phone number, please!";
    } else if (_phoneNumber.length < 10) {
      _phoneNumberError = "Not enough numbers!";
    }
    if (_phoneNumberError != null) {
      notifyListeners();
      return false;
    }
    return true;
  }

  void onSendOtpButtonPressed() {
    isFormDataValid = isValidatedPhone();
    if (isFormDataValid) {
      _loginRepository.sendOtp(phoneNumber: phoneNumber);
    }

    _navigationUtil.navigateBack();
  }

  void onLoginGoogleButtonPressed() {
    _loginRepository.loginGoogle().then((value) {
      if (value != null) {
        _userService.user = User(
            name: value.displayName!,
            phoneNumber: value.phoneNumber,
            photo: value.photoURL);
        // _userRepository
        //     .saveUserOnSignIn()
        //     .onError((error, stackTrace) => print(error.toString()));
        // String userID = value.uid;
        // _userRepository.readUser(id: userID).then((value) {
        //   if (value == null) {
        //     _userRepository.createUser(id: userID, data: _userService.userJSON);
        //   }
        // });
      }
    });
  }

  void navigateToSMSLogin() {
    _navigationUtil.navigateTo(routeSMSLogin, data: {"otp": otp});
  }
}
