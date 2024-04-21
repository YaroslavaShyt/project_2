import 'package:flutter/material.dart';
import 'package:project_2/app/screens/camera/widgets/progress_indicator_painter.dart';
import 'package:project_2/app/theming/app_colors.dart';

class CustomProgressButton extends StatelessWidget {
  final AnimationController animationController;
  const CustomProgressButton({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
              animation: animationController,
              builder: (BuildContext context, Widget? widget) {
                return CustomPaint(
                  painter: ProgressIndicatorPainter(
                      animation: animationController,
                      backgroundColor: AppColors.darkWoodGeenColor,
                      color: AppColors.lightMentolGreenColor),
                );
              }),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }
}
