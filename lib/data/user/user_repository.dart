import 'package:cloud_functions/cloud_functions.dart';
import 'package:project_2/app/services/networking/firestore/collections.dart';
import 'package:project_2/app/services/networking/functions/firebase_functions_service.dart';
import 'package:project_2/app/services/networking/functions/functions.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/domain/user/iuser.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class UserRepository implements IUserRepository {
  final INetworkService _networkService;
  final FirebaseFunctionsService _firebaseFunctionsService;

  UserRepository(
      {required INetworkService networkService,
      required FirebaseFunctionsService firebaseFunctionsService})
      : _networkService = networkService,
        _firebaseFunctionsService = firebaseFunctionsService;

  @override
  Future<void> createUser(
      {String? id, required Map<String, dynamic> data}) async {
    await _networkService.create(id: id, endpoint: usersCollection, data: data);
  }

  @override
  Future<void> deleteUser({required String id}) async {
    await _networkService.delete(endpoint: usersCollection, id: id);
  }

  @override
  Future<IUser?> readUser({required String id}) async {
    IBaseResponse data =
        await _networkService.read(endpoint: usersCollection, id: id);
    if (data.code == 200) {
      return User.fromJSON(data: data.data!);
    }
    return null;
  }

  @override
  Future<void> updateUser(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkService.update(endpoint: usersCollection, id: id, data: data);
  }

  @override
  Future<void> saveUserOnSignIn() async {
    await _firebaseFunctionsService.call(
      functionName: saveUserDataOnSignIn,
    );
  }
}
