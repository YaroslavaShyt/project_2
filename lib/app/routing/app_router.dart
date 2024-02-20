import 'package:flutter/material.dart';
import 'package:project_2/app/routing/routes.dart';
import 'package:project_2/app/screens/home/home_factory.dart';
import 'package:project_2/app/screens/landing/landing_factory.dart';
import 'package:project_2/app/screens/login/login_factory.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case routeLanding:
        return MaterialPageRoute(
            builder: (_) => _buildLandingSettings(routeSettings));
      case routeLogin:
        return MaterialPageRoute(
            builder: (_) => _buildLoginSettings(routeSettings));
      case routeHome:
        return MaterialPageRoute(
            builder: (_) => _buildHomeSettings(routeSettings));

      default:
        return MaterialPageRoute(builder: (_) => const Placeholder());
    }
  }

  Widget _buildLandingSettings(RouteSettings settings) {
    return LandingFactory.build();
  }

  Widget _buildLoginSettings(RouteSettings settings) {
    return LoginFactory.build();
  }

  Widget _buildHomeSettings(RouteSettings settings) {
    return HomeFactory.build([]);
  }
}
