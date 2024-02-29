import 'package:cloud_functions/cloud_functions.dart';
import 'package:project_2/app/services/networking/storage/collections.dart';
import 'package:project_2/app/services/networking/functions/functions.dart';
import 'package:project_2/domain/services/ifunctions_service.dart';
import 'package:project_2/domain/services/imodification_service.dart';

class PlantsModificationService implements IModificationService {
  final IFunctionsService _functionsService;

  PlantsModificationService({required IFunctionsService functionsService})
      : _functionsService = functionsService;

  @override
  Future<Map<String, dynamic>> toLowerCaseData() async {
    HttpsCallableResult data = await _functionsService.call(
        functionName: toLowerCaseFunction, arguments: plantsCollection);
    return data.data;
  }

  @override
  Future toUpperCaseData() async {
    HttpsCallableResult data = await _functionsService.call(
        functionName: toUpperCaseFunction, arguments: plantsCollection);
    return data.data;
  }
}
