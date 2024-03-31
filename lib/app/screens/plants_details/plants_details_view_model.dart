import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/domain/plants/iplant.dart';

class PlantsDetailsViewModel extends BaseChangeNotifier {
 // IPlant _plant;
  INavigationUtil _navigationUtil;

  PlantsDetailsViewModel(
      {//required IPlant plant, 
      required INavigationUtil navigationUtil})
      : //_plant = plant,
        _navigationUtil = navigationUtil;

 // IPlant get plant => _plant;

  // set plant(IPlant newPlant){
  //   _plant = newPlant;
  // }
}
