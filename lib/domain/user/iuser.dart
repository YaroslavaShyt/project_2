abstract interface class IUser {
  final String name;
  final String? phoneNumber;
  final String? photo;

  IUser({required this.name, this.phoneNumber, this.photo});
}
