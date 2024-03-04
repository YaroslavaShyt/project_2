import 'package:project_2/data/plants/plants_data.dart';

abstract interface class IPlantsRepository {
  Future<void> createPlant({required Map<String, dynamic> data});
  Future<void> readPlant({required String id});
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data});
  Future<void> deletePlant({required String id});
  Future toUpperCaseData();
  Future toLowerCaseData();
  Stream<PlantsData> plantsState();
  void closePlantsStream();
}
