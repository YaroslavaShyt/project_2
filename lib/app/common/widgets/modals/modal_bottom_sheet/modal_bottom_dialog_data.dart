import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ModalBottomDialogData {
  final String title;
  final String firstLabel;
  final String? secondLabel;
  final String buttonTitle;
  final String? firstFieldValue;
  final String? secondFieldValue;
  final String? firstErrorText;
  final String? secondErrorText;
  final MaskTextInputFormatter? formatter;
  final void Function(String) onFirstTextFieldChanged;
  final void Function(String)? onSecondTextFieldChanged;
  final void Function() onButtonPressed;

  ModalBottomDialogData(
      {required this.title,
      required this.firstLabel,
      this.secondLabel,
      required this.buttonTitle,
      required this.onFirstTextFieldChanged,
      this.onSecondTextFieldChanged,
      required this.onButtonPressed,
      this.firstFieldValue,
      this.formatter,
      this.secondFieldValue,
      this.firstErrorText,
      this.secondErrorText});
}
