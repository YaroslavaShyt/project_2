import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:video_player/video_player.dart';

class VideoScrollScreen extends StatefulWidget {
  final VideoScrollViewModel viewModel;
  const VideoScrollScreen({super.key, required this.viewModel});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  late PageController _verticalPageController;
  late PageController _horizontalPageController;
  int _index = 0;
  late int _maxIndex;

  @override
  void initState() {
    super.initState();
    _maxIndex = widget.viewModel.controllers.length;
    widget.viewModel.controllers[_index].play();
  }

  @override
  void dispose() {
    _verticalPageController.dispose();
    _horizontalPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          if (dragEndDetails.primaryVelocity == 0) return; 
          
          if (dragEndDetails.primaryVelocity?.compareTo(0) == -1) {
            print('dragged from bottom');
            if (_index < _maxIndex - 1) {
              setState(() {
                widget.viewModel.controllers[_index].pause();
                _index++;
                widget.viewModel.controllers[_index].play();
              });
            }
          } else {
            print('dragged from top');
            if (_index > 0) {
              setState(() {
                widget.viewModel.controllers[_index].pause();
                _index--;
                widget.viewModel.controllers[_index].play();
              });
            }
          }
        },
        onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
          if (dragEndDetails.primaryVelocity == 0) return;

          if (dragEndDetails.primaryVelocity?.compareTo(0) == -1) {
            print('dragged from left');
            if (_index < _maxIndex - 1) {
              setState(() {
                widget.viewModel.controllers[_index].pause();
                _index++;
                widget.viewModel.controllers[_index].play();
              });
            }
          } else {
            print('dragged from right');
            if (_index > 0) {
              setState(() {
                widget.viewModel.controllers[_index].pause();
                _index--;
                widget.viewModel.controllers[_index].play();
              });
            }
          }
        },
        child: Center(child: VideoPlayer(widget.viewModel.controllers[_index])),
      ),
    );
  }
}
