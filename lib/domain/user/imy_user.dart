abstract interface class IMyUser {
  final String id;
  String name;
  String? phoneNumber;
  String? email;
  String? profilePhoto;

  IMyUser(
      {this.name = 'Анонім',
      this.phoneNumber,
      this.email,
      this.profilePhoto,
      required this.id});

}
