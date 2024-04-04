import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

Widget buildDrawerItem(IconData icon, String text, Function() onTap) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(color: AppColors.lightMentolGreenColor)),
      leading: Icon(
        icon,
        color: AppColors.lightMentolGreenColor,
      ),
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(
            fontWeight: FontWeight.w300, color: AppColors.whiteColor),
      ),
    ),
  );
}
