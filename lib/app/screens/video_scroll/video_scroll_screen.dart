import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';


class VideoScrollScreen extends StatefulWidget {
  final VideoScrollViewModel viewModel;
  const VideoScrollScreen({super.key, required this.viewModel});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}