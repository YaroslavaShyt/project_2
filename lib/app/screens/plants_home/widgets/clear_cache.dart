import 'package:flutter/material.dart';
import 'package:project_2/app/common/caching/caching_manager.dart';

class ClearCacheWidget extends StatelessWidget {
  const ClearCacheWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: IconButton(
        onPressed: CachingManager.clearCache,
        icon: Icon(Icons.cleaning_services_outlined),
      ),
      title: Text("Очистити кеш"),
    );
  }
}
