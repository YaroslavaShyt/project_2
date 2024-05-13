import 'package:project_2/app/common/base_change_notifier.dart';
import 'package:video_player/video_player.dart';

enum SwipeAxisDirection { vertical, horizontal }

class CarouselScrollViewModel extends BaseChangeNotifier {
  int _verticalIndex = 0;
  int _horizontalIndex = 0;
  int _index = 0;
  int _previousIndex = 0;
  final List<VideoPlayerController> controllers;
  final List<dynamic> videoUrl;
  final bool isVideo;
  CarouselScrollViewModel(
      {required this.controllers,
      required this.videoUrl,
      required this.isVideo});

  int get verticalIndex => _verticalIndex;
  int get horizontalIndex => _horizontalIndex;
  int get index => _index;

  void changeVerticalIndex(int newIndex) {
    _verticalIndex = newIndex;
    notifyListeners();
  }

  void changeHorizontalIndex(int newIndex) {
    _horizontalIndex = newIndex;
    notifyListeners();
  }

  bool isLeftSwipe(int index) {
    return _horizontalIndex > index ? true : false;
  }

  bool isUpSwipe(int index) {
    return _verticalIndex >= index ? true : false;
  }

  void handleIndex(int index, SwipeAxisDirection direction) {
    bool isDecrement;
    if (direction == SwipeAxisDirection.vertical) {
      isDecrement = isUpSwipe(index);
    } else {
      isDecrement = isLeftSwipe(index);
    }
    if (isDecrement) {
      _index = _previousIndex;
      if (_index > 0) {
        _previousIndex = _index - 1;
      }
    } else {
      _previousIndex = _index;
      _index = _index + 1;
    }
    notifyListeners();
  }
}
