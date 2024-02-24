import 'package:flutter/material.dart';
import 'package:project_2/app/common/modals/modal_bottom_sheet/modal_bottom_sheet_content_data.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';

class ModalBottomSheetContent extends StatelessWidget {
  final ModalBottomSheetContentData data;

  const ModalBottomSheetContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(data.title),
          MainTextField(
              label: data.firstLabel,
              onChanged: data.onFirstTextFieldChanged,
              obscureText: false),
          MainTextField(
              label: data.secondLabel,
              onChanged: data.onSecondTextFieldChanged,
              obscureText: false),
          MainElevatedButton(
              onButtonPressed: () => data.onButtonPressed,
              title: data.buttonTitle)
        ],
      ),
    );
  }
}
