import 'package:flutter/material.dart';

class MainElevatedButton extends StatelessWidget {
  final Function() onButtonPressed;
  final String title;
  const MainElevatedButton(
      {super.key, required this.onButtonPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width - 100,
      child: ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.cyan.shade200,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
