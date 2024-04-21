import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class FrameBottomContainer extends StatelessWidget {
  final bool isPhotoCamera;
  final bool isVideoCamera;
  const FrameBottomContainer(
      {super.key, required this.isPhotoCamera, required this.isVideoCamera});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          color: AppColors.coldWoodGreenColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (isPhotoCamera) ...[
            const Icon(
              Icons.camera,
              color: AppColors.whiteColor,
            ),
          ],
          if (isVideoCamera) ...[
            const Icon(Icons.videocam, color: AppColors.whiteColor),
          ],
        ],
      ),
    );
  }
}
