import 'package:project_2/app/services/networking/firestore/collections.dart';
import 'package:project_2/data/user/user.dart';
import 'package:project_2/domain/services/ibase_response.dart';
import 'package:project_2/domain/services/inetwork_service.dart';
import 'package:project_2/domain/user/iuser.dart';
import 'package:project_2/domain/user/iuser_repository.dart';

class UserRepository implements IUserRepository {
  final INetworkService _networkService;

  UserRepository({
    required INetworkService networkService,
  }) : _networkService = networkService;

  @override
  Future<IMyUser?> readUser({required String id}) async {
    IBaseResponse data =
        await _networkService.read(endpoint: usersCollection, id: id);
    if (data.code == 200) {
      return MyUser.fromJson(data: data.data!);
    }
    return null;
  }

  @override
  Future<void> updateUser(
      {required String id, required Map<String, dynamic> data}) async {
    await _networkService.update(endpoint: usersCollection, id: id, data: data);
  }
  
  @override
  Future<void> deleteUser({required String id}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}
