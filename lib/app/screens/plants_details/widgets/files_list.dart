import 'package:flutter/material.dart';
// import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:video_player/video_player.dart';

class FilesList extends StatelessWidget {
  final void Function() onTap;
  final List files;
  final List<VideoPlayerController>? controllers;
  final bool isVideo;
  const FilesList(
      {super.key,
      required this.onTap,
      required this.files,
      this.controllers,
      required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsetsDirectional.all(10.0),
              height: 90,
              width: 50,
              color: AppColors.lightMentolGreenColor,
              child: const Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsetsDirectional.all(10.0),
                      height: 90,
                      width: 50,
                      color: AppColors.lightMentolGreenColor,
                      child: isVideo
                          ? controllers != null
                              ? controllers![index].value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          controllers![index].value.aspectRatio,
                                      child: VideoPlayer(controllers![index]),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator())
                              : const Center(child: CircularProgressIndicator())
                          : Image.network(files[
                              index]) //CachedImageWidget(imageUrl: files[index]),
                      );
                }),
          ),
        ],
      ),
    );
  }
}
