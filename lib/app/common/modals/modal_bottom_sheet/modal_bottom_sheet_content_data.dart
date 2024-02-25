import 'package:flutter/material.dart';

class ModalBottomSheetContentData {
  final String title;
  final String firstLabel;
  final String secondLabel;
  final String buttonTitle;
  final String? firstFieldValue;
  final String? secondFieldValue;
  final void Function(String) onFirstTextFieldChanged;
  final void Function(String) onSecondTextFieldChanged;
  final void Function() onButtonPressed;

  ModalBottomSheetContentData(
      {required this.title,
      required this.firstLabel,
      required this.secondLabel,
      required this.buttonTitle,
      required this.onFirstTextFieldChanged,
      required this.onSecondTextFieldChanged,
      required this.onButtonPressed,
      this.firstFieldValue, 
      this.secondFieldValue
     });
}
