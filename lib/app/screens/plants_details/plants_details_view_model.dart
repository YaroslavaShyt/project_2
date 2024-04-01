import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:share_plus/share_plus.dart';

class PlantsDetailsViewModel extends BaseChangeNotifier {
  IPlant? plant;
  final String plantId;
  final IPlantsRepository _plantsRepository;

  PlantsDetailsViewModel(
      {required this.plantId, required IPlantsRepository plantsRepository})
      : _plantsRepository = plantsRepository;

  void loadPlantData() {
    _plantsRepository.readPlant(id: plantId).then((data) {
      if (data is IPlant) {
        plant = data;
        notifyListeners();
      }
    });
  }

  void sharePlant() {
    Share.share('Подивись на цю рослину:\n'
        '$uriPlantsDetails${plant!.id}');
  }
}
