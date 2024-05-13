import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CategoryRow extends StatelessWidget {
  final Function() onPressed;
  final String title;
  const CategoryRow({super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 20.0,
        ),
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.whiteColor),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Icons.add,
            color: AppColors.whiteColor,
          ),
        )
      ],
    );
  }
}