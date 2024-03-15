import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;

  const CachedImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const Icon(
        Icons.image,
        color: AppColors.lightMentolGreenColor,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
