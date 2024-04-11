import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';

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
    widget.viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: widget.viewModel.navigateBack,
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.viewModel.isInitialized
                ? SizedBox(
                    height: 700,
                    width: 400,
                    child: widget.viewModel.videoPlayer)
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: widget.viewModel.playOrPause,
                    icon: Icon(widget.viewModel.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_rounded)),
                widget.viewModel.isDataLoaded
                    ? IconButton(
                        onPressed: () => widget.viewModel.addFileToStorage(
                            onError: (err) => widget.showErrorDialog(
                                context, err.toString())),
                        icon: const Icon(Icons.upload))
                    : const SizedBox(
                        height: 30,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
              ],
            )
          ],
        ));
  }
}
