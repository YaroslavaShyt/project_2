import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/screens/camera/camera_view_model.dart';
import 'package:project_2/app/screens/camera/widgets/camera_frame.dart';
import 'package:project_2/app/services/camera/interfaces/icamera_service.dart';

import 'package:project_2/app/theming/app_colors.dart';

class CameraScreen extends StatefulWidget with ErrorHandlingMixin {
  final CameraViewModel viewModel;
  const CameraScreen({super.key, required this.viewModel});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadCamera();
  }

  @override
  void dispose() {
    widget.viewModel.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: widget.viewModel.navigateBack,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.whiteColor,
            )),
        title: const Text(
          'Створити',
          style: TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkWoodGeenColor,
      ),
      body: StreamBuilder<CameraState>(
          stream: widget.viewModel.cameraStateStream,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case CameraState.init:
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightMentolGreenColor,
                  ),
                );
              case CameraState.error:
                return const Center(
                  child: Text(
                    "Помилка",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                );
              case CameraState.ready ||
                    CameraState.recording ||
                    CameraState.recorded ||
                    CameraState.paused:
                return CameraFrame(
                  cameraPreview: widget.viewModel.cameraPreview,
                  takePicture: () => widget.viewModel.takePicture(
                      onPhotoTaken: () => _showTakenPicture(context,
                          onSubmit: widget.viewModel.onPhotoCameraSuccess)),
                  startVideo: () => widget.viewModel.startVideo(),
                  stopVideo: () => widget.viewModel.stopVideo(
                      onFailure: (message) =>
                          widget.showErrorDialog(context, message)),
                  resumeVideo: () => widget.viewModel.resumeVideo,
                  pauseVideo: () => widget.viewModel.pauseVideo,
                  cameraState: widget.viewModel.cameraState,
                  toggleCamera: widget.viewModel.toggleCamera,
                  changeCaptureType: widget.viewModel.changeCaptureType,
                  isVideoCameraSelected: widget.viewModel.isVideoCameraSelected,
                  isVideoCamera: widget.viewModel.isVideoCamera,
                  isPhotoCamera: widget.viewModel.isPhotoCamera,
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.lightMentolGreenColor,
                  ),
                );
            }
          }),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }

  void _showTakenPicture(BuildContext context, {required Function onSubmit}) {
    Modals.showPopUpModal(
        context: context,
        data: PopUpDialogData(
            title: 'Фото',
            content: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(File(widget.viewModel.capturedImagePath!))),
            actions: [
              MainElevatedButton(
                  onButtonPressed: widget.viewModel.navigateBack,
                  title: 'Відміна'),
              MainElevatedButton(
                  onButtonPressed: () =>
                      onSubmit(XFile(widget.viewModel.capturedImagePath!)),
                  title: 'ОК')
            ]));
  }
}
