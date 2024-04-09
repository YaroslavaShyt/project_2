import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/modals/modals_service.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/theming/app_colors.dart';

mixin ErrorHandlingMixin {
  void showErrorDialog(BuildContext context, String message) => {
        Modals.showPopUpModal(
          context: context,
          data: PopUpDialogData(
            title: 'Помилка',
            content: Text(
              message,
              style: const TextStyle(color: AppColors.whiteColor),
            ),
            actions: [],
          ),
        )
      };
}
