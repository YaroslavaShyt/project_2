import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/camera/camera_config_data.dart';
import 'package:project_2/app/services/camera/video_config_data.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseChangeNotifier {
  final IVideoPlayer _videoPlayer;
  final INavigationUtil _navigationUtil;
  final CameraConfigData _cameraConfigData;
  final VideoConfigData _videoConfigData;

  VideoViewModel(
      {required CameraConfigData cameraConfigData,
      required VideoConfigData videoConfigData,
      required IVideoPlayer videoPlayer,
      required INavigationUtil navigationUtil,
      required StorageService storageService})
      : _videoPlayer = videoPlayer,
        _navigationUtil = navigationUtil,
        _cameraConfigData = cameraConfigData,
        _videoConfigData = videoConfigData;

  Future<void> initialize() async {
    _videoPlayer.initialize(videoPath: _videoConfigData.video.path);
  }

  void navigateBackToCamera() {
    _navigationUtil.navigateToAndReplace(
      routeCamera,
      data: _cameraConfigData
    );
  }

  bool get isInitialized => _videoPlayer.isInitialized;

  VideoPlayer get videoPlayer => _videoPlayer.videoPlayer;

  bool get isPlaying => _videoPlayer.isPlaying;

  double get aspectRatio => _videoPlayer.aspectRatio;

  VideoPlayerController get videoPlayerController =>
      _videoPlayer.videoPlayerController;

  set isPlaying(bool newIsPlaying) {
    _videoPlayer.isPlaying = newIsPlaying;
    notifyListeners();
  }

  Future<void> onVideoSubmit() async {
    setIsDataLoaded(false);
    notifyListeners();
    await _videoConfigData.onVideoSubmit(_videoConfigData.video, _cameraConfigData.onVideoCameraSuccess);
    setIsDataLoaded(true);
    notifyListeners();
  }

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
