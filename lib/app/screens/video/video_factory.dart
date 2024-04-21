import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/camera/camera_factory.dart';
import 'package:project_2/app/screens/camera/camera_view_model.dart';
import 'package:project_2/app/screens/video/video_screen.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:provider/provider.dart';

class VideoFactory {
  static Widget build(RouteSettings settings) {
    final arguments = settings.arguments as List;
    final Map<CameraConfigKeys, Map<CameraType, dynamic>> cameraConfig =
        arguments[0];
    final Map<Video, dynamic> videoConfig = arguments[1];
    return ChangeNotifierProvider(
        create: (context) => VideoViewModel(
            video: videoConfig[Video.data],
            onVideoSubmit: videoConfig[Video.onSubmit],
            videoPlayer: getItInst.get<IVideoPlayer>(),
            cameraConfig: cameraConfig,
            navigationUtil: context.read<INavigationUtil>(),
            storageService: getItInst.get<StorageService>()),
        child: Consumer<VideoViewModel>(builder: (context, model, child) {
          return VideoScreen(
            viewModel: model,
          );
        }));
  }
}
