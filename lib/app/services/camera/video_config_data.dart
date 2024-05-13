import 'package:share_plus/share_plus.dart';

class VideoConfigData {
  final XFile video;
  final Function onVideoSubmit;

  VideoConfigData({
    required this.video,
    required this.onVideoSubmit,
  });
}
