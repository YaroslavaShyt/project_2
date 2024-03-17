import 'package:flutter/material.dart';

Widget buildDrawerItem(IconData icon, String text, Function() onTap) {
  return ListTile(
    leading: IconButton(
      onPressed: onTap,
      icon: Icon(icon),
    ),
    title: Text(text),
  );
}
