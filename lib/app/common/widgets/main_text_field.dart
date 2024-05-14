import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:project_2/app/theming/app_colors.dart';

class MainTextField extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final String? errorText;
  final MaskTextInputFormatter? formatter;
  const MainTextField(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.obscureText,
      this.value,
      this.formatter,
      this.errorText});

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: widget.formatter != null ? [widget.formatter!] : [],
      style: const TextStyle(color: AppColors.lightMentolGreenColor),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.errorText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor)),
      ),
      cursorColor: AppColors.whiteColor,
      obscureText: widget.obscureText,
    );
  }
}
