import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CameraFrame extends StatelessWidget {
  final Widget cameraPreview;
  final Function() toggleCamera;
  final Function() takePicture;
  final Function() takeVideo;

  const CameraFrame(
      {super.key,
      required this.cameraPreview,
      required this.takePicture,
      required this.takeVideo,
      required this.toggleCamera});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                          width: 2.0, color: AppColors.lightMentolGreenColor)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: AspectRatio(
                      aspectRatio: 9.0 / 16.0,
                      child: cameraPreview,
                    ),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  right: 20.0,
                  child: IconButton(
                      icon: const Icon(
                        Icons.switch_camera,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: toggleCamera),
                ),
              ],
            ),
            //  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: const Icon(
                  Icons.camera,
                  color: AppColors.whiteColor,
                ),
                onPressed: takePicture),
            IconButton(
              icon: const Icon(
                Icons.videocam,
                color: AppColors.whiteColor,
              ),
              onPressed: takeVideo
            ),
          ],
        ),
      ],
    );
  }
}
