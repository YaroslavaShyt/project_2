import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class MainTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final String? errorText;
  const MainTextField(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.obscureText,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: AppColors.lightMentolGreenColor),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor)),
      ),
      cursorColor: AppColors.whiteColor,
      obscureText: obscureText,
    );
  }
}
