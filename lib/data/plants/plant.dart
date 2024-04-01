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

  Plant(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.image});

  factory Plant.fromJSON({required Map<String, dynamic> data}) {
    return Plant(
        id: data["id"],
        name: data["data"]["name"],
        quantity: data["data"]["quantity"],
        image: data["data"]["image"]);
  }
}
