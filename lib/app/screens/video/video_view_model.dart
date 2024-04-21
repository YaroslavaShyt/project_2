import 'package:camera/camera.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseChangeNotifier {
  final XFile video;
  final IVideoPlayer _videoPlayer;
  final INavigationUtil _navigationUtil;
  final Function _onVideoSubmit;
  late Function onVideoCameraSuccess;
  late Function onVideoCameraError;

  VideoViewModel(
      {required this.video,
      required IVideoPlayer videoPlayer,
      required Function onVideoSubmit,
      required Map<CameraConfigKeys, Map<CameraType, dynamic>> cameraConfig,
      required INavigationUtil navigationUtil,
      required StorageService storageService})
      : _videoPlayer = videoPlayer,
        _onVideoSubmit = onVideoSubmit,
        _navigationUtil = navigationUtil {
    onVideoCameraSuccess =
        cameraConfig[CameraConfigKeys.onSuccess]?[CameraType.video] ?? () {};
    onVideoCameraError =
        cameraConfig[CameraConfigKeys.onError]?[CameraType.video] ?? () {};
  }

  Future<void> initialize() async {
    _videoPlayer.initialize(videoPath: video.path);
  }

  void navigateBackToCamera() {
    _navigationUtil.navigateTo(
      routeCamera,
      data: {
        CameraConfigKeys.cameraTypes: {
          CameraType.photo: false,
          CameraType.video: true
        },
        CameraConfigKeys.onSuccess: {
          CameraType.photo: null,
          CameraType.video: (XFile video) async {
            onVideoCameraSuccess(video);
          }
        },
        CameraConfigKeys.onError: {
          CameraType.photo: null,
          CameraType.video: onVideoCameraError
        }
      },
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
    await _onVideoSubmit(video);
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
