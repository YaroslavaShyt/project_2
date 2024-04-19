import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatelessWidget {
  final VideoPlayerController controller;
  final Function() onVideoPreviewTap;

  const VideoPreview({super.key, required this.controller, required this.onVideoPreviewTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onVideoPreviewTap,
      child: VideoPlayer(controller),
    );
  }
}
