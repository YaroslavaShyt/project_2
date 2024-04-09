import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/screens/video/video_screen.dart';
import 'package:project_2/app/screens/video/video_view_model.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/app/services/networking/firebase_storage/storage_service.dart';
import 'package:project_2/app/utils/video_player/ivideo_player.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:provider/provider.dart';

class VideoFactory {
  static Widget build(RouteSettings settings) {
    return ChangeNotifierProvider(
        create: (context) => VideoViewModel(
            video: settings.arguments as XFile,
            videoPlayer: getItInst.get<IVideoPlayer>(),
            userService: context.read<IUserService>(),
            navigationUtil: context.read<INavigationUtil>(),
            storageService: getItInst.get<StorageService>()),
        child: Consumer<VideoViewModel>(builder: (context, model, child) {
          return VideoScreen(
            viewModel: model,
          );
        }));
  }
}
