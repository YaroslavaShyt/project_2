import 'package:flutter/material.dart';
import 'package:project_2/app/common/error_handling/error_handling_mixin.dart';
import 'package:project_2/app/screens/home/home_view_model.dart';
import 'package:project_2/app/screens/login/login_factory.dart';
import 'package:project_2/app/screens/plants_home/plants_home_factory.dart';
import 'package:project_2/app/services/app_state/app_state_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:project_2/domain/services/iauth_service.dart';
import 'package:provider/provider.dart';
import "package:shared_preferences/shared_preferences.dart";

class HomeScreen extends StatefulWidget with ErrorHandlingMixin {
  final HomeViewModel homeViewModel;
  const HomeScreen({super.key, required this.homeViewModel});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("app in resumed");
      getItInst.get<AppStateService>().appState = AppState.foreground;
    }
    if (state == AppLifecycleState.inactive) {
      print("app in inactive");
      
      getItInst.get<AppStateService>().appState = AppState.background;
    }
    if (state == AppLifecycleState.paused) {
      print("app in paused");
      getItInst.get<AppStateService>().appState = AppState.background;
    }
    if (state == AppLifecycleState.detached) {
      print("app in detached");
      getItInst.get<AppStateService>().appState = AppState.terminated;
    }
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
