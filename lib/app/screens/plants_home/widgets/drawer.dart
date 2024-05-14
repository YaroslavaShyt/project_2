import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/common/caching/caching_manager.dart';
import 'package:project_2/app/screens/plants_home/widgets/build_drawer_item.dart';
import 'package:project_2/app/screens/plants_home/widgets/no_photo_avatar.dart';
import 'package:project_2/app/screens/plants_home/widgets/photo_avatar.dart';
import 'package:project_2/app/theming/app_colors.dart';
import 'package:project_2/domain/user/imy_user.dart';

class MainDrawer extends StatelessWidget {
  final IMyUser? user;
  final Function showPicker;
  final Function showAddPlantModal;
  final Function() onLogoutButtonPressed;
  final Function() onChangeLanguageButtonPressed;
  const MainDrawer(
      {super.key,
      this.user,
      required this.onChangeLanguageButtonPressed,
      required this.onLogoutButtonPressed,
      required this.showAddPlantModal,
      required this.showPicker});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkWoodGeenColor,
      width: 250.0,
      child: ListView(
        children: [
          Container(
            color: AppColors.darkWoodGeenColor,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user == null || user!.profilePhoto == null
                      ? NoPhotoAvatar(onPressed: showPicker)
                      : SizedBox(
                          height: 100,
                          width: 100,
                          child: PhotoAvatar(
                              imageUrl: user!.profilePhoto!,
                              onPressed: showPicker)),
                  Text(
                    user?.name ?? 'Анонім',
                    style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor),
                  )
                ],
              ),
            ),
          ),
          buildDrawerItem(Icons.add, 'new_plant'.tr().toString(),
              () => showAddPlantModal(context)),
          buildDrawerItem(Icons.cleaning_services,
              "clear_cache".tr().toString(), CachingManager.clearCache),
          buildDrawerItem(Icons.logout_rounded, 'quit'.tr().toString(),
              onLogoutButtonPressed),
          buildDrawerItem(Icons.language, "language".tr().toString(),
              onChangeLanguageButtonPressed)
        ],
      ),
    );
  }
}
