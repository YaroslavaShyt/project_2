import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class MainElevatedButton extends StatelessWidget {
  final Function() onButtonPressed;
  final Widget? icon;
  final String title;
  const MainElevatedButton(
      {super.key,
      required this.onButtonPressed,
      this.icon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed: onButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coldWoodGreenColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 15),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
  }
}
