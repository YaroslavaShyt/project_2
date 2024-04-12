abstract interface class IPlant {
  final String id;
  final String name;
  final String quantity;
  final String image;
  final List<dynamic> photos;
  final List<dynamic> videos;

  IPlant(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.image,
      required this.photos,
      required this.videos});
}
