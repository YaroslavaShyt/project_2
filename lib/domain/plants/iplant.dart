abstract interface class IPlant{
  final String id;
  final String name;
  final String quantity;
  final String image;

  IPlant({required this.id, required this.name, required this.quantity, required this.image});
}