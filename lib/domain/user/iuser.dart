abstract interface class IUser {
  final String name;
  final String surname;
  final String phoneNumber;

  IUser({required this.name, required this.surname, required this.phoneNumber});
}
