import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:video_player/video_player.dart';

class VideoScrollViewModel extends BaseChangeNotifier{
  final List<VideoPlayerController> controllers;
  VideoScrollViewModel({required this.controllers});
}