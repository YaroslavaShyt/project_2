import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/app/services/networking/storage/collections.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/data/plants/plant.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

class PlantsRepository implements IPlantsRepository {
  final INetworkService _networkService;

  PlantsRepository({required INetworkService networkService})
      : _networkService = networkService;

  final StreamController<PlantsData> _streamController =
      StreamController.broadcast();

  @override
  Stream<PlantsData> plantsState() {
    FirebaseFirestore.instance
        .collection(plantsCollection)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<Plant> plants = [];
      for (var doc in snapshot.docs) {
        plants.add(Plant.fromJSON(data: {"id": doc.id, "data": doc.data()}));
      }
      _streamController.add(PlantsData(data: plants));
    });

    return _streamController.stream;
  }

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
    return Plant.fromJSON(data: data);
  }

  @override
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkService.update(id: id, data: data);
  }
}
