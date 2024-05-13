import 'package:flutter/material.dart';
import 'package:project_2/app/screens/carousel_scroll/carousel_scroll_view_model.dart';
import 'package:project_2/app/screens/carousel_scroll/widgets/outer_swipe.dart';

class CarouselScrollScreen extends StatefulWidget {
  final CarouselScrollViewModel viewModel;
  const CarouselScrollScreen({super.key, required this.viewModel});

  @override
  State<CarouselScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<CarouselScrollScreen> {
  final List<String> text = const [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OuterSwipe(
            key: ValueKey(widget.viewModel.index),
            index: widget.viewModel.index,
            handleIndex: widget.viewModel.handleIndex,
            changeVerticalIndex: widget.viewModel.changeVerticalIndex,
            //data: text,
            data: widget.viewModel.videoUrl,
            isVideo: widget.viewModel.isVideo,
            changeHorizontalIndex: widget.viewModel.changeHorizontalIndex));
  }
}
