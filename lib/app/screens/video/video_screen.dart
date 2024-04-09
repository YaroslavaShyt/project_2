import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';

class VideoScreen extends StatefulWidget {
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
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget.viewModel.isInitialized
            ? SizedBox(
                height: 800, width: 400, child: widget.viewModel.videoPlayer)
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: widget.viewModel.playOrPause,
                icon: Icon(widget.viewModel.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow_rounded))
          ],
        )
      ],
    ));
  }
}
