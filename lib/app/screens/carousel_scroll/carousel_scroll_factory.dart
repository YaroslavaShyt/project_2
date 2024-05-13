import 'package:flutter/material.dart';
import 'package:project_2/app/screens/carousel_scroll/carousel_scroll_screen.dart';
import 'package:project_2/app/screens/carousel_scroll/carousel_scroll_view_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CarouselScrollFactory {
  static Widget build(
      {required List<VideoPlayerController> controllers,
      required List<dynamic> videoUrls, required bool isVideo}) {
    return ChangeNotifierProvider(
      create: (context) => CarouselScrollViewModel(
          controllers: controllers, videoUrl: videoUrls, isVideo: isVideo),
      child:
          Consumer<CarouselScrollViewModel>(builder: (context, model, child) {
        return CarouselScrollScreen(
          viewModel: model,
        );
      }),
    );
  }
}
