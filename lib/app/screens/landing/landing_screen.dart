import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              Future.delayed(Duration.zero, () {
                context.read<INavigationUtil>().navigateTo(routeLogin);
              });
            } else {
              Future.delayed(Duration.zero, () {
                context.read<INavigationUtil>().navigateTo(routeHome);
              });
            }
          }
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        });
  }
}
