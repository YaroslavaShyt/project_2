import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_screen.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoScrollFactory {
  static Widget build(
      {required List<VideoPlayerController> controllers,
      required List<dynamic> videoUrls}) {
    return ChangeNotifierProvider(
        create: (context) =>
            VideoScrollViewModel(controllers: controllers, videoUrl: videoUrls),
        child: Consumer<VideoScrollViewModel>(builder: (context, model, child) {
          return VideoScrollScreen(
            viewModel: model,
          );
        }));
  }
}
