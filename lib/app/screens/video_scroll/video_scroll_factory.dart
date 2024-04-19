import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_screen.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:provider/provider.dart';

class VideoScrollFactory {
  static Widget build() {
    return ChangeNotifierProvider(
        create: (context) => VideoScrollViewModel(),
        child: Consumer<VideoScrollViewModel>(builder: (context, model, child) {
          return VideoScrollScreen(
            viewModel: model,
          );
        }));
  }
}
