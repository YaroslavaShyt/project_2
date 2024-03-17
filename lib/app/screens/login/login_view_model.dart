import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/data/user/my_user.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  bool isFormDataValid = true;

  String _phoneNumber = '';
  String _otp = '';
  String? _phoneNumberError;

  LoginViewModel(
      {required ILoginRepository loginRepository,
      required INavigationUtil navigationUtil,
      required IUserService userService})
      : _loginRepository = loginRepository,
        _navigationUtil = navigationUtil,
        _userService = userService;

  String get phoneNumber => _phoneNumber;

  String? get phoneNumberError => _phoneNumberError;

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    _phoneNumberError = null;
  }

  set otp(String newOtp) {
    _otp = newOtp;
  }

  bool isValidated() {
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

  void onLoginOtpButtonPressed({required Function onError}) async {
    _loginRepository.loginOtp(otp: _otp).then((value) {
      if (value != null) {
        _userService.setUser(MyUser(id: value));
      }
    }).onError((error, stackTrace) => onError(error.toString()));
    _navigationUtil.navigateBack();
  }

  void onSendOtpButtonPressed() {
    isFormDataValid = isValidated();
    notifyListeners();
    if (isFormDataValid) {
      _loginRepository.sendOtp(phoneNumber: phoneNumber);
    }
    _navigationUtil.navigateBack();
  }

  void onLoginGoogleButtonPressed({required Function(String) onError}) async {
    _loginRepository.loginGoogle().then((value) {
      _userService.setUser(value);
    }).onError((error, stackTrace) => onError(error.toString()));
  }
}
