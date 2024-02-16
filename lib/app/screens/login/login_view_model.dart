import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';

class LoginViewModel extends BaseChangeNotifier {
  final INavigationUtil _navigationUtil;

  LoginViewModel({required INavigationUtil navigationUtil})
      : _navigationUtil = navigationUtil {}
}
