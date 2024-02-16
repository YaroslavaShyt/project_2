import 'package:flutter/material.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/login/login_factory.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case routeLogin:
        return MaterialPageRoute(
            builder: (_) => _buildLoginSettings(routeSettings));
      
      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }

  Widget _buildLoginSettings(RouteSettings settings) {
    return LoginFactory.build();
  }

 
}
