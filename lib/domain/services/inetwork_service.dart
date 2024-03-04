abstract interface class INetworkService {
  Future<void> create(
      {required String endpoint, required Map<String, dynamic> data});
  Future<Map<String, dynamic>> read(
      {required String endpoint, required String id});
  Future<void> update(
      {required String endpoint,
      required String id,
      required Map<String, dynamic> data});
  Future<void> delete({required String endpoint, required String id});
}
