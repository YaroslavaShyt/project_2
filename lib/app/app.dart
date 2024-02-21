import 'package:flutter/material.dart';
import 'package:project_2/app/routing/app_router.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  final AppRouter router;
  const App({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: context.read<INavigationUtil>().navigatorKey,
      onGenerateRoute: router.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: routeLanding,
    );
  }
}





