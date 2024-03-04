import 'package:flutter/material.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/screens/login/login_factory.dart';
import 'package:project_2/app/screens/plants_home/plants_home_factory.dart';
import 'package:project_2/domain/services/iauth_service.dart';

class HomeScreen extends StatefulWidget {
  final HomeViewModel homeViewModel;
  const HomeScreen({super.key, required this.homeViewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      print("paused");
    // widget.homeViewModel.closeStream();
    }else{
      
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserState>(
      stream: widget.homeViewModel.userStateStream,
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
