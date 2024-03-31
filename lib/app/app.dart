import 'package:flutter/material.dart';
import 'package:project_2/app/routing/app_router.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/services/deep_linking/deep_linking_service.dart';
import 'package:project_2/app/services/get_it/get_it.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final AppRouter router;
  const App({super.key, required this.router});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

@override
  void didChangeDependencies() {
    getItInst.get<DeepLinkingService>().getLinkStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: context.read<INavigationUtil>().navigatorKey,
      onGenerateRoute: widget.router.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: routeHome,
    );
  }
}





