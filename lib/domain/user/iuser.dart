abstract interface class IMyUser {
  final String id;
  final String name;
  final String? phoneNumber;
  final String? email;
  final String? profilePhoto;

  IMyUser(
      {this.name = 'Анонім',
      this.phoneNumber,
      this.email,
      this.profilePhoto,
      required this.id});

}
