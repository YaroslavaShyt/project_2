import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/video/video_screen.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';
import 'package:project_2/app/services/camera/camera_config_data.dart';
import 'package:project_2/app/services/camera/video_config_data.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:provider/provider.dart';

class VideoFactory {
  static Widget build(
      {required CameraConfigData cameraConfigData,
      required VideoConfigData videoConfigData}) {
    return ChangeNotifierProvider(
        create: (context) => VideoViewModel(
            cameraConfigData: cameraConfigData,
            videoPlayer: getItInst.get<IVideoPlayer>(),
            videoConfigData: videoConfigData,
            navigationUtil: context.read<INavigationUtil>(),
            storageService: getItInst.get<StorageService>()),
        child: Consumer<VideoViewModel>(builder: (context, model, child) {
          return VideoScreen(
            viewModel: model,
          );
        }));
  }
}
