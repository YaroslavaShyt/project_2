import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class NoPhotoAvatar extends StatelessWidget {
  final Function onPressed; 
  const NoPhotoAvatar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: AppColors.lightMentolGreenColor),
      child: IconButton(
          onPressed: () => onPressed(context),
          icon: const Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.oliveGreenColor,
          )),
    );
  }
}