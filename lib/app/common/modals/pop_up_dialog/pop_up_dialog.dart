import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/theming/app_colors.dart';

class PopUpDialog extends StatelessWidget {
  final PopUpDialogData data;
  const PopUpDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.darkWoodGeenColor,
      title: Text(
        data.title,
        style: const TextStyle(color: AppColors.whiteColor),
      ),
      content: data.content,
      actions: data.actions,
    );
  }
}
