import 'package:project_2/domain/user/iuser.dart';

abstract interface class IUserRepository {
  Future<void> createUser({String? id, required Map<String, dynamic> data});
  Future<IUser?> readUser({required String id});
  Future<void> updateUser(
      {required String id, required Map<String, dynamic> data});
  Future<void> deleteUser({required String id});
}
