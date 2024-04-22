import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatelessWidget {
  final int index;
  final VideoPlayerController controller;
  final Function({required int index}) onVideoPreviewTap;

  const VideoPreview(
      {super.key,
      required this.controller,
      required this.onVideoPreviewTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onVideoPreviewTap(index: index),
      child: VideoPlayer(controller),
    );
  }
}
