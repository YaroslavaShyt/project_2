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
  final List<dynamic> videoUrls;
  VideoCacheUtil({required this.videoUrls});

  
  Future<void> cacheVideos() async {
    for (var url in videoUrls) {
      FileInfo? fileInfo = await kCacheManager.getFileFromCache(url);
      if(fileInfo == null){
        debugPrint("-------chaching");
        await kCacheManager.downloadFile(url);
        debugPrint("-------chached");
      }
    }
  }
}
