import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/app.dart';
import 'package:project_2/app/routing/app_router.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/navigation_util.dart';
import 'package:project_2/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final INavigationUtil navigationUtil = NavigationUtil();
  final AppRouter appRouter = AppRouter();

  runApp(MultiProvider(
      providers: [Provider.value(value: navigationUtil)], child: App(router: appRouter,)));
}
