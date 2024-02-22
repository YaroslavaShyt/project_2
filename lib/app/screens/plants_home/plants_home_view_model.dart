import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class PlantsHomeViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IUserService _userService;

  PlantsHomeViewModel(
      {required IUserService userService,
      required ILoginRepository loginRepository})
      : _userService = userService,
        _loginRepository = loginRepository;

  void onLogoutButtonPressed() {
    _loginRepository.logout();
  }

  String get userName => _userService.user?.name ?? '';
  String get userSurname => _userService.user?.surname ?? '';
  String get userPhoneNumber => _userService.user?.phoneNumber ?? '';
}
