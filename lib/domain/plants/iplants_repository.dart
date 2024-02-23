abstract interface class IPlantsRepository {
  Future<void> createPlant({required Map<String, dynamic> data});
  Future<void> readPlant({required String id});
  Future<void> updatePlant(
      {required String id, required Map<String, dynamic> data});
  Future<void> deletePlant({required String id});
}
