import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';

class HomeViewModel extends BaseChangeNotifier {
  final INavigationUtil _navigationUtil;
  final ILoginRepository _loginRepository;

  HomeViewModel(
      {required INavigationUtil navigationUtil,
      required ILoginRepository loginRepository})
      : _navigationUtil = navigationUtil,
        _loginRepository = loginRepository;

  void onLogoutButtonPressed() {
    _loginRepository.logout();
    _navigationUtil.navigateTo(routeLogin);
  }
}
