import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/pop_up_dialog/pop_up_dialog_data.dart';

class PopUpDialog extends StatelessWidget {
  final PopUpDialogData data;
  const PopUpDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(data.title),
      content: data.content,
      actions: data.actions,
    );
  }
}
