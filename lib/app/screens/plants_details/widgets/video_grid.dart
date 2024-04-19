import 'package:flutter/material.dart';
import 'package:project_2/app/screens/plants_details/widgets/video_preview.dart';
import 'package:video_player/video_player.dart';

class VideoGrid extends StatefulWidget {
  final Stream<VideoPlayerController> videoControllerStream;
  final Function() onVideoPreviewTap;
  final Function(List<VideoPlayerController>) disposeControllers;
  const VideoGrid(
      {super.key,
      required this.videoControllerStream,
      required this.disposeControllers,
      required this.onVideoPreviewTap});

  @override
  State<VideoGrid> createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  late Stream<VideoPlayerController> stream;
  List<VideoPlayerController> controllers = [];

  @override
  void initState() {
    super.initState();
    stream = widget.videoControllerStream;
    stream.listen((event) {
      setState(() {
        controllers.add(event);
      });
    });
  }

    @override
  void dispose() {
    widget.disposeControllers(controllers);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: controllers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 20.0),
        itemBuilder: (context, index) {
          return VideoPreview(
            controller: controllers[index],
            onVideoPreviewTap: widget.onVideoPreviewTap,
          );
        });
  }
}
