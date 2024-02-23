import 'package:project_2/domain/plants/iplant.dart';

class Plant implements IPlant {
  @override
  String id;

  @override
  String name;

  @override
  String quantity;

  Plant({required this.id, required this.name, required this.quantity});

  factory Plant.fromMap({required Map<String, dynamic> data}) {
    return Plant(
        id: data["id"], name: data["name"], quantity: data["quantity"]);
  }
}
