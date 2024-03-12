import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class AddPhotoContainer extends StatelessWidget {
  final void Function() onAddPhotoButtonPressed;
  final String? photoUrl;

  const AddPhotoContainer({
    Key? key,
    required this.onAddPhotoButtonPressed,
    this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(color: AppColors.whiteColor),
      ),
      child: photoUrl == null
          ? IconButton(
              icon: const Icon(
                Icons.add_a_photo_outlined,
                size: 30.0,
                color: AppColors.whiteColor,
              ),
              onPressed: onAddPhotoButtonPressed,
            )
          : Text(photoUrl ?? 'url'),
    );
  }
}
