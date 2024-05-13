import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:video_player/video_player.dart';

class FilesList extends StatelessWidget {
  final Function({required int index}) onTap;
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
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onTap(index: index),
                    child: Container(
                      margin: const EdgeInsetsDirectional.all(10.0),
                      height: 90,
                      width: 50,
                      child: isVideo
                          ? controllers != null
                              ? controllers![index].value.isInitialized
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: AspectRatio(
                                        aspectRatio: controllers![index]
                                            .value
                                            .aspectRatio,
                                        child: VideoPlayer(controllers![index]),
                                      ))
                                  : const Center(
                                      child: CircularProgressIndicator())
                              : const Center(child: CircularProgressIndicator())
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedImageWidget(imageUrl: files[index]),
                            ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
