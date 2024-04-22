import 'package:flutter/material.dart';
import 'package:project_2/app/screens/plants_details/widgets/video_preview.dart';
import 'package:video_player/video_player.dart';

class VideoGrid extends StatefulWidget {
  final Stream<VideoPlayerController> videoControllerStream;
  final Function({required int index}) onVideoPreviewTap;
  final List<VideoPlayerController> controllers;
  final Function(VideoPlayerController) addControllers;
  final Function(List<VideoPlayerController>) disposeControllers;
  const VideoGrid(
      {super.key,
      required this.videoControllerStream,
      required this.controllers,
      required this.addControllers,
      required this.disposeControllers,
      required this.onVideoPreviewTap});

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late Stream<VideoPlayerController> stream;
  
  @override
  void initState() {
    super.initState();
    stream = widget.videoControllerStream;
    stream.listen((event) {
        widget.addControllers(event);
    });
  }

    @override
  void dispose() {
    widget.disposeControllers(widget.controllers);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.controllers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 20.0),
        itemBuilder: (context, index) {
          return VideoPreview(
            index: index,
            controller: widget.controllers[index],
            onVideoPreviewTap: widget.onVideoPreviewTap,
          );
        });
  }
}
