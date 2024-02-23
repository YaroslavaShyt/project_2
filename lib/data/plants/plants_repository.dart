import 'dart:async';

import 'package:project_2/app/services/network_storage/inetwork_storage.dart';
import 'package:project_2/data/plants/plant.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

class PlantsRepository implements IPlantsRepository {
  final INetworkStorage _networkStorage;

  PlantsRepository({required INetworkStorage networkStorage})
      : _networkStorage = networkStorage;

  @override
  Future<void> createPlant({required Map<String, dynamic> data}) async {
    await _networkStorage.create(data: data);
  }

  @override
  Future<void> deletePlant({required String id}) async {
    await _networkStorage.delete(id: id);
  }

  @override
  Future<IPlant> readPlant({required String id}) async {
    Map<String, dynamic> data = await _networkStorage.read(id: id);
    return Plant.fromMap(data: data);
  }

  @override
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkStorage.update(id: id, data: data);
  }
}
