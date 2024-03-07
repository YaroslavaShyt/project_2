import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/domain/services/ibase_response.dart';

abstract interface class IPlantsRepository {
  Future<void> createPlant({required Map<String, dynamic> data});
  Future<dynamic> readPlant({required String id});
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data});
  Future<void> deletePlant({required String id});
  Future<IBaseResponse> toUpperCaseData();
  Future<IBaseResponse> toLowerCaseData();
  Stream<PlantsData> plantsState();
}
