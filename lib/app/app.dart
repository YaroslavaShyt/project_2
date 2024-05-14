import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_2/app/routing/app_router.dart';
import 'package:project_2/app/routing/inavigation_util.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/utils/deep_linking/deep_link_handler.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final AppRouter router;
  final DeepLinkHandler deepLinkHandler;
  const App({super.key, required this.router, required this.deepLinkHandler});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  
  @override
  void initState() {
    super.initState();
    widget.deepLinkHandler.getInitialLink();
  }

  @override
  void didChangeDependencies() {
    widget.deepLinkHandler.getLinkStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
