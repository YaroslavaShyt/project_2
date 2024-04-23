import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:video_player/video_player.dart';

class VideoScrollViewModel extends BaseChangeNotifier{
  int _index = 0;
  final List<VideoPlayerController> controllers;
  VideoScrollViewModel({required this.controllers});

  int get index => _index;

  void moveToNextVideo(){
    controllers[_index].pause();
    _index++;
    controllers[_index].setLooping(true);
    controllers[_index].play();
    notifyListeners();
  }

  void moveToPreviousVideo(){
    controllers[_index].pause();
    _index--;
    controllers[_index].setLooping(true);
    controllers[_index].play();
    notifyListeners();
  }

  void stopLastVideo(){
    controllers[_index].pause();
  }
}