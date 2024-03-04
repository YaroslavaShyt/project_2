import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/domain/services/inetwork_service.dart';

class FirebaseStorage implements INetworkService {
  final FirebaseFirestore _firestore;

  FirebaseStorage({required FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> create(
      {required String endpoint, required Map<String, dynamic> data}) async {
    await _firestore.collection(endpoint).add(data);
  }

  @override
  Future<Map<String, dynamic>> read(
      {required String endpoint, required String id}) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(endpoint).doc(id).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
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
