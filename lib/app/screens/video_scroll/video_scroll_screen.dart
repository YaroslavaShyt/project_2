import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:project_2/app/screens/video_scroll/widgets/outer_swipe.dart';

class VideoScrollScreen extends StatefulWidget {
  final VideoScrollViewModel viewModel;
  const VideoScrollScreen({super.key, required this.viewModel});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  final List<String> text = const [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OuterSwipe(
            key: ValueKey(widget.viewModel.index),
            index: widget.viewModel.index,
            handleIndex: widget.viewModel.handleIndex,
            changeVerticalIndex: widget.viewModel.changeVerticalIndex,
            data: text, // widget.viewModel.videoUrl,
            changeHorizontalIndex: widget.viewModel.changeHorizontalIndex));
  }
}
