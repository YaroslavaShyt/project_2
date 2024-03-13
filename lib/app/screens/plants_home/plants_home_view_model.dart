import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:project_2/domain/user/iuser.dart';

class PlantsHomeViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IPlantsRepository _plantsRepository;
  final INavigationUtil _navigationUtil;
  final IUserService _userService;

  PlantsHomeViewModel(
      {required INavigationUtil navigationUtil,
      required IUserService userService,
      required IPlantsRepository plantsRepository,
      required ILoginRepository loginRepository})
      : _navigationUtil = navigationUtil,
        _userService = userService,
        _plantsRepository = plantsRepository,
        _loginRepository = loginRepository;

  String _newPlantName = '';
  String _newPlantQuantity = '';
  String? _newPlantNameError;
  String? _newPlantQuantityError;

  String get newPlantName => _newPlantName;
  String get newPlantQuantity => _newPlantQuantity;

  String? get newPlantNameError => _newPlantNameError;
  String? get newPlantQuantityError => _newPlantQuantityError;

  IMyUser? get user => _userService.user;

  // Future<void> changeCaseTitles(
  //     {required bool isNeedToUpperCase,
  //     required Function(String) showAlertDialog}) async {
  //   try {
  //     IBaseResponse data = isNeedToUpperCase
  //         ? await _plantsRepository.toUpperCaseData()
  //         : await _plantsRepository.toLowerCaseData();
  //     if (!data.success!) {
  //       showAlertDialog(data.error ?? 'Виникла помилка');
  //     }
  //   } catch (e) {
  //     showAlertDialog(e.toString());
  //   }
  // }

  set newPlantName(String name) {
    if (name.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
      notifyListeners();
    } else {
      _newPlantName = name;
    }
  }

  set newPlantQuantity(String quantity) {
    if (quantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
      notifyListeners();
    } else {
      _newPlantQuantity = quantity;
    }
  }

  bool isNewPlantValidated() {
    if (_newPlantName.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
    } else {
      _newPlantNameError = null;
    }
    if (_newPlantQuantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
    } else {
      _newPlantQuantityError = null;
    }
    notifyListeners();
    return _newPlantNameError == null && _newPlantQuantityError == null;
  }

  Stream<PlantsData> get getPlantsStream => _plantsRepository.plantsState();

  void onLogoutButtonPressed() => _loginRepository.logout();

  Future<void> onAddPlantButtonPressed() async {
    final bool isValid = isNewPlantValidated();
    if (isValid) {
      await _plantsRepository.createPlant(
          data: {"name": newPlantName, "quantity": newPlantQuantity});
      newPlantName = '';
      newPlantQuantity = '';
      _navigationUtil.navigateBack();
    }
  }

  void onReadPlantButtonPressed({required String id}) =>
      _plantsRepository.readPlant(id: id);

  void onUpdatePlantButtonPressed({required String id}) {
    final bool isValid = isNewPlantValidated();
    if (isValid) {
      _plantsRepository.updatePlant(
          id: id, data: {"name": newPlantName, "quantity": newPlantQuantity});
      newPlantName = '';
      newPlantQuantity = '';
      _navigationUtil.navigateBack();
    }
  }

  void onDeletePlantButtonPressed({required String id}) =>
      _plantsRepository.deletePlant(id: id);
}
