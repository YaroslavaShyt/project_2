import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PhotoAvatar extends StatelessWidget {
  final String imageUrl;
  final Function onPressed;
  const PhotoAvatar({super.key, required this.imageUrl, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: CachedImageWidget(imageUrl: imageUrl),
        ),
        Positioned(
          bottom: -5.0,
          right: -10.0,
          child: IconButton(
              onPressed: () => onPressed(context),
              icon: const Icon(
                Icons.add_a_photo,
                color: AppColors.whiteColor,
              )),
        )
      ],
    );
  }
}
