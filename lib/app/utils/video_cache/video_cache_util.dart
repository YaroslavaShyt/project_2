import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

const kReelCacheKey = "reelsCacheKey";
final CacheManager kCacheManager = CacheManager(
  Config(
    kReelCacheKey,
    stalePeriod: const Duration(days: 7),
    maxNrOfCacheObjects: 100,
    repo: JsonCacheInfoRepository(databaseName: kReelCacheKey),
    fileService: HttpFileService(),
  ),
);

class VideoCacheUtil {
  final String videoUrl;
  VideoCacheUtil({required this.videoUrl});

  Future<void> cacheVideo() async {
    FileInfo? fileInfo = await kCacheManager.getFileFromCache(videoUrl);
    if (fileInfo == null) {
      debugPrint("-------chaching");
      await kCacheManager.downloadFile(videoUrl);
      debugPrint("-------chached");
    }
  }
}
