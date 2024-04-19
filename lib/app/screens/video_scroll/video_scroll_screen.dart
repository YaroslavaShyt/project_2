import 'package:flutter/material.dart';
import 'package:project_2/app/screens/video_scroll/video_scroll_view_model.dart';
import 'package:project_2/app/theming/app_colors.dart';

class VideoScrollScreen extends StatefulWidget {
  final VideoScrollViewModel viewModel;
  const VideoScrollScreen({super.key, required this.viewModel});

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

class _VideoScrollScreenState extends State<VideoScrollScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemBuilder: (context, positionVertical) {
              return PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, positionHorizontal) {
                    return Container(
                      color: AppColors.lightMentolGreenColor,
                      child: Center(
                          child: Text(
                              "TEXT $positionVertical $positionHorizontal")),
                    );
                  },
                  itemCount: 20);
            },
            itemCount: 20));
  }
}
