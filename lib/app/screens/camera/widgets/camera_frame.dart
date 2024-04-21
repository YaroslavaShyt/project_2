import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CameraFrame extends StatelessWidget {
  final Widget cameraPreview;
  const CameraFrame({super.key, required this.cameraPreview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border:
              Border.all(width: 2.0, color: AppColors.lightMentolGreenColor)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: AspectRatio(
          aspectRatio: 9.0 / 16.0,
          child: cameraPreview,
        ),
      ),
    );
  }
}
