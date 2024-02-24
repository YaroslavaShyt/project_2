import 'package:flutter/material.dart';

class ModalBottomSheetContentData {
  final String title;
  final String firstLabel;
  final String secondLabel;
  final String buttonTitle;
  final TextEditingController firstController;
  final void Function(String) onFirstTextFieldChanged;
  final void Function(String) onSecondTextFieldChanged;
  final void Function() onButtonPressed;
  final TextEditingController secondController;

  ModalBottomSheetContentData(
      {required this.title,
      required this.firstLabel,
      required this.secondLabel,
      required this.buttonTitle,
      required this.firstController,
      required this.onFirstTextFieldChanged,
      required this.onSecondTextFieldChanged,
      required this.onButtonPressed,
      required this.secondController});
}
