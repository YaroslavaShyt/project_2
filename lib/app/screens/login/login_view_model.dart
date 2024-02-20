import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class LoginViewModel extends BaseChangeNotifier {
  final INavigationUtil _navigationUtil;
  final ILoginRepository _loginRepository;

  String _name = '';
  String _surname = '';
  String _phoneNumber = '';

  String? _nameError;
  String? _surnameError;
  String? _phoneNumberError;

  LoginViewModel(
      {required INavigationUtil navigationUtil,
      required ILoginRepository loginRepository})
      : _navigationUtil = navigationUtil,
        _loginRepository = loginRepository;

  String get name => _name;
  String get surname => _surname;
  String get phoneNumber => _phoneNumber;

  set name(String newName) {
    _name = newName;
    _nameError == null;
  }

  set surname(String newSurname) {
    _surname = newSurname;
    _surnameError == null;
  }

  set phoneNumber(String newPhoneNumber) {
    _phoneNumber = newPhoneNumber;
    _phoneNumberError == null;
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

  void onLoginButtonPressed() {
    //_loginRepository.loginOtp(otp: otp, verifyID: verifyID)
    final bool isValid = isValidated();
    if (isValid) {
      _navigationUtil.navigateTo(routeHome);
    }
  }
}
