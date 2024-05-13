import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/app/utils/video_cache/video_cache_util.dart';
import 'package:video_player/video_player.dart';

class MainVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const MainVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  State<MainVideoPlayer> createState() => _MainVideoPlayerState();
}

class _MainVideoPlayerState extends State<MainVideoPlayer>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  bool _videoInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeController();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initializeController() async {
    var fileInfo = await kCacheManager.getFileFromCache(widget.videoUrl);
    if (fileInfo == null) {
      await kCacheManager.downloadFile(widget.videoUrl);
      fileInfo = await kCacheManager.getFileFromCache(widget.videoUrl);
    }
    if (mounted) {
      _controller = VideoPlayerController.file(fileInfo!.file)
        ..initialize().then((_) {
          setState(() {
            _controller.setLooping(true);
            _controller.play();
            _videoInitialized = true;
          });
        });
      _controller.addListener(() {
        if (_controller.value.isPlaying && !_isPlaying) {
          setState(() {
            _isPlaying = true;
          });
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _controller.play();
    } else if (state == AppLifecycleState.inactive) {
      _controller.pause();
    } else if (state == AppLifecycleState.paused) {
      _controller.pause();
    } else if (state == AppLifecycleState.detached) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_videoInitialized) {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                    _isPlaying = false;
                  } else {
                    _controller.play();
                    _isPlaying = true;
                  }
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                !_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkWoodGeenColor,
                        ),
                      )
                    : VideoPlayer(_controller),
                !_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.darkWoodGeenColor,
                        ),
                      )
                    : const SizedBox(),
                if (!_isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                !_videoInitialized
                    ? const SizedBox()
                    : VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: AppColors.lightMentolGreenColor,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.white,
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
