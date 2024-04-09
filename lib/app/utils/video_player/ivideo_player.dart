import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

abstract interface class IVideoPlayer {
  Future<void> initialize({required String videoPath});
  Future<void> playOrPause();
  void dispose();
  bool get isInitialized;
  VideoPlayer get videoPlayer;
  double get aspectRatio;
  bool get isPlaying;
}
