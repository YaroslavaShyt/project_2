import 'package:project_2/domain/plants/iplant.dart';

class Plant implements IPlant {
  @override
  String id;

  @override
  String name;

  @override
  String quantity;

  @override
  String image;

  @override
  List<dynamic> photos;

  @override
  List<dynamic> videos;

  Plant(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.photos,
      required this.videos,
      required this.image});

  factory Plant.fromJSON({required Map<String, dynamic> data}) {
    return Plant(
        id: data["id"],
        name: data["data"]["name"],
        quantity: data["data"]["quantity"],
        photos: data["data"]["photos"],
        videos: data["data"]["videos"],
        image: data["data"]["image"]);
  }
}
