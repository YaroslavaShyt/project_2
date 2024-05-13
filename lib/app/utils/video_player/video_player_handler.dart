import 'dart:io';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:video_player/video_player.dart';




class VideoPlayerHandler implements IVideoPlayer {
  late VideoPlayerController _videoPlayerController;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  Future<void> initialize({required String videoPath}) async {
    _videoPlayerController = VideoPlayerController.file(File(videoPath))
      ..initialize();
    _isInitialized = true;
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  VideoPlayer get videoPlayer => VideoPlayer(_videoPlayerController);

  @override
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  @override
  double get aspectRatio => _videoPlayerController.value.aspectRatio;

  @override
  bool get isPlaying => _isPlaying;

  @override
  set isPlaying(bool newIsPlaying){
    _isPlaying = newIsPlaying;
  }

  @override
  Future<void> playOrPause() async {
    _isPlaying
        ? await _videoPlayerController.pause()
        : await _videoPlayerController.play();
    _isPlaying = !_isPlaying;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
  }
}
