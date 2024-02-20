import 'package:project_2/domain/user/iuser.dart';

class User implements IUser {
  @override
  final String name;

  @override
  final String surname;

  @override
  final String phoneNumber;


  User({required this.name, required this.surname, required this.phoneNumber});
}
