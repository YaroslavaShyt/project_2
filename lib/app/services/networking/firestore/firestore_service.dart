import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/app/services/networking/base_response.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/inetwork_service.dart';

class FirestoreService implements INetworkService {
  final FirebaseFirestore _firestore;

  FirestoreService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> create(
      {required String endpoint, required Map<String, dynamic> data}) async {
    await _firestore.collection(endpoint).add(data);
  }

  @override
  Future<IBaseResponse> read(
      {required String endpoint, required String id}) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(endpoint).doc(id).get();
    if (documentSnapshot.exists) {
      return BaseResponse(
          code: 200,
          success: true,
          data: {"id": documentSnapshot.id, "data": documentSnapshot.data()});
    } else {
      return BaseResponse(code: 404, success: false, data: {});
    }
  }

  @override
  Future<void> update(
      {required String endpoint,
      required String id,
      required Map<String, dynamic> data}) async {
    await _firestore.collection(endpoint).doc(id).update(data);
  }

  @override
  Future<void> delete({required String endpoint, required String id}) async {
    await _firestore.collection(endpoint).doc(id).delete();
  }
}
