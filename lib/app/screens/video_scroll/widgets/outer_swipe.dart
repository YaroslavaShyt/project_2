import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:project_2/app/screens/video_scroll/widgets/inner_swipe.dart';


class OuterSwipe extends StatefulWidget {
  final int index;
  final Function(int, SwipeAxisDirection) handleIndex;
  final Function(int) changeVerticalIndex;
  final Function(int) changeHorizontalIndex;
  final List<dynamic> data;
  const OuterSwipe(
      {super.key,
      required this.index,
      required this.handleIndex,
      required this.changeVerticalIndex,
      required this.data,
      required this.changeHorizontalIndex});

  @override
  State<OuterSwipe> createState() => _OuterSwipeState();
}

class _OuterSwipeState extends State<OuterSwipe> {
  @override
  Widget build(BuildContext context) {
    return Swiper(
        index: widget.index,
        itemCount: widget.data.length,
        scrollDirection: Axis.horizontal,
        loop: false,
        onIndexChanged: (index) {
          widget.changeVerticalIndex(index);
          widget.handleIndex(index, SwipeAxisDirection.horizontal);
          widget.changeHorizontalIndex(index);
        },
        itemBuilder: (BuildContext context, int index) {
          return InnerSwipe(
            key: ValueKey(widget.index),
            changeVerticalIndex: widget.changeVerticalIndex,
            data: widget.data,
            handleIndex: widget.handleIndex,
            index: widget.index,
            changeHorizontalIndex: widget.changeHorizontalIndex,
          );
        });
  }
}
