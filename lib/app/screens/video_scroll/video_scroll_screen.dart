import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoScrollScreen extends StatefulWidget {
  final VideoScrollViewModel viewModel;
  const VideoScrollScreen({super.key, required this.viewModel});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.controllers[widget.viewModel.index].setLooping(true);
    widget.viewModel.controllers[widget.viewModel.index].play();
  }

  @override
  void dispose() {
    widget.viewModel.stopLastVideo();
    super.dispose();
  }

  void _onVideoSwipe(DragEndDetails dragEndDetails) {
    if (dragEndDetails.primaryVelocity == 0) return;

    if (dragEndDetails.primaryVelocity?.compareTo(0) == -1) {
      if (widget.viewModel.index < widget.viewModel.controllers.length - 1) {
        widget.viewModel.moveToNextVideo();
      }
    } else {
      if (widget.viewModel.index > 0) {
        widget.viewModel.moveToPreviousVideo();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: _onVideoSwipe,
        onHorizontalDragEnd: _onVideoSwipe,
        child: Center(
            child: VideoPlayer(
                widget.viewModel.controllers[widget.viewModel.index])),
      ),
    );
  }
}
