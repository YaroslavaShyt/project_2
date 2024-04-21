import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class TimerElement extends StatelessWidget {
  final int progress;
  const TimerElement({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: Text(
          "00:${progress < 10 ? "0" : ''}${progress.toString()}",
          style: const TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 15.0),
        ),
      ),
    );
  }
}
