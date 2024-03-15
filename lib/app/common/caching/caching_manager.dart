import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachingManager {
  static Future<void> clearCache() async {
    DefaultCacheManager().emptyCache();
  }
}
