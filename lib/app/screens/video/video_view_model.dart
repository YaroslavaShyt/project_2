import 'dart:io';

import 'package:camera/camera.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:video_player/video_player.dart';

class VideoViewModel extends BaseChangeNotifier {
  final XFile video;
  final IVideoPlayer _videoPlayer;
  final StorageService _storageService;
  final IUserService _userService;
  final INavigationUtil _navigationUtil;

  VideoViewModel(
      {required this.video,
      required IVideoPlayer videoPlayer,
      required IUserService userService,
      required INavigationUtil navigationUtil,
      required StorageService storageService})
      : _videoPlayer = videoPlayer,
        _storageService = storageService,
        _userService = userService,
        _navigationUtil = navigationUtil;

  Future<void> initialize() async {
    _videoPlayer.initialize(videoPath: video.path);
    
  }

  void navigateBack(){
    _navigationUtil.navigateToAndReplace(routeCamera);
  }

  bool get isInitialized => _videoPlayer.isInitialized;

  VideoPlayer get videoPlayer => _videoPlayer.videoPlayer;

  bool get isPlaying => _videoPlayer.isPlaying;

  double get aspectRatio => _videoPlayer.aspectRatio;

  Future<void> addFileToStorage({
    required Function onError,
  }) async {
    setIsDataLoaded(false);
    notifyListeners();
    File file = File(video.path);
    _storageService
        .addFileToStorage(
            file: file,
            path:
                "$userFilesPath/${_userService.user!.id}/")
        .then((response) {
      if (response.error != null) {
        onError(response.error!);
      } else {
        setIsDataLoaded(true);
        _navigationUtil.navigateBack();
      }
    }).onError((error, stackTrace) => onError(error.toString()));
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
