import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/app/services/networking/functions/functions.dart';
import 'package:project_2/app/services/networking/firestore/collections.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/data/plants/plant.dart';
import 'package:project_2/data/plants/plants_data.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';

class PlantsRepository implements IPlantsRepository {
  final INetworkService _networkService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  PlantsRepository(
      {required INetworkService networkService,
      required FirebaseFunctionsService firebaseFunctionsService})
      : _networkService = networkService,
        _firebaseFunctionsService = firebaseFunctionsService;

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
  Future<void> createPlant(
      {required Map<String, dynamic> data}) async {
    await _networkService.create(endpoint: plantsCollection, data: data);
  }

  @override
  Future<void> deletePlant({required String id}) async {
    await _networkService.delete(endpoint: plantsCollection, id: id);
  }

  @override
  Future<IPlant> readPlant({required String id}) async {
    Map<String, dynamic> data =
        await _networkService.read(endpoint: plantsCollection, id: id);
    return Plant.fromJSON(data: data);
  }

  @override
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkService.update(
        endpoint: plantsCollection, id: id, data: data);
  }

  @override
  Future<Map<String, dynamic>> toLowerCaseData() async {
    HttpsCallableResult data = await _firebaseFunctionsService.call(
        functionName: toLowerCaseFunction, arguments: plantsCollection);
    return data.data;
  }

  @override
  Future toUpperCaseData() async {
    HttpsCallableResult data = await _firebaseFunctionsService.call(
        functionName: toUpperCaseFunction, arguments: plantsCollection);
    return data.data;
  }
}
