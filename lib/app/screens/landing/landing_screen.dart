import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/domain/login/ilogin_repository.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: context.read<ILoginRepository>().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          } 
          else if (snapshot.hasError) {
            return Scaffold(body: Text('Error: ${snapshot.error}'));
          } 
          else if (snapshot.data == null) {
            Future.delayed(Duration.zero, () {
              context.read<INavigationUtil>().navigateTo(routeLogin);
            });
          } 
          else {
            Future.delayed(Duration.zero, () {
              context.read<INavigationUtil>().navigateTo(routeHome);
            });
          }
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        });
  }
}
