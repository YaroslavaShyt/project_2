import 'package:flutter/material.dart';
import 'package:project_2/app/common/widgets/main_elevated_button.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/services/user_service.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final UserService userService;
  const HomeScreen(
      {super.key, required this.homeViewModel, required this.userService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(userService.user?.name ?? ''),
        actions: [Text(userService.user?.phoneNumber ?? '')],
      ),
      body: Center(
        child: MainElevatedButton(
            onButtonPressed: homeViewModel.onLogoutButtonPressed,
            title: 'Log out'),
      ),
    );
  }
}
