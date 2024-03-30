import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/data/user/my_user.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginViewModel extends BaseChangeNotifier {
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  final ILoginRepository _loginRepository;

  String _otp = '';
  String _phoneNumber = '';
  String? _phoneNumberError;
  bool isFormDataValid = true;

  String get phoneNumber => _phoneNumber;
  String? get phoneNumberError => _phoneNumberError;

  LoginViewModel({
    required IUserService userService,
    required INavigationUtil navigationUtil,
    required ILoginRepository loginRepository,
  })  : _userService = userService,
        _navigationUtil = navigationUtil,
        _loginRepository = loginRepository;

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

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    _phoneNumberError = null;
  }

  set otp(String newOtp) {
    _otp = newOtp;
  }
}
