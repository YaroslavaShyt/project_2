import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final String? errorText;
  const LoginTextField(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.obscureText,
      this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
      ),
      obscureText: obscureText,
    );
  }
}
