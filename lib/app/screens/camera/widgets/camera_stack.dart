import 'package:flutter/material.dart';
import 'package:project_2/app/screens/camera/widgets/camera_frame.dart';
import 'package:project_2/app/screens/camera/widgets/frame_bottom_container.dart';
import 'package:project_2/app/screens/camera/widgets/progress_button.dart';
import 'package:project_2/app/screens/camera/widgets/timer_element.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CameraStack extends StatefulWidget {
  final Widget cameraPreview;
  final Function toggleCamera;
  final Function takePicture;
  final Function startVideo;
  final Function stopVideo;
  final Function resumeVideo;
  final Function pauseVideo;
  final Function changeCaptureType;
  final CameraState cameraState;
  final bool isVideoCameraSelected;
  final bool isVideoCamera;
  final bool isPhotoCamera;
  final int? progress;

  const CameraStack(
      {super.key,
      this.progress,
      required this.cameraState,
      required this.cameraPreview,
      required this.takePicture,
      required this.startVideo,
      required this.pauseVideo,
      required this.stopVideo,
      required this.resumeVideo,
      required this.isPhotoCamera,
      required this.isVideoCamera,
      required this.toggleCamera,
      required this.changeCaptureType,
      required this.isVideoCameraSelected});

  @override
  State<CameraStack> createState() => _CameraStackState();
}

class _CameraStackState extends State<CameraStack>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  double _previousAnimationValue = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CameraFrame(cameraPreview: widget.cameraPreview),
                Positioned(
                  top: 30.0,
                  right: 20.0,
                  child: IconButton(
                      icon: const Icon(
                        Icons.switch_camera,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () => widget.toggleCamera()),
                ),
                if (widget.isVideoCamera && widget.progress != null) ...[
                  Positioned(
                      top: 30.0,
                      left: 30.0,
                      child: TimerElement(
                        progress: widget.progress!,
                      )),
                ],
                Positioned(
                    bottom: 40,
                    right: 100.0,
                    child: widget.cameraState == CameraState.recording
                        ? IconButton(
                            onPressed: () {
                              widget.pauseVideo();
                              _pauseAnimation();
                            },
                            icon: const Icon(
                              Icons.pause,
                              color: AppColors.whiteColor,
                            ))
                        : widget.cameraState == CameraState.paused
                            ? IconButton(
                                onPressed: () {
                                  widget.resumeVideo();
                                  _resumeAnimation();
                                },
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.whiteColor,
                                ))
                            : const SizedBox()),
                Positioned(
                    bottom: 40,
                    left: 100.0,
                    child: widget.cameraState == CameraState.recording ||
                            widget.cameraState == CameraState.paused
                        ? IconButton(
                            onPressed: () {
                              widget.stopVideo();
                              _pauseAnimation();
                            },
                            icon: const Icon(
                              Icons.stop,
                              color: AppColors.whiteColor,
                            ))
                        : const SizedBox()),
                Positioned(
                    bottom: 30,
                    child: GestureDetector(
                        onTap: () {
                          if (widget.isVideoCameraSelected) {
                            widget.startVideo();
                            _startAnimation();
                          } else {
                            widget.takePicture();
                          }
                        },
                        child: CustomProgressButton(
                            animationController: animationController)))
              ],
            ),
          ),
        ),
        FrameBottomContainer(
          isPhotoCamera: widget.isPhotoCamera,
          isVideoCamera: widget.isVideoCamera,
        )
      ],
    );
  }

  void _pauseAnimation() {
    setState(() {
      _previousAnimationValue = animationController.value;
    });
    animationController.stop();
  }

  void _resumeAnimation() {
    animationController.forward(from: _previousAnimationValue);
  }

  void _startAnimation() {
    animationController.forward(from: 0.0);
  }
}
