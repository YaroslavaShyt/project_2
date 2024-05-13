import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/camera/camera_config_data.dart';
import 'package:project_2/app/services/networking/firebase_storage/paths.dart';
import 'package:project_2/app/utils/content/icontent_handler.dart';
import 'package:project_2/app/utils/storage/iremote_storage_handler.dart';
import 'package:project_2/app/utils/video_cache/video_cache_util.dart';
import 'package:project_2/domain/plants/iplant.dart';
import 'package:project_2/domain/plants/iplants_repository.dart';
import 'package:project_2/domain/services/iuser_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class PlantsDetailsViewModel extends BaseChangeNotifier
    with ErrorHandlingMixin {
  final String plantId;
  final IPlantsRepository _plantsRepository;
  final INavigationUtil _navigationUtil;
  final IContentHandler _contentHandler;
  final IRemoteStorageHandler _remoteStorageHandler;
  double currentStep = 0.0;
  final List<VideoPlayerController> _controllers = [];
  final StreamController<VideoPlayerController> _streamController =
      StreamController.broadcast();

  Stream<IPlant> Function({required String id}) get plantStateStream =>
      _plantsRepository.plantStream;

  PlantsDetailsViewModel(
      {required this.plantId,
      required INavigationUtil navigationUtil,
      required IContentHandler contentHandler,
      required IUserService userService,
      required IPlantsRepository plantsRepository,
      required IRemoteStorageHandler remoteStorageHandler})
      : _navigationUtil = navigationUtil,
        _contentHandler = contentHandler,
        _plantsRepository = plantsRepository,
        _remoteStorageHandler = remoteStorageHandler;

  Stream<VideoPlayerController> get videoGridStream => _streamController.stream;

  Future navigateToCarouselScrollPage(
          {required int index,
          required bool isVideo,
          required List<dynamic> data}) =>
      _navigationUtil.navigateTo(routeVideoScroll, data: [
        controllers.sublist(index),
        isVideo ? data.sublist(index) : data.sublist(index),
        isVideo
      ]);

  void addControllers(VideoPlayerController controller) {
    VideoCacheUtil videoCacheUtil =
        VideoCacheUtil(videoUrl: controller.dataSource);
    videoCacheUtil.cacheVideo();
    _controllers.add(controller);
    notifyListeners();
  }

  List<VideoPlayerController> get controllers => _controllers;

  Future<void> initControllers(List<dynamic> urls) async {
    if (_controllers.isNotEmpty && _controllers.length != urls.length) {
      VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(urls.last));

      await controller.initialize();
      _streamController.add(controller);
    } else if (_controllers.isEmpty && _controllers.length != urls.length) {
      for (String url in urls) {
        VideoPlayerController controller =
            VideoPlayerController.networkUrl(Uri.parse(url));

        await controller.initialize();
        _streamController.add(controller);
      }
    }
  }

  void disposeControllers(List<VideoPlayerController> controllers) async {
    for (var controller in controllers) {
      await controller.dispose();
    }
  }

  Future<void> addPlantFileFromCamera(
    BuildContext context, {
    required bool isVideo,
  }) async {
    await _contentHandler.addFileFromCamera(
      onSuccess: () => _navigationUtil.navigateTo(routeCamera,
          data: CameraConfigData(
              isPhotoCamera: !isVideo,
              isVideoCamera: isVideo,
              onPhotoCameraSuccess: !isVideo ? _onPhotoCameraSuccess : null,
              onVideoCameraSuccess: isVideo ? _onVideoCameraSuccess : null,
              onVideoCameraError:
                  isVideo ? (context) => onError(context) : null,
              onPhotoCameraError:
                  !isVideo ? (context) => onError(context) : null)),
      onError: (context) => onError(context),
    );
  }

  Future<void> addPlantFileFromGallery(
      {required Function onError, required bool isVideo}) async {
    _navigationUtil.navigateBack();
    await _contentHandler.addFileFromGallery(
        path: isVideo
            ? "$userFilesPath/vd/$plantId"
            : "$userFilesPath/ph/$plantId",
        onError: onError,
        onSuccess: (String url) {});
  }

  Future<void> _onPhotoCameraSuccess(XFile image) async {
    await _remoteStorageHandler.addDataToStorage(
      path: "$userFilesPath/ph/$plantId",
      file: image,
      onError: onError,
      onSuccess: (String url) {
        _navigationUtil.navigateBack();
        _navigationUtil.navigateBack();
        _navigationUtil.navigateBack();
      },
    );
  }

  void onError(BuildContext context) => (err) => showErrorDialog(context, err);

  Future<void> _onVideoCameraSuccess(XFile video, Function onError) async {
    await _remoteStorageHandler.addDataToStorage(
      path: "$userFilesPath/vd/$plantId",
      file: video,
      onError: onError,
      onSuccess: (String url) {
        _navigationUtil.navigateBack();
        _navigationUtil.navigateBack();

        notifyListeners();
      },
    );
  }

  void sharePlant() {
    Share.share('Подивись на цю рослину:\n'
        '$uriPlantsDetails$plantId');
  }
}
