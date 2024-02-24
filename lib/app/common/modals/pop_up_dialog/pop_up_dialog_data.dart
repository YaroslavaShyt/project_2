import 'package:flutter/material.dart';

class PopUpDialogData {
  final String title;
  final Widget content;
  final List<Widget> actions;

  PopUpDialogData({
    required this.title,
    required this.content,
    required this.actions,
  });
}
