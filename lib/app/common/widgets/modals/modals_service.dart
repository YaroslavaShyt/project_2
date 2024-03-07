import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog.dart';
import 'package:project_2/app/common/widgets/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/theming/app_colors.dart';

class ModalsService {
  static Future<void> showBottomModal(
      {required BuildContext context, required ModalBottomDialogData data}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.darkWoodGeenColor,
      context: context,
      builder: (BuildContext context) {
        return ModalBottomDialog(data: data);
      },
    );
  }

  static Future<void> showPopUpModal(
      {required BuildContext context, required PopUpDialogData data}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopUpDialog(
            data: data,
          );
        });
  }
}
