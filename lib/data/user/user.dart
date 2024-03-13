import 'package:project_2/domain/user/iuser.dart';

class MyUser implements IMyUser {
  @override
  final String name;

  @override
  final String? phoneNumber;

  @override
  final String? email;

  @override
  final String id;

  @override
  final String? profilePhoto;

  MyUser(
      {this.name = 'Анонім',
      this.phoneNumber,
      this.email,
      this.profilePhoto,
      required this.id});

  factory MyUser.fromJson({required Map<String, dynamic> data}) {
    return MyUser(
        name: data["name"],
        phoneNumber: data["phoneNumber"],
        id: data["id"],
        email: data["email"],
        profilePhoto: data["profilePhoto"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "email": email,
      "phoneNumber": phoneNumber,
      "profilePhoto": profilePhoto
    };
  }
}
