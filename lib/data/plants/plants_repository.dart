import 'dart:async';
import 'package:project_2/app/services/networking/inetwork_service.dart';
import 'package:project_2/data/plants/plant.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

class PlantsRepository implements IPlantsRepository {
  final INetworkService _networkService;

  PlantsRepository({required INetworkService networkService})
      : _networkService = networkService;

  @override
  Future<void> createPlant({required Map<String, dynamic> data}) async {
    await _networkService.create(data: data);
  }

  @override
  Future<void> deletePlant({required String id}) async {
    await _networkService.delete(id: id);
  }

  @override
  Future<IPlant> readPlant({required String id}) async {
    Map<String, dynamic> data = await _networkService.read(id: id);
    return Plant.fromMap(data: data);
  }

  @override
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkService.update(id: id, data: data);
  }
}
