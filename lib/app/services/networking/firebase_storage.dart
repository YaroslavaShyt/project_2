import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2/app/services/networking/inetwork_service.dart';

class FirebaseStorage implements INetworkService {
  final String _collectionName;
  final FirebaseFirestore _firestore;

  FirebaseStorage(
      {required String collection, required FirebaseFirestore firestore})
      : _firestore = firestore,
        _collectionName = collection;

  @override
  Future<void> create({required Map<String, dynamic> data}) async {
    await _firestore.collection(_collectionName).add(data);
  }

  @override
  Future<Map<String, dynamic>> read({required String id}) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection(_collectionName).doc(id).get();
    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  @override
  Future<void> update(
      {required String id, required Map<String, dynamic> data}) async {
    await _firestore.collection(_collectionName).doc(id).update(data);
  }

  @override
  Future<void> delete({required String id}) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}
