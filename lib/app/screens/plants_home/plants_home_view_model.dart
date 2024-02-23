import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/services/iuser_service.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

class PlantsHomeViewModel extends BaseChangeNotifier {
  final ILoginRepository _loginRepository;
  final IUserService _userService;
  final IPlantsRepository _plantsRepository;

  String _newPlantName = '';
  String _newPlantQuantity = '';

  String? _newPlantNameError;
  String? _newPlantQuantityError;

  String get newPlantName => _newPlantName;
  String get newPlantQuantity => _newPlantQuantity;
  String? get newPlantNameError => _newPlantNameError;
  String? get newPlantQuantityError => _newPlantQuantityError;

  set newPlantName(name) {
    if (name.isEmpty) {
      _newPlantNameError = "Назва є обов'язковою!";
      notifyListeners();
    } else {
      _newPlantName = name;
    }
  }

  set newPlantQuantity(quantity) {
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
    }
    if (_newPlantQuantity.isEmpty) {
      _newPlantQuantityError = "Кількість є обов'язковою!";
    }
    if (_newPlantNameError != null || _newPlantQuantityError != null) {
      notifyListeners();
      return false;
    } else {
      _newPlantNameError = null;
      _newPlantQuantityError = null;
      notifyListeners();
    }
    return true;
  }

  PlantsHomeViewModel(
      {required IUserService userService,
      required IPlantsRepository plantsRepository,
      required ILoginRepository loginRepository})
      : _userService = userService,
        _plantsRepository = plantsRepository,
        _loginRepository = loginRepository;

  void onLogoutButtonPressed() {
    _loginRepository.logout();
  }

  String get userName => _userService.user?.name ?? '';
  String get userSurname => _userService.user?.surname ?? '';
  String get userPhoneNumber => _userService.user?.phoneNumber ?? '';

  void onAddPlantButtonPressed() {
    final bool isValid = isNewPlantValidated();
    if (isValid) {
      _plantsRepository.createPlant(
          data: {"name": newPlantName, "quantity": newPlantQuantity});
    }
  }

  void onReadPlantButtonPressed({required String id}) {
    _plantsRepository.readPlant(id: id);
  }

  void onUpdatePlantButtonPressed(
      {required String id, required Map<String, dynamic> data}) {
    _plantsRepository.updatePlant(id: id, data: data);
  }

  void onDeletePlantButtonPressed({required String id}) {
    _plantsRepository.deletePlant(id: id);
  }
}
