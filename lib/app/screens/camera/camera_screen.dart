import 'dart:io';
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
          'Нове фото',
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
              case CameraState.ready:
                return CameraFrame(
                    cameraPreview: widget.viewModel.cameraPreview,
                    takePicture: () => widget.viewModel.takePicture(
                        onSuccess: () => _showTakenPicture(context),
                        onFailure: (message) =>
                            widget.showErrorDialog(context, message)),
                    takeVideo: () => widget.viewModel.takeVideo(
                        onSuccess: () => _showTakenVideo(context),
                        onFailure: (message) =>
                            widget.showErrorDialog(context, message)),
                    toggleCamera: widget.viewModel.toggleCamera);
              default:
                return Center(
                  child: Text(snapshot.data.toString()),
                );
            }
          }),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }

  void _showTakenPicture(BuildContext context) {
    ModalsService.showPopUpModal(
        context: context,
        data: PopUpDialogData(
            title: 'Фото',
            content: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.file(File(widget.viewModel.capturedImagePath!))),
            actions: [
              MainElevatedButton(
                  onButtonPressed: widget.viewModel.navigateBack, title: 'ОК')
            ]));
  }

  void _showTakenVideo(BuildContext context) {}
}
