import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/screens/carousel_scroll/carousel_scroll_view_model.dart';
import 'package:project_2/app/screens/carousel_scroll/widgets/main_video_player.dart';

class InnerSwipe extends StatefulWidget {
  final int index;
  final Function(int, SwipeAxisDirection) handleIndex;
  final Function(int) changeVerticalIndex;
  final Function(int) changeHorizontalIndex;
  final bool isVideo;

  final List<dynamic> data;

  const InnerSwipe(
      {super.key,
      required this.changeVerticalIndex,
      required this.data,
      required this.handleIndex,
      required this.isVideo,
      required this.index,
      required this.changeHorizontalIndex});

  @override
  State<InnerSwipe> createState() => _InnerSwipeState();
}

class _InnerSwipeState extends State<InnerSwipe> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
        index: widget.index,
        onIndexChanged: (int index) {
          widget.handleIndex(index, SwipeAxisDirection.vertical);
          widget.changeVerticalIndex(index);
          widget.changeHorizontalIndex(index);
        },
        loop: false,
        scrollDirection: Axis.vertical,
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int indexV) {
          return widget.isVideo
              ? MainVideoPlayer(videoUrl: widget.data[widget.index])
              : CachedImageWidget(imageUrl: widget.data[widget.index]);
        });
  }
}
