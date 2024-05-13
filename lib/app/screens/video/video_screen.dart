import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';
import 'package:project_2/app/theming/app_colors.dart';

class VideoScreen extends StatefulWidget with ErrorHandlingMixin {
  final VideoViewModel viewModel;
  const VideoScreen({super.key, required this.viewModel});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.initialize().then((value) =>
        {widget.viewModel.videoPlayerController.addListener(_videoListener)});
  }

  void _videoListener() {
    if (!widget.viewModel.videoPlayerController.value.isPlaying &&
        widget.viewModel.videoPlayerController.value.isInitialized &&
        widget.viewModel.videoPlayerController.value.duration ==
            widget.viewModel.videoPlayerController.value.position) {
      widget.viewModel.isPlaying = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Назад",
          style: TextStyle(
              color: AppColors.whiteColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.darkWoodGeenColor,
        leading: IconButton(
            onPressed: widget.viewModel.navigateBackToCamera,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.whiteColor,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.viewModel.isInitialized
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: AppColors.whiteColor,
                        width: 3,
                      )),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: widget.viewModel.videoPlayer),
                )
              : const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.darkWoodGeenColor),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: widget.viewModel.playOrPause,
                  icon: Icon(
                    widget.viewModel.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_rounded,
                    color: AppColors.whiteColor,
                  )),
              widget.viewModel.isDataLoaded
                  ? IconButton(
                      onPressed: widget.viewModel.onVideoSubmit,
                      icon: const Icon(
                        Icons.upload,
                        color: AppColors.whiteColor,
                      ))
                  : const SizedBox(
                      height: 30,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
            ],
          )
        ],
      ),
      backgroundColor: AppColors.darkWoodGeenColor,
    );
  }
}
