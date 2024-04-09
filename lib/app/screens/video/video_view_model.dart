import 'package:camera/camera.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseChangeNotifier {
  final XFile video;
  final IVideoPlayer _videoPlayer;

  VideoViewModel({required this.video, required IVideoPlayer videoPlayer})
      : _videoPlayer = videoPlayer;

  Future<void> initialize() async {
    _videoPlayer.initialize(videoPath: video.path);
  }

  bool get isInitialized => _videoPlayer.isInitialized;

  VideoPlayer get videoPlayer => _videoPlayer.videoPlayer;

  bool get isPlaying => _videoPlayer.isPlaying;

  double get aspectRatio => _videoPlayer.aspectRatio;

  Future<void> playOrPause() async {
    await _videoPlayer.playOrPause();
    notifyListeners();
  }

  @override
  void dispose() {
    _videoPlayer.dispose();
    super.dispose();
  }
}
