import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/modals/modal_bottom_sheet/modal_bottom_dialog_data.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/common/widgets/main_text_field.dart';
import 'package:project_2/app/theming/app_colors.dart';

class ModalBottomDialog extends StatelessWidget {
  final ModalBottomDialogData data;

  const ModalBottomDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                    color: AppColors.lightMentolGreenColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              MainTextField(
                  value: data.firstFieldValue,
                  label: data.firstLabel,
                  errorText: data.firstErrorText,
                  onChanged: data.onFirstTextFieldChanged,
                  obscureText: false),
              const SizedBox(
                height: 20.0,
              ),
              MainTextField(
                  value: data.secondFieldValue,
                  errorText: data.secondErrorText,
                  label: data.secondLabel,
                  onChanged: data.onSecondTextFieldChanged,
                  obscureText: false),
              const SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 60,
                width: 300,
                child: MainElevatedButton(
                    onButtonPressed: data.onButtonPressed,
                    title: data.buttonTitle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
