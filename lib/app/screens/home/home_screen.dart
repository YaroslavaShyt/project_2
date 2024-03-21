import 'package:flutter/material.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/screens/login/login_factory.dart';
import 'package:project_2/app/screens/plants_home/plants_home_factory.dart';

import 'package:project_2/domain/services/iauth_service.dart';

class HomeScreen extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const HomeScreen({super.key, required this.homeViewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
      stream: homeViewModel.userStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')));
          }
          switch (snapshot.data) {
            case UserState.ready:
              return PlantsHomeFactory.build([]);
            case UserState.notReady:
              return LoginFactory.build();
            default:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
          }
        }
      },
    );
  }
}
