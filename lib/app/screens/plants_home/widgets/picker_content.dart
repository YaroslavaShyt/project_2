import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PickerContent extends StatelessWidget {
  final Function() onGalleryTap;
  final Function() onCameraTap;
  const PickerContent(
      {super.key, required this.onCameraTap, required this.onGalleryTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      child: Column(
        children: [
          ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.whiteColor),
              title: const Text(
                'З галереї',
                style: TextStyle(color: AppColors.whiteColor),
              ),
              onTap: onGalleryTap),
          ListTile(
              leading:
                  const Icon(Icons.photo_camera, color: AppColors.whiteColor),
              title: const Text(
                'З камери',
                style: TextStyle(color: AppColors.whiteColor),
              ),
              onTap: onCameraTap),
        ],
      ),
    );
  }
}
