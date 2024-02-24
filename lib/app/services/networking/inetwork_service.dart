abstract interface class INetworkService {
  Future<void> create({required Map<String, dynamic> data});
  Future<Map<String, dynamic>> read({required String id});
  Future<void> update({required String id, required Map<String, dynamic> data});
  Future<void> delete({required String id});
}
