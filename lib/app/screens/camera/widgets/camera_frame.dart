import 'package:flutter/material.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CameraFrame extends StatelessWidget {
  final Widget cameraPreview;
  final Function() toggleCamera;
  final Function() takePicture;
  final Function() startVideo;
  final Function() stopVideo;
  final Function resumeVideo;
  final Function pauseVideo;
  final Function() changeCaptureType;
  final CameraState cameraState;
  final bool isVideoCameraSelected;

  const CameraFrame(
      {super.key,
      required this.cameraState,
      required this.cameraPreview,
      required this.takePicture,
      required this.startVideo,
      required this.pauseVideo,
      required this.stopVideo,
      required this.resumeVideo,
      required this.toggleCamera,
      required this.changeCaptureType,
      required this.isVideoCameraSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
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
                Positioned(
                    bottom: 40,
                    right: 100.0,
                    child: cameraState == CameraState.recording
                        ? IconButton(
                            onPressed: () => pauseVideo(),
                            icon: const Icon(
                              Icons.pause,
                              color: AppColors.whiteColor,
                            ))
                        : cameraState == CameraState.paused
                            ? IconButton(
                                onPressed: () => resumeVideo(),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.whiteColor,
                                ))
                            : const SizedBox()),
                Positioned(
                    bottom: 40,
                    left: 100.0,
                    child: cameraState == CameraState.recording ||
                            cameraState == CameraState.paused
                        ? IconButton(
                            onPressed: () => stopVideo(),
                            icon: const Icon(
                              Icons.stop,
                              color: AppColors.whiteColor,
                            ))
                        : const SizedBox()),
                Positioned(
                    bottom: 30,
                    child: GestureDetector(
                      onTap: isVideoCameraSelected ? startVideo : takePicture,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: AppColors.whiteColor),
                      ),
                    ))
              ],
            ),
            //  ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0)),
              color: AppColors.coldWoodGreenColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.camera,
                    color: isVideoCameraSelected
                        ? AppColors.greyColor
                        : AppColors.whiteColor,
                  ),
                  onPressed: changeCaptureType),
              IconButton(
                  icon: Icon(
                    Icons.videocam,
                    color: isVideoCameraSelected
                        ? AppColors.whiteColor
                        : AppColors.greyColor,
                  ),
                  onPressed: changeCaptureType),
            ],
          ),
        ),
      ],
    );
  }
}
