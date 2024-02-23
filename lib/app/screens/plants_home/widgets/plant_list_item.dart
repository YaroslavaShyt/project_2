import 'package:flutter/material.dart';

class PlantListItem extends StatelessWidget {
  final String title;
  final String quantity;
  final void Function() onDeleteButtonPressed;
  final void Function() onEditButtonPressed;
  const PlantListItem(
      {super.key,
      required this.title,
      required this.quantity,
      required this.onDeleteButtonPressed,
      required this.onEditButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Text(
          quantity,
          style: const TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
        ),
        Row(
          children: [
            IconButton(
                onPressed: onEditButtonPressed, icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: onDeleteButtonPressed,
                icon: const Icon(Icons.delete))
          ],
        ),
      ],
    );
  }
}
