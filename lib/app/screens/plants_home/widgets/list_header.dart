import 'package:flutter/material.dart';
import 'package:project_2/app/theming/app_colors.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(color: AppColors.oliveGreenColor),
      child: Row(
        children: [
          const Text(
            'Назва',
            style: TextStyle(color: AppColors.whiteColor, fontSize: 15.0),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3 - 20,
          ),
          const Text(
            'Кількість',
            style: TextStyle(color: AppColors.whiteColor, fontSize: 15.0),
          )
        ],
      ),
    );
  }
}
