import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/modal_bottom_sheet/modal_bottom_sheet_content.dart';
import 'package:project_2/app/common/modals/modal_bottom_sheet/modal_bottom_sheet_content_data.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog_data.dart';
import 'package:project_2/app/theming/app_colors.dart';

class ModalsService {
  static void showBottomModal(
      {required BuildContext context,
      required ModalBottomSheetContentData data}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.darkWoodGeenColor,
      context: context,
      builder: (BuildContext context) {
        return ModalBottomSheetContent(data: data);
      },
    );
  }

  static void showPopUpModal(
      {required BuildContext context, required PopUpDialogData data}) {
    showDialog(
      
        context: context,
        builder: (BuildContext context) {
          return PopUpDialog(
            data: data,
          );
        });
  }
}
