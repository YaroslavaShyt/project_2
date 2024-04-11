import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/chached_image.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PhotoAvatar extends StatelessWidget {
  final String imageUrl;
  final Function? onPressed;
  const PhotoAvatar({super.key, required this.imageUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipOval(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
              height: 100,
              width: 100,
              child: CachedImageWidget(imageUrl: imageUrl)),
        ),
        if (onPressed != null) ...[
          Positioned(
            bottom: -5.0,
            right: -10.0,
            child: IconButton(
                onPressed: () => onPressed!(context),
                icon: const Icon(
                  Icons.add_a_photo,
                  color: AppColors.whiteColor,
                )),
          )
        ]
      ],
    );
  }
}
