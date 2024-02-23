import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/services/iuser_service.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IUserService _userService;
  final INavigationUtil _navigationUtil;
  bool isFormDataValid = true;

  String _name = '';
  String _surname = '';
  String _phoneNumber = '';

  String? _nameError;
  String? _surnameError;
  String? _phoneNumberError;

  LoginViewModel(
      {required ILoginRepository loginRepository,
      required INavigationUtil navigationUtil,
      required IUserService userService})
      : _loginRepository = loginRepository,
        _navigationUtil = navigationUtil,
        _userService = userService;

  String get name => _name;
  String get surname => _surname;
  String get phoneNumber => _phoneNumber;
  String? get nameError => _nameError;
  String? get surnameError => _surnameError;
  String? get phoneNumberError => _phoneNumberError;

  set name(String newName) {
    _name = newName;
    _nameError = null;
  }

  set surname(String newSurname) {
    _surname = newSurname;
    _surnameError = null;
  }

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    _phoneNumberError = null;
  }

  bool isValidated() {
    if (_name.isEmpty) {
      _nameError = "Provide name, please!";
    }

    if (_surname.isEmpty) {
      _surnameError = "Provide surname, please!";
    }

    if (_phoneNumber.isEmpty) {
      _phoneNumberError = "Provide phone number, please!";
    } else if (_phoneNumber.length < 10) {
      _phoneNumberError = "Not enough numbers!";
    }

    if (_nameError != null ||
        _surnameError != null ||
        _phoneNumberError != null) {
      notifyListeners();
      return false;
    }
    return true;
  }

  void onLoginButtonPressed(String otp) {
    _loginRepository.loginOtp(otp: otp);
    _userService
        .setUser(User(name: name, surname: surname, phoneNumber: phoneNumber));
    _navigationUtil.navigateBack();
  }

  void onSendOtpButtonPressed() {
    isFormDataValid = isValidated();
    notifyListeners();
    if (isFormDataValid) {
      _loginRepository.sendOtp(phoneNumber: phoneNumber);
    }
  }
}
