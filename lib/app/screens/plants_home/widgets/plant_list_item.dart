import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/plants/iplant.dart';

class PlantListItem extends StatelessWidget {
  final IPlant plant;
  final void Function() onDeleteButtonPressed;
  final void Function() onEditButtonPressed;
  const PlantListItem(
      {super.key,
      required this.plant,
      required this.onDeleteButtonPressed,
      required this.onEditButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          plant.name,
          style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor),
        ),
        Row(
          children: [
            IconButton(
                onPressed: onEditButtonPressed,
                icon: const Icon(Icons.edit, color: AppColors.whiteColor)),
            IconButton(
                onPressed: onDeleteButtonPressed,
                icon: const Icon(Icons.delete, color: AppColors.whiteColor))
          ],
        ),
      ],
    );
  }
}
