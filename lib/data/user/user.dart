import 'package:project_2/domain/user/imy_user.dart';

class MyUser implements IMyUser {
  @override
  String name;

  @override
  String? phoneNumber;

  @override
  String? email;

  @override
  final String id;

  @override
  String? profilePhoto;

  MyUser(
      {this.name = 'Анонім',
      this.phoneNumber,
      this.email,
      this.profilePhoto,
      required this.id});

  factory MyUser.fromJson({required Map<String, dynamic> data}) {
    return MyUser(
        name: data["data"]["name"],
        phoneNumber: data["data"]["phoneNumber"],
        id: data["id"],
        email: data["data"]["email"],
        profilePhoto: data["data"]["image"]);
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
