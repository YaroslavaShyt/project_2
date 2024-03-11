import 'package:project_2/domain/user/iuser.dart';

class User implements IUser {
  @override
  final String name;

  @override
  final String? phoneNumber;

  @override
  final String? photo;

  User({required this.name, this.phoneNumber, this.photo});

  factory User.fromJSON({required Map<String, dynamic> data}){
    return User(name: data["name"], photo: data["photo"]);
  }
}
