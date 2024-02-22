import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/plants_home/plants_home_view_model.dart';

class PlantsHomeScreen extends StatelessWidget {
  final PlantsHomeViewModel homeViewModel;
  const PlantsHomeScreen({super.key, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("${homeViewModel.userName} ${homeViewModel.userSurname}"),
        actions: [Text(homeViewModel.userPhoneNumber)],
      ),
      body: Center(
        child: MainElevatedButton(
            onButtonPressed: homeViewModel.onLogoutButtonPressed,
            title: 'Log out'),
      ),
    );
  }
}
